//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface HZAreaPickerView ()
{
    NSArray *provinces, *cities, *areas;
    NSDictionary *areaDic;
    NSString *selectedProvince;
    BOOL isCanMakeSure;
    
    
    NSUInteger isSelectRowCity;
    NSUInteger isSelectRowProvince;
    NSUInteger isSelectRowDist;
    BOOL  IsSelectyCity;

}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneToolBarBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *face;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@end

@implementation HZAreaPickerView

@synthesize delegate=_delegate;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;



-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

- (id)initWithStyle:(id<HZAreaPickerDelegate>)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0] ;
    if (self) {
        self.delegate = delegate;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        _face.width=UI_SCREEN_WIDTH-100;
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
        areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        NSArray *components = [areaDic allKeys];
        NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *tmp = [[areaDic objectForKey: index] allKeys];
            [provinceTmp addObject: [tmp objectAtIndex:0]];
        }
        
        provinces = [[NSArray alloc] initWithArray: provinceTmp];
        
        NSString *index = [sortedArray objectAtIndex:0];
        NSString *selected = [provinces objectAtIndex:0];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
        
        NSArray *cityArray = [dic allKeys];
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
        cities = [[NSArray alloc] initWithArray: [cityDic allKeys]];
        
        
        NSString *selectedCity = [cities objectAtIndex: 0];
        areas = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    }
    
    return self;
    
}

- (void)updatePickerWithAddress:(HZLocation *)location
{
    if ([provinces containsObject:location.state]) {
        NSInteger aNum = [provinces indexOfObject:location.state];
        [_locatePicker selectRow:aNum inComponent:PROVINCE_COMPONENT animated:NO];
        [self pickerView:_locatePicker didSelectRow:aNum inComponent:PROVINCE_COMPONENT];
    
        if ([cities containsObject:location.city]) {
            NSInteger bNum = [cities indexOfObject:location.city];
            [_locatePicker selectRow:bNum inComponent:CITY_COMPONENT animated:NO];
            [self pickerView:_locatePicker didSelectRow:bNum inComponent:1];
            if ([areas containsObject:location.district]) {
                NSInteger cNum = [areas indexOfObject:location.district];
                [_locatePicker selectRow: cNum inComponent: DISTRICT_COMPONENT animated: NO];
            }
        }
    }
}

#pragma mark - PickerView lifecycle
#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [provinces count];
    }
    else if (component == CITY_COMPONENT) {
        return [cities count];
    }
    else {
        return [areas count];
    }
}

#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [provinces objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [cities objectAtIndex: row];
    }
    else {
        return [areas objectAtIndex: row];
    }
}
-(void)getCityAndAreaWithTemp:(NSDictionary *)tmp WithIsOnlyDistricity:(BOOL) isOnlyDistricity
{

    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
    NSArray *cityArray = [dic allKeys];
    NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;//递减
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;//上升
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *temp = [[dic objectForKey: index] allKeys];
        [array addObject: [temp objectAtIndex:0]];
    }
    if(isOnlyDistricity)
    {
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: isSelectRowCity]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        areas = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        
    }
    else
    {
        cities = [[NSArray alloc] initWithArray: array];
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        areas = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cities objectAtIndex: 0]]];

    }


}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    isSelectRowCity = 0;
    if (provinces.count <= 0) {
        return;
    }
    if (component == PROVINCE_COMPONENT) {
        IsSelectyCity=NO;
        
        selectedProvince = [provinces objectAtIndex: row];
        NSLog(@"selectde－－－%@",selectedProvince);
        isSelectRowProvince =row;
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        [self getCityAndAreaWithTemp:tmp WithIsOnlyDistricity:IsSelectyCity];
        /*
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        cities = [[NSArray alloc] initWithArray: array];
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        areas = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cities objectAtIndex: 0]]];
         */
        [pickerView reloadComponent: CITY_COMPONENT];
        [pickerView reloadComponent: DISTRICT_COMPONENT];
        if (cities.count > 0 && areas.count > 0) {
            [pickerView selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
            [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        }
        
     
    }
    else if (component == CITY_COMPONENT) {
        IsSelectyCity = YES;
        if (selectedProvince.length==0) {
        selectedProvince = [provinces objectAtIndex: row];
        }
        
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[provinces indexOfObject: selectedProvince]];
        NSLog(@"provinceindex－－－%@",provinceIndex);
        
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
//        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        isSelectRowCity = row;
        
        [self getCityAndAreaWithTemp:tmp WithIsOnlyDistricity:IsSelectyCity];
        /*
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        areas = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        */
        [pickerView reloadComponent: DISTRICT_COMPONENT];
        if (areas.count > 0) {
            [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        }
    }else
    {
          IsSelectyCity = NO;
    }

}
-(void)creatProCityDist
{
    NSInteger provinceIndex = [_locatePicker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [_locatePicker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [_locatePicker selectedRowInComponent: DISTRICT_COMPONENT];

    NSString *provinceStr = [provinces objectAtIndex: provinceIndex];
//    selectedProvince = provinceStr;
//    NSString *provinceIndexStr = [NSString stringWithFormat:@"%ld",(long)provinceIndex];
//    NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey:provinceIndexStr]];
//    if (IsSelectyCity) {
//          isSelectRowCity=cityIndex;
//    }
//    [self getCityAndAreaWithTemp:tmp WithIsOnlyDistricity:IsSelectyCity];
//    
    NSLog(@"cities--new-%@",cities);
    NSLog(@"arears－－new－%@",areas);
    
    
//  NSString *provinceStr = [provinces objectAtIndex: provinceIndex];
    NSString *cityStr = [cities objectAtIndex: cityIndex];
    NSString *districtStr = [areas objectAtIndex:districtIndex];
    

    
    
    self.locate.state = provinceStr;
    self.locate.city = cityStr;
    self.locate.district = districtStr;
//    NSLog(@"state－－－%@,city=====%@,,,,,district----%@",self.locate.state, self.locate.city, self.locate.district);
    
}
#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, view.width/*self.frame.size.width*/, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

- (IBAction)cityPickerTureToolBar:(id)sender {
    [self performSelector:@selector(clickBtnDone) withObject:nil afterDelay:1.0f];
    
}
-(void)clickBtnDone
{
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self creatProCityDist];
        [self.delegate pickerDidChaneStatus:self];
    }
}
- (IBAction)cityPickerCancleToolBar:(id)sender {
    if([self.delegate respondsToSelector:@selector(pickerToolBarCancel:)]) {
        [self.delegate pickerToolBarCancel:self];
    }
}

@end
