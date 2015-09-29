//
//  CardView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "CardView.h"
#import "CollocationInfo.h"
#import "Toast+UIView.h"
@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
//    CGFloat borderWidth = 0.5f;
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = borderWidth;
//     Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
//    self.layer.shadowRadius = 4.0;
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // Corner Radius
//    self.layer.cornerRadius = 10.0;
    [self createImageView];
}

-(void)createImageView{
    if (_imageView == nil) {
        UIImageView *imageVIew = [[UIImageView alloc] initWithFrame:self.frame];
        _imageView = imageVIew;
        imageVIew.image = [UIImage imageNamed:@"btn_ornaments_normal@3x"];
        [self addSubview:imageVIew];
     
        UIImageView *skipimageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x+10, self.bounds.origin.y+10, self.bounds.size.width/3, self.bounds.size.height/6)];
        _skipImageView = skipimageVIew;
//         skipimageVIew.hidden = YES;
        skipimageVIew.alpha = 0.0f;
        skipimageVIew.image = [UIImage imageNamed:@"SKIP@3x"];
        [self addSubview:skipimageVIew];
     
        UIImageView *saveimageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-10-self.bounds.size.width/3, self.bounds.origin.y+10, self.bounds.size.width/3, self.bounds.size.height/6)];
        _saveImageView = saveimageVIew;
//        saveimageVIew.hidden = YES;
        saveimageVIew.alpha = 0.0f;
        saveimageVIew.image = [UIImage imageNamed:@"SAVE@3x"];
        [self addSubview:saveimageVIew];
    

    }
   

}

-(void)setCollocationInfo:(CollocationInfo *)collocationInfo{
    _collocationInfo = collocationInfo;
           NSString *imageurl =  [self changeStringWithurlString:collocationInfo.pictureUrl];
    if (collocationInfo.showImage == nil) {
        [self makeToastActivity];
        
        UIImageFromURLConvert([NSURL URLWithString:imageurl], ^(UIImage *image) {
            self.imageView.image = image;
            [self hideToastActivity];
        }, ^{
            [self hideToastActivity];
        });
    }else{
        self.imageView.image = collocationInfo.showImage;
    }
  

}

void UIImageFromURLConvert( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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

-(NSString *)changeStringWithurlString:(NSString *)imageurl{
    
    NSMutableString *mainurlString;
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:imageurl];
    NSRange range = [String1 rangeOfString:@"--"];
    
    int location = (int)range.location;
    int leight = (int)range.length;
    
    if (leight == 2) {////有--400x400
        mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
        [mainurlString appendString:[NSString stringWithFormat:@".png"]];
        
        
    }else{//没有--400x400 //有后缀.png
        NSRange range = [String1 rangeOfString:@".png"];
        
        int leight = (int)range.length;
        if (leight == 4){//有后缀.png
            
            mainurlString = [[NSMutableString alloc] initWithString:String1];
            
        }else{//没有后缀png
            
            //后缀jpg
            NSRange range2 = [String1 rangeOfString:@".jpg"];
            int location2 = (int)range2.location;
            int leight2 = (int)range2.length;
            if (leight2 == 4){//有后缀.jpg
                
                mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
                [mainurlString appendString:[NSString stringWithFormat:@".jpg"]];
            }else{//没有后缀
                
                mainurlString = [[NSMutableString alloc] initWithString:String1];
                [mainurlString appendString:[NSString stringWithFormat:@".png"]];
                
            }
            
            
        }
        
    }
    
    [mainurlString insertString:[NSString stringWithFormat:@"--%dx%d",(int)200,(int)200] atIndex:mainurlString.length -4];
    NSLog(@"mainurlString--------%@",mainurlString);
    return mainurlString;
}



@end
