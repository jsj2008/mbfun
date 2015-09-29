//
//  AddressPicker.m
//  BanggoPhone
//
//  Created by Samuel on 14-7-14.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "AddressPicker.h"
#import "Animations.h"
#import "DetectionSystem.h"

@implementation AddressPicker
{
    BOOL chooseControl;
    
    int yForIOS6;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AddressPicker"owner:self options:nil];
        self = [nib objectAt:0];
        self.frame = CGRectMake(0, frame.origin.y, self.frame.size.width, self.frame.size.height);
        NSLog(@"%f,%f,%f,%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
        self.pickerViews.delegate = self;
        self.pickerViews.dataSource = self;
        UITapGestureRecognizer *back = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesControl)];
        [self addGestureRecognizer:back];
        chooseControl = YES;
    }
    return self;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if([touch.view isKindOfClass:[UIPickerView class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)touchesControl
{
    if (chooseControl == YES)
    {
        [Animations moveDown:self andAnimationDuration:.3 andWait:YES andLength:self.frame.size.height];
    }
}
#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
    return 3;
}
- (NSInteger) pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger) component
{
    long i =0;
    if (component == 0 )
    {
        i = [self.provinces count];
    }
    else if(component == 1)
    {
        i = [self.citys count];
    }
    else if(component == 2)
    {
        i = [self.districts count];
    }
    return i;
}
#pragma mark Picker Delegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 100, 25);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:25]];
    }

    if (component == 0)
    {
//        MGetZoneListlist *getZoneListlistProvinces = [self.provinces objectAt:row];
//
//        pickerLabel.text = getZoneListlistProvinces.regionName;
    }
    else if (component == 1)
    {
//        MGetZoneListlist *getZoneListlistCitys = [self.citys objectAt:row];
//
//        pickerLabel.text = getZoneListlistCitys.regionName;
        
    }
    else if (component == 2)
    {
//        MGetZoneListlist *getZoneListlistDistricts = [self.districts objectAt:row];
//
//        pickerLabel.text = getZoneListlistDistricts.regionName;
        
    }
    return pickerLabel;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return 100;
        }
            break;
        case 1:
        {
            return 100;
        }
            break;
        case 2:
        {
            return 100;
        }
            break;
        default:
            return 100;
            break;
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (!IOS7)
    {
        return 30;
    }
    return 25;
}

//触发事件
- (void)pickerView:(UIPickerView *)PickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
//            MGetZoneListlist *getZoneListlist = [self.provinces objectAt:row];
//            [BGSever getZoneListWithZoneID:getZoneListlist.regionId
//                                   success:^(id result)
//             {
//                 MGetZoneList *getZoneList = result;
//                 self.citys = getZoneList.list;
//                 [self.pickerViews reloadComponent:1];
//                 [PickerView selectRow:0 inComponent:1 animated:YES];
//                 MGetZoneListlist *getZoneListlist2 = [self.citys objectAt:0];
//                 chooseControl = NO;
//                 [BGSever getZoneListWithZoneID:getZoneListlist2.regionId
//                                        success:^(id result)
//                  {
//                      MGetZoneList *getZoneList = result;
//                      self.districts = getZoneList.list;
//                      [self.pickerViews reloadComponent:2];
//                      [PickerView selectRow:0 inComponent:2 animated:YES];
//                      chooseControl = YES;
//                      [self saveDataes];
//                  } failure:^(NSError *error)
//                  {
//                      ;
//                  }];
//                 
//             } failure:^(NSError *error)
//             {
//                 ;
//             }];

            break;
        }
        case 1:
        {
//            MGetZoneListlist *getZoneListlist3 = [self.citys objectAt:row];
//            chooseControl = NO;
//            [BGSever getZoneListWithZoneID:getZoneListlist3.regionId
//                                   success:^(id result)
//             {
//                 MGetZoneList *getZoneList = result;
//                 self.districts = getZoneList.list;
//                 [self.pickerViews reloadComponent:2];
//                 [PickerView selectRow:0 inComponent:2 animated:YES];
//                 chooseControl = YES;
//                 [self saveDataes];
//             } failure:^(NSError *error)
//             {
//                 ;
//             }];
            
            
            break;
        }
        case 2:
        {
            [self saveDataes];
            break;
        }
        default:
            break;
    }
}
- (void)saveDataes
{
//    NSInteger row0 = [self.pickerViews selectedRowInComponent:0];
//    NSInteger row1 = [self.pickerViews selectedRowInComponent:1];
//    NSInteger row2 = [self.pickerViews selectedRowInComponent:2];
//    MGetZoneListlist *state = [self.provinces objectAt:row0];
//    MGetZoneListlist *city = [self.citys objectAt:row1];
//    MGetZoneListlist *area = [self.districts objectAt:row2];
//    NSMutableArray *mainData = [[NSMutableArray alloc]initWithObjects:state,city,area, nil];
//    NSMutableDictionary *allDataDic = [[NSMutableDictionary alloc]init];
//    [allDataDic setObject:mainData forKey:@"getAllData"];
//    [allDataDic setObject:self.citys forKey:@"citylist"];
//    [allDataDic setObject:self.districts forKey:@"districtslist"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangAddressCodes" object:allDataDic];
}
@end
