//
//  PTFileManager.h
//  PathTrack
//
//  Created by Stefan Herold on 7/10/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTFileManager : NSObject

/*! @brief Directory where the data is stored.
	@details Creates this directory if necessary.
 */
@property(nonatomic, strong, readonly)NSString * dataDirectory;

/*! @brief List of all saved track records in the format @c PTTrackRecord.
 */
@property(nonatomic, strong, readonly)NSArray * allSavedTrackRecords;


@end
