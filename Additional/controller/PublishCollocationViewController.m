//
//  PublishCollocationViewController.m
//  newdesigner
//
//  Created by Miaoz on 14-10-14.
//  Copyright (c) 2014年 mb. All rights reserved.
//
#define totalloc 4
#define appvieww 62.5
#define appviewh 22
#define margin (self.view.frame.size.width-totalloc*appvieww)/(totalloc+3)
#define  positionHeight  30.0f
#import "PublishCollocationViewController.h"


@interface PublishCollocationViewController ()<UITextViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@end

@implementation PublishCollocationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [_titleTextView isFirstResponder];
//    [self.titleTextView canBecomeFirstResponder];
//    [self.titleTextView becomeFirstResponder];
    _titleTextView.backgroundColor = [UIColor clearColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self addTapRecognizer];
    _shareRelated = [ShareRelated sharedShareRelated];
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:_scrollView];
    [self createDesc];
   
   
//    _titleTextView.placeholder = @"请输入标题(不能为空)";
//    _titleTextView.delegate = self;
//
//    [self createTitleLab];
//    CGFloat linY = [self creatLineImageViewWithY:_titleTextView.frame.origin.y+25.0f];
//    [self createTopicLabWithY:linY+10.0f];
//    
//    [self requestHttpTopic];

    // Do any additional setup after loading the view.
}
-(void)createDesc{
    UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
//    descLab.backgroundColor = [UIColor redColor];
    descLab.text = @"描述";
    descLab.font = [UIFont boldSystemFontOfSize:18.0f];
    [_scrollView addSubview:descLab];
    
    
    UIPlaceHolderTextView *descplacetextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(15, descLab.frame.origin.y + descLab.frame.size.height + 5, _scrollView.frame.size.width -35, 60)];
    descplacetextView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    descplacetextView.tag = 666;
    _descTextView = descplacetextView;
    descplacetextView.delegate = self;
//    descplacetextView.layer.borderColor = [UIColor grayColor].CGColor;
//    descplacetextView.layer.borderWidth = 1.0f;
//    descplacetextView.layer.masksToBounds = YES;
//    descplacetextView.layer.cornerRadius = 3.0f;
    descplacetextView.font = [UIFont systemFontOfSize:12.0f];
     descplacetextView.placeHolderLabel.font = [UIFont systemFontOfSize:12.0f];
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
    
    
    UILabel *tagLab = [[UILabel  alloc] initWithFrame:CGRectMake(20, descpromptLab.frame.origin.y + descpromptLab.frame.size.height + 5, 100, 30)];
    tagLab.text = @"标签";
//    tagLab.backgroundColor = [UIColor redColor];
    tagLab.font = [UIFont boldSystemFontOfSize:18.0f];
    [_scrollView addSubview:tagLab];
    
    UIPlaceHolderTextView *tagplacetextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(15, tagLab.frame.origin.y + tagLab.frame.size.height + 5, _scrollView.frame.size.width -35, 60)];
    tagplacetextView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    tagplacetextView.tag = 777;
    _tagTextView = tagplacetextView;
    tagplacetextView.delegate = self;
//    tagplacetextView.layer.borderColor = [UIColor grayColor].CGColor;
//    tagplacetextView.layer.borderWidth = 1.0f;
//    tagplacetextView.layer.masksToBounds = YES;
//    tagplacetextView.layer.cornerRadius = 3.0f;
    tagplacetextView.font = [UIFont systemFontOfSize:12.0f];
    
    tagplacetextView.placeholder = @"请选择或输入标签";
    tagplacetextView.placeHolderLabel.font = [UIFont systemFontOfSize:12.0f];
    [_scrollView addSubview:tagplacetextView];
    
    UILabel *tagpromptLab = [[UILabel alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width - 100-20, tagplacetextView.frame.origin.y + tagplacetextView.frame.size.height + 5, 100, 20)];
//    tagpromptLab.backgroundColor = [UIColor redColor];
    tagpromptLab.text = @"输完文字以“空格”隔开";
    [tagpromptLab setAttributedText:[self getAttributeStrWithStringWithString:tagpromptLab.text withRange:NSMakeRange(6, 2)]];
    _tagpromptLab = tagpromptLab;
    tagpromptLab.font = [UIFont boldSystemFontOfSize:10.0f];
    [_scrollView addSubview:tagpromptLab];
    
    
    UILabel *systemtagLab = [[UILabel  alloc] initWithFrame:CGRectMake(20, tagpromptLab.frame.origin.y + descpromptLab.frame.size.height + 5, 100, 30)];
//    systemtagLab.backgroundColor = [UIColor redColor];
    systemtagLab.text = @"系统标签";
    systemtagLab.font = [UIFont boldSystemFontOfSize:18.0f];
    [_scrollView addSubview:systemtagLab];
    
    
    [[HttpRequest shareRequst] httpRequestGetWxCollocationShowTagFilter:(NSMutableDictionary *)@{@"pageIndex":[NSNumber numberWithInt:1],
                                                                                                 @"pageSize":[NSNumber numberWithInt:100]} success:^(id obj) {
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
            
            [self createTagButtonsWithY:systemtagLab.frame.origin.y+systemtagLab.frame.size.height];
        }
        
    } ail:^(NSString *errorMsg) {
        
    }];

    

}
//计算输入字符串长度
-  (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}
-(void)addTapRecognizer
{
    //点击手势
    if (_singleFinger == nil) {
        UITapGestureRecognizer *singleFinger;
        
        singleFinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:
                        @selector(handleEvent:)];
        singleFinger.numberOfTouchesRequired = 1;
        singleFinger.numberOfTapsRequired = 1;
        _singleFinger = singleFinger;
        [self.scrollView addGestureRecognizer:singleFinger];
    }
    
}
-(void)handleEvent:(id)sender{
    
    NSLog(@"消失键盘");
    [self .view endEditing:NO];
    [_titleTextView canResignFirstResponder];
    [_titleTextView resignFirstResponder];
    
}
-(void)createTitleLab{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 200.0f, 30.0f)];
    lab.text = @"标题";
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithHexString:@"#353535"];
    lab.font = [UIFont boldSystemFontOfSize:15.0f];
    [_scrollView addSubview:lab];
}

-(void)createTopicLabWithY:(CGFloat)y{
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, y, 200.0f, 20.0f)];
    lab.text = @"主题";
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithHexString:@"#353535"];
    lab.font = [UIFont boldSystemFontOfSize:15.0f];
    _topicLab = lab;
    [_scrollView addSubview:lab];
    
}
-(void)createTagLabWithY:(CGFloat )y{

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, y, 200.0f, 20.0f)];
    lab.text = @"风格";
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithHexString:@"#353535"];
    lab.font = [UIFont boldSystemFontOfSize:15.0f];
    _tagLab = lab;
    [_scrollView addSubview:lab];
    
}
#pragma 添加line
-(CGFloat)creatLineImageViewWithY:(CGFloat)y{
    UIImageView *line = [UIImageView new];
    line.frame = CGRectMake(15.0f, y, _scrollView.bounds.size.width -30.0f,1.0f);
    line.backgroundColor = [UIColor colorWithHexString:@"#acacac"];
    [_scrollView addSubview:line];
    
    UIImageView *leftpoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_ICO"]];
    leftpoint.frame = CGRectMake(line.frame.origin.x, y-1.0f, 3.0f,3.0f);
    leftpoint.backgroundColor = [UIColor colorWithHexString:@"#acacac"];
    [_scrollView addSubview:leftpoint];
    
    UIImageView *rightpoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_ICO"]];
    rightpoint.frame = CGRectMake(line.frame.size.width+15.0f, y-1.0f, 3.0f,3.0f);
    rightpoint.backgroundColor = [UIColor colorWithHexString:@"#acacac"];
    [_scrollView addSubview:rightpoint];
    
    return y;
    
}
-(void)requestHttpTopic{
    [[HttpRequest shareRequst] httpRequestGetWxCollocationShowTopicFilter:nil success:^(id obj) {
       
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in data)
                {
                    TopicMapping *topicMapping;
                    topicMapping = [JsonToModel objectFromDictionary:dic className:@"TopicMapping"];
                    [_dataTopicarray addObject:topicMapping];
                }

            }
            
           CGFloat y = [self createTopicButtonsWithY:_topicLab.frame.origin.y+_topicLab.frame.size.height];
            
            [self requestHttpTagWithY:y];
        }
        
        
    } ail:^(NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
    }];

}

-(void)requestHttpTagWithY:(CGFloat)y{

 
    [[HttpRequest shareRequst] httpRequestGetWxCollocationShowTagFilter:nil success:^(id obj) {
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
        
        [self creatLineImageViewWithY:y+10.0f];
        [self createTagLabWithY:y+15.0f];
        [self createTagButtonsWithY:_tagLab.frame.size.height+_tagLab.frame.origin.y];
    }

} ail:^(NSString *errorMsg) {
    
}];

}
-(CGFloat)createTopicButtonsWithY:(CGFloat)y{
    int count=(int)_dataTopicarray.count;
    for (int i=0; i<count; i++)
    {
         int row=i/totalloc;//行号
         int loc=i%totalloc;//列号

         CGFloat appviewx=margin+(margin+appvieww)*loc;
         CGFloat appviewy=margin+(margin+appviewh)*row;
        
        TopicMapping *topicMapping = _dataTopicarray[i];
        UMButton *btn = [UMButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 20+i;
        btn.frame = CGRectMake(appviewx+10, appviewy+y, appvieww, appviewh);
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn setTitleColor:[UIColor colorWithHexString:@"#6b6b6b"] forState:UIControlStateNormal];
      
        [btn addTarget:self action:@selector(buttonTopicClickevent:) forControlEvents:UIControlEventTouchUpInside];
        if (topicMapping.name == nil) {
            topicMapping.name = @"默认";
        }
        
        [btn setTitle:topicMapping.name forState:UIControlStateNormal];
        [_scrollView addSubview:btn];
        if (i == count-1) {
            _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, btn.frame.origin.y+btn.frame.size.height);
        }
    }
    
    return _scrollView.contentSize.height;
   
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
            _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,btn.frame.origin.y + btn.frame.size.height);
           
        }
        
        
    }
     _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+150);
//        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, 1000);
    
}

-(void)buttonTopicClickevent:(UMButton *)sender{
    int index = (int)sender.tag -20;
    if ([sender.titleLabel.textColor isEqual:[UIColor colorWithHexString:@"#333333"]]) {
        [sender setTitleColor:[UIColor colorWithHexString:@"#6b6b6b"] forState:UIControlStateNormal];
         [sender setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
         sender.layer.borderColor = [[UIColor colorWithHexString:@"#919191"] CGColor];
         [_postTopicarray removeObject:_dataTopicarray[index]];
        
    }else{
        
        [sender setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithHexString:@"#ffde00"]];
        [_postTopicarray addObject:_dataTopicarray[index]];
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

# pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self .view endEditing:NO];
    [_titleTextView canResignFirstResponder];
    [_titleTextView resignFirstResponder];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self .view endEditing:NO];
    [_titleTextView canResignFirstResponder];
    [_titleTextView resignFirstResponder];

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

        [self .view endEditing:NO];
        [_titleTextView canResignFirstResponder];
        [_titleTextView resignFirstResponder];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_scrollView endEditing:NO];
    [_titleTextView canResignFirstResponder];
    [_titleTextView resignFirstResponder];

}
-(void)dealloc{
    
    NSLog(@"PublishCollocationViewController---dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)uploaddataWithGestureImageViewarray:(NSMutableArray *)array withTopicArray:(NSMutableArray *)topicmappingarray withTagArray:(NSMutableArray *)tagarray{
    
    if (array.count >20) {
        [Toast makeToast:@"亲,搭配图片限制20张"];
        _rightBarButton.enabled = YES;
        return;
    }
    [self .view endEditing:NO];
    [_titleTextView canResignFirstResponder];
    [_titleTextView resignFirstResponder];
   
   _titleTextView.text = @"iPhone发布搭配";
   //12.04 add by miao
    /*
    NSRange range1 = [_titleTextView.text rangeOfString:@" "];
    int leight1 = range1.length;
    NSLog(@"sssssssssssss---%@---",_titleTextView.text);
    NSRange range2 = [_titleTextView.text rangeOfString:@""];
    int leight2 = range2.length;
    
    NSRange range3 = [_titleTextView.text rangeOfString:@"\n"];
    int leight3 = range3.length;
    
    if (leight2 > 0 || _titleTextView.text == nil || [_titleTextView.text isEqualToString:@""]) {
        
        [Toast makeToast:@"亲,请添加标题"];
         _rightBarButton.enabled = YES;
        return;
    }
   //11.9 add by miao
    if (leight1>0 ) {
        [Toast makeToast:@"亲,标题不能输入空格"];
         _rightBarButton.enabled = YES;
        return;
    }
    if (leight3>0) {
        [Toast makeToast:@"亲,标题不能输入换行符"];
         _rightBarButton.enabled = YES;
        return;
    }
     
    //12.8 add by miao
    NSString *str = [_titleTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *lastTitleTextStr=[str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    */
    
//    NSRange range1 = [_descTextView.text rangeOfString:@" "];
//    int leight1 = range1.length;
    NSLog(@"sssssssssssss---%@---",_titleTextView.text);
    NSRange range2 = [_descTextView.text rangeOfString:@""];
    int leight2 = (int)range2.length;
    
    NSRange range3 = [_descTextView.text rangeOfString:@"\n"];
    int leight3 = (int)range3.length;
    
    if (leight2 > 0 || _descTextView.text == nil || [_descTextView.text isEqualToString:@""]) {
        
        [Toast makeToast:@"亲,请添加描述"];
        _rightBarButton.enabled = YES;
        return;
    }else if(_descTextView.text.length > 70){
        [Toast makeToast:@"描述字符不能大于70个字符！"];
        _rightBarButton.enabled = YES;
        return;
    }
    //11.9 add by miao
//    if (leight1>0 ) {
//        [Toast makeToast:@"亲,描述不能输入空格"];
//        _rightBarButton.enabled = YES;
//        return;
//    }
    if (leight3>0) {
        [Toast makeToast:@"亲,描述不能输入换行符"];
        _rightBarButton.enabled = YES;
        return;
    }
    
    //12.8 add by miao
    NSString *str = [_descTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *lastdescTextStr=[str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    int charNun =[self convertToInt:lastdescTextStr];
    if (charNun >wordNum) {
        [Toast makeToast:@"亲,描述超过限制"];
        _rightBarButton.enabled = YES;
        return;
    }
    
    
    NSString *regex1 = @"[a-zA-Z0-9\u4e00-\u9fa5]+";//[a-zA-Z\u4e00-\u9fa5]
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    
    if([pred1 evaluateWithObject: lastdescTextStr])
    {
//        [Toast makeToast:@"亲,描述只能是文字、数字、字母"];
//        _rightBarButton.enabled = YES;
//        return;
//        return;
    }else{
    
        [Toast makeToast:@"亲,描述只能是文字、数字、字母"];
        _rightBarButton.enabled = YES;
        return;
                
    }

    if (array.count>0){
        
        //11.20 add by miao
        GesturesImageView *view = array[0];
        //在最外层添加参数maintemplateId  内部搭配布局中的TemplateId及LayoutId 不再需要
        NSString *maintemplateId;
        if (view.templateId != nil) {
            maintemplateId = view.templateId;

        }else{
            maintemplateId = @"-1";
        }
        
        
        //主题
        NSMutableArray *topicMappingList = [NSMutableArray new];
         
         /*
        if (topicMappingList != nil && topicmappingarray.count != 0)
        {
            for (TopicMapping *topicMapping in topicmappingarray)
            {
                int topicid = topicMapping.id.intValue;
                [topicMappingList addObject:@{@"TOPIC_ID":[NSNumber numberWithInt:topicid],@"NAME":topicMapping.name}];
                
            }
        }else{
            [Toast makeToast:@"亲,请添加主题"];
             _rightBarButton.enabled = YES;
            
            return;
        
        }
         */
       //风格标签
        NSMutableArray *tagMappingList = [NSMutableArray new];
        if (tagarray != nil && tagarray.count != 0) {
            for (TagMapping *tagMapping in tagarray) {
                int tagid = tagMapping.id.intValue;
                [tagMappingList addObject:@{@"ShowTagId":[NSNumber numberWithInt:tagid]}];
                
            }
        }
        
       
        
        //自定义标签
      
        NSArray *customTagarr = [_tagTextView.text componentsSeparatedByString:@" "];
        
      
        NSMutableArray *customTagMappingList = [NSMutableArray new];
        for (NSString *customTag in customTagarr) {
            //            ![customTag containsString:@" "]&&
//            ![customTag containsString:@"\n"]
            if (customTag.length>0&&
                ![customTag isEqualToString:@""]&&
                ![customTag isEqualToString:@" "]
                )
            {
                if (customTag.length<=5)
                {
                    
                    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]+";//[a-zA-Z\u4e00-\u9fa5]
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    
                    if([pred evaluateWithObject: customTag])
                    {
                        [customTagMappingList addObject:@{@"Name":customTag}];
                    }else{
                        [Toast makeToast:@"亲,标签只能是文字、数字、字母"];
                        _rightBarButton.enabled = YES;
                        return;
                    }
                    
                }else{
                    [Toast makeToast:@"亲,标签不能超过5个字符"];
                    _rightBarButton.enabled = YES;
                    return;
                
                }
                
            }
        }
        
        
        
        
       NSSet *set = [NSSet setWithArray:customTagMappingList];
        if (set.count != customTagMappingList.count) {
            [Toast makeToast:@"亲,标签不能重复"];
             _rightBarButton.enabled = YES;
            return;
        }

        if (customTagMappingList.count + tagarray.count >5) {
            [Toast makeToast:@"亲,标签只能添加5个"];
            _rightBarButton.enabled = YES;
            return;
        }
        if (customTagMappingList.count + tagarray.count <= 0.0f) {
            [Toast makeToast:@"亲,标签不能为空"];
            _rightBarButton.enabled = YES;
            return;
        }
        
        // add by miao 3.6
        if (tagarray.count != 0 && customTagarr.count !=0) {
            for (int i = 0; i<tagarray.count; i++) {
                TagMapping  *tagmap = tagarray[i];
                for (NSString *customTag in customTagarr) {
                    if ([tagmap.name isEqualToString:customTag]) {
                        [Toast makeToast:@"亲,自定义标签和系统标签不能重复"];
                        _rightBarButton.enabled = YES;
                        return;
                    }
                    
                }
            }
            
        }
        
        
        //layout
        NSMutableArray *layoutMappingList = [NSMutableArray new];
        //商品基本信息
        NSMutableArray*detaillist =[NSMutableArray new] ;
        for (int i = 0; i < array.count; i++) {
            GesturesImageView *view = array[i];
            
            NSString * productClsId;
            NSString *pictureurl;
            NSString *productName ;
            NSString *productCode;
            NSString *productPrice;
            NSString *productColorCode;
            NSString *productColorNam;
            NSString *sourceType;
            NSString *templateId;
            NSString *layoutId = [NSString stringWithFormat:@"%d",i];
            NSString *index = [NSString stringWithFormat:@"%d",i];
            
           
            if (view.goodObj != nil) {//从商品列表选择
                GoodObj *goodObj = view.goodObj;
                productClsId = goodObj.clsInfo.id;
                if (goodObj.shearPicUrl != nil && ![goodObj.shearPicUrl isEqualToString:@""] ) {
                    pictureurl = goodObj.shearPicUrl;
                }else
                {
                    pictureurl = goodObj.clsPicUrl.filE_PATH;
                }
                productName = [Utils getSNSString:goodObj.clsInfo.name];
                productCode = goodObj.clsInfo.code;
                productPrice = goodObj.clsInfo.sale_price;
                productColorCode = goodObj.productColorMapping.code;
                productColorNam = goodObj.productColorMapping.name;
                if (goodObj.sourceType == nil) {
                    sourceType = @"1";
                }else{
                    sourceType = goodObj.sourceType;
                }
                 templateId = @"-1";
                
            }else if(view.detailMapping != nil){//从保存的草稿列表选择
                DetailMapping *detailMapping = view.detailMapping;
                productClsId = detailMapping.productClsId;
                if (detailMapping.shearPicUrl != nil && ![detailMapping.shearPicUrl isEqualToString:@""] ) {
                    pictureurl = detailMapping.shearPicUrl;
                }else
                {
                    pictureurl = detailMapping.productPictureUrl;
                }
                if ([[Utils getSNSString:detailMapping.productName] isEqualToString:@""]) {
                     productName = @"-1";
                }else{
                productName = [Utils getSNSString:detailMapping.productName];
                }
                productCode = detailMapping.productCode;
                productPrice = detailMapping.productPrice;
                productColorCode = detailMapping.colorCode;
                productColorNam = detailMapping.colorName;
                if (detailMapping.sourceType == nil) {
                    sourceType = @"1";
                }else{
                    sourceType = detailMapping.sourceType;
                }
                
                if (_gesturesView.templateElement.templateInfo != nil) {
                    templateId = _gesturesView.templateElement.templateInfo.id;
                }else{
                    templateId =@"-1";
                }

            }else if(view.materialMapping != nil){
                MaterialMapping *materialMapping = view.materialMapping;
                
               
                if (materialMapping.id != nil) {
                    productClsId = materialMapping.id;
                }
                
                if (materialMapping.shearPicUrl != nil && ![materialMapping.shearPicUrl isEqualToString:@""] ) {
                    pictureurl = materialMapping.shearPicUrl;
                }else
                {
                    pictureurl = materialMapping.pictureUrl;
                }
                sourceType = @"2";
                productName = @"-1";
                productCode = @"-1";
                productPrice = @"0.0";
                productColorCode = @"-1";
                productColorNam = @"无色";
                
                templateId = [NSString stringWithFormat:@"-1"];
            }
            
             //商品基本信息

            [detaillist addObject:@{@"ProductClsId":productClsId!=nil?[NSNumber numberWithInt:productClsId.intValue]:[NSNumber numberWithInt:-1],
                                    @"ProductName":productName,
                                    @"ProductCode":productCode,
                                    @"ColorCode":productColorCode,
                                    @"ColorName":productColorNam,
                                    @"ProductPrice":productPrice,
                                    @"ProductPictureUrl":pictureurl,
                                    @"SourceType":[NSNumber numberWithInt:sourceType.intValue]}];
         
            
//            textFont_Id;
//            textPoint;
//            textScale;
//            textContent;
//            textColor;
//            (lastIndexPath !=nil)?[lastIndexPath row]:-1;
//            LayoutMapping
            NSDictionary *layoutDic = @{@"ProductClsId":[NSNumber numberWithInt:productClsId.intValue],
                                        @"ProductName":productName,
                                        @"LayoutId":[NSNumber numberWithInt:layoutId.intValue],
                                        @"TemplateId":[NSNumber numberWithInt:templateId.intValue],
                                        @"Index":[NSNumber numberWithInt:index.intValue],
                                        @"Width":[NSNumber numberWithInt:view.width],
                                        @"Height":[NSNumber numberWithInt:view.height],
                                        @"XPosition":[NSNumber numberWithInt:view.center.x],
                                        @"YPosition":[NSNumber numberWithInt:view.center.y],
                                        @"PictureUrl":pictureurl,
                                        @"RectSx":[NSNumber numberWithDouble:view.transform.a],
                                        @"RectRx":[NSNumber numberWithDouble:view.transform.b],
                                        @"RectRy":[NSNumber numberWithDouble:view.transform.c],
                                        @"RectSy":[NSNumber numberWithDouble:view.transform.d],
                                        @"TextFont_Id":view.layoutMapping.textFont_Id!=nil?[NSNumber numberWithInt:view.layoutMapping.textFont_Id.intValue]:[NSNumber numberWithInt:-1],
                                        @"TextPoint":view.layoutMapping.textPoint!=nil?[NSNumber numberWithInt:view.layoutMapping.textPoint.intValue]:[NSNumber numberWithInt:-1],
                                        @"TextScale":view.layoutMapping.textScale!=nil?[NSNumber numberWithFloat:view.layoutMapping.textScale.floatValue]:[NSNumber numberWithInt:-1],
                                        @"TextContent":view.layoutMapping.textContent!=nil?view.layoutMapping.textContent:@"-1",
                                        @"TextColor":view.layoutMapping.textColor!=nil?view.layoutMapping.textColor:@"-1"
                                        
                                        };
            [layoutMappingList addObject:layoutDic];
        }
        NSString *backWidthStr = [NSString stringWithFormat:@"%d",(int)[Globle shareInstance].globleWidth];
        //@"9999" @"Miaozhang"
//        SNSStaffFull *userinfo =  [[Globle shareInstance] getUserInfo];
        [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
        }complete:^(SNSStaffFull *staff, BOOL success){
            if (success)
            {
                [self requestCreatcollocationWithtitleName:@"iPhone发布搭配" BackWidth:backWidthStr Description:lastdescTextStr UserId:sns.ldap_uid CreateUser:staff.nick_name DetailList:(NSMutableArray *)detaillist LayoutMappingList:layoutMappingList TopicMappingList:(NSMutableArray *)topicMappingList TagMapping:(NSMutableArray *)tagMappingList TemplateId:maintemplateId CustomTagList:customTagMappingList];
            }
        }];
        
    }
}
#pragma mark--发布请求接口
-(void)requestCreatcollocationWithtitleName:(NSString *)name BackWidth:(NSString *)backwidth Description:(NSString *)description UserId:(NSString *)userId CreateUser:(NSString *)creatuser DetailList:(NSMutableArray *)detaillist LayoutMappingList:(NSMutableArray *)layoutMappingList TopicMappingList:(NSMutableArray *)topicMappingList TagMapping:(NSMutableArray *)TagMappingList TemplateId:(NSString *)templateId CustomTagList:(NSMutableArray *)customTagList{
     [Toast makeToastActivity:@"正在加载..." hasMusk:NO];//正在加载...
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setObject:name forKey:@"Name"];
    [dic setObject:[NSNumber numberWithInt:backwidth.intValue] forKey:@"BackWidth"];
    [dic setObject:description forKey:@"Description"];
    [dic setObject:userId forKey:@"UserId"];
    [dic setObject:creatuser forKey:@"CREATE_USER"];
    [dic setObject:detaillist forKey:@"DetailList"];
    [dic setObject:layoutMappingList forKey:@"LayoutMappingList"];
    [dic setObject:topicMappingList forKey:@"TopicMapping"];
    [dic setObject:TagMappingList forKey:@"TagMapping"];
    //11.20 add by miao
    [dic setObject:templateId forKey:@"TemplateId"];
    //2.3 add by miao  添加自定义标签
    [dic setObject:customTagList forKey:@"CustomTagList"];

    if (_uniquesessionid == nil) {
        _uniquesessionid = [NSString stringWithFormat:@"%@%@%@",[[Globle shareInstance] getuuid],[[Globle shareInstance] getTimeNow],[[Globle shareInstance] getRandomWord]];
    }
    NSLog(@"_uniquesessionid------%@",_uniquesessionid);
    [dic setObject:_uniquesessionid forKey:@"uniquesessionid"];
    
    [[HttpRequest shareRequst] httpRequestPostCollocationCreateWithDic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            
            NSDictionary *getdic = (NSDictionary *)obj;
            
           
           
            NSString *imageurl = [getdic objectForKey:@"message"];
            NSString *collocationId = [getdic objectForKey:@"collocationId"];
            
            
           
            
           NSString *lastImgUrl = [CommMBBusiness changeStringWithurlString:imageurl size:SNS_IMAGE_SMALL];
             [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
            UIImageFromURL([NSURL URLWithString:lastImgUrl], ^(UIImage *image) {
                
               
                _shareRelatedImage = image;
                [dic setObject:_shareRelatedImage forKey:@"shareRelatedImage"];
                [dic setObject:imageurl forKey:@"shareRelatedImageUrl"];
                [dic setObject:collocationId forKey:@"collocationId"];
                
                //12.10 add by miao 清空画布
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_CLEANCANCANVAS object:nil userInfo:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createCollocation" object:nil userInfo:nil];
                
                
                [Toast hideToastActivity];
                [self.view makeToast:@"发布搭配成功"];
              
                [self performSelector:@selector(pushToShareReatedMeViewControllerWithDic:) withObject:dic afterDelay:0.0f];
                
                

            }, ^{
                
                [Toast hideToastActivity];
                _rightBarButton.enabled = YES;
                
            });
          
        }else
        {
            
            NSString *msgStr = [obj objectForKey:@"message"];
            if (msgStr.length == 0)
            {
                [self.view makeToast:@"发布失败"];
            }else
            {
                [self.view makeToast:msgStr];
            }
            
             [Toast hideToastActivity];
            _rightBarButton.enabled = YES;
        }

    } ail:^(NSString *errorMsg) {
        
        [self.view makeToast:@"服务器超时,发布失败"];
        [Toast hideToastActivity];
        _rightBarButton.enabled = YES;
    }];
    
}

-(void)pushToShareReatedMeViewControllerWithDic:(NSMutableDictionary *)dic{
   
    
    _rightBarButton.enabled = YES;

}



- (IBAction)rightBarButtonItemClickevent:(id)sender
{
 
 
    if (_gesturesViewArray.count == 0|| _gesturesViewArray == nil) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"没有编辑内容不能发布" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
    }
    UIBarButtonItem *barItem = (UIBarButtonItem *)sender;
    _rightBarButton = barItem;
    barItem.enabled = NO;
    if (_postTagarray.count <= 5) {
         [self uploaddataWithGestureImageViewarray:_gesturesViewArray withTopicArray:_postTopicarray withTagArray:_postTagarray];
    }else{
        [Toast makeToast:@"亲,风格标签最多选择五个"];
        barItem.enabled = YES;
    }
   
}

- (IBAction)leftBarButtonItemClickevent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
