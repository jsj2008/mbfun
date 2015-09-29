//
//  UIViewController+help.m
//  Qilian
//
//  Created by Miaozlc on 13-12-11.
//  Copyright (c) 2013年 Miaoz. All rights reserved.
//

#import "UIViewController+help.h"
#import "Globle.h"
#define ViewOffset 140

#define viewwh 140
@implementation UIViewController (help)

+(void)setSubViewExternNone:(UIViewController *)viewController

{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    if ( IOS7_OR_LATER )
        
    {
        
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
        
        viewController.extendedLayoutIncludesOpaqueBars = NO;
        
        viewController.modalPresentationCapturesStatusBarAppearance = NO;
        
        viewController.navigationController.navigationBar.translucent = NO;
        
    }
    
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
}


-(UIButton *)setNavRightBarbtnWithString:(NSString *)righttitleStr{
    //导航右按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:righttitleStr forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(registered)
    //     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    return button;
}
-(UIButton *)setNavRightBarbtnWithimage:(NSString *)imageStr{
    //导航右按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageStr]
                      forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(registered)
//     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;

    return button;
}
-(UIButton *)setNavLeftBarbtnWithimage:(NSString *)imageStr{
    //导航右按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageStr]
                      forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(registered)
    //     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    return button;
}
-(UIButton *)setNavLeftBarbtnWithimage:(NSString *)imageStr withRect:(CGRect )rect{
    //导航左按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageStr]
                      forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(registered)
    //     forControlEvents:UIControlEventTouchUpInside];
    button.frame = rect;
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    return button;
}
-(void)setNavbarchangeBgdAndTitlecolor{
   UINavigationBar *navBar = self.navigationController.navigationBar;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(40.0f, 203.0f, 182.0f,1.0f), UITextAttributeTextColor,[UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,nil]];

//     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1]
        if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
    //if iOS 5.0 and later
            [navBar setBackgroundColor:[UIColor blackColor]];
//    [navBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            UIImageView *imageView = (UIImageView *)[navBar viewWithTag:10];
            if (imageView == nil)
            {
                imageView = [[UIImageView alloc] initWithImage:
                             [UIImage imageNamed:@"navbar"]];
                [imageView setTag:10];
                 [imageView setBackgroundColor:[UIColor blackColor]];
                [navBar insertSubview:imageView atIndex:0];
                
            }
        }
}

-(void)changeSearchBar:(UISearchBar *)_searchBar{
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor whiteColor],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIColor whiteColor],
                                                                                                  UITextAttributeTextShadowColor,
                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                                                                  UITextAttributeTextShadowOffset,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    
    
    if(IOS7_OR_LATER){
        
        UIView *topView = _searchBar.subviews[0];
        
        UIButton *cancelButton;
        //for iOS 7
        
        
        if ([ _searchBar respondsToSelector: @selector(barTintColor)]) {
            
            
            //            [ _searchBar setBarTintColor:[UIColor grayColor]];
            
        }
        
        for (UIView *subView in topView.subviews) {
            
            if([subView isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                
                cancelButton = (UIButton*)subView;
                
                [cancelButton setBackgroundImage:[UIImage imageNamed:@"xxx.png"] forState:UIControlStateNormal];
                
                [cancelButton setEnabled:YES];
                
                cancelButton.userInteractionEnabled = YES;
                
                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                
            }
            
        }
        
    }else{
        
        //
        //for iOS6
        
        
        for(id cancelbutton in [_searchBar subviews])//将取消键换成发布活动
            
        {
            
            if([cancelbutton isKindOfClass:[NSClassFromString(@"UINavigationButton") class]])
                
            {
                [_searchBar setTintColor:[UIColor clearColor]];
                UIButton *btn = (UIButton *)cancelbutton;
                [btn setEnabled:YES];
                
                btn.userInteractionEnabled = YES;
                
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                
                
                
            }
            
        }
        
        for (UIView *subview in  _searchBar.subviews) {
            
            
            if ([subview isKindOfClass: NSClassFromString (@"UISearchBarBackground" )]) {
                
                [subview removeFromSuperview];
                
                UIView *vi = [UIView new];
                vi.frame = CGRectMake(0, 0, 320, 44);
                vi.backgroundColor = RGBACOLOR(201, 201, 206,1.0f);
                vi.alpha = 0.7;
                [_searchBar addSubview:vi];
                [_searchBar sendSubviewToBack:vi];
                
                break ;
                
                
            }
            
        }
        
        
    }
    
    
}



-(void)changeViewlayer:(CALayer *)layer{
    layer.cornerRadius = 8;//(值越大，角就越圆)
    layer.masksToBounds = YES;
    //边框宽度及颜色设置
    [layer setBorderWidth:1];
    [layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为蓝色


}
#pragma mark -- 自定义缓存图片 使用EGOCache
void UIImageFromURLTOCache( NSURL * URL , NSString *cachekey,void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
   
   
//    获取缓存的图片：
    
    /*保存到disk
    [[TMDiskCache sharedCache] objectForKey:cachekey block:^(TMDiskCache *cache, NSString *key, id<NSCoding> object, NSURL *fileURL) {
        if (object) {
            UIImage *image = (UIImage *)object;
            
            dispatch_async( dispatch_get_main_queue(), ^(void){
                if( image != nil )
                {
                    
                    imageBlock( image );
                    NSLog(@"获取缓存图片-----得到");
                    
                } else {
                    errorBlock();
                    
                }
            });
            return;
        }
        
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                       {
                           
                           NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                           UIImage * image = [[UIImage alloc] initWithData:data] ;
                           dispatch_async( dispatch_get_main_queue(), ^(void){
                               if( image != nil )
                               {
                                   [[TMDiskCache sharedCache] setObject:image forKey:cachekey block:nil];
                                   NSLog(@"获取缓存图片-----设置");
                                   imageBlock( image );
                                   
                               } else {
                                   errorBlock();
                               }
                           });
                       });

    }];
    
    
  
    */
    
    
    [[TMCache sharedCache] objectForKey:cachekey
                                  block:^(TMCache *cache, NSString *key, id object) {
                                      if (object) {
                                          UIImage *image = (UIImage *)object;
                                          
                                          dispatch_async( dispatch_get_main_queue(), ^(void){
                                              if( image != nil )
                                              {
                                                  
                                                  imageBlock( image );
                                                  NSLog(@"获取缓存图片-----得到");
                                                 
                                              } else {
                                                  errorBlock();
                                                 
                                              }
                                          });
                                          return;
                                      }
                                      
                                      dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                                                     {
                                                         
                                                         NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                                                         UIImage * image = [[UIImage alloc] initWithData:data] ;
                                                         dispatch_async( dispatch_get_main_queue(), ^(void){
                                                             if( image != nil )
                                                             {
                                                                 [[TMCache sharedCache] setObject:image forKey:cachekey block:nil];
                                                                 NSLog(@"获取缓存图片-----设置");
                                                                 imageBlock( image );
                                                                 
                                                             } else {
                                                                 errorBlock();
                                                             }
                                                         });
                                                     });

                                  }];
    

}



void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{


    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data] ;
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                              
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
    }

//排除一个文件备份
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL

{
    
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                    
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        
    }
    
    return success;
    
}

#pragma mark -直接画成image图片
-(UIImage *)imageDrawGroupimageWithimageArray:(NSArray *)imageArray{
    
//    NSArray *imgArray = [[NSArray alloc] initWithObjects:
//                         [self circleImage:[UIImage imageNamed:@"0"] withParam:0],
//                         [self circleImage:[UIImage imageNamed:@"1"] withParam:0],
//                         [self circleImage:[UIImage imageNamed:@"2"] withParam:0],
//                         [self circleImage:[UIImage imageNamed:@"3"] withParam:0],
//                         nil];
    NSMutableArray *imgArray = [NSMutableArray new];
    for (int i = 0; i<imageArray.count; i++) {
        if (i >= 4) {
            break;
        }
        [imgArray addObject:[self circleImage:imageArray[i] withParam:0]];
    }
    
    if (imgArray.count == 0 || imgArray == nil) {
        NSLog(@"图片数组为空");
        return nil;
    }
    NSArray *imgPointArray;
    switch (imgArray.count) {
        case 1:
            imgPointArray =@[
                             [NSString stringWithFormat:@"%d",viewwh/2],[NSString stringWithFormat:@"%d",viewwh/2]];
            break;
        case 2:
            imgPointArray =@[
                             [NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",viewwh/2],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",viewwh/2]];
            break;
        case 3:
            imgPointArray =@[
                             [NSString stringWithFormat:@"%d",viewwh/2],[NSString stringWithFormat:@"%d",viewwh/6],
                             [NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",viewwh]];
            break;
        case 4:
            imgPointArray =@[[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",0],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",0]];
            
            
            break;
        default:
            imgPointArray =@[[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",0],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",0]];
            break;
    }
    
    
    return [self mergedImageOnMainImage:[UIImage imageNamed:@"0.png"] WithImageArray:imgArray AndImagePointArray:imgPointArray];
    
    
}

- (UIImage *) mergedImageOnMainImage:(UIImage *)mainImg WithImageArray:(NSArray *)imgArray AndImagePointArray:(NSArray *)imgPointArray
{
    
    
    UIGraphicsBeginImageContext(CGSizeMake(viewwh+ViewOffset, viewwh+ViewOffset));
    
    //    [mainImg drawInRect:CGRectMake(0, 0, viewwh+ViewOffset, viewwh+ViewOffset)];
    int i = 0;
    for (UIImage *img in imgArray) {
        NSLog(@"imgimgimg-------%d",i);
                [img drawInRect:CGRectMake([[imgPointArray objectAtIndex:i] floatValue],
                                           [[imgPointArray objectAtIndex:i+1] floatValue],
                                           viewwh,
                                           viewwh)];
//        [img drawAtPoint:CGPointMake([[imgPointArray objectAtIndex:i] floatValue],
//                                     [[imgPointArray objectAtIndex:i+1] floatValue])];
        i+=2;
        
        if (i>=8) {
            break;
        }
    }
    
    CGImageRef NewMergeImg = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
                                                          CGRectMake(0, 0, viewwh+ViewOffset, viewwh+ViewOffset));
    
    UIGraphicsEndImageContext();
    
    
    if (NewMergeImg == nil) {
        return NO;
    }
    else {
        
        //        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:NewMergeImg], self, nil, nil);
        return [UIImage imageWithCGImage:NewMergeImg];
    }
}


-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


#pragma mark ---截图功能
/**
 
 *截图功能
 
 */

-(UIImage *)screenShot{
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 480), YES, 0);
//    
//    //设置截屏大小
//    
//    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    CGImageRef imageRef = viewImage.CGImage;
//    
//    CGRect rect = CGRectMake(0, 0, 320, 480);//这里可以设置想要截图的区域
//    
//    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
//    
//    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
//
//    //以下为图片保存代码
//    
//    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库

    UIGraphicsBeginImageContext(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-120)); //currentView 当前的view
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *sendImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return sendImage;
    
}
@end
