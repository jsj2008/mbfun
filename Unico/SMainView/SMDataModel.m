//
//  SMDataModel.m
//  Wefafa
//
//  Created by su on 15/6/3.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SMDataModel.h"
#import "SUtilityTool.h"

@implementation SMDataModel
{
    UILabel *_label_tool;
}

@synthesize cellHeight = _cellHeight;
//兼容7.1版本，我的搭配cell没有高度。黄磊
- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        CGFloat height = 0;
        //header高度
        height += 71;
        //图片高度
        SMDataModel *model = self;
        height += [model.img_height floatValue] * UI_SCREEN_WIDTH/ [model.img_width floatValue];
        //info高度
        if (model.content_info.length > 0) {
            height += [model.content_info boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
            //详情上下各增加2的高度
            height += 12;
            /*
             height += 5.0;
             */
            //不知道为什么有了info高度会减少一个底色高度手工补上
            //底色高度
            height += 14;
        }
        //四个按钮高度
        height += 39;
        //喜欢人高度
        height += 50;
        if (model.likeUserArray.count <= 0) {
            height -= 50;
        }
        //评论高度
        height += model.commentHeight;
        //底色高度
        height += 14;
        //    //之前有5间距现在取消掉
        //    height -= 5;
        //四个按钮距离下面控件多1像素
        height += 1;
        if (height < 10) {
            height = 100;
        }
        //评论列表间隙
        height += model.commentHeight ? 7 : 0;
        //没有赞且有评论，评论距离四个按钮13像素
        if (model.commentHeight != 0 && model.likeUserArray.count == 0) {
            //顶部已经有了3像素
            height += 10;
        }
        return height;
    }else {
        return _cellHeight;
    }
}

- (void)setCommentHeight:(CGFloat)commentHeight {
    _commentHeight = commentHeight;
    CGFloat height = 0;
    //header高度
    height += 71;
    //图片高度
    SMDataModel *model = self;
    height += [model.img_height floatValue] * UI_SCREEN_WIDTH/ [model.img_width floatValue];
    //info高度
    if (model.content_info.length > 0) {
        height += [model.content_info boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        //详情上下各增加2的高度
        height += 12;
        /*
        height += 5.0;
         */
        //不知道为什么有了info高度会减少一个底色高度手工补上
        //底色高度
        height += 14;
    }
    //四个按钮高度
    height += 39;
    //喜欢人高度
    height += 50;
    if (model.likeUserArray.count <= 0) {
        height -= 50;
    }
    //评论高度
    height += model.commentHeight;
    //底色高度
    height += 14;
//    //之前有5间距现在取消掉
//    height -= 5;
    //四个按钮距离下面控件多1像素
    height += 1;
    if (height < 10) {
        height = 100;
    }
    //评论列表间隙
    height += model.commentHeight ? 7 : 0;
    //没有赞且有评论，评论距离四个按钮13像素
    if (model.commentHeight != 0 && model.likeUserArray.count == 0) {
        //顶部已经有了3像素
        height += 10;
    }
    self.cellHeight = height;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _label_tool = [UILabel new];
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idValue = value;
    }else if ([key isEqualToString:@"like_user_list"]){
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dict in value){
            SMLikeUser *user = [[SMLikeUser alloc] initWithDictionary:dict];
            [array addObject:user];
        }
        self.likeUserArray = array;
    }else if ([key isEqualToString:@"comment_list"]){
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in value) {
            SMCommentInfo *info = [[SMCommentInfo alloc] initWithDict:dic];
            NSString *str = [@"" mutableCopy];
            if (IS_STRING(info.to_user_nick_name)) {//有回复
                str = [NSString stringWithFormat:@"%@回复%@: %@", info.nick_name, info.to_user_nick_name, info.info];
            }else {
                str = [NSString stringWithFormat:@"%@: %@", info.nick_name, info.info];
            }
            [_label_tool setFont:FONT_t6];  //你妹的
            _label_tool.text = str;
            [_label_tool setPreferredMaxLayoutWidth:[UIScreen mainScreen].bounds.size.width - 30];
            _label_tool.numberOfLines = 1;
            CGSize size = [_label_tool intrinsicContentSize];
            size.width = [UIScreen mainScreen].bounds.size.width - 30;//手动设置宽度，numberOfLines == 1不支持这个方法
            info.info_Height = size.height + 6;
            [array addObject:info];
            NSLog(@"str ==-== %@ size.height ==-== %f", str, size.height);
        }
        self.commentArray = [NSMutableArray arrayWithArray:array];
    }
}
@end

@implementation SMLikeUser

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation SMBannerModle

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idValue = value;
    }
    if ([key isEqualToString:@"jump_type"]) {
        self.show_type = value;
    }
}

@end

@implementation SMCommentInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"to_user"]) {
        self.to_user_nick_name = [value objectForKey:@"nick_name"];
        self.to_user_user_id = [value objectForKey:@"user_id"];
    }
}

@end