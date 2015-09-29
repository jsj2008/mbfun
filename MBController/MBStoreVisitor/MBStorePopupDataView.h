//
//  MBStorePopupDataView.h
//  Wefafa
//
//  Created by Jiang on 5/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    bottomDirection = 0,
    topDirection
} PointToDirection;

@interface MBStorePopupDataView : UIView

@property (nonatomic, assign) CGFloat apicoLocation_X;
@property (nonatomic, assign) PointToDirection direction;

- (void)setDirection:(PointToDirection)direction location_X:(CGFloat)location_X;

- (instancetype)initWithFrame:(CGRect)frame
                   shareCount:(int)sharedCount
                 visitorCount:(int)visitorCount
                        month:(NSString*)month
                          day:(NSString*)day;

- (instancetype)initWithShareCount:(int)sharedCount
                      visitorCount:(int)visitorCount
                             month:(NSString*)month
                               day:(NSString*)day;

- (void)setSubViewsDataWithShareCount:(int)sharedCount
                         visitorCount:(int)visitorCount
                                month:(NSString*)month
                                  day:(NSString*)day;

@end
