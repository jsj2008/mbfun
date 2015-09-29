//
//  CommentNumberTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-11-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//废弃 不用 以前的 搭配详情 评论数
#import "CommentNumberTableViewCell.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"

//static const int CommentNumberTableViewCellHeight=55;43
static const int CommentNumberTableViewCellHeight=26.5;

@interface CommentNumberTableViewCell()


@end


@implementation CommentNumberTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self innerInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)innerInit
{
    //    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    self.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:239.0/255.0 alpha:1];
    self.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
//    self.backgroundColor=COLLOCATION_TABLE_BG;
    self.frame=CGRectMake(0, 0, self.frame.size.width, CommentNumberTableViewCellHeight);
    if (_lbCommentNum==nil)
    {
//        更多按钮
        btnMoreComment=[UIButton buttonWithType:UIButtonTypeCustom];
//        btnMoreComment.frame=CGRectMake(SCREEN_WIDTH-70, y, 60, 14);
//        btnMoreComment.titleLabel.font=[UIFont systemFontOfSize:12];
//        [btnMoreComment setTitleColor:[Utils HexColor:0x353535 Alpha:1.0] forState:UIControlStateNormal];
        //CGRectMake(WINDOWW - 70, 7.5, 60, 28);
        [btnMoreComment setTitle:@"更多评论>" forState:UIControlStateNormal];
        btnMoreComment.frame = CGRectMake(WINDOWW - 80, 0, 70, CommentNumberTableViewCellHeight);
        btnMoreComment.titleLabel.font = [UIFont systemFontOfSize:10];
        [btnMoreComment setTitleColor:[Utils HexColor:0x000000 Alpha:0.6] forState:UIControlStateNormal];
//        [Utils HexColor:0x919191 Alpha:1]
//        [btnMoreComment setTitle:@"更多" forState:UIControlStateNormal];
        [btnMoreComment addTarget:self action:@selector(btnMoreCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnMoreComment];
        
//        评论图标
//        imageComment=[[UIImageView alloc] initWithFrame:CGRectMake(10, y, 14, 14)];
//        imageComment.image=[UIImage imageNamed:@"ico_home_discuss.png"];
        imageComment = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12.5, 18, 15)];
        imageComment.center = CGPointMake(imageComment.center.x, self.center.y);
        imageComment.image = [UIImage imageNamed:@"new_apprise_show"];
       
        [self.contentView addSubview:imageComment];
        

//        _lbStyle=[[UILabel alloc] initWithFrame:CGRectMake(imageComment.frame.origin.x, 5, 300, 12)];
//        _lbStyle.font=[UIFont systemFontOfSize:11];
//        _lbStyle.textColor=[Utils HexColor:0x66cccc Alpha:1.0];
//        [self.contentView addSubview:_lbStyle];
        
//        评论数量
//        _lbCommentNum=[[UILabel alloc] initWithFrame:CGRectMake(imageComment.frame.origin.x+imageComment.frame.size.width+3, y, 80, 14)];
//        _lbCommentNum.font=[UIFont systemFontOfSize:12];
//        _lbCommentNum.textColor=[Utils HexColor:0x6b6b6b Alpha:1.0];
//        _lbCommentNum.backgroundColor=[UIColor redColor];
        
        //(imageComment.frame) + 5, 12.5, 180, 18)];
        _lbCommentNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageComment.frame) + 5, 0, 180, CommentNumberTableViewCellHeight)];
        _lbCommentNum.center = CGPointMake(_lbCommentNum.center.x, self.center.y);
        _lbCommentNum.font = [UIFont systemFontOfSize:10];
        _lbCommentNum.textColor=[Utils HexColor:0x000000 Alpha:0.6];
        
        currentEditControl=(UIControl *)_lbCommentNum;
        [self.contentView addSubview:_lbCommentNum];
        
        imageSeparator=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 0.5)];
        imageSeparator.backgroundColor=COLLOCATION_TABLE_LINE;
        [self.contentView addSubview:imageSeparator];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCommentNum) name:@"changeCommentNum" object:nil];
        
    }
    _lbCommentNum.text =[self convertCommentNumberWithText:@"0"];
//    _lbCommentNum.text=@"0";
}
-(NSString *)convertCommentNumberWithText:(NSString *)sender{
    NSString *temp = sender;
    temp = [Utils getSNSInteger:temp];
    NSString *str = [NSString stringWithFormat:@"评论(%@)",temp];
    return str;
}
//-(void)changeCommentNum
//{
//    int num=0;
//    num= [_lbCommentNum.text intValue];
//    num++;
////    [self reloadInputViews];
//    
//    _lbCommentNum.text=[NSString stringWithFormat:@"%d",num];
//    NSLog(@"————————numtEXT---%@",_lbCommentNum.text);
//
//    
////    UILabel *label=(UILabel *)currentEditControl;
////    label.text = [NSString stringWithFormat:@"%d",num];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"changeCommentNum"
//                                                  object:nil];
//    
//    
//}

-(void)btnMoreCommentClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notif_CommentNumberTableViewCell_ShowCommentList" object:self userInfo:@{@"collocationId":collocationID}];
}

-(void)setData:(id)data1
{
    
#if 0
    NSDictionary *d=nil;
    if ([data1 isKindOfClass:[NSDictionary class]]) {
        d=data1;
    }
    if (d!=nil && d[@"commentNum"]!=nil)
    {
        _lbCommentNum.text=[Utils getSNSInteger:d[@"commentNum"]];
    }
#endif
    if ([data1 isKindOfClass:[NSDictionary class]]) {
        _data = data1;
        _lbCommentNum.text = [self convertCommentNumberWithText:data1[@"commentCount"]];
    }
}


/*此方法中的多线程中的请求成功后再次给评论量赋值的时候有时候和setData:方法中的赋值顺序不定，导致请求后的评论量不正确时，评论量相差1*/
-(void)setCollocationInfo:(NSDictionary *)collocationDict
{
    collocationID=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSInteger:collocationDict[@"collocationInfo"][@"id"]] ];

//    if (collocationDict[@"statisticsFilterList"]!=nil && ((NSArray *)collocationDict[@"statisticsFilterList"]).count>0 && collocationDict[@"statisticsFilterList"][0][@"commentCount"]!=nil)
//    {
////        _lbCommentNum.text=[Utils getSNSInteger:collocationDict[@"statisticsFilterList"][0][@"commentCount"]];
//        _lbCommentNum.text = [self convertCommentNumberWithText:collocationDict[@"collocationInfo"][@"commentCount"]];
//    }
//    else
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSMutableDictionary *rstdict=[[NSMutableDictionary alloc] initWithCapacity:10];
//            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//            BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxCollocationStatisticsFilter" param:@{@"sourceId":collocationDict[@"collocationInfo"][@"id"]} responseAll:rstdict responseMsg:msg];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success)
//                {
////                    _lbCommentNum.text=[Utils getSNSInteger:rstdict[@"statisticsInfo"][@"commentCount"]];
//                    
                   /*此处给评论量赋值存在的问题:
                    1、如果评论成功后在控制器中没有刷新评论量的数据源,那么此处的评论量如果在执行完setData:方法,才执行此处代码时,会造成评论量少一次，如果是先执行该处,然后执行setData:方法,那么现实的评论量将是正确的
                    2、此处是否是增加评论量，浏览量，分享量的？？？？
                    3、不知道是不是服务器的原因造成的问题
                    */
//                     _lbCommentNum.text = [self convertCommentNumberWithText:collocationDict[@"collocationInfo"][@"commentCount"]];
//                    
//                }
//            });
//        });
//    }
}

+(int)getCellHeight:(id)data1
{
    return CommentNumberTableViewCellHeight;
}

@end
