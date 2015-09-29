//
//  CollocationDetailGridTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-18.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CollocationDetailGridTableViewCell.h"
#import "Utils.h"
#import "CollocationDetailGridView.h"
#import "MBShoppingGuideInterface.h"

//static const int Margin=13;
static const int FixHeight=0;
//static const int CellHeight=116;
//static const int CellWidth=96;
//static const int CellHeight=127;
static const int CellHeight=160;
//static const int CellWidth=108;

@implementation CollocationDetailGridTableViewCell

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
    
    self.backgroundColor=COLLOCATION_TABLE_BG; 
//    self.backgroundColor = [Utils HexColor:0xE2E2E2 Alpha:1];
    
    self.frame=CGRectMake(0, 0, self.frame.size.width, FixHeight+CellHeight);
    
    if (uigridArray==nil)
        uigridArray=[[NSMutableArray alloc] initWithCapacity:6];
    
#ifdef NAMEANDTIME
    if (_lbName==nil)
    {
        int titleHeight=16;
        _lbName=[[UILabel alloc] initWithFrame:CGRectMake(Margin, Margin, 200, titleHeight)];
        _lbName.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_lbName];
        
        int x=_lbName.frame.origin.x+_lbName.frame.size.width;
        _lbTime=[[UILabel alloc] initWithFrame:CGRectMake(x, Margin+2, SCREEN_WIDTH-x-Margin, titleHeight)];
        _lbTime.font=[UIFont systemFontOfSize:10];
        [_lbTime setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lbTime];
    }
#endif
}

-(void)setData:(NSArray *)data1
{
    _data=data1;
    
    self.frame=CGRectMake(0, 0, self.frame.size.width, [CollocationDetailGridTableViewCell getCellHeight:data1]);
#ifdef NAMEANDTIME
    int x=17;
    int y=_lbName.frame.origin.y+_lbName.frame.size.height+3;
#else
    int x=0;
    int y=0;
#endif
    
    for (UIView *view in uigridArray)
    {
        [view removeFromSuperview];
    }
    [uigridArray removeAllObjects];
    
    int rownum=((int)_data.count-1)/2+1;
    for (int i=0;i<rownum*2;i++)
    {
//        CollocationDetailGridView *grid=[[CollocationDetailGridView alloc] initWithFrame:CGRectMake(x+CellWidth*(i%3)-i%3, y+CellHeight*(i/3)-i/3, CellWidth, CellHeight)];
        
        CollocationDetailGridView *grid=[[CollocationDetailGridView alloc] initWithFrame:CGRectMake(x+(UI_SCREEN_WIDTH/2+0.5)*(i%2)-i%2, y+CellHeight*(i/2)-i/2, UI_SCREEN_WIDTH/2+0.5, CellHeight)];
        [self.contentView addSubview: grid];
        if (i<_data.count)
            grid.data=_data[i];
        else
            grid.data=nil;
        grid.index=i;
        [uigridArray addObject:grid];
    }
}

-(void)setCollocationInfo:(NSDictionary *)collocationDict
{
#ifdef NAMEANDTIME
    _lbName.text=[Utils getSNSString:collocationDict[@"collocationInfo"][@"name"]];
    
    NSString *jsondate=[Utils getSNSString:collocationDict[@"collocationInfo"][@"creatE_DATE"]];
    if (jsondate.length>0)
    {
        NSString *interval=[MBShoppingGuideInterface getJsonDateInterval:jsondate];
        NSDate *datetime=[Utils getDateTimeInterval_MS:interval];
        NSString *createdatestr=[Utils FormatDateTime:datetime FormatType:FORMAT_DATE_TYPE_DURATION_ALL];
        _lbTime.text=createdatestr;
    }
    else
    {
        NSDate *datetime=[NSDate date];
        _lbTime.text=[Utils FormatDateTime:datetime FormatType:FORMAT_DATE_TYPE_DURATION_ALL];
    }
#endif
}

+(int)getCellHeight:(id)data1
{
    NSArray *arr=data1;
    int rownum=((int)arr.count-1)/2+1;
    
    return FixHeight+rownum*CellHeight+49;
}

@end
