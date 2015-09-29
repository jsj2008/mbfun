//
//  SMineReleaseCollectionView.m
//  Wefafa
//
//  Created by Funwear on 15/8/25.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMineReleaseCollectionView.h"
#import "SProductShowImageCell.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SCollocationDetailViewController.h"
#import "SCollocationDetailNoneShopController.h"
@interface SMineReleaseCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end
static NSString *cellIdentifier = @"SProductShowImageCellIdentifier";
@implementation SMineReleaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
- (void)awakeFromNib{
    self.backgroundColor =[UIColor whiteColor];
    self.alwaysBounceVertical = YES;
    [self registerNib:[UINib nibWithNibName:@"SProductShowImageCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellIdentifier"];
    self.delegate = self;
    self.dataSource = self;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = [NSMutableArray arrayWithArray:contentArray];
    [self reloadData];
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_WIDTH-3) / 3, UI_SCREEN_HEIGHT/3.55);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        NSDictionary *dic=_contentArray[indexPath.row];
        SProductShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.contentImageView setFrame:cell.bounds];
        [cell.contentImageView sd_setImageWithURL:[dic objectForKey:@"img"] ];
//        [cell initData:dic];
        [cell.contentImageView setTag:indexPath.row];
        cell.contentImageView.userInteractionEnabled = YES;
        [SUTILITY_TOOL_INSTANCE addViewAction:cell.contentImageView target:self action:@selector(enterCollocationView:)];
        return cell;
}

//定义每个UICollectionView 的 margin  四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.5f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.5f;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.opration) {
        self.opration(indexPath, _contentArray);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.collectionViewDelegate respondsToSelector:@selector(listViewDidScroll:)]){
        [self.collectionViewDelegate listViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.collectionViewDelegate respondsToSelector:@selector(listViewWillBeginDraggingScroll:)]) {
        [self.collectionViewDelegate listViewWillBeginDraggingScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.collectionViewDelegate respondsToSelector:@selector(listViewDidEndDecelerating:)]) {
        [self.collectionViewDelegate listViewDidEndDecelerating:scrollView];
    }    
}


//进入搭配详情，判断是否登录暂时屏蔽
-(void)enterCollocationView:(UITapGestureRecognizer *)selector{
    /*     SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
     if (dataModel) {
     vc.collocationId = [dataModel.idValue intValue];
     }else{
     vc.collocationId = [self.cellData[@"id"] intValue];
     vc.collocationInfo = self.cellData;
     }
     [self.parentVc.navigationController pushViewController:vc animated:YES];*/
    
    
    NSDictionary *dic=_contentArray[selector.view.tag];
    
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
     
        detailNoShoppingViewController.collocationId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        detailNoShoppingViewController.collocationInfo = dic;

        [self.parentVc.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        
        collocationDetailVC.collocationId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        collocationDetailVC.collocationInfo = dic;
    
        [self.parentVc.navigationController pushViewController:collocationDetailVC animated:YES];
    }
    
    
}
-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset] ;
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]  : nil;
    return thumbnailImage;
}

//-(UIImage *)CreateVideoImage:(NSURL *)url{
//    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:[AVAsset assetWithURL:url]];
//    
//    NSError *error=nil;
//    CMTime actualTime;
//    
//    UIImage *image= nil;
//    
//    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:&actualTime error:&error];
//    if(error == nil)
//    {
//        CMTimeShow(actualTime);
//        image=[UIImage imageWithCGImage:cgImage];
//        
//        CGImageRelease(cgImage);
//    }
//    
//    return image;
//}
@end
