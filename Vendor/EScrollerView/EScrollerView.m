//
//  EScrollerView.m  
//  One
//
//  Created by fafatime on 14-3-31.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "EScrollerView.h"
//#import "SDImageCache.h"
//#import "UIImageView+WebCache.h"
#import "UIUrlImageView.h"
#import "AppSetting.h"

@implementation EScrollerView
@synthesize delegate;

- (void)dealloc {
	[scrollView release];scrollView=nil;
    
    [noteTitle release]; noteTitle=nil;
	delegate=nil;
    if (pageControl) {
        [pageControl release];pageControl=nil;
    }
    if (imageArray) {
        [imageArray release];
        imageArray=nil;
    }
    if (titleArray) {
        [titleArray release];
        titleArray=nil;
    }
    [super dealloc];
}
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr defaultImageName:(NSString *)defaultImageName scrollPagePosition:(ESCROLLERVIEW_SCROLL_PAGE_POSITION)scrollPagePosition isRecycleScroll:(BOOL)isRecycleScroll
{
	if ((self=[super initWithFrame:rect])) {
        self.userInteractionEnabled=YES;
        _isRecycleScroll=isRecycleScroll;
        _defaultImageName=defaultImageName;
        _scrollPagePosition=scrollPagePosition;
        
        viewSize=rect;
        [self initImageScrollView:imgArr TitleArray:titArr];
	}
	return self;
}
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr
{
    
	if ((self=[super initWithFrame:rect])) {
        self.userInteractionEnabled=YES;
        _isRecycleScroll=YES;
        
        viewSize=rect;
        [self initImageScrollView:imgArr TitleArray:titArr];
	}
	return self;
}
-(void)initImageScrollView:(NSArray *)imgArr TitleArray:(NSArray *)titArr
{
    titleArray=[titArr retain];
    NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
    if (_isRecycleScroll)
    {
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
    }
    imageArray=[[NSArray arrayWithArray:tempArray] retain];
    NSUInteger pageCount=[imageArray count];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getXMLFilePath]];
    
    NSString *zipUpPath= [nameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"url"]];
    
    if ([fileManager fileExistsAtPath:zipUpPath])
    {
        
    }
    else
    {
        
        NSString *zipUpPaths = [nameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"secondImg"]];
        zipUpPath=zipUpPaths;
        
    }
    
    [scrollView removeFromSuperview];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    for (int i=0; i<pageCount; i++) {
        NSString *imgURL=[imageArray objectAtIndex:i];
        
        NSString *imgSt =[imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //            NSLog(@"********imagURL=====%@",imgURL);
        
        UIUrlImageView *imgView=[[[UIUrlImageView alloc] init] autorelease];
        if ([imgURL hasPrefix:@"http://"]||[imgURL hasPrefix:@"https://"]) {
            //网络图片 请使用ego异步图片库
//            if (_defaultImageName.length==0)
//                [imgView setImageWithURL:[NSURL URLWithString:imgURL]];
//            else
//                [imgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:_defaultImageName]];
            

            [imgView downloadImageUrl:imgSt cachePath:[AppSetting getMBCacheFilePath] defaultImageName:_defaultImageName];
        }
        else
        {
            UIImage *img=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",zipUpPath,[imageArray objectAtIndex:i]]];
            //                NSLog(@"--tupain-------%@",[NSString stringWithFormat:@"%@/%@",zipUpPath,[imageArray objectAtIndex:i]]);
            [imgView setImage:img];
            
        }
        
        [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
        imgView.tag=i;
        UITapGestureRecognizer *Tap =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] autorelease];
        [Tap setNumberOfTapsRequired:1];
        [Tap setNumberOfTouchesRequired:1];
        imgView.userInteractionEnabled=YES;
        [imgView addGestureRecognizer:Tap];
        
        //
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.backgroundColor=[UIColor whiteColor];
        
        [scrollView addSubview:imgView];
    }
    if (_isRecycleScroll)
        [scrollView setContentOffset:CGPointMake(1*viewSize.size.width, 0)];
    else
        [scrollView setContentOffset:CGPointMake(0*viewSize.size.width, 0)];
    [self addSubview:scrollView];
    
    
    if (_scrollPagePosition!=ESCROLLERVIEW_SCROLL_NO_PAGE)
    {
        //说明文字层
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30,self.bounds.size.width,30)];
        self.noteView=view1;
        [self.noteView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [self addSubview:self.noteView];
        [view1 release];
        
        float pageControlWidth=imgArr.count*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        switch (_scrollPagePosition) {
            case ESCROLLERVIEW_SCROLL_PAGE_RIGHT:
                pageControl=[[StyledPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),6, pageControlWidth, pagecontrolHeight)];
                break;
            case ESCROLLERVIEW_SCROLL_PAGE_LEFT:
                pageControl=[[StyledPageControl alloc]initWithFrame:CGRectMake(6,6, pageControlWidth, pagecontrolHeight)];
                break;
            case ESCROLLERVIEW_SCROLL_PAGE_CENTER:
                pageControl=[[StyledPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth)/2,6, pageControlWidth, pagecontrolHeight)];
                break;
            default:
                break;
        }
        pageControl.currentPage=0;
        if (_isRecycleScroll)
            pageControl.numberOfPages=(int)pageCount-2;
        else
            pageControl.numberOfPages=(int)pageCount;
        // change color
        [pageControl setCoreNormalColor:[UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:0.8]];
        [pageControl setCoreSelectedColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        [pageControl setPageControlStyle:PageControlStyleDefault];
        [self.noteView addSubview:pageControl];
        
        if (titleArray.count>0)
        {
            noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 6, self.frame.size.width-pageControlWidth-15, 20)];
            noteTitle.textColor=[UIColor whiteColor];
            
            [noteTitle setText:[titleArray objectAtIndex:0]];
            [noteTitle setBackgroundColor:[UIColor clearColor]];
            [noteTitle setFont:[UIFont systemFontOfSize:16]];//13
            [self.noteView addSubview:noteTitle];
            
        }
    }

}

-(NSArray *)getImageUrlArray
{
    return imageArray;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (_isRecycleScroll)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        currentPageIndex=page;
        
        pageControl.currentPage=(page-1);
        
        int titleIndex=page-1;
        if (titleIndex==[titleArray count]) {
            titleIndex=0;
        }
        if (titleIndex<0) {
            titleIndex=(int)[titleArray count]-1;
        }
        [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
    }
    else
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        currentPageIndex=page;
        pageControl.currentPage=page;
        [noteTitle setText:[titleArray objectAtIndex:pageControl.currentPage]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (_isRecycleScroll)
    {
        if (currentPageIndex==0) {
            
            [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
        }
        if (currentPageIndex==([imageArray count]-1)) {
            
            [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
            
        }
    }
}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{

    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [delegate EScrollerViewDidClicked:(UIImageView*)sender.view];
    }
}

@end
