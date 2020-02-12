//
//  ViewController.m
//  UICollectionViewResizeTest
//
//  Created by Stefan Herold on 13/05/15.
//  Copyright (c) 2015 Stefan Herold. All rights reserved.
//

#import "ViewController.h"

static NSString *const kCollectionViewHeaderReuseID = @"kCollectionViewHeaderReuseID";
static NSString *const kCollectionViewCellReuseID = @"kCollectionViewCellReuseID";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSLayoutConstraint *rightConstraint;
@end



@interface MyLayout : UICollectionViewFlowLayout
@property(nonatomic, assign)BOOL animatingBoundsChange;
@end
@implementation MyLayout

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}
//
//- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds
//{
//    [super prepareForAnimatedBoundsChange:oldBounds];
//    self.animatingBoundsChange = YES;
//}
//
//- (void)finalizeAnimatedBoundsChange
//{
//    [super finalizeAnimatedBoundsChange];
//    self.animatingBoundsChange = NO;
//}
//
//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    if (self.animatingBoundsChange) {
//        // If the view is rotating, appearing items should animate from their current attributes (specify `nil`).
//        // Both of these appear to do much the same thing:
////        return [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        return nil;
//    }
//    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
//}
//
//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    if (self.animatingBoundsChange) {
//        // If the view is rotating, disappearing items should animate to their new attributes.
//        return [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    }
//    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
//}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    
    // Prepare the collection view's layout
    UICollectionViewFlowLayout *layout = [[MyLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor grayColor];
    
    // Register the kind of the cells
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellReuseID];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeaderReuseID];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(toggle:)];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    NSDictionary *viewMap = @{
                              @"collectionView" : _collectionView
                              };
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraint:rightConstraint];
    self.rightConstraint = rightConstraint;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:kNilOptions metrics:kNilOptions views:viewMap]];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (IBAction)toggle:(id)sender
{
    if (self.rightConstraint.constant == 0)
    {
        self.rightConstraint.constant = -100.f;
    }
    else
    {
        self.rightConstraint.constant = 0.f;
    }
    
    NSLog(@"F: %@    B: %@", NSStringFromCGRect(self.collectionView.frame), NSStringFromCGRect(self.collectionView.bounds));
    
    [UIView animateWithDuration:1.0 animations:^{
        
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.view setNeedsLayout];
        [self.collectionView performBatchUpdates:NULL completion:NULL];
        
    } completion:NULL];
}

#pragma mark - UICollectionViewDelegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 100.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 75.f);
}


#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 100;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Reuse an already allocated cell or let it create implicitly
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellReuseID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];

    NSInteger tag = 666;
    [[cell viewWithTag:tag] removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor greenColor];
    label.text = @"Hello World!";
    label.tag = tag;
    
    [cell.contentView addSubview:label];
    
    // Return the cell now
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // Provide a header view
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        NSInteger tag = 666;
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionViewHeaderReuseID forIndexPath:indexPath];
        
        [[view viewWithTag:tag] removeFromSuperview];
        
        CGRect labelBounds = view.bounds;
        labelBounds.origin = CGPointZero;
        UILabel *label = [[UILabel alloc] initWithFrame:labelBounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label.text = @"Titel der sehr sehr sehr lang ist und den man nicht mehr sehen sollte.";
        label.textColor = [UIColor blackColor];
        label.tag = tag;
        
        [view addSubview:label];
    
        // Return the reusable view
        return view;
    }
    
    return nil;
}


@end
