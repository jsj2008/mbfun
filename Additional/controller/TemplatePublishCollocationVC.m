//
//  TemplatePublishCollocationVC.m
//  Wefafa
//
//  Created by Miaoz on 15/4/3.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "TemplatePublishCollocationVC.h"
#import "MentallySuperView.h"
#import "PublishCustomView.h"
@interface TemplatePublishCollocationVC ()
@property(nonatomic,strong)PublishCustomView *publishCustomView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property(nonatomic,strong)NSString *uniquesessionid;
@end

@implementation TemplatePublishCollocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetLeftButton:nil Image:@"ion_back"];
//    [self setRightButton:@"发布" action:@selector(addRightTemplateClick:)];
    [self creatMainView];
    
}
-(void)creatMainView{
    PublishCustomView *publishCustomView = [[PublishCustomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _publishCustomView = publishCustomView;
    [self.view addSubview:publishCustomView];

}
-(void)setMentallyViewArray:(NSMutableArray *)mentallyViewArray{
    _mentallyViewArray = mentallyViewArray;
}
//-(void)addRightTemplateClick:(id)sender{
//
//    [self uploaddataWithMentallySuperViewarray:_mentallyViewArray withTopicArray:_publishCustomView.postTopicarray withTagArray:_publishCustomView.postTagarray];
//
//}
- (IBAction)rightBarButtonItemClickevent:(id)sender
{
    
    
    if (_mentallyViewArray.count == 0|| _mentallyViewArray == nil) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"没有编辑内容不能发布" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
    }
    UIBarButtonItem *barItem = (UIBarButtonItem *)sender;
    _rightBarButton = barItem;
    barItem.enabled = NO;
    if (_publishCustomView.postTagarray.count <= 5) {
        [self uploaddataWithMentallySuperViewarray:_mentallyViewArray withTopicArray:_publishCustomView.postTopicarray withTagArray:_publishCustomView.postTagarray];
    }else{
        [Toast makeToast:@"亲,风格标签最多选择五个"];
        barItem.enabled = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)uploaddataWithMentallySuperViewarray:(NSMutableArray *)array withTopicArray:(NSMutableArray *)topicmappingarray withTagArray:(NSMutableArray *)tagarray{
    
    if (array.count >20) {
        [Toast makeToast:@"亲,搭配图片限制20张"];
        self.rightBarButton.enabled = YES;
        return;
    }
    [self .view endEditing:NO];
   
//    NSRange range1 = [_publishCustomView.descTextView.text rangeOfString:@" "];
//    int leight1 = range1.length;

    NSRange range2 = [_publishCustomView.descTextView.text rangeOfString:@""];
    int leight2 = (int)range2.length;
    
    NSRange range3 = [_publishCustomView.descTextView.text rangeOfString:@"\n"];
    int leight3 = (int)range3.length;
    
    if (leight2 > 0 || _publishCustomView.descTextView.text == nil || [_publishCustomView.descTextView.text isEqualToString:@""]) {
        
        [Toast makeToast:@"亲,请添加描述"];
        self.rightBarButton.enabled = YES;
        return;
    }else if(_publishCustomView.descTextView.text.length > 70){
        [Toast makeToast:@"描述字符不能大于70个字符！"];
        self.rightBarButton.enabled = YES;
        return;
    }
    //11.9 add by miao
    //    if (leight1>0 ) {
    //        [Toast makeToast:@"亲,描述不能输入空格"];
    //        self.rightBarButton.enabled = YES;
    //        return;
    //    }
    if (leight3>0) {
        [Toast makeToast:@"亲,描述不能输入换行符"];
        self.rightBarButton.enabled = YES;
        return;
    }
    
    //12.8 add by miao
    NSString *str = [_publishCustomView.descTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *lastdescTextStr=[str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    int charNun =[self convertToInt:lastdescTextStr];
    if (charNun >wordNum) {
        [Toast makeToast:@"亲,描述超过限制"];
        self.rightBarButton.enabled = YES;
        return;
    }
    
    
    NSString *regex1 = @"[a-zA-Z0-9\u4e00-\u9fa5]+";//[a-zA-Z\u4e00-\u9fa5]
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    
    if([pred1 evaluateWithObject: lastdescTextStr])
    {
        //        [Toast makeToast:@"亲,描述只能是文字、数字、字母"];
        //        self.rightBarButton.enabled = YES;
        //        return;
        //        return;
    }else{
        
        [Toast makeToast:@"亲,描述只能是文字、数字、字母"];
        self.rightBarButton.enabled = YES;
        return;
        
    }
    
    if (array.count>0){
        
        //11.20 add by miao
        MentallySuperView *view = array[0];
        //在最外层添加参数maintemplateId  内部搭配布局中的TemplateId及LayoutId 不再需要
        NSString *maintemplateId;
        if (view.templateInfo.id != nil) {
            maintemplateId = view.templateInfo.id;
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
         [topicMappingList addObject:@{@"TOPICself.ID":[NSNumber numberWithInt:topicid],@"NAME":topicMapping.name}];
         
         }
         }else{
         [Toast makeToast:@"亲,请添加主题"];
         self.rightBarButton.enabled = YES;
         
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
        
        NSArray *customTagarr = [_publishCustomView.tagTextView.text componentsSeparatedByString:@" "];
        
        
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
                        self.rightBarButton.enabled = YES;
                        return;
                    }
                    
                }else{
                    [Toast makeToast:@"亲,标签不能超过5个字符"];
                    self.rightBarButton.enabled = YES;
                    return;
                    
                }
                
            }
        }
        
        
        
        
        NSSet *set = [NSSet setWithArray:customTagMappingList];
        if (set.count != customTagMappingList.count) {
            [Toast makeToast:@"亲,标签不能重复"];
            self.rightBarButton.enabled = YES;
            return;
        }
        
        if (customTagMappingList.count + tagarray.count >5) {
            [Toast makeToast:@"亲,标签只能添加5个"];
            self.rightBarButton.enabled = YES;
            return;
        }
        if (customTagMappingList.count + tagarray.count <= 0.0f) {
            [Toast makeToast:@"亲,标签不能为空"];
            self.rightBarButton.enabled = YES;
            return;
        }
        
        // add by miao 3.6
        if (tagarray.count != 0 && customTagarr.count !=0) {
            for (int i = 0; i<tagarray.count; i++) {
                TagMapping  *tagmap = tagarray[i];
                for (NSString *customTag in customTagarr) {
                    if ([tagmap.name isEqualToString:customTag]) {
                        [Toast makeToast:@"亲,自定义标签和系统标签不能重复"];
                        self.rightBarButton.enabled = YES;
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
            MentallySuperView *view = array[i];
            
            //模板容器层
            NSString * detailClsId;
            NSString *detailpictureurl;
            NSString *detailName;
            NSString *detailCode;
            NSString *detailPrice;
            NSString *detailColorCode;
            NSString *detailColorNam;
            NSString *detailsourceType;
            NSString *detaillayoutId = [NSString stringWithFormat:@"%d",i];
            NSString *detailindex = [NSString stringWithFormat:@"%d",(i+1)*10];
            
            //商品层
            NSString * productClsId ;
            NSString *productpictureurl;
            NSString *productLayoutpictureurl;
            NSString *productName;
            NSString *productCode;
            NSString *productPrice;
            NSString *productColorCode;
            NSString *productColorNam;
            NSString *productsourceType;
            NSString *productlayoutId = [NSString stringWithFormat:@"%d",i];
            NSString *productindex = [NSString stringWithFormat:@"%d",(i+1)*10+1];
            
            if (view.detailMapping.productPictureUrl.length == 0) {//第一次 使用模板
                if(view.detailMapping != nil){//模板的数据
                    DetailMapping *detailMapping = view.detailMapping;
                    detailClsId = detailMapping.productClsId;
                    if (detailMapping.shearPicUrl != nil && ![detailMapping.shearPicUrl isEqualToString:@""] ) {
                        detailpictureurl = detailMapping.shearPicUrl;
                    }else
                    {
                        
                        detailpictureurl = detailMapping.productPictureUrl;
                        if (detailpictureurl.length == 0) {
                            detailpictureurl = view.layoutMapping.pictureUrl;
                        }
                        
                    }
                    
                    
                    detailName = detailMapping.productName;
                    detailCode = detailMapping.productCode;
                    detailPrice = detailMapping.productPrice;
                    detailColorCode = detailMapping.colorCode;
                    detailColorNam = detailMapping.colorName;
                    if (detailMapping.sourceType == nil)
                    {
                        detailsourceType = @"1";
                    }else{
                        detailsourceType = detailMapping.sourceType;
                    }
                    
                }
            }
            else{//复原保存的搭配&草稿
                LayoutMapping *modulelayout = view.layoutMapping;
                //                DetailMapping *detailMapping = view.detailMapping;
                detailClsId =  modulelayout.productClsId;
                detailpictureurl = modulelayout.pictureUrl;
                detailName = modulelayout.productName; //@"";
                detailCode = @"";
                detailPrice = @"";
                detailColorCode = @"";
                detailColorNam = @"";
                detailsourceType = @"";
            }
            
            //重新拼接bankurl
            NSRange range = [detailpictureurl rangeOfString:@"$blank_"];
            if (range.length == 7) {
                NSArray *tmparray = [detailpictureurl componentsSeparatedByString:@"$blank_"];
//                NSString * dicString = [[[tmparray objectAtIndex:1] componentsSeparatedByString:@"--"] objectAtIndex:0];
                
                //                NSDictionary *oldBankdic = [NSString dictionaryWithJsonString:dicString];
                NSMutableDictionary *bankDic = [NSMutableDictionary new];
                //
                [bankDic setObject:[NSNumber numberWithInt:view.bankWidth.intValue] forKey:@"w"];
                [bankDic setObject:[NSNumber numberWithInt:view.bankHeight.intValue] forKey:@"h"];
                
                //                [bankDic setObject:[oldBankdic objectForKey:@"w"] forKey:@"w"];
                //                [bankDic setObject:[oldBankdic objectForKey:@"h"] forKey:@"h"];
                [bankDic setObject:[NSNumber numberWithInt:0] forKey:@"b"];
                NSString *lastBankStr = [NSString stringWithFormat:@"$blank_%@.png",[NSString stringByJson:bankDic]];
                
                detailpictureurl = [NSString stringWithFormat:@"%@%@",[tmparray objectAtIndex:0],lastBankStr];
                
            }
            
            
            
            if (view.goodObj != nil) {//从商品列表选择
                GoodObj *goodObj = view.goodObj;
                productClsId = [NSString stringWithFormat:@"%@",goodObj.clsInfo.id] ;
                if (goodObj.shearPicUrl != nil && ![goodObj.shearPicUrl isEqualToString:@""] ) {
                    productpictureurl = goodObj.shearPicUrl;
                }else
                {
                    //合成需要
                    NSRange tmpRange = [detailpictureurl rangeOfString:@"$blank_"];
                    if (tmpRange.length== 7) {
                        productLayoutpictureurl =[self stitchedTogetherImageDataWithbankpicUrl:detailpictureurl withproductPictureUrl:goodObj.clsPicUrl.filE_PATH withMentallyView:view];
                    }
                    
                    
                    productpictureurl = goodObj.clsPicUrl.filE_PATH;
                }
                
                productName = goodObj.clsInfo.name;
                productCode = goodObj.clsInfo.code;
                productPrice = goodObj.clsInfo.sale_price;
                productColorCode = goodObj.productColorMapping.code;
                productColorNam = goodObj.productColorMapping.name;
                
                if (goodObj.sourceType == nil) {
                    productsourceType = @"1";
                }else{
                    productsourceType = goodObj.sourceType;
                }
                
            }else if(view.materialMapping != nil){
                MaterialMapping *materialMapping = view.materialMapping;
                
                if (materialMapping.id != nil) {
                    productClsId = [NSString stringWithFormat:@"%@",materialMapping.id];
                }
                
                if (materialMapping.shearPicUrl != nil && ![materialMapping.shearPicUrl isEqualToString:@""] ) {
                    productpictureurl = materialMapping.shearPicUrl;
                }else
                {
                    productpictureurl = materialMapping.pictureUrl;
                }
                productsourceType = @"2";
                productName = @"素材";
                productCode = @"09";
                productPrice = @"0.0";
                productColorCode = @"09";
                productColorNam = @"无色";
                
                
            }else if(view.contentInfo != nil){
                DetailMapping *goodDetailMapping = view.detailMapping;
                //                ContentInfo *contentInfo = view.contentInfo;
                productClsId =[NSString stringWithFormat:@"%@",goodDetailMapping.id];
                //                if (goodObj.shearPicUrl != nil && ![goodObj.shearPicUrl isEqualToString:@""] ) {
                //                    productpictureurl = goodObj.shearPicUrl;
                //                }else
                //                {
                
                //合成需要
                NSRange tmpRange = [detailpictureurl rangeOfString:@"$blank_"];
                if (tmpRange.length== 7) {
                    productLayoutpictureurl = [self stitchedTogetherImageDataWithbankpicUrl:detailpictureurl withproductPictureUrl:goodDetailMapping.productPictureUrl withMentallyView:view];
                }
                productpictureurl = goodDetailMapping.productPictureUrl;//contentInfo.pictureUrl
                
                //                }
                
                productName = goodDetailMapping.productName;
                productCode = goodDetailMapping.productCode;
                productPrice = goodDetailMapping.productPrice;
                productColorCode = goodDetailMapping.colorCode;
                productColorNam = goodDetailMapping.colorName;
                if (goodDetailMapping.sourceType == nil)//sourceType 1是商品2是图片素材
                {
                    productsourceType = @"1";
                }else{
                    productsourceType = goodDetailMapping.sourceType;
                }
                
            }else{//解决 模板上有图片和没模板只有图片
                
                if(view.detailMapping != nil){
                    DetailMapping *goodDetailMapping = view.detailMapping;
                    productClsId = goodDetailMapping.productClsId;
                    if (goodDetailMapping.shearPicUrl != nil && ![goodDetailMapping.shearPicUrl isEqualToString:@""] ) {
                        productpictureurl = goodDetailMapping.shearPicUrl;
                    }else
                    {
                        
                        NSRange tmpRange = [detailpictureurl rangeOfString:@"$blank_"];
                        if (tmpRange.length== 7&&goodDetailMapping.productPictureUrl.length != 0) {
                            productLayoutpictureurl = [self stitchedTogetherImageDataWithbankpicUrl:detailpictureurl withproductPictureUrl:goodDetailMapping.productPictureUrl withMentallyView:view];
                        }
                        productpictureurl = goodDetailMapping.productPictureUrl;
                        
                        
                    }
                    
                    
                    productName = goodDetailMapping.productName;
                    productCode = goodDetailMapping.productCode;
                    productPrice = goodDetailMapping.productPrice;
                    productColorCode = goodDetailMapping.colorCode;
                    productColorNam = goodDetailMapping.colorName;
                    if (goodDetailMapping.sourceType == nil)
                    {
                        productsourceType = @"1";
                    }else{
                        productsourceType = goodDetailMapping.sourceType;
                    }
                    
                }
                
                
                
                
                
            }
            
            
            
            //商品信息
            
            NSMutableArray *contentList = [NSMutableArray new];
            //            CGPoint point = [self.view convertPoint:view.gesturesImageView.center fromView:view];
            
            if (productLayoutpictureurl != nil) {//contentList  里的XYPosition 是 模板容器的中心坐标
                [contentList addObject:@{@"ProductClsId":productClsId != nil?[NSNumber numberWithInt:productClsId.intValue]:[NSNumber numberWithInt:-1],
                                         @"ProductName":productName,
                                         @"LayoutId":[NSNumber numberWithInt:productlayoutId.intValue],
                                         @"Index":[NSNumber numberWithInt:productindex.intValue],
                                         @"Width":[NSNumber numberWithInt:view.gesturesImageView.frame.size.width],
                                         @"Height":[NSNumber numberWithInt:view.gesturesImageView.frame.size.height],
                                         @"XPosition":[NSNumber numberWithInt:view.center.x],//+view.gesturesImageView.center.x
                                         @"YPosition":[NSNumber numberWithInt:view.center.y],
                                         @"PictureUrl":productLayoutpictureurl!=nil ?productLayoutpictureurl:@"",//productpictureurl
                                         @"RectSx":[NSNumber numberWithFloat:view.transform.a],
                                         @"RectRx":[NSNumber numberWithFloat:view.transform.b],
                                         @"RectRy":[NSNumber numberWithFloat:view.transform.c],
                                         @"RectSy":[NSNumber numberWithFloat:view.transform.d],
                                         @"ItemType":[NSNumber numberWithInt:2]
                                         }];
                //            1 占位符 2 图片
            }
            
            
            
            
            //detaillist  放商品
            [detaillist addObject:@{@"ProductClsId":productClsId!=nil?[NSNumber numberWithInt:productClsId.intValue]:[NSNumber numberWithInt:-1],
                                    @"ProductName":productName,
                                    @"ProductCode":productCode,
                                    @"ColorCode":productColorCode,
                                    @"ColorName":productColorNam,
                                    @"ProductPrice":productPrice,
                                    @"ProductPictureUrl":productpictureurl,
                                    @"SourceType":[NSNumber numberWithInt:productsourceType.intValue]}];
            
            
            
            NSLog(@"%@---------%@",productindex,productlayoutId);
            
            
            //模板信息
            NSDictionary *layoutDic = @{@"ProductClsId":[NSNumber numberWithInt:detailClsId.intValue],
                                        @"ProductName":detailName,
                                        @"LayoutId":[NSNumber numberWithInt:detaillayoutId.intValue],
                                        @"Index":[NSNumber numberWithInt:detailindex.intValue],
                                        @"Width":[NSNumber numberWithInt:view.bankWidth.intValue],//view.frame.size.width
                                        @"Height":[NSNumber numberWithInt:view.bankHeight.intValue],//view.frame.size.height
                                        @"XPosition":[NSNumber numberWithInt:view.center.x],
                                        @"YPosition":[NSNumber numberWithInt:view.center.y],
                                        @"PictureUrl":detailpictureurl,
                                        @"RectSx":[NSNumber numberWithFloat:view.transform.a],
                                        @"RectRx":[NSNumber numberWithFloat:view.transform.b],
                                        @"RectRy":[NSNumber numberWithFloat:view.transform.c],
                                        @"RectSy":[NSNumber numberWithFloat:view.transform.d],
                                        @"ItemType":[NSNumber numberWithInt:1]
                                        ,
                                        @"TextFont_Id":view.layoutMapping.textFont_Id!=nil?[NSNumber numberWithInt:view.layoutMapping.textFont_Id.intValue]:[NSNumber numberWithInt:-1],
                                        @"TextPoint":view.layoutMapping.textPoint!=nil?[NSNumber numberWithInt:view.layoutMapping.textPoint.intValue]:[NSNumber numberWithInt:-1],
                                        @"TextScale":view.layoutMapping.textScale!=nil?[NSNumber numberWithFloat:view.layoutMapping.textScale.floatValue]:[NSNumber numberWithInt:-1],
                                        @"TextContent":view.layoutMapping.textContent!=nil?view.layoutMapping.textContent:@"-1",
                                        @"TextColor":view.layoutMapping.textColor!=nil?view.layoutMapping.textColor:@"-1",
                                        @"ContentList":contentList
                                        };
            [layoutMappingList addObject:layoutDic];
        }
        
        //@"9999" @"Miaozhang"
        //        SNSStaffFull *userinfo =  [[Globle shareInstance] getUserInfo];
        
        
        NSString *backWidthStr = [NSString stringWithFormat:@"%f",[Globle shareInstance].globleWidth];
        

        [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
        }complete:^(SNSStaffFull *staff, BOOL success){
            if (success)
            {
                [self requestCreatcollocationWithtitleName:@"iPhone发布模板搭配" BackWidth:backWidthStr Description:lastdescTextStr UserId:sns.ldap_uid CreateUser:staff.nick_name DetailList:(NSMutableArray *)detaillist LayoutMappingList:layoutMappingList TopicMappingList:(NSMutableArray *)topicMappingList TagMapping:(NSMutableArray *)tagMappingList TemplateId:maintemplateId CustomTagList:customTagMappingList];
            }
        }];
        
    }
}

#pragma mark -- 拼接合成图片url
-(NSString *)stitchedTogetherImageDataWithbankpicUrl:(NSString *)detailpictureurl withproductPictureUrl:(NSString *)productPictureUrl withMentallyView:(MentallySuperView *)view{
    
    NSString * bankdicString = [[detailpictureurl componentsSeparatedByString:@"$blank_"] objectAtIndex:1];
    NSArray *bankdicArray =    [bankdicString   componentsSeparatedByString:@"--"];
    NSString *lastBankdicStr ;
    if(bankdicArray.count == 2){
        
        lastBankdicStr = bankdicArray[0];
    }else{
        NSString *tmpStr = [bankdicArray objectAtIndex:0];
        NSMutableString *tmpBankString = [[NSMutableString alloc] initWithString:[tmpStr substringToIndex:tmpStr.length-4]];
        lastBankdicStr = tmpBankString;
        
    }
    //                {"w":200,"h":200,"b":1,"bc":"FF0000"}
    NSDictionary *oldBankdic = [NSString dictionaryWithJsonString:lastBankdicStr];
    
    NSMutableDictionary *bankDic = [NSMutableDictionary new];
    [bankDic setObject:[oldBankdic objectForKey:@"w"] forKey:@"w"];
    [bankDic setObject:[oldBankdic objectForKey:@"h"] forKey:@"h"];
    [bankDic setObject:[NSNumber numberWithInt:0] forKey:@"b"];
    [bankDic setObject:@"FF0000" forKey:@"bc"];
    NSString *lastMainBankStr = [NSString stringWithFormat:@"$blank_%@.png",[NSString stringByJson:bankDic]];
    NSData *tmpMainBankdata = [lastMainBankStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64MainBankStr =[ASIHTTPRequest base64forData:tmpMainBankdata];//p
    //goodDetailMapping.productPictureUrl
    NSArray *picStrarray = [productPictureUrl componentsSeparatedByString:@"--"];
    NSString *picUrlStr;
    if (picStrarray.count ==2) {
        picUrlStr =[NSString stringWithFormat:@"%@--MTD_",[ picStrarray objectAtIndex:0]];
    }else{
        NSString *tmpStr = [ picStrarray objectAtIndex:0];
        NSMutableString *lastString = [[NSMutableString alloc] initWithString:[tmpStr substringToIndex:tmpStr.length-4]];
        picUrlStr =[NSString stringWithFormat:@"%@--MTD_",lastString];
    }
    
    NSMutableDictionary *_sourceDic = [NSMutableDictionary new];
    [_sourceDic setObject:base64MainBankStr forKey:@"p"];
    
    NSString *aStr = [NSString stringWithFormat:@"%@",view.layoutMapping.rectSx];
    float a = [aStr floatValue];
    NSString *bStr = [NSString stringWithFormat:@"%@",view.layoutMapping.rectRx];
    float b = [bStr floatValue];
    NSString *cStr = [NSString stringWithFormat:@"%@",view.layoutMapping.rectRy];
    float c = [cStr floatValue];
    NSString *dStr = [NSString stringWithFormat:@"%@",view.layoutMapping.rectSy];
    float d = [dStr floatValue];
    if (b != 0) {
        view.transform = CGAffineTransformMake(a, 0, 0, d, 0.0f, 0.0f);
    }
    
    //
    //    NSString *aStr2 = [NSString stringWithFormat:@"%f",view.gesturesImageView.transform.a];
    //    float a2 = [aStr2 floatValue];
    //    NSString *bStr2 = [NSString stringWithFormat:@"%@",view.contentInfo.rectRx];
    //    float b2 = [bStr2 floatValue];
    //    NSString *cStr2 = [NSString stringWithFormat:@"%@",view.contentInfo.rectRy];
    //    float c2 = [cStr2 floatValue];
    //    NSString *dStr2 = [NSString stringWithFormat:@"%f",view.gesturesImageView.transform.d];
    //    float d2 = [dStr2 floatValue];
    //    if (b2 != 0) {
    //        view.gesturesImageView.transform =  CGAffineTransformMake(a2, 0, 0, d2, 0.0f, 0.0f);
    //    }
    //
    
    
    CGPoint point1 = [self.view convertPoint:CGPointMake(view.gesturesImageView.frame.origin.x, view.gesturesImageView.frame.origin.y) fromView:view];
    //    if (b2 == 0) {
    [_sourceDic setObject:[NSNumber numberWithInt:abs((int)(point1.x -view.center.x))] forKey:@"x"];
    [_sourceDic setObject:[NSNumber numberWithInt:abs((int)(point1.y -view.center.y))] forKey:@"y"];
    //    }else{
    
    //        [_sourceDic setObject:[NSNumber numberWithInt:abs(point1.x -view.center.x)+30] forKey:@"x"];
    //        [_sourceDic setObject:[NSNumber numberWithInt:abs(point1.y -view.center.y)+30] forKey:@"y"];
    //    }
    
    [_sourceDic setObject:[NSNumber numberWithInt:view.bankWidth.intValue] forKey:@"w"];
    [_sourceDic setObject:[NSNumber numberWithInt:view.gesturesImageView.frame.size.width] forKey:@"iw"];//
    NSString *lastPicString =[NSString stringWithFormat:@"%@%@--%dx%d.png",picUrlStr,[NSString stringByJson:_sourceDic],view.bankWidth.intValue,view.bankHeight.intValue];
    
    if (b != 0) {
        view.transform = CGAffineTransformMake(a, b, c, d, 0.0f, 0.0f);
    }
    //    if (b2 != 0) {
    //        view.gesturesImageView.transform =  CGAffineTransformMake(a2, b2, c2, d2, 0.0f, 0.0f);
    //    }
    return lastPicString;
    //p是原图的相对路径path x、y是抠图模板的中心坐标 w是抠图模板宽 iw是原图的宽
    
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
                
                
                _publishCustomView.shareRelatedImageView.image = image;
                [dic setObject:image forKey:@"shareRelatedImage"];
                [dic setObject:imageurl forKey:@"shareRelatedImageUrl"];
                [dic setObject:collocationId forKey:@"collocationId"];
                
                //12.10 add by miao 清空画布
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_CLEANCANCANVAS object:nil userInfo:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createCollocation" object:nil userInfo:nil];
                
                
                [Toast hideToastActivity];
                [self.view makeToast:@"发布搭配成功"];
                
//                [self performSelector:@selector(pushToShareReatedMeViewControllerWithDic:) withObject:dic afterDelay:0.0f];
                
                
                
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
