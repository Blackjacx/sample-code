//
//  IPViewController.m
//  ImagePickerSample
//
//  Created by Stefan Herold on 12/17/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "IPViewController.h"

@interface IPViewController ()

@end

@implementation IPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear:animated];

	UIImagePickerController * picker = [[UIImagePickerController alloc] init];

	if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {

		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	else if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {

		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	else if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] ) {

		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	}
	else {

		NSAssert(NO, @"No source type known");
	}

	picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
	picker.delegate = self;

	[self presentViewController:picker animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// MARK: UIImagepickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

	if( [[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage] ) {

		// Post process images
		[self postProcessImageFromMediaInfo:info];
	}
	else if( [[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie] ) {

		// Post process movie
//		[self postProcessVideoFromMediaInfo:info];
	}

	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

	[self dismissViewControllerAnimated:YES completion:NULL];
}

//- (void)postProcessVideoFromMediaInfo:(NSDictionary *)info {
//
////	NSURL * videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//
//}

- (void)postProcessImageFromMediaInfo:(NSDictionary *)info {

	NSURL * referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
	NSDictionary * newlyCapturedPhotoMetaData = [info objectForKey:UIImagePickerControllerMediaMetadata];

	// We newly captured a photo
	if( newlyCapturedPhotoMetaData ) {

		// Create a image source from the original image
		[self postProcessImage:[info objectForKey:UIImagePickerControllerOriginalImage]
				  withMetaData:newlyCapturedPhotoMetaData];
	}
	else {

		// We did select an image from the photo library
		[[[ALAssetsLibrary alloc] init]
		 assetForURL:referenceURL
		 resultBlock:^(ALAsset *asset) {

			 if( asset ) {

				 // Create image source from the default representations full resolution image
				 [self postProcessImage:[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage]
						   withMetaData:nil];
			 }
			 else {

				 // Create a image source from the original image
				 [self postProcessImage:[info objectForKey:UIImagePickerControllerOriginalImage]
						   withMetaData:nil];
			 }


		 } failureBlock:^(NSError *error) {

			 // Create a image source from the original image
			 [self postProcessImage:[info objectForKey:UIImagePickerControllerOriginalImage]
					   withMetaData:nil];
		 }];
	}
}

- (void)postProcessImage:(UIImage*)image withMetaData:(NSDictionary*)metaData {

	NSData * jpegData = UIImageJPEGRepresentation(image, 1.0);
	CGImageSourceRef imgSource = CGImageSourceCreateWithData((__bridge CFDataRef)jpegData, NULL);

	// Tag image without additional meta data
	[self taggedImageForImageSource:imgSource mergingExistingMetaData:metaData];

	// Cleanup
	CFRelease(imgSource);
}

- (void)taggedImageForImageSource:(CGImageSourceRef)source mergingExistingMetaData:(NSDictionary*)existingMetaData {

    //get all the metadata in the image
    NSDictionary * metadata = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
	NSDictionary * mergedMetaData = [[self class] dictionaryByMerging:existingMetaData with:metadata];

	NSLog(@"ExistingMetaInfo: %@", existingMetaData);
	NSLog(@"InternalMetaData: %@", metadata);
	NSLog(@"MergedMetaData: %@", mergedMetaData);

    //make the metadata dictionary mutable so we can add properties to it
    NSMutableDictionary * mergedMetadataAsMutable = [mergedMetaData mutableCopy];

    NSMutableDictionary * EXIFDictionary = [[mergedMetadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary * GPSDictionary = [[mergedMetadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary]mutableCopy];

    if(!EXIFDictionary) {
        //if the image does not have an EXIF dictionary (not all images do), then create one for us to use
        EXIFDictionary = [NSMutableDictionary dictionary];
    }
    if(!GPSDictionary) {
        GPSDictionary = [NSMutableDictionary dictionary];
    }

    //Setup GPS dict
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_lat] forKey:(NSString*)kCGImagePropertyGPSLatitude];
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_lon] forKey:(NSString*)kCGImagePropertyGPSLongitude];
//    [GPSDictionary setValue:lat_ref forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
//    [GPSDictionary setValue:lon_ref forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_alt] forKey:(NSString*)kCGImagePropertyGPSAltitude];
//    [GPSDictionary setValue:[NSNumber numberWithShort:alt_ref] forKey:(NSString*)kCGImagePropertyGPSAltitudeRef];
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_heading] forKey:(NSString*)kCGImagePropertyGPSImgDirection];
//    [GPSDictionary setValue:[NSString stringWithFormat:@"%c",_headingRef] forKey:(NSString*)kCGImagePropertyGPSImgDirectionRef];

//    [EXIFDictionary setValue:xml forKey:(NSString *)kCGImagePropertyExifUserComment];

    // add our modified EXIF data back into the image’s metadata
    [mergedMetadataAsMutable setObject:EXIFDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
    [mergedMetadataAsMutable setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];

    CFStringRef UTI = CGImageSourceGetType(source); //this is the type of image (e.g., public.jpeg)

    //this will be the data CGImageDestinationRef will write into
    NSMutableData *dest_data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,NULL);

    if(!destination) {
        NSLog(@"***Could not create image destination ***");
    }

    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef)mergedMetadataAsMutable);

    //tell the destination to write the image data and metadata into our data object.
    //It will return false if something goes wrong
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);

    if(!success) {
        NSLog(@"***Could not create data from image destination ***");
    }

    /*
	 
	 now we have the data ready to go, so do whatever you want with it

	 */

    //cleanup
    CFRelease(destination);
}


// MARK: Helper

+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2 {

    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:dict1];

	[dict2 enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {

		if ([obj isKindOfClass:[NSDictionary class]]) {

			NSDictionary * newVal = [[self class] dictionaryByMerging:[dict1 objectForKey:key] with:(NSDictionary *)obj];
			[result setObject:newVal forKey:key];
		}
		else {

			if (![result objectForKey:key]) {

				[result setObject:obj forKey:key];
			}
		}
	}];
    return [result copy];
}

@end
