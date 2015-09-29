//
//  ImageInfo.h
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
#import "ImageInfo.h"
#import "Utils.h"
#import "CommMBBusiness.h"
@implementation ImageInfo
-(instancetype)initWithDictionary:(NSDictionary*)dictionary WithGood:(BOOL)goods WithBrand:(BOOL)Isbrand;//是否是品牌
{
    self = [super init];
    if (self) {
        self.imageData =dictionary;
        if (Isbrand)
        {
            NSString *favrtieCount = [NSString stringWithFormat:@"%@",self.imageData[@"clsInfo"][@"favoriteCount"]];
            self.favriteCount=[Utils getSNSString:favrtieCount];
//            self.clsPicUrl = [self.imageData objectForKey:@"clsPicUrl"];
            self.thumbURL = [CommMBBusiness changeStringWithurlString:[self.imageData objectForKey:@"clsInfo"][@"mainImage"] width:300 height:300];
//            self.thumbURL =[self.imageData objectForKey:@"clsPicUrl"];
            //self.titleName = [self.imageData objectForKey:@"name"];
            self.titleName =[NSString stringWithFormat:@"%@",self.imageData[@"clsInfo"][@"name"]];
            NSString *prices=[NSString stringWithFormat:@"%@",self.imageData [@"clsInfo" ][@"sale_price"]];
            float showPric=[prices floatValue];
            self.price= [NSString stringWithFormat:@"%0.2f",showPric];
        }
        else
        {
            if (goods)
            {
                [self setValuesForKeysWithDictionary:dictionary];
//                self.isFavorite = self.imageData[@"isFavorite"];
//                NSString *favrtieCount = [NSString stringWithFormat:@"%@",self.imageData[@"favoriteCount"]];
//                self.favriteCount=[Utils getSNSString:favrtieCount];
//                
//                if (self.imageData[@"prodList"]!=nil&&((NSArray*)self.imageData[@"prodList"]).count>0)
//                {
//                    self.prodList = [self.imageData objectForKey:@"prodList"];
//                    
//                    if ([[self.prodList objectAtIndex:0] objectForKey:@"clsPicUrl"]!=nil&&((NSArray*)[[self.prodList objectAtIndex:0] objectForKey:@"clsPicUrl"]).count>0)
//                    {
//                        self.clsPicUrl = [[self.prodList objectAtIndex:0] objectForKey:@"clsPicUrl"];
//                        for (int k=0; k<[self.clsPicUrl count];k++) {
//                            NSString *isMainImage=[NSString stringWithFormat:@"%@",[[self.clsPicUrl objectAtIndex:k] objectForKey:@"isMainImage"]];
//                            if ([isMainImage isEqualToString:@"1"])
//                            {
//                                self.thumbURL =[[self.clsPicUrl objectAtIndex:k] objectForKey:@"filE_PATH"];
//                                self.width = [[[self.clsPicUrl objectAtIndex:k]  objectForKey:@"width"]floatValue];
//                                self.height = [[[self.clsPicUrl objectAtIndex:k]  objectForKey:@"height"]floatValue];
//                                break;
//                            }
//                        }
//                        if (self.thumbURL.length==0||self.thumbURL==nil)
//                        {
//                            self.thumbURL =[[self.clsPicUrl objectAtIndex:0] objectForKey:@"filE_PATH"];
//                            self.width = [[[self.clsPicUrl objectAtIndex:0]  objectForKey:@"width"]floatValue];
//                            self.height = [[[self.clsPicUrl objectAtIndex:0]  objectForKey:@"height"]floatValue];
//                        }
//                        
//                        
//                    }
//                    if ([[self.prodList objectAtIndex:0] objectForKey:@"clsInfo"]!=nil)
//                    {
//                        self.clsInfo = [NSDictionary dictionaryWithDictionary:[[self.prodList objectAtIndex:0] objectForKey:@"clsInfo"]];
//                        self.titleName = [self.clsInfo objectForKey:@"name"];
//                        NSString *prices=[NSString stringWithFormat:@"%@",[self.clsInfo objectForKey:@"sale_price"]];
//                        float showPric=[prices floatValue];
//                        self.price= [NSString stringWithFormat:@"%0.2f",showPric];
//                        
//                        //                      NSString *commentCount= [NSString stringWithFormat:@"%@",[self.clsInfo objectForKey:@"commentCount"]];
//                        //                    self.stockCount =[Utils getSNSString:commentCount];
//                        
//                        
//                        //                    NSString *favrtieCount = [NSString stringWithFormat:@"%@",self.clsInfo[@"favortieCount"]];
//                        
//                        //                    self.stockCount=[Utils getSNSString:favrtieCount];
//                        self.stockCount=@"";
//                        //                    self.favriteCount=[Utils getSNSString:favrtieCount];
//                        
//                    }
//                    else
//                    {
//                        
//                        self.titleName=@"";
//                        self.price=@"";
//                        self.stockCount=@"";
//                        
//                    }
//                }
//                else
//                {
//                    
////                    clsPicUrl = "http://img.51mb.com:5659/sources/designer/ProdCls/ed9afefb-265a-41ee-b365-22d9161a57ec.jpg";
////                    favoriteCount = 1;
////                    id = 7640;
////                    name = "\U5973\U9ad8\U8170\U8d85\U7ea7\U7d27\U8eab\U725b\U4ed4\U957f\U88e4";
////                    price = 199;
////                    "sale_price" = 199;
//                    self.clsPicUrl = [self.imageData objectForKey:@"clsPicUrl"];
//                    self.thumbURL =[self.imageData objectForKey:@"clsPicUrl"];
//                    self.goodIds = [self.imageData objectForKey:@"id"];
//                    self.goodCode = [self.imageData objectForKey:@"code"];
//                    self.titleName = [self.imageData objectForKey:@"name"];
//                    NSString *prices=[NSString stringWithFormat:@"%@",[self.imageData objectForKey:@"sale_price"]];
//                    NSString *registPrices=[NSString stringWithFormat:@"%@",[self.imageData objectForKey:@"price"]];
//                    float showPric=[prices floatValue];
//                    float registPrice=[registPrices floatValue];
//                    self.price= [NSString stringWithFormat:@"%0.2f",showPric];
//                    self.showRegistPrice = [NSString stringWithFormat:@"%0.2f",registPrice];
//                    
////                    self.titleName=@"";
////                    self.price=@"";
////                    self.stockCount=@"";
//                    
//                }
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            else if ([[self.imageData allKeys] containsObject:@"code"]&&[[self.imageData allKeys] containsObject:@"parentId"])
            {
                self.titleName = self.imageData[@"name"];
                self.thumbURL = self.imageData[@"pictureUrl"];
            }
            else
            {
                self.sharedCount =  self.imageData[@"statisticsFilterList"][0][@"sharedCount"];
                if (self.imageData[@"collocationList"]!=nil&&((NSArray*)self.imageData[@"collocationList"]).count>0)
                {
                    self.collocationList = self.imageData[@"collocationList"];
                    
                    if ([[self.collocationList objectAtIndex:0] objectForKey:@"collocationInfo"]!=nil)
                    {
                        self.collocationInfo=[[self.collocationList objectAtIndex:0] objectForKey:@"collocationInfo"];
                        self.titleName = [self.collocationInfo objectForKey:@"name"];
                        self.thumbURL = [self.collocationInfo objectForKey:@"thrumbnailUrl"];
                        
                        if (self.thumbURL.length==0||self.thumbURL==nil)
                        {
                            self.thumbURL =[self.collocationInfo objectForKey:@"pictureUrl"];
                        }
                        if ([[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"]!=nil)
                        {
                            self.stockCount = [NSString stringWithFormat:@"%@",[[[[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"commentCount"]];
                            self.favriteCount =[NSString stringWithFormat:@"%@",[[[[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"favoritCount"]];
                            self.sharedCount = [NSString stringWithFormat:@"%@",[[[[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"sharedCount"]];
                            self.browserCount =[NSString stringWithFormat:@"%@",[[[[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"browserCount"]];
                        }
                        else
                        {
                            self.stockCount=@"0";
                            self.favriteCount=@"0";
                            self.browserCount=@"0";
                        }
                        
                    }
                    else
                    {
                        self.titleName=@"";
                        self.stockCount=@"0";
                        self.favriteCount=@"0";
                        self.browserCount=@"0";
                        
                    }
                    
                }
                else if (self.imageData[@"collocationInfo"]!=nil&&self.imageData[@"detailList"]!=nil)
                {
                    self.collocationInfo=self.imageData[@"collocationInfo"];
                    self.titleName = [self.collocationInfo objectForKey:@"name"];
                    self.descriptionStr = [self.collocationInfo objectForKey:@"description"];
                    self.thumbURL = [self.collocationInfo objectForKey:@"thrumbnailUrl"];
                    
                    if (self.thumbURL.length==0||self.thumbURL==nil)
                    {
                        self.thumbURL =[self.collocationInfo objectForKey:@"pictureUrl"];
                    }
                    if (self.imageData[@"statisticsFilterList"]!=nil)
                    {
                        self.stockCount = [NSString stringWithFormat:@"%@",[[self.imageData[@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"commentCount"]];
                        
                        self.favriteCount =[NSString stringWithFormat:@"%@",[[self.imageData[@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"favoritCount"]];
                        self.browserCount =[NSString stringWithFormat:@"%@",[[self.imageData[@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"browserCount"]];
                    }
                    else
                    {
                        self.stockCount=@"0";
                        self.favriteCount=@"0";
                        self.browserCount=@"0";
                    }
                }else if (self.imageData[@"collectionList"]!=nil&&((NSArray*)self.imageData[@"collectionList"]).count>0){
                
                
                    self.collocationList = self.imageData[@"collectionList"];
                    
                    if ([[self.collocationList objectAtIndex:0] objectForKey:@"collocationInfo"]!=nil)
                    {
                        self.collocationInfo=[[self.collocationList objectAtIndex:0] objectForKey:@"collocationInfo"];
                        self.isFavorite = self.collocationInfo[@"isFavorite"];
                        self.titleName = [self.collocationInfo objectForKey:@"name"];
                        self.thumbURL = [self.collocationInfo objectForKey:@"thrumbnailUrl"];
                        
                        if (self.thumbURL.length==0||self.thumbURL==nil)
                        {
                            self.thumbURL =[self.collocationInfo objectForKey:@"pictureUrl"];
                        }
                        if ([[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"]!=nil)
                        {
                            self.stockCount = [NSString stringWithFormat:@"%@",[[[[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"commentCount"]];
                            self.favriteCount =[NSString stringWithFormat:@"%@",[[[[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"favoritCount"]];
                            self.sharedCount = [NSString stringWithFormat:@"%@",[[[[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"sharedCount"]];
                            self.browserCount =[NSString stringWithFormat:@"%@",[[[[self.collocationList objectAtIndex:0] objectForKey:@"statisticsFilterList"] objectAtIndex:0] objectForKey:@"browserCount"]];
                        }
                        else
                        {
                            self.stockCount=@"0";
                            self.favriteCount=@"0";
                            self.browserCount=@"0";
                        }
                        
                    }
                    else
                    {
                        self.titleName=@"";
                        self.stockCount=@"0";
                        self.favriteCount=@"0";
                        self.browserCount=@"0";
                        
                    }

                
                
                
                }
                else
                {
                    self.titleName=@"";
                    self.stockCount=@"0";
                    self.favriteCount=@"0";
                    self.browserCount=@"0";
                    
                }
            }
   
        }

    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"price"]) {
        self.price= [NSString stringWithFormat:@"%0.2f",[value floatValue]];
    }else if([key isEqualToString:@"market_price"]){
        self.market_price= [NSString stringWithFormat:@"%0.2f",[value floatValue]];
    }
}
-(NSString *)description
{
//    return [NSString stringWithFormat:@"thumbURL:%@ width:%f height:%f",self.thumbURL,self.width,self.height];
    return   [NSString stringWithFormat:@"%@",self.imageData];
    
}
@end
