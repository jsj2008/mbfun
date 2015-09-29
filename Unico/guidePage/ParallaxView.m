//
//  ParallaxView.m
//  MCPagerView
//
//  Created by wave on 15/9/15.
//
//

#import "parallaxView.h"

//#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
//#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define PARALLAXFACTOR  [UIScreen mainScreen].bounds.size.width / 370

#define BASETAG 1001

@interface ParallaxView ()
@property (nonatomic, strong) NSArray *imageNameArray;
@property (nonatomic, strong) NSMutableArray *imgViewArray;
@property (nonatomic, assign) CGFloat tempX;
@end

@implementation ParallaxView

- (instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray*)imgArray {
    frame = CGRectMake(0, 0, SCREEN_WIDTH * 6, SCREEN_HEIGHT);
    if (self == [super initWithFrame:frame]) {
        self.imgViewArray = [@[] mutableCopy];
        self.imageNameArray = imgArray;
        [self uiconfig];
    }
    return self;
}


- (void)uiconfig {
    __weak __typeof(self) ws = self;
    [self.imageNameArray enumerateObjectsUsingBlock:^(NSString *imgName, NSUInteger idx, BOOL *stop) {
        UIView *tempView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        tempView.backgroundColor = [UIColor clearColor];
        [tempView setTag:idx + BASETAG];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:ws.frame];
        [tempView addSubview:imgView];
        //set image
        [imgView setImage:[UIImage imageNamed:imgName]];
        //set imgViewArray
        [ws.imgViewArray addObject:imgView];
        //set frame
        switch (idx) {
                //-----------------------第一页
            case 0:
            {
                //时尚大牌应有尽有
                [imgView setFrame:CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 1:
            {
                //phone
                [imgView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 2:
            {
                //a3-01
                [imgView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 3:
            {
                //a3-02
                [imgView setFrame:CGRectMake(SCREEN_WIDTH / 3, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
                //-----------------------第二页
            case 4:
            {
                [imgView setFrame:CGRectMake(1 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 5:
            {
                [imgView setFrame:CGRectMake(2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 6:
            {
                [imgView setFrame:CGRectMake(3 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 7:
            {
                [imgView setFrame:CGRectMake(4 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 8:
            {
                [imgView setFrame:CGRectMake(5 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
                //-----------------------第三页
            case 9:
            {
                [imgView setFrame:CGRectMake(2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 10:
            {
                [imgView setFrame:CGRectMake(4 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 11:
            {
                [imgView setFrame:CGRectMake(5 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 12:
            {
                [imgView setFrame:CGRectMake(6 *SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 13:
            {
                [imgView setFrame:CGRectMake(7 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
                //-----------------------第三页
            case 14:
            {
                [imgView setFrame:CGRectMake(3 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 15:
            {
                [imgView setFrame:CGRectMake(3.75 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//                [imgView setFrame:CGRectMake(3.15 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 16:
            {
                [imgView setFrame:CGRectMake(7.5 *SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
            case 17:
            {
                [imgView setFrame:CGRectMake(10.5 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
                break;
                
            default:
                break;
        }
        if (tempView.tag == 8 + BASETAG) {
            [ws insertSubview:tempView belowSubview:[ws viewWithTag:5 + BASETAG]];
            
        }else{
            [ws addSubview:tempView];
        }
    }];
}

- (void)updataUI:(CGPoint)point {
    /*
    __weak __typeof(self) ws = self;
    [self.imgViewArray enumerateObjectsUsingBlock:^(UIImageView *imgView, NSUInteger idx, BOOL *stop) {
        if (idx < 5) {
            //-----------------------第一页
            if (idx == 2) {
                CGFloat factor = 0.5;
                CGFloat x = 0;
                if (ws.tempX > point.x) {
                    NSLog(@"1 == point.x == %f", point.x);
                    x = imgView.frame.origin.x + 2;
                }else if(ws.tempX < point.x) {
                    NSLog(@"2");
                    x = imgView.frame.origin.x - 2;
                }else if (ws.tempX == point.x) {
                    
                }
                //还原frame
                CGRect rect = imgView.frame;
                rect.origin = CGPointMake(0, rect.origin.y);
                //赋值frame
                imgView.frame = CGRectOffset(rect, x, 0);
                ws.tempX = point.x;
            }
        }else if (idx < 11) {
            //-----------------------第二页
        }
    }];
     */
}

@end
