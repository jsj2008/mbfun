//
//  CollocationImageTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-12-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CollocationImageTableViewCell.h"

//#import "EGOPhotoGlobal.h"
//#import "MyPhoto.h"
//#import "MyPhotoSource.h"
//#import "AppDelegate.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "Utils.h"

@implementation CollocationImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)innerInit
{
    [super innerInit];
    
    imageView.userInteractionEnabled=YES;
    imageView.layer.zPosition= 5;//
    
    self.backgroundColor = [UIColor whiteColor];
//    CAGradientLayer *layer = [CAGradientLayer layer];
//    layer.frame = self.frame;
////    layer.opacity = 0.3;
//    layer.colors = @[(id)[Utils HexColor:0xe2e2e2 Alpha:1].CGColor, (id)[Utils HexColor:0xe2e2e2 Alpha:0].CGColor];
//    layer.locations = @[@0, @0.5];
//    layer.startPoint = CGPointMake(0.5, 1); // 从上中 到下中
//    layer.endPoint = CGPointMake(0.5, 0);
//    [self.layer insertSublayer:layer atIndex:0];
    
    
    UITapGestureRecognizer *singleTouchHeadImage=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(imageViewClicked:)];
    [imageView addGestureRecognizer:singleTouchHeadImage];
}

-(void)imageViewClicked:(UIImage*)sender
{
//    UIGestureRecognizer *touch=(UIGestureRecognizer *)sender;
//    UIImageView *imageView=(UIImageView *)[touch view];
    
    
//    NSMutableArray *phonto_arr=[[NSMutableArray alloc] initWithCapacity:5];
//    MyPhoto *photo=[[MyPhoto alloc] initWithImage:imageView.image];
//    [phonto_arr addObject:photo];
//    if ([phonto_arr count]>0)
//    {
//        MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:phonto_arr];
//        EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
//        
//        //图片在附件中所有图片的序号
//        int imagecount=1;
//        [photoController setStartPhotoIndex:imagecount-1];
//        
//        RootViewController *rootVC = [AppDelegate rootViewController];
//        [rootVC pushViewController:photoController animated:YES];
//    }
    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.image = imageView.image;
    photo.srcImageView = imageView; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
