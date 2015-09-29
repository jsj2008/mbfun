//
//  CollectionBaseView.h
//  Wefafa
//
//  Created by mac on 13-10-10.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "PSTCollectionView.h"
#import "CommonEventHandler.h"

@interface CollectionBaseView : UIView<PSTCollectionViewDataSource, PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    PSUICollectionView *_gridView;
    NSCondition *download_lock;
    NSString *CollectionViewCellIdentifier;
    UIActivityIndicatorView *_actView;
}

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) CommonEventHandler *onDidSelectedCell;

-(CGSize)contentSize;
-(void)reloadData;
-(UIImage *) getImageAsyn:(NSString *)fileID ImageCallback:(void (^)(UIImage * image,NSObject *recv_img_id))imageBlock ErrorCallback:(void (^)(void))errorBlock;

-(PSUICollectionView *)getGridView;
-(void)configView;
-(void)startAnimating;
-(void)stopAnimating;

@end
