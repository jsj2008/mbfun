//
//  MakeViewController.h
//  newdesigner
//
//  Created by Miaoz on 14-9-16.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GesturesImageView.h"
#import "BaseViewController.h"
typedef void (^MakeViewVCSourceVoBlock) (id sender,UIImage *shearimage);

@interface MakeViewController : BaseViewController
@property(nonatomic,copy)MakeViewVCSourceVoBlock myblock;
@property(strong,nonatomic) UIImage *selectImage;
//@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property(nonatomic,strong)GesturesImageView *mainGesturesImageView;

@property(nonatomic,assign)int lastWidth;
@property(nonatomic,assign)int lastHeight;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarBtnItem;

-(void)makeViewVCSourceVoBlockWithsourceVO:(MakeViewVCSourceVoBlock) block;


- (IBAction)removePointViewClickevent:(id)sender;

- (IBAction)leftBarButtonItemClickevent:(id)sender;

- (IBAction)rightBarButtonItemClickevent:(id)sender;

@end
