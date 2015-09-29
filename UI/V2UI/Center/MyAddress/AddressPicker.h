//
//  AddressPicker.h
//  BanggoPhone
//
//  Created by Samuel on 14-7-14.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressPicker : UIView<UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViews;

@property (nonatomic,retain)NSMutableArray *provinces;

@property (nonatomic,retain)NSMutableArray *citys;

@property (nonatomic,retain)NSMutableArray *districts;


@end
