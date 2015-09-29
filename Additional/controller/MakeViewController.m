//
//  MakeViewController.m
//  newdesigner
//
//  Created by Miaoz on 14-9-16.
//  Copyright (c) 2014年 mb. All rights reserved.
//


#define distanceWhight 55
#define kTopHeight   20 //65+15
#define kDeviceWidth  self.view.bounds.size.width
#define kDeviceHeight self.view.bounds.size.width  //self.view.bounds.size.height
#define kTabBarHeight 64
#define POSITIONID (int)scrollView.contentOffset.x/kDeviceWidth
#define buttontag 70

#import "MakeViewController.h"
#import "AppDelegate.h"
#import "NLImageCropperView.h"
#import "DrawLineCropImageView.h"
#import "GesturesImageView.h"
#import "TopImageView.h"
#import "NavTopTitleView.h"
#import "Globle.h"
//#import "NSData+XMPP.h"
#import "ShearModelMapping.h"
#import "NSString+help.h"
@interface MakeViewController ()<UIActionSheetDelegate>//UIImagePickerControllerDelegate,UINavigationControllerDelegate,
@property (strong, nonatomic) IBOutlet UIButton *removePointButton;
//@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic,strong)  NLImageCropperView* imageCropper;
@property (nonatomic,strong) DrawLineCropImageView * drawLineCropImageView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) GesturesImageView *gesturesImageView;
@property (nonatomic,strong) NSString *selectmark;
@property (nonatomic,strong)UIImageView *topBackImageView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *dataarray;
@property (nonatomic,strong)ShearModelMapping *shearModelMapping;
@property (nonatomic,strong)NSMutableDictionary *sourceDic;//模型抠图数据
@property (nonatomic,strong)NSMutableDictionary *source2Dic;//矩形切割数据

@property(nonatomic,strong)NavTopTitleView *navTopTitleView;

@property (nonatomic,strong)NSMutableArray      *source3Array;//点切割数据存放字典的存放数组
@property(nonatomic,strong)NSMutableData *mutableData;

@property(nonatomic,strong)NSString *shear1Path;
@end

@implementation MakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma 焦点记忆效果

-(void)recordClickSelectShearWithclickint:(int) clickint {
    for ( int i = 0 ; i < _navTopTitleView.buttonarray.count; i ++) {
        UIButton *btn = _navTopTitleView.buttonarray[i];
        
        //点击操作
        btn.layer.borderColor = [[UIColor colorWithHexString:@"#353535"] CGColor];//#acacac
        btn.layer.borderWidth = 1.0f;
        btn.backgroundColor = [UIColor colorWithHexString:@"#353535"];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        //    sender.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        
        if (_navTopTitleView.whiteImageArray != nil) {
            [btn setImage:[UIImage imageNamed:_navTopTitleView.whiteImageArray[i]] forState:UIControlStateNormal];
        }
      
        
    }
    
    UIButton *sender = _navTopTitleView.buttonarray[clickint];
    sender.layer.borderColor = [[UIColor colorWithHexString:@"#353535"] CGColor];//#acacac
    sender.layer.borderWidth = 1.0f;
    sender.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    sender.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    //        btn.titleLabel.textColor = [UIColor colorWithHexString:@"#353535"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#353535"] forState:UIControlStateNormal];
    
    if (_navTopTitleView.blackImageArray != nil) {
        [sender setImage:[UIImage imageNamed:_navTopTitleView.blackImageArray[clickint]] forState:UIControlStateNormal];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    _selectmark = @"1";
    if (_sourceDic == nil) {
        _sourceDic = [NSMutableDictionary new];
    }
    if (_source2Dic == nil) {
        _source2Dic = [NSMutableDictionary new];
    }
   
    
    if (_source3Array == nil) {
        _source3Array = [NSMutableArray new];
    }
    if (_dataarray == nil) {
        _dataarray = [NSMutableArray new];
    }
    [self createScrollerView];
  
    
    [self requestWXPicShear];
    
    [self creatNavTitleView];
    
   
 
}

-(void)setMainGesturesImageView:(GesturesImageView *)mainGesturesImageView{
    _mainGesturesImageView = mainGesturesImageView;

    NSString *imageurl ;
    
    //add by miao 11.12
    if (_mainGesturesImageView.imageurl != nil)
    {
        imageurl = _mainGesturesImageView.imageurl;
    }else{
    
        if (_mainGesturesImageView.goodObj != nil) {
            imageurl = _mainGesturesImageView.goodObj.clsPicUrl.filE_PATH;
        }else if(_mainGesturesImageView.detailMapping != nil){
                    imageurl = _mainGesturesImageView.detailMapping.productPictureUrl;
        }else if(_mainGesturesImageView.materialMapping != nil){
                    imageurl = _mainGesturesImageView.materialMapping.pictureUrl;
        }
    }
    NSMutableString *mainurlString;
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:imageurl];
    NSRange range = [String1 rangeOfString:@"--"];
    
    int location = (int)range.location;
    int leight = (int)range.length;
    
    if (leight == 2) {////有--400x400
        mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
        [mainurlString appendString:[NSString stringWithFormat:@".png"]];
        
        
    }else{//没有--400x400 //有后缀.png
        NSRange range = [String1 rangeOfString:@".png"];
        
        int leight = (int)range.length;
        if (leight == 4){//有后缀.png
            
             mainurlString = [[NSMutableString alloc] initWithString:String1];
            
        }else{//没有后缀png
            
            //后缀jpg
            NSRange range2 = [String1 rangeOfString:@".jpg"];
            int location2 = (int)range2.location;
            int leight2 = (int)range2.length;
            if (leight2 == 4){//有后缀.jpg
                
                mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
                [mainurlString appendString:[NSString stringWithFormat:@".jpg"]];
            }else{//没有后缀
                
                mainurlString = [[NSMutableString alloc] initWithString:String1];
                [mainurlString appendString:[NSString stringWithFormat:@".png"]];
                
            }
           

        }
        
    }

 
   
    [mainurlString insertString:[NSString stringWithFormat:@"--%dx%d",(int)kDeviceWidth,(int)kDeviceWidth] atIndex:mainurlString.length -4];
    
    [self.view makeToastActivity];
//
    UIImageFromURL([NSURL URLWithString:[mainurlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], ^(UIImage *image) {
        _selectImage = image;
        [self.view hideToastActivity];
        if(_selectImage != nil)
        {
            if (_topBackImageView == nil)
            {
                
             
//                UIImageView *b = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - _selectImage.size.width/averageint)/2, kTopHeight,_selectImage.size.width/averageint ,_selectImage.size.height/averageint )];
                
                 UIImageView *b = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-_selectImage.size.width)/2, kTopHeight,_selectImage.size.width ,_selectImage.size.height )];
                b.image = _selectImage;
//                b.backgroundColor = [UIColor yellowColor];
//                b.layer.masksToBounds = YES;
                _topBackImageView = b;
                
                [self.view addSubview:b ];
            }
            
            
            _removePointButton.hidden = YES;
            [self creatNLImageCropperView];
            [self creatDrawLineCropImageView];
            [self recordMothel];
            
        }
        
    }, ^{
        
    });
}


-(void)recordMothel{
    if (_mainGesturesImageView.imageurl == nil) {
        return ;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_mainGesturesImageView.imageurl] != NULL) {
        NSDictionary *sheardic = [[NSUserDefaults standardUserDefaults] objectForKey:_mainGesturesImageView.imageurl];
        if ([sheardic objectForKey:SHEAR1] != nil || [sheardic objectForKey:SHEAR1] != NULL) {
            [self recordClickSelectShearWithclickint:0];
            [self imageByimageClickevent];
            
            NSData * data = [sheardic objectForKey:SHEAR1];
//           NSNumber *numberX = [sheardic objectForKey:@"x"];
            _shear1Path = [sheardic objectForKey:@"path"];
            NSNumber *numberY  = [sheardic objectForKey:@"y"];
//            UIImage *image =   [UIImage  imageWithData:data];
            NSNumber *numberwidth = [sheardic objectForKey:@"w"];
            NSLog(@"numberwidth-----%@",numberwidth);
            if (_gesturesImageView == nil) {
                _gesturesImageView = [[GesturesImageView alloc] initWithFrame:
                                      CGRectMake(0, 0,  numberwidth.floatValue,
                                                 numberwidth.floatValue)];
                //numberX.floatValue
                _gesturesImageView.center = CGPointMake(_topBackImageView.center.x, numberY.floatValue);
                //11.21 add by miao
                [_gesturesImageView crossBorderDisappearevent];
                [_gesturesImageView.spinner stopAnimating];
                [_gesturesImageView.spinner setHidesWhenStopped:YES];
                
//                _gesturesImageView.center = _topBackImageView.center;
                [_gesturesImageView.rotationG setEnabled:NO];
                //    gesturesImageView.delegate = self;
                _gesturesImageView.tag = 1001;
               _gesturesImageView.image = [UIImage  imageWithData:data];
                _gesturesImageView.parentView = self.view;
                [_gesturesImageView.singleFinger setEnabled:NO];
                [self.view addSubview:_gesturesImageView];
            }else{
                _gesturesImageView.hidden = NO;
            }
           
            
        }
        else if ([sheardic objectForKey:SHEAR2] != nil || [sheardic objectForKey:SHEAR2] != NULL) {
            [self recordClickSelectShearWithclickint:1];
            [self lineboxClickevent];
            
            NSString * shera2datastr = [sheardic objectForKey:SHEAR2];
           CGRect rect = CGRectFromString(shera2datastr);
            [_imageCropper setCropRegionRect:rect];
            
        }
        else if ([sheardic objectForKey:SHEAR3] != nil || [sheardic objectForKey:SHEAR3] != NULL) {
            
            [self recordClickSelectShearWithclickint:2];
            
            [self pointImageClickevent];
            
            NSString * shera3datastr = [sheardic objectForKey:SHEAR3];
            
            id shera3data = [NSString dictionaryWithJsonString:shera3datastr];
            if ([shera3data isKindOfClass:[NSArray class]]) {
                //
                NSMutableArray *pointArray = [NSMutableArray new];
                for(NSDictionary *dic in shera3data){
                    
                    NSString *pointx = [dic objectForKey:@"x"];
                    NSString *pointy = [dic objectForKey:@"y"];
                    CGFloat backwidth = _drawLineCropImageView.frame.size.width;
                    CGFloat backheight = _drawLineCropImageView.frame.size.height;
                    
                    [pointArray addObject: [NSValue valueWithCGPoint:CGPointMake(pointx.floatValue*backwidth,pointy.floatValue*backheight)]];
                }
                _drawLineCropImageView.pointsArray = pointArray;
                [_drawLineCropImageView  resetPointWithpointarray:pointArray];
                
                
            }

           
        }
        
    }
    


}
#pragma mark -- 创建scrollView
-(void)createScrollerView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kTabBarHeight-50, self.view.frame.size.width, 50)];
        
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_scrollView];
        
        _scrollView.contentSize =CGSizeMake(self.view.frame.size.width, 50);
    }
    
}
#pragma mark--底部剪切模型图
-(void)addmakeBottombuttonwithshearmodelArray:(NSMutableArray *)shearmodelArray{

    //设置底部contentSize
    if (shearmodelArray != nil) {
        _scrollView.contentSize =CGSizeMake(distanceWhight+shearmodelArray.count*distanceWhight, 50);
    }
    
    for (int i = 0; i<shearmodelArray.count; i++) {
        
        ShearModelMapping *shearModelMapping = _dataarray[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+i*distanceWhight, 2, 45, 45);
        button.tag = buttontag+i;

        NSString *imageurl = [CommMBBusiness changeStringWithurlString:shearModelMapping.pictureUrl width:150 height:150];

        NSString *url = [imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"UIImageFromURLTOCache     %@",url);
        UIImageFromURLTOCache([NSURL URLWithString:url], url, ^(UIImage *image) {
            [button setBackgroundImage:image forState:UIControlStateNormal];
        }, ^{
            [button setBackgroundImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE] forState:UIControlStateNormal];
        });
        [button addTarget:self action:@selector(scrollViewButtonclick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];


    }
    
}

-(void)scrollViewButtonclick:(UIButton *)sender{
    
    ShearModelMapping *shearModelMapping = _dataarray[sender.tag -buttontag];
    
    _shearModelMapping = shearModelMapping;
    
    UIImage *image = [sender backgroundImageForState:UIControlStateNormal];
    if (_gesturesImageView == nil) {
        
        NSLog(@"%f",image.size.width/6);
        _gesturesImageView = [[GesturesImageView alloc] initWithFrame:
                              CGRectMake(0, 0, image.size.width,
                                         image.size.height)];
        _gesturesImageView.center = _topBackImageView.center;

        [_gesturesImageView.rotationG setEnabled:NO];
        //11.21 add by miao
        [_gesturesImageView crossBorderDisappearevent];
        [_gesturesImageView.spinner stopAnimating];
        [_gesturesImageView.spinner setHidesWhenStopped:YES];
        
        //    gesturesImageView.delegate = self;
        _gesturesImageView.tag = 1001;
        _gesturesImageView.parentView = self.view;
        [_gesturesImageView.singleFinger setEnabled:NO];
        [self.view addSubview:_gesturesImageView];
    }else{
        _gesturesImageView.hidden = NO;
        
    }

        _gesturesImageView.image = [sender backgroundImageForState:UIControlStateNormal];
  
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
//            if (view.layer.borderWidth != 0.5f) {
                view.layer.borderColor = [[UIColor clearColor] CGColor];
                view.layer.borderWidth = 0.5f;
                
//            }
        }
    }
    
//    if (sender.layer.borderWidth != 0.5f) {
        sender.layer.borderColor = [[UIColor colorWithHexString:@"#353535"] CGColor];
        sender.layer.borderWidth = 0.5f;

//    }
    
}
#pragma mark -- 创建NavTitleView
-(void)creatNavTitleView{
    if (_navTopTitleView == nil) {
        NavTopTitleView *navTopTitleView = [[NavTopTitleView alloc] initWithFrame:CGRectMake(0, -10, 49*3, 30.0f)];
        navTopTitleView.whiteImageArray = @[@"btn_picture-cut_pressed",@"btn_rectangular-cut_pressed",@"btn_free-cut_pressed"];
        navTopTitleView.blackImageArray = @[@"btn_picture-cut_normal",@"btn_rectangular-cut_normal",@"btn_free-cut_normal"];
        navTopTitleView.titlearray  = @[@"",@"",@""];//@"图形",@"矩形",@"线"
        
        [navTopTitleView navTopTitleViewBlockWithbuttontag:^(id sender) {
            NSString *btntagStr = [NSString stringWithFormat:@"%@",sender];
            int btntag = btntagStr.intValue;
            switch (btntag) {
                case 0:
                    [self imageByimageClickevent];
                    break;
                    
                case 1:
                    [self lineboxClickevent];
                    break;
                case 2:
                    [self pointImageClickevent];
                    break;
                default:
                    break;
            }
        }];
        _navTopTitleView = navTopTitleView;
        self.navigationItem.titleView = navTopTitleView;
        

    }
   
    
}

//框
-(void)creatNLImageCropperView
{
    if (_imageCropper == nil) {
     
        _imageCropper = [[NLImageCropperView alloc] initWithFrame:
                         CGRectMake((kDeviceWidth-_selectImage.size.width)/2, kTopHeight,_selectImage.size.width ,_selectImage.size.height)];
        _imageCropper.hidden = YES;
        [_imageCropper setImage:_selectImage];
        [_imageCropper setCropRegionRect:CGRectMake((_selectImage.size.width-100)/2, 50,100 , 100)];
        //    _imageCropper.imageView.center = _imageCropper.center;
        _imageCropper.tag = 22;
        [self.view addSubview:_imageCropper];
    }
   
    
}
//点
-(void)creatDrawLineCropImageView
{
    if (_drawLineCropImageView == nil) {
      
        _drawLineCropImageView = [[DrawLineCropImageView alloc] initWithFrame:
                                  CGRectMake((kDeviceWidth-_selectImage.size.width)/2, kTopHeight,_selectImage.size.width ,_selectImage.size.height)];
        _drawLineCropImageView.Image =_selectImage;
        _drawLineCropImageView.hidden = YES;
        _drawLineCropImageView.tag = 33;
        
        [self.view addSubview:_drawLineCropImageView];
    }
   
    
}

-(void)requestWXPicShear
{
    [[HttpRequest shareRequst] httpRequestGetWXPicShearFilterWithDic:nil success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                
                    for (NSDictionary *dic in data)
                    {
                        
                        ShearModelMapping* shearModelMapping = [JsonToModel objectFromDictionary:dic className:@"ShearModelMapping"];
                        [_dataarray addObject:shearModelMapping];
                    }
             
                [self addmakeBottombuttonwithshearmodelArray:_dataarray];
                
            }
        }
    } fail:^(NSString *errorMsg) {
        
    }];

}
-(void)dealloc{
    
    NSLog(@"MakeViewController---dealloc");
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)imageByimageClickevent
{
    _selectmark = @"1";
    _scrollView.hidden = NO;
    _removePointButton.hidden = YES;
    _drawLineCropImageView.hidden = YES;
    _imageCropper.hidden = YES;
    

    
}

- (void)lineboxClickevent
{
    _selectmark = @"2";
        _scrollView.hidden = YES;
    _removePointButton.hidden = YES;
    _gesturesImageView.hidden = YES;
    
    _drawLineCropImageView.hidden = YES;
    _imageCropper.hidden = NO;
}

- (void)pointImageClickevent
{
    _selectmark = @"3";
    _scrollView.hidden = YES;
    _removePointButton.hidden = NO;
    _gesturesImageView.hidden = YES;
    

    _drawLineCropImageView.hidden = NO;
    _imageCropper.hidden = YES;
}

- (IBAction)removePointViewClickevent:(id)sender {
    
    [_drawLineCropImageView removePoint];
}

- (IBAction)leftBarButtonItemClickevent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonItemClickevent:(id)sender {
    
    _rightBarBtnItem.enabled = NO;
    switch (_selectmark.intValue) {
        case 1:
        {
            
            if (_shearModelMapping == nil) {
                //add by miao 11.13
                if (_shear1Path == nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请添加下方抠图模板" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    return;
                   
                }else{
                    NSLog(@"二次进入---%@",_shear1Path);
                }
                
            }else{
            
                _shear1Path = _shearModelMapping.path;
            }

         
         //p是原图的相对路径path x、y是抠图模板的中心坐标 w是抠图模板宽 iw是原图的宽
            
//            NSString *base64Imagepath = result;
//            //            [_shear1Path base64EncodedString];
            NSData *data = [_shear1Path dataUsingEncoding:NSUTF8StringEncoding];
          
            NSString *base64Imagepath =[ASIHTTPRequest base64forData:data];
            [_sourceDic setObject:base64Imagepath forKey:@"p"];
            //目标加载到self.view上情况
            NSLog(@"_selectImage.size.width --%f",_selectImage.size.width);
//
            [_sourceDic setObject:[NSNumber numberWithInt:_gesturesImageView.center.x-(kDeviceWidth-_selectImage.size.width)/2] forKey:@"x"];
            [_sourceDic setObject:[NSNumber numberWithInt:_gesturesImageView.center.y-kTopHeight] forKey:@"y"];
            [_sourceDic setObject:[NSNumber numberWithInt:_gesturesImageView.frame.size.width] forKey:@"w"];
            [_sourceDic setObject:[NSNumber numberWithInt:_topBackImageView.frame.size.width] forKey:@"iw"];//
            NSString *sourchStr =[NSString stringWithFormat:@"--MT_%@",[NSString stringByJson:_sourceDic]];
            
           NSString *keyStr = [self commonCombinationPicWithsourchStr:sourchStr];
            
            NSData *modelImageData =  UIImagePNGRepresentation(_gesturesImageView.image);
            
            [[NSUserDefaults standardUserDefaults] setObject:@{SHEAR1:modelImageData,@"x":[NSNumber numberWithInt:_gesturesImageView.center.x-(kDeviceWidth-_selectImage.size.width)/2],@"y":[NSNumber numberWithInt:_gesturesImageView.center.y],@"path":_shear1Path,@"w":[NSNumber numberWithInt:_gesturesImageView.width]} forKey:keyStr] ;
        }
            break;
        case 2:
        {
         
            //w原图的宽，x1,y1矩形左上角相对原图左上角的坐标，x2,y2矩形右下角相对原图左上角的坐标
            [_source2Dic setObject:[NSNumber numberWithInt:_topBackImageView.bounds.size.width] forKey:@"w"];//原图宽
            [_source2Dic setObject:[NSNumber numberWithInt:_imageCropper.cropView.leftTopCorner.center.x] forKey:@"x1"];
            [_source2Dic setObject:[NSNumber numberWithInt:_imageCropper.cropView.leftTopCorner.center.y] forKey:@"y1"];
            [_source2Dic setObject:[NSNumber numberWithInt:_imageCropper.cropView.rightBottomCorner.center.x] forKey:@"x2"];
            [_source2Dic setObject:[NSNumber numberWithInt:_imageCropper.cropView.rightBottomCorner.center.y] forKey:@"y2"];
    
            NSString *sourchStr =[NSString stringWithFormat:@"--MT_%@",[NSString stringByJson:_source2Dic]];
           NSString *keyStr = [self commonCombinationPicWithsourchStr:sourchStr];
            
            CGRect rect = CGRectMake(_imageCropper.cropView.leftTopCorner.center.x, _imageCropper.cropView.leftTopCorner.center.y, _imageCropper.cropView.rightTopCorner.center.x -_imageCropper.cropView.leftTopCorner.center.x, _imageCropper.cropView.leftBottomCorner.center.y-_imageCropper.cropView.leftTopCorner.center.y);
           
             [[NSUserDefaults standardUserDefaults] setObject:@{SHEAR2:NSStringFromCGRect(rect)} forKey:keyStr] ;
            
          
            
        }
            break;
        case 3:{
            
            if (_drawLineCropImageView.pointsArray == nil || _drawLineCropImageView.pointsArray.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请添加切割点" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }

         
            for (NSValue *pointvalue in _drawLineCropImageView.pointsArray) {
                CGPoint point = pointvalue.CGPointValue;
                NSLog(@"得到点线截取坐标(%f,%f)",
                      point.x,
                      point.y);
                NSMutableDictionary *source3Dic = [NSMutableDictionary new];//点切割数据存放字典
                CGFloat backwidth = _drawLineCropImageView.frame.size.width;
                CGFloat backheight = _drawLineCropImageView.frame.size.height;
                CGFloat percentageX = point.x/backwidth;
                CGFloat percentageY = point.y/backheight;
                //得到点坐标百分比 x、y是各个点的相对长宽的百分比
                [source3Dic setObject:[NSNumber numberWithFloat:percentageX] forKey:@"x"];
                [source3Dic setObject:[NSNumber numberWithFloat:percentageY] forKey:@"y"];
               
                [_source3Array addObject:source3Dic];
              
            }

            NSString * str=[NSString arrayAnddictoJSONDataStr:_source3Array];
            NSString *sourchStr =[NSString stringWithFormat:@"--MT_%@",str];
            
           NSString *keyStr = [self commonCombinationPicWithsourchStr:sourchStr];

            [[NSUserDefaults standardUserDefaults] setObject:@{SHEAR3:str} forKey:keyStr] ;
            
            
        }
            break;
        default:
            break;
    }
    
}

#pragma 提取相同的代码抠图
//判断三种数据
-(NSString *)commonCombinationPicWithsourchStr:(NSString *)sourchStr{
 
    NSString *pictureurl;
    NSMutableString *mainString ;
    if (_mainGesturesImageView.goodObj != nil)
    {
        pictureurl = _mainGesturesImageView.goodObj.clsPicUrl.filE_PATH;
       mainString = [self get1StitchingconversionString:pictureurl withsourchString:sourchStr];
     
//必须重新创建为了修改两张是相同图片剪裁造成的bug
        GoodObj *tmpgoodobj =[GoodObj new];
        tmpgoodobj.clsInfo = _mainGesturesImageView.goodObj.clsInfo;
        tmpgoodobj.clsPicUrl = _mainGesturesImageView.goodObj.clsPicUrl;
        tmpgoodobj.productColorMapping = _mainGesturesImageView.goodObj.productColorMapping;
        tmpgoodobj.sourceType = _mainGesturesImageView.goodObj.sourceType;
        tmpgoodobj.shearPicUrl = mainString;
   

        [self getimageUrlToimageByimageurlstr:mainString wirhsourcevo:tmpgoodobj];
        
    }else if(_mainGesturesImageView.detailMapping != nil){
        pictureurl = _mainGesturesImageView.detailMapping.productPictureUrl;
        mainString = [self get1StitchingconversionString:pictureurl withsourchString:sourchStr];
//        mainString = [[NSMutableString alloc] initWithString:[mainString substringToIndex:mainString.length-4]];
//        [mainString appendString:[NSString stringWithFormat:@"__200x200.png"]];
        NSLog(@"lastAtring-----%@",mainString);
//必须重新创建为了修改两张是相同图片剪裁造成的bug
        DetailMapping *tmpdetailMapping = [DetailMapping new];
        tmpdetailMapping.id = _mainGesturesImageView.detailMapping.id;
        tmpdetailMapping.collocationId = _mainGesturesImageView.detailMapping.collocationId;
        tmpdetailMapping.productClsId = _mainGesturesImageView.detailMapping.productClsId;
        tmpdetailMapping.productName = _mainGesturesImageView.detailMapping.productName;
        tmpdetailMapping.productCode = _mainGesturesImageView.detailMapping.productCode;
        tmpdetailMapping.colorCode = _mainGesturesImageView.detailMapping.colorCode;
        tmpdetailMapping.colorName = _mainGesturesImageView.detailMapping.colorName;
        tmpdetailMapping.productPrice = _mainGesturesImageView.detailMapping.productPrice;
        tmpdetailMapping.productPictureUrl = _mainGesturesImageView.detailMapping.productPictureUrl;
        tmpdetailMapping.sourceType = _mainGesturesImageView.detailMapping.sourceType;
        tmpdetailMapping.shearPicUrl = mainString;
        [self getimageUrlToimageByimageurlstr:mainString wirhsourcevo:tmpdetailMapping];
        
        
    }else if(_mainGesturesImageView.materialMapping != nil)
    {
        pictureurl = _mainGesturesImageView.materialMapping.pictureUrl;
        
        mainString = [self get1StitchingconversionString:pictureurl withsourchString:sourchStr];
      
        
     //必须重新创建为了修改两张是相同图片剪裁造成的bug
        MaterialMapping *tmpmaterialMapping = [MaterialMapping new];
        tmpmaterialMapping.id = _mainGesturesImageView.materialMapping.id;
        tmpmaterialMapping.pictureUrl = _mainGesturesImageView.materialMapping.pictureUrl;
        tmpmaterialMapping.sourceType = _mainGesturesImageView.materialMapping.sourceType;
        tmpmaterialMapping.shearPicUrl = mainString;
        
       
        [self getimageUrlToimageByimageurlstr:mainString wirhsourcevo:tmpmaterialMapping];
        
    }
    
    NSLog(@"mainString-----------%@",mainString);
    return mainString;

}

-(NSMutableString *)get1StitchingconversionString:(NSString *)pictureurl withsourchString:(NSString *)sourchStr{
//    //解决脏数据造成的问题
//    if (pictureurl == nil || [pictureurl isEqualToString:@""]) {
//        pictureurl = _mainGesturesImageView.imageurl;
//    }
//    
    NSMutableString *mainString;
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:pictureurl];
    NSRange range = [String1 rangeOfString:@"--"];
    
    int location = (int)range.location;
    int leight = (int)range.length;
    
    if (leight == 2)
    {////有--400x400
        mainString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
        [mainString appendString:[NSString stringWithFormat:@"%@.png",sourchStr]];
        
        
    }else
    {//没有--400x400
        NSRange range = [String1 rangeOfString:@".png"];
        
        int leight = (int)range.length;
        if (leight == 4)//有后缀.png
        {
            mainString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:pictureurl.length-4]];
            [mainString appendString:[NSString stringWithFormat:@"%@.png",sourchStr]];
        }else
        {//没有后缀.png
            //后缀jpg
            NSRange range2 = [String1 rangeOfString:@".jpg"];
            int location2 = (int)range2.location;
            int leight2 = (int)range2.length;
            if (leight2 == 4)
            {//有后缀.jpg
                
                mainString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
                //                            mainString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:pictureurl.length-4]];
                [mainString appendString:[NSString stringWithFormat:@"%@.png",sourchStr]];
            }else
            {//没有后缀
                
                mainString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:pictureurl.length]];
                [mainString appendString:[NSString stringWithFormat:@"%@.png",sourchStr]];
                
            }
        }
        
        
    }

    return mainString;

}
-(void)setLastWidth:(int)lastWidth{
    _lastWidth = lastWidth;

}
-(void)setLastHeight:(int)lastHeight{
    _lastHeight = lastHeight;
}
-(void)getimageUrlToimageByimageurlstr:(NSString *)mainString wirhsourcevo:(id) sender{

    [self.view makeToastActivity];

    NSMutableString *lastString = [[NSMutableString alloc] initWithString:[mainString substringToIndex:mainString.length-4]];
    [lastString appendString:[NSString stringWithFormat:@"__%dx%d.png",_lastWidth,_lastHeight]];
    NSLog(@"mainString-------------%@----lastString%@",mainString,lastString);
    
  

    
    UIImageFromURL([NSURL URLWithString:[lastString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], ^(UIImage *image) {
        [self.view hideToastActivity];
        if (_myblock) {
            _myblock(sender,image);
              _rightBarBtnItem.enabled = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }

    }, ^{
        _rightBarBtnItem.enabled = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"图片合成错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    });
    
}
-(void)makeViewVCSourceVoBlockWithsourceVO:(MakeViewVCSourceVoBlock) block{
    _myblock = block;

}




















/*******************************暂时不用*******************************/
- (void)loadImage:(id)sender {
    
    NSURL *url = [NSURL URLWithString:sender];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"]; //设置请求方式
    [request setTimeoutInterval:60];//设置超时时间
    self.mutableData = [[NSMutableData alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:self];//发送一个异步请求
    
}

#pragma mark - NSURLConnection delegate
//数据加载过程中调用,获取数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.mutableData appendData:data];
}

//数据加载完成后调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *image = [UIImage imageWithData:self.mutableData];
    _topBackImageView.image = image;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"请求网络失败:%@",error);
}











//模型剪切
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    
    
    //    CGImageRef maskRef = image.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(image.CGImage),
                                        CGImageGetHeight(image.CGImage),
                                        CGImageGetBitsPerComponent(image.CGImage),
                                        CGImageGetBitsPerPixel(image.CGImage),
                                        CGImageGetBytesPerRow(image.CGImage),
                                        CGImageGetDataProvider(image.CGImage), NULL, false);
    
    //    CGImageRef masked = CGImageCreateWithMask(image.CGImage, mask);
    return [UIImage imageWithCGImage:CGImageCreateWithMask(image.CGImage, mask)];
    
}



/*
 
 - (IBAction)saveClickevent:(id)sender
 {
 
 
 if ([_selectmark isEqualToString:@"1"])
 {
 _imageView.image = [self maskImage:[UIImage imageNamed:@"3.png"] withMask:
 _gesturesImageView.image];
 _gesturesImageView.hidden = NO;
 _gesturesImageView.userInteractionEnabled = NO;
 _imageView.frame =_gesturesImageView.frame;
 
 }
 if ([_selectmark isEqualToString:@"2"])
 {
 //得到切线坐标
 //        _imageCropper.cropView.leftTopCorner(71.420837,70.420837)
 //       _imageCropper.cropView.leftTopCorner(69.260513,171.000000)
 
 //_imageCropper.cropView.leftTopCorner.center
 //_imageCropper.cropView.leftBottomCorner
 //_imageCropper.cropView.rightTopCorner
 //_imageCropper.cropView.rightBottomCorner
 NSLog(@"_imageCropper.cropView.leftTopCorner(%f,%f)",
 _imageCropper.cropView.leftTopCorner.center.x,
 _imageCropper.cropView.leftTopCorner.center.y);
 UIImageWriteToSavedPhotosAlbum(_imageCropper.getCroppedImage, nil, nil, nil);
 }
 if ([_selectmark isEqualToString:@"3"])
 {
 
 for (NSValue *pointvalue in _drawLineCropImageView.pointsArray) {
 CGPoint point = pointvalue.CGPointValue;
 //得到点坐标
 NSLog(@"得到点线截取坐标(%f,%f)",
 point.x,
 point.y);
 
 }
 
 UIImageWriteToSavedPhotosAlbum([_drawLineCropImageView getCroppedImage], nil, nil, nil);
 }
 
 
 }

 
 - (IBAction)cameraAndphotoClickevent:(id)sender
 {
 [self creatActionSheet];
 }
 
 #pragma mark -creatActionSheet
 -(void)creatActionSheet
 {
 
 if([ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
 {
 UIActionSheet *actionSheet;
 actionSheet = [[UIActionSheet alloc] initWithTitle:nil
 delegate:self
 cancelButtonTitle:@"取消"
 destructiveButtonTitle:nil
 otherButtonTitles:@"拍照",
 @"从相册选择",nil];
 actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
 
 [actionSheet showInView:[AppDelegate shareAppdelegate].window];
 }else
 {
 
 UIAlertView *alert;
 alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持此功能" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
 [alert show];
 }
 }
 - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 if (buttonIndex == 0) {
 [self pickImageFromCamera];
 }else if(buttonIndex == 1){
 [self pickImageFromAlbum];
 
 }else{
 [self dismissViewControllerAnimated:YES completion:^{
 NSLog(@"选取相片完成");
 }];
 
 }
 
 
 }
 #pragma mark -从用户相册获取活动图片
 - (void)pickImageFromAlbum
 {
 _imagePicker = [[UIImagePickerController alloc] init];
 _imagePicker.delegate = self;
 _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
 _imagePicker.allowsEditing = YES;
 
 [self presentViewController:_imagePicker animated:YES completion:^{
 
 
 NSLog(@"系统相册调用成功");
 }];
 }
 
 
 
 #pragma mark -从摄像头获取活动图片
 - (void)pickImageFromCamera
 {
 _imagePicker = [[UIImagePickerController alloc] init];
 _imagePicker.delegate = self;
 _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
 _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
 _imagePicker.allowsEditing = YES;
 
 [self presentViewController:_imagePicker animated:YES completion:^{
 
 NSLog(@"系统相机调用成功");
 }];
 }
 #pragma mark -imagePickerdelegate
 - (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
 {
 UIImage *image1= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
 UIImage *  image = [self imageWithImageSimple:image1 scaledToSize:CGSizeMake(320, 280)];
 if ([_selectmark isEqualToString:@"1"]) {
 _imageView.image = image;
 }
 if ([_selectmark isEqualToString:@"2"]) {
 if (_imageCropper != nil) {
 [_imageCropper removeFromSuperview];
 _imageCropper = nil;
 }
 _imageCropper = [[NLImageCropperView alloc] initWithFrame:
 CGRectMake(0, 100, self.view.bounds.size.width,
 self.view.bounds.size.height-200)];
 
 _imageCropper.hidden = NO;
 [_imageCropper setImage:image];
 [_imageCropper setCropRegionRect:CGRectMake(20, 20,_imageCropper.bounds.size.width/2 ,_imageCropper.bounds.size.height/2)];
 
 [self.view addSubview:_imageCropper];
 }
 if ([_selectmark isEqualToString:@"3"]) {
 _drawLineCropImageView.Image =image ;
 }
 
 
 
 
 
 //    UIImage *theImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.7)];
 //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
 //    {
 //                UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);
 //    }
 //
 //    [self saveImage:theImage WithName:@"portraitImageSmall.jpg"];
 //
 [self dismissViewControllerAnimated:YES completion:^{
 [_imagePicker removeFromParentViewController];
 _imagePicker = nil;
 NSLog(@"选取相片完成");
 }];
 
 
 }
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
 {
 
 
 }
 
 - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
 {
 [self dismissViewControllerAnimated:YES completion:^{
 NSLog(@"cancle完成");
 }];
 }
 //压缩图片
 - (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
 {
 // Create a graphics image context
 UIGraphicsBeginImageContext(newSize);
 
 // Tell the old image to draw in this new context, with the desired
 // new size
 [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
 
 // Get the new image from the context
 UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
 
 // End the context
 UIGraphicsEndImageContext();
 
 // Return the new image.
 return newImage;
 }
 #pragma mark 保存图片到document
 - (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
 {
 
 NSData* imageData = UIImagePNGRepresentation(tempImage);
 
 NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
 
 NSString *imgpathnamStr = [NSString stringWithFormat:@"portraitimage"];
 NSString *savepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imgpathnamStr];
 
 NSFileManager *filesManager = [NSFileManager defaultManager];
 BOOL isDir = NO;
 
 BOOL existed = [filesManager fileExistsAtPath:savepath isDirectory:&isDir];
 
 if ( !(isDir == YES && existed == YES) )
 {
 [filesManager createDirectoryAtPath:savepath withIntermediateDirectories:YES attributes:nil error:nil];
 
 }
 
 
 NSString *imageFilePath =[savepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
 [imageData writeToFile:imageFilePath atomically:NO];
 
 //    [[NSFileManager defaultManager] removeItemAtPath:<#(NSString *)#> error:nil];
 //        NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
 //        UIImage *img = [UIImage imageWithData:imageData];
 //        self.m_SettingMainView.m_topbgdimgView.image = img;
 //        [self requestuploadimg:img];
 //    }
 }
 #pragma mark 从文档目录下获取Documents路径
 - (NSString *)documentFolderPath
 {
 return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
 }
 
 
 -(NSString *)changeStringWithurlString:(NSString *)imageurl withWidth:(int)width{
 NSMutableString *mainurlString;
 NSMutableString *String1 = [[NSMutableString alloc] initWithString:imageurl];
 NSRange range = [String1 rangeOfString:@"--"];
 
 int location = range.location;
 int leight = range.length;
 
 if (leight == 2) {////有--400x400
 mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
 [mainurlString appendString:[NSString stringWithFormat:@".png"]];
 
 
 }else{//没有--400x400 //有后缀.png
 NSRange range = [String1 rangeOfString:@".png"];
 
 int leight = range.length;
 if (leight == 4){//有后缀.png
 
 mainurlString = [[NSMutableString alloc] initWithString:String1];
 
 }else{//没有后缀png
 
 //后缀jpg
 NSRange range2 = [String1 rangeOfString:@".jpg"];
 int location2 = range2.location;
 int leight2 = range2.length;
 if (leight2 == 4){//有后缀.jpg
 
 mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
 [mainurlString appendString:[NSString stringWithFormat:@".jpg"]];
 }else{//没有后缀
 
 mainurlString = [[NSMutableString alloc] initWithString:String1];
 [mainurlString appendString:[NSString stringWithFormat:@".png"]];
 
 }
 
 
 }
 
 }
 
 [mainurlString insertString:[NSString stringWithFormat:@"--%dx%d",(int)width,(int)width] atIndex:mainurlString.length -4];
 NSLog(@"mainurlString--------%@",mainurlString);
 return mainurlString;
 }

*/
@end
