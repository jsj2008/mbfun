//
//  CollocationDetailTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CollocationDetailTableViewCell.h"
#import "Utils.h"
#import "CommMBBusiness.h"

static const int CollocationDetailTableViewCellHeight=60;
static const int Margin=5;

@implementation CollocationDetailTableViewCell

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
    
    if (imageView==nil)
    {
        imageView=[[UIUrlImageView alloc] initWithFrame:CGRectMake(Margin, Margin, CollocationDetailTableViewCellHeight-Margin*2, CollocationDetailTableViewCellHeight-Margin*2)];
  
        
//        imageView.image=[UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        imageView.image=[UIImage imageNamed:DEFAULT_LOADING_MEDIUM];
        
        [self.contentView addSubview: imageView];
    }
    
    self.frame=CGRectMake(0, 0, self.frame.size.width, CollocationDetailTableViewCellHeight);
    
    int price_width=45, price_height=28;
    int price_x=SCREEN_WIDTH-price_width-Margin;
    int price_y=(self.frame.size.height-price_height)/2;
    _lbPrice=[[UILabel alloc] initWithFrame:CGRectMake(price_x, price_y, price_width, price_height)];
    _lbPrice.font=[UIFont systemFontOfSize:12];
    _lbPrice.textColor=[UIColor redColor];
//    _lbPrice.backgroundColor=[UIColor yellowColor];
    _lbPrice.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:_lbPrice];

    int name_x=imageView.frame.origin.x+imageView.frame.size.width+Margin, name_height=28;
    int name_y=(self.frame.size.height-name_height)/2;
    _lbName=[[UILabel alloc] initWithFrame:CGRectMake(name_x, name_y, price_x-name_x+Margin, name_height)];
    _lbName.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_lbName];
    
}

-(void)setData:(NSDictionary *)data1
{
    _data=data1;
    _lbName.text=@"";
    _lbPrice.text=[NSString stringWithFormat:@"￥0"];
    
    if (_data!=nil && _data[@"detailInfo"]!=nil)
        _lbName.text=_data[@"detailInfo"][@"productName"];
    
    NSString *imgname=@"";
    if (_data!=nil && _data[@"proudctList"]!=nil)
    {
        if (_data[@"proudctList"][@"clsInfo"]!=nil)
            _lbPrice.text=[NSString stringWithFormat:@"￥%@",_data[@"proudctList"][@"clsInfo"][@"price"]];
        
        if (_data[@"proudctList"][@"clsPicUrl"]!=nil &&[_data[@"proudctList"][@"clsPicUrl"] count]>0)
        {
            NSString *filePath=[Utils getSNSString: _data[@"proudctList"][@"clsPicUrl"][0][@"filE_PATH"]];
          
            imgname= [CommMBBusiness changeStringWithurlString:filePath size:SNS_IMAGE_ORIGINAL];
        }
    }
    [self downloadImage:imgname];
}

+(int)getCellHeight:(id)data1
{
    return CollocationDetailTableViewCellHeight;
}

@end
