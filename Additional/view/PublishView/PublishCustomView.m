//
//  PublishCustomView.m
//  Wefafa
//
//  Created by Miaoz on 15/5/8.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#define wordNum 70

#define totalloc 4
#define appvieww 62.5
#define appviewh 22
#define margin (self.frame.size.width-totalloc*appvieww)/(totalloc+3)
#define  positionHeight  30.0f

#import "Globle.h"
#import "PublishCustomView.h"
#import "UIPlaceHolderTextView.h"
#import "TagMapping.h"
#import "UMButton.h"
#import "ShareCellView.h"
@interface  PublishCustomView()<UITextViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@end

@implementation PublishCustomView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.backgroundColor = [UIColor clearColor];
        //        self.opaque = YES;
        [self creatScrollView];
        [self createArray];
        [self createDesc];
       
    }
    return self;
}

-(void)creatScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:_scrollView];

}
-(void)createArray{
    if (_dataTopicarray == nil) {
        _dataTopicarray = [NSMutableArray new];
    }
    if (_dataTagarray == nil) {
        _dataTagarray = [NSMutableArray new];
    }
    
    if (_postTagarray == nil) {
        _postTagarray = [NSMutableArray new];
    }
    if (_postCustomTagarray == nil) {
        _postCustomTagarray = [NSMutableArray new];
    }
    if (_postTopicarray == nil) {
        _postTopicarray = [NSMutableArray new];
    }

}
-(void)createDesc{
    UIImageView *shareRelatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 54, 54)];
    _shareRelatedImageView = shareRelatedImageView;
    shareRelatedImageView.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:shareRelatedImageView];
    
    
    UIPlaceHolderTextView *descplacetextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(shareRelatedImageView.frame.origin.x+shareRelatedImageView.frame.size.width+15, 15, _scrollView.frame.size.width -(shareRelatedImageView.frame.origin.x+shareRelatedImageView.frame.size.width+15*2), 80)];
    descplacetextView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    descplacetextView.tag = 666;
    _descTextView = descplacetextView;
    descplacetextView.delegate = self;
    //    descplacetextView.layer.borderColor = [UIColor grayColor].CGColor;
    //    descplacetextView.layer.borderWidth = 1.0f;
    //    descplacetextView.layer.masksToBounds = YES;
    //    descplacetextView.layer.cornerRadius = 3.0f;
    descplacetextView.font = [UIFont systemFontOfSize:14.0f];
     descplacetextView.textColor = [UIColor colorWithHexString:@"#919191"];
    
    descplacetextView.placeHolderLabel.font = [UIFont systemFontOfSize:14.0f];
    descplacetextView.placeholder = @"请输入相关搭配描述";
    [_scrollView addSubview:descplacetextView];
    
    UILabel *descpromptLab = [[UILabel alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width - 100-20, descplacetextView.frame.origin.y + descplacetextView.frame.size.height + 5, 100, 20)];
    //    descpromptLab.backgroundColor = [UIColor redColor];
    _descpromptLab = descpromptLab;
    [descpromptLab setTextAlignment:NSTextAlignmentRight];
    descpromptLab.text = [NSString stringWithFormat:@"你还可以输入%d个字",wordNum];
    [descpromptLab setAttributedText:[self getAttributeStrWithStringWithString:descpromptLab.text withRange:NSMakeRange(6, 2)]];
    descpromptLab.font = [UIFont boldSystemFontOfSize:10.0f];
    [_scrollView addSubview:descpromptLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, descpromptLab.frame.origin.y+descpromptLab.frame.size.height + 5, _scrollView.frame.size.width-30, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [_scrollView addSubview:lineView];
    
    UILabel *tagLab = [[UILabel  alloc] initWithFrame:CGRectMake(15, lineView.frame.origin.y + lineView.frame.size.height + 10, 100, 20)];
    tagLab.text = @"标签";
    tagLab.textColor = [UIColor colorWithHexString:@"#333333"];
    //    tagLab.backgroundColor = [UIColor redColor];
    tagLab.font = [UIFont boldSystemFontOfSize:14.0f];
    [_scrollView addSubview:tagLab];
    
    UIPlaceHolderTextView *tagplacetextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, tagLab.frame.origin.y + tagLab.frame.size.height + 5, _scrollView.frame.size.width -20, 40)];
    tagplacetextView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    tagplacetextView.tag = 777;
    _tagTextView = tagplacetextView;
    tagplacetextView.delegate = self;
    //    tagplacetextView.layer.borderColor = [UIColor grayColor].CGColor;
    //    tagplacetextView.layer.borderWidth = 1.0f;
    //    tagplacetextView.layer.masksToBounds = YES;
    //    tagplacetextView.layer.cornerRadius = 3.0f;
    tagplacetextView.font = [UIFont systemFontOfSize:14.0f];
    tagplacetextView.textColor = [UIColor colorWithHexString:@"#919191"];
    
    tagplacetextView.placeholder = @"选择标签或输入自定义标签按“空格”隔开";
    tagplacetextView.placeHolderLabel.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:tagplacetextView];
    

    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, tagplacetextView.frame.origin.y+tagplacetextView.frame.size.height + 5, _scrollView.frame.size.width-30, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [_scrollView addSubview:lineView2];
    
    //系统标签
    [[HttpRequest shareRequst] httpRequestGetWxCollocationShowTagFilter:
     (NSMutableDictionary *)@{@"pageIndex":[NSNumber numberWithInt:1],
                              
                              @"pageSize":[NSNumber numberWithInt:100]} success:^(id obj){
                                  if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
                                 {
                                     id data = [obj objectForKey:@"results"];
                                     if ([data isKindOfClass:[NSArray class]])
                                     {
                                         for (NSDictionary *dic in data)
                                         {
                                             TagMapping *tagMapping;
                                             tagMapping = [JsonToModel objectFromDictionary:dic className:@"TagMapping"];
                                             [_dataTagarray addObject:tagMapping];
                                         }
                                         
                                     }
                                     
                                     [self createTagButtonsWithY:lineView2.frame.origin.y+lineView2.frame.size.height+10];
                                 }

        
                                                                                                 } ail:^(NSString *errorMsg) {
                                                                                                     
                                                                                                 }];
    
    
    
}
-(void)createTagButtonsWithY:(CGFloat )y{
    int count=(int)_dataTagarray.count;
    for (int i=0; i<count; i++)
    {
        int row=i/totalloc;//行号
        int loc=i%totalloc;//列号
        
        
        CGFloat appviewx=margin+(margin+appvieww)*loc;
        CGFloat appviewy=margin+(margin+appviewh)*row;
        
        TagMapping *tagMapping = _dataTagarray[i];
        UMButton *btn = [UMButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 120+i;
        btn.frame = CGRectMake(appviewx+10, appviewy+y, appvieww, appviewh);
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //文本文字自适应大小
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setTitleColor:[UIColor colorWithHexString:@"#6b6b6b"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        [btn addTarget:self action:@selector(buttonTagClickevent:) forControlEvents:UIControlEventTouchUpInside];
        if (tagMapping.name == nil) {
            tagMapping.name = @"默认";
        }
        [btn setTitle:tagMapping.name forState:UIControlStateNormal];
        [_scrollView addSubview:btn];
        
        if (i == count-1) {
            _scrollView.contentSize = CGSizeMake(self.frame.size.width,btn.frame.origin.y + btn.frame.size.height);
            
            UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(15, btn.frame.origin.y + btn.frame.size.height+ 15, _scrollView.frame.size.width-30, 0.5)];
            lineView3.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
            [_scrollView addSubview:lineView3];
            
            [self createClickButtonWithY:lineView3.frame.origin.y + lineView3.frame.size.height+10];
        }
        
        
    }
    _scrollView.contentSize = CGSizeMake(self.frame.size.width,self.frame.size.height+150);
    //        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, 1000);
    
}

-(void)createClickButtonWithY:(CGFloat)Y{
    UIView *view=nil;
    view=[self createShareCellView:@"微信" imageName:@"btn_wechat_normal@2x.png" imageNameClicked:@"btn_wechat_pressed@3x.png" clickAction:@selector(btnWeiXinClicked:) index:0 withY:Y];
    [self addSubview:view];
    
    view=[self createShareCellView:@"朋友圈" imageName:@"btn_friend_normal@2x.png" imageNameClicked:@"btn_friend_pressed@3x.png" clickAction:@selector(btnCircleClicked:) index:1 withY:Y];
    [self addSubview:view];
    
    view=[self createShareCellView:@"微博" imageName:@"btn_weibo_normal@2x.png" imageNameClicked:@"btn_weibo_pressed@3x.png" clickAction:@selector(btnSinaClicked:) index:2 withY:Y];
    [self addSubview:view];
    
    view=[self createShareCellView:@"QQ" imageName:@"btn_QQ_normal@2x.png" imageNameClicked:@"btn_QQ_pressed@3x.png" clickAction:@selector(btnQQclicked:) index:3  withY:Y];
    [self addSubview:view];
    
    
    //    view=[self createShareCellView:@"造型师好友" imageName:@"btn_share.png" imageNameClicked:@"btn_share.png" clickAction:@selector(btnTxlClicked:) index:4];
    //
    
    //     view=[self createShareCellView:@"造型师朋友圈" imageName:@"btn_share.png" imageNameClicked:@"btn_share.png" clickAction:@selector(btnFriendslicked:) index:5];
    [self addSubview:view];
    
    
    [self addSubview:view];
}

-(UIView*)createShareCellView:(NSString *)name imageName:(NSString *)imageName imageNameClicked:(NSString *)imageNameClicked clickAction:(SEL)clickAction index:(int)index withY:(CGFloat)Y
{
    
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50*index, 0, 50, 50)];
    //    UIImageView
    ShareCellView *view=[[[NSBundle mainBundle] loadNibNamed:@"ShareCellView" owner:self options:nil] objectAtIndex:0];
    view.backgroundColor = [UIColor clearColor];
    //    view.backgroundColor = [UIColor redColor];
    //    [view.btnItem setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //    [view.btnItem setImage:[UIImage imageNamed:imageNameClicked] forState:UIControlStateHighlighted];
    view.btnItem.tag = 70+index;
    view.imageView.image=[UIImage imageNamed:imageName];
    
    [view.btnItem addTarget:self action:clickAction forControlEvents:UIControlEventTouchUpInside];
    view.lbName.textColor=[Utils HexColor:0x6b6b6b Alpha:1.0];
    view.lbName.text=[[NSString alloc] initWithFormat:@"%@",name ];
    view.lbName.font = [UIFont systemFontOfSize:12.0f];
    view.frame=CGRectMake(15+index*80, Y, 80, 80);
    view.btnItem.frame = CGRectMake(0, 0, 45, 45);
    view.imageView.frame  = CGRectMake(5, 0,  40, 40);
    view.lbName.frame  = CGRectMake(5, view.imageView.frame.size.height,  40, 15);
    //    view.imageView.layer.masksToBounds=YES;
    //    view.imageView.layer.cornerRadius=view.imageView.frame.size.width/2;
    //    view.frame=CGRectMake(101+index%3*view.frame.size.width/1.5,(index/3)*view.frame.size.height/1.2+fixedWidth, 50, 50);
    
    return view;
}

-(void)btnWeiXinClicked :(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackPublishCustomViewWithShareButton:)]) {
        [_delegate callBackPublishCustomViewWithShareButton:sender];
    }
}
-(void)btnCircleClicked :(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackPublishCustomViewWithShareButton:)]) {
        [_delegate callBackPublishCustomViewWithShareButton:sender];
    }
}
-(void)btnSinaClicked :(UIButton *)sender{
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackPublishCustomViewWithShareButton:)]) {
        [_delegate callBackPublishCustomViewWithShareButton:sender];
    }
}
-(void)btnQQclicked :(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackPublishCustomViewWithShareButton:)]) {
        [_delegate callBackPublishCustomViewWithShareButton:sender];
    }
}

- (void)btnFriendslicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(callBackPublishCustomViewWithShareButton:)]) {
        [_delegate callBackPublishCustomViewWithShareButton:sender];
    }
}

-(void)btnTxlClicked :(UIButton *)sender{
    //    CustomActionSheet *actionview=(CustomActionSheet*)[[[((UIButton*)sender) superview] superview] superview];
    //    [actionview dismissWithClickedButtonIndex:0 animated:YES];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackPublishCustomViewWithShareButton:)]) {
        [_delegate callBackPublishCustomViewWithShareButton:sender];
    }
}

-(void)buttonTagClickevent:(UMButton *)sender{
    int index = (int)sender.tag - 120;
    if ([sender.titleLabel.textColor isEqual:[UIColor colorWithHexString:@"#333333"]]) {
        [sender setTitleColor:[UIColor colorWithHexString:@"#6b6b6b"] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        sender.layer.borderColor = [[UIColor colorWithHexString:@"#919191"] CGColor];
        [_postTagarray removeObject:_dataTagarray[index]];
        
    }else{
        [sender setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithHexString:@"#ffde00"]];
        sender.layer.borderColor = [[UIColor clearColor] CGColor];
        [_postTagarray addObject:_dataTagarray[index]];
    }
    
}


- (NSAttributedString *)getAttributeStrWithStringWithString:(NSString *)string withRange:(NSRange)range
{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    //把this的字体颜色变为红色
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor redColor]
                        range:range];
    //把is变为黄色
    //    [attriString addAttribute:NSForegroundColorAttributeName
    //                        value:[UIColor blackColor]
    //                        range:NSMakeRange(3, [string length] - 3)];
    //改变this的字体，value必须是一个CTFontRef
    //        [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 10)];
    
    return attriString;
}
# pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self endEditing:NO];
  
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:NO];
   
    
}
# pragma mark-UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    
}


//这个函数的最后一个参数text代表你每次输入的的那个字，所以：
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        [self endEditing:NO];
   
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    
    return YES;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
////    int charNun = [self convertToInt:textView.text];
////
////    _wordsLastNumLbl.text = [NSString stringWithFormat:@"已经写 %d 字,还剩 %d 字",charNun,300 - charNun];
//
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 666) {
        int charNun = (int)textView.text.length;
        //        [self convertToInt:textView.text];d
        NSString *descpromptLabString = nil;
        if (wordNum - charNun >= 0) {
            descpromptLabString = [NSString stringWithFormat:@"你还可以输入%d个字", wordNum - charNun];
        }else{
            descpromptLabString = [NSString stringWithFormat:@"输入已超出%d个字", charNun - wordNum];
        }
        _descpromptLab.text = descpromptLabString;
        
        
        NSString *tmpnumStr = [NSString stringWithFormat:@"%d",wordNum - charNun];
        if (wordNum - charNun >= 0) {
            if (tmpnumStr.length==3&&tmpnumStr.intValue>=100) {
                
                [_descpromptLab setAttributedText:[self getAttributeStrWithStringWithString:_descpromptLab.text withRange:NSMakeRange(6, 3)]];
            }else if (tmpnumStr.length==2&&tmpnumStr.intValue>=10) {
                [_descpromptLab setAttributedText:[self getAttributeStrWithStringWithString:_descpromptLab.text withRange:NSMakeRange(6, 2)]];
            }else{
                [_descpromptLab setAttributedText:[self getAttributeStrWithStringWithString:_descpromptLab.text withRange:NSMakeRange(6, 1)]];
            }
            
        }else{
            
            if (tmpnumStr.length==4) {
                
                [_descpromptLab setAttributedText:[self getAttributeStrWithStringWithString:_descpromptLab.text withRange:NSMakeRange(5, 3)]];
            }else if (tmpnumStr.length==3) {
                [_descpromptLab setAttributedText:[self getAttributeStrWithStringWithString:_descpromptLab.text withRange:NSMakeRange(5, 2)]];
            }else{
                [_descpromptLab setAttributedText:[self getAttributeStrWithStringWithString:_descpromptLab.text withRange:NSMakeRange(5, 1)]];
            }
        }
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
