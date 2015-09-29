//
//  UzysAssetsPickerController.m
//  UzysAssetsPickerController
//
//  Created by Uzysjung on 2014. 2. 12..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//
#import "UzysAssetsPickerController.h"
#import "UzysAssetsViewCell.h"
#import "UzysWrapperPickerController.h"
#import "UzysGroupPickerView.h"
#import "SCRecorder.h"

#import "SUtilityTool.h"

#import "Dialog.h"


@implementation UzysCameraViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = YES;
        
        self.backgroundColor = [UIColor grayColor];//[UIColor colorWithRed:254.0/255.0 green:223.0/255.0 blue:59.0/255.0 alpha:1.0];
        
        _recorder = [SCRecorder recorder];
        _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
        _recorder.autoSetVideoOrientation = YES;
        
        _recorder.previewView = [[UIView alloc] initWithFrame:self.bounds];
        
        [self addSubview:_recorder.previewView];
        
        
        UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2.0, self.bounds.size.width/2.0)];
        imageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"Unico/camera_switch_photo.png"];
        
        [_recorder.previewView addSubview:imageView];
        
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_recorder startRunning];
        });
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(uzysCameraViewCellClick:)])
    {
        [self.delegate performSelector:@selector(uzysCameraViewCellClick:) withObject:self];
    }
}

- (void)dealloc
{
    [_recorder stopRunning];
}

@end



@interface UzysAssetsPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView  *_newBottomView;
    UIScrollView  *_bottomScrollView;
    UIButton  *_doneButton;//开始制作mv的按钮
    
    
    NSMutableArray *_selectedAssets;
    NSMutableArray *_selectedThumbnailImageViewMutableArray;
    NSMutableArray *_deleteButtonMutableArray;
}


//View
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTitleArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIView *navigationTop;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectedMedia;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (nonatomic, strong) UIButton *rightDoneButton;

@property (nonatomic, strong) UIView *noAssetView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UzysWrapperPickerController *picker;
@property (nonatomic, strong) UzysGroupPickerView *groupPicker;
//@property (nonatomic, strong) UzysGroupPickerViewController *groupPicker;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger curAssetFilterType;

- (IBAction)btnAction:(id)sender;
- (IBAction)indexDidChangeForSegmentedControl:(id)sender;

@property(assign, readwrite,nonatomic) UIStatusBarStyle backUpStatusBarStyle;

@end

@implementation UzysAssetsPickerController

#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}


- (id)init
{
    self = [super initWithNibName:@"UzysAssetsPickerController" bundle:nil];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsLibraryUpdated:) name:ALAssetsLibraryChangedNotification object:nil];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
    
    self.assetsLibrary = nil;
    self.assetsGroup = nil;
    self.assets = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.backUpStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = self.backUpStatusBarStyle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.navigationTop.frame = CGRectMake(self.navigationTop.frame.origin.x, self.navigationTop.frame.origin.y, [UIScreen mainScreen].bounds.size.width, self.navigationTop.frame.size.height);
    
    UIImageView *navigationTopImageView = [[UIImageView alloc] initWithFrame:self.navigationTop.bounds];
    
    navigationTopImageView.image = [UIImage imageNamed:@"Unico/common_navi_mixblack.png"];
    navigationTopImageView.contentMode = UIViewContentModeScaleToFill;
    [self.navigationTop insertSubview:navigationTopImageView atIndex:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnTitle.titleLabel.font = FONT_T2;//[UIFont boldSystemFontOfSize:19];
    [self.btnTitle setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    
    [self.btnClose setImage:[UIImage imageNamed:@"Unico/camera_navbar_back"] forState:UIControlStateNormal];
    
    
    self.imageViewTitleArrow.image = [UIImage imageNamed:@"Unico/btn_filter_downarrow"];
    self.imageViewTitleArrow.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewTitleArrow.frame = CGRectMake(self.imageViewTitleArrow.frame.origin.x, self.imageViewTitleArrow.frame.origin.y, 40, 40);
    
    
    self.rightDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.rightDoneButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [self.rightDoneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightDoneButton.frame = CGRectMake(UI_SCREEN_WIDTH-65, 20, 65, 44);
    
    navigationTopImageView.userInteractionEnabled = YES;
    [navigationTopImageView addSubview:self.rightDoneButton];
    self.rightDoneButton.hidden = YES;
    
    
    
    
    [self initVariable];
    [self initImagePicker];
    [self setupOneMediaTypeSelection];
    
    __weak typeof(self) weakSelf = self;
    
    /* [self setupGroup:^{
     [weakSelf.groupPicker.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
     } withSetupAsset:YES];*/
    
    
    self.title = @"加载中...";
    
    self.imageViewTitleArrow.hidden = YES;
    
    [self setupLayout];
    
    [self setupCollectionView];
    
    
    
    [self.bottomView removeFromSuperview];//去掉nib文件中的底部工具栏
    if (self.maximumNumberOfSelectionMedia > 1
        && self.mulSelectionStyle == AssetsPickerMulSelectionMakingMVStyle)//多选
    {
        _newBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 120, [UIScreen mainScreen].bounds.size.width, 120)];//新的底部视图
        _newBottomView.backgroundColor = [UIColor blackColor];
        
        _newBottomView.alpha = 1;
        
        [self.view addSubview:_newBottomView];
        
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, _newBottomView.bounds.size.width, _newBottomView.bounds.size.height - 30)];
        //_bottomScrollView.backgroundColor = [UIColor redColor];
        
        _bottomScrollView.contentSize = _bottomScrollView.bounds.size;
        
        _bottomScrollView.alwaysBounceHorizontal = YES;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        
        [_newBottomView addSubview:_bottomScrollView];
        
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = [UIFont systemFontOfSize:13];
        
        
        tipLabel.text = [NSString stringWithFormat:@"支持%d~%d张照片", (int)self.miniimumNumberOfSelectionMedia, (int)self.maximumNumberOfSelectionMedia];
        
        [_newBottomView addSubview:tipLabel];
        
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(_newBottomView.bounds.size.width-100-10, 5, 100, 30)];
        
        [_doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton setTitle:@"开始制作" forState:UIControlStateNormal];
        
        _doneButton.layer.cornerRadius = 5;
        _doneButton.layer.masksToBounds = YES;
        
        [_doneButton setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:220.0/255.0 blue:20.0/255.0 alpha:1.0]];
        
        [_newBottomView addSubview:_doneButton];
    }
    
    
    [self setupGroupPickerview];
    
    [weakSelf initNoAssetView];
    
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf asyncLoadGroupAndAllGroupCompletion:^(BOOL finished) {
            
            weakSelf.groupPicker.groups = weakSelf.groups;
            [weakSelf.groupPicker.tableView reloadData];
            
            weakSelf.imageViewTitleArrow.hidden = NO;
            
            [weakSelf.groupPicker.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            
        } groupOfSavedPhotosCompletion:^(BOOL finished) {
            
            
        } doLoadAsset:YES];
    });
}

- (void)initVariable
{
    //    self.assetsFilter = [ALAssetsFilter allPhotos];
    [self setAssetsFilter:self.assetsFilter type:1];
    self.maximumNumberOfSelection = self.maximumNumberOfSelectionPhoto;
    self.view.clipsToBounds = YES;
}
- (void)initImagePicker
{
    UzysWrapperPickerController *picker = [[UzysWrapperPickerController alloc] init];
    //    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSArray *availableMediaTypes =
        [UIImagePickerController availableMediaTypesForSourceType:
         UIImagePickerControllerSourceTypeCamera];
        NSMutableArray *mediaTypes = [NSMutableArray arrayWithArray:availableMediaTypes];
        
        if (_maximumNumberOfSelectionMedia == 0)
        {
            if (_maximumNumberOfSelectionPhoto == 0)
                [mediaTypes removeObject:@"public.image"];
            else if (_maximumNumberOfSelectionVideo == 0)
                [mediaTypes removeObject:@"public.movie"];
        }
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = mediaTypes;
    }
    self.picker = picker;
}
- (void)setupLayout
{
    UzysAppearanceConfig *appearanceConfig = [UzysAppearanceConfig sharedConfig];
    
    [self.btnCamera setImage:[UIImage Uzys_imageNamed:appearanceConfig.cameraImageName] forState:UIControlStateNormal];
    //[self.btnClose setImage:[UIImage Uzys_imageNamed:appearanceConfig.closeImageName] forState:UIControlStateNormal];
    
    self.btnDone.layer.cornerRadius = 15;
    self.btnDone.clipsToBounds = YES;
    [self.btnDone setBackgroundColor:appearanceConfig.finishSelectionButtonColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15f];
    [self.bottomView addSubview:lineView];
}

- (void)setupGroupPickerview
{
    __weak typeof(self) weakSelf = self;
    self.groupPicker = [[UzysGroupPickerView alloc] initWithGroups:self.groups];
    
    self.groupPicker.blockTouchCell = ^(NSInteger row){
        [weakSelf changeGroup:row];
    };
    
    [self.view insertSubview:self.groupPicker aboveSubview:self.bottomView];
    [self.view bringSubviewToFront:self.navigationTop];
    [self menuArrowRotate];
}
- (void)setupOneMediaTypeSelection
{
    if(_maximumNumberOfSelectionMedia > 0)
    {
        //        self.assetsFilter = [ALAssetsFilter allAssets];
        //[self setAssetsFilter:[ALAssetsFilter allAssets] type:0];
        [self setAssetsFilter:self.assetsFilter type:0];
        self.maximumNumberOfSelection = self.maximumNumberOfSelectionMedia;
        self.segmentedControl.hidden = YES;
        self.labelSelectedMedia.hidden = NO;
        if(_maximumNumberOfSelection > 1)
            self.labelSelectedMedia.text = NSLocalizedStringFromTable(@"选择素材", @"UzysAssetsPickerController", nil);
        else
            self.labelSelectedMedia.text = NSLocalizedStringFromTable(@"选择素材", @"UzysAssetsPickerController", nil);
        
    }
    else
    {
        if(_maximumNumberOfSelectionPhoto == 0)
        {
            //            self.assetsFilter = [ALAssetsFilter allVideos];
            //[self setAssetsFilter:[ALAssetsFilter allVideos] type:2];
            [self setAssetsFilter:self.assetsFilter type:2];
            self.maximumNumberOfSelection = self.maximumNumberOfSelectionVideo;
            self.segmentedControl.hidden = YES;
            self.labelSelectedMedia.hidden = NO;
            if(_maximumNumberOfSelection > 1)
                self.labelSelectedMedia.text = NSLocalizedStringFromTable(@"选择视频", @"UzysAssetsPickerController", nil);
            else
                self.labelSelectedMedia.text = NSLocalizedStringFromTable(@"选择视频", @"UzysAssetsPickerController", nil);
        }
        else if(_maximumNumberOfSelectionVideo == 0)
        {
            //            self.assetsFilter = [ALAssetsFilter allPhotos];
            //[self setAssetsFilter:[ALAssetsFilter allPhotos] type:1];
            
            [self setAssetsFilter:self.assetsFilter type:1];
            
            self.segmentedControl.selectedSegmentIndex = 0;
            self.maximumNumberOfSelection = self.maximumNumberOfSelectionPhoto;
            self.segmentedControl.hidden = YES;
            self.labelSelectedMedia.hidden = NO;
            if(_maximumNumberOfSelection >1)
                self.labelSelectedMedia.text = NSLocalizedStringFromTable(@"选择相片", @"UzysAssetsPickerController", nil);
            else
                self.labelSelectedMedia.text = NSLocalizedStringFromTable(@"选择相片", @"UzysAssetsPickerController", nil);
        }
        else
        {
            self.segmentedControl.hidden = NO;
            self.labelSelectedMedia.hidden = YES;
        }
    }
}

- (void)setupCollectionView
{
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    
    if(IS_IPHONE_6_IOS8)
    {
        layout.itemSize = kThumbnailSize_IPHONE6;
    }
    else if(IS_IPHONE_6P_IOS8)
    {
        layout.itemSize = kThumbnailSize_IPHONE6P;
    }
    else
    {
        layout.itemSize                     = kThumbnailSize;
    }
    layout.sectionInset                 = UIEdgeInsetsMake(1.0, 0, 0, 0);
    layout.minimumInteritemSpacing      = 1.0;
    layout.minimumLineSpacing           = 1.0;
    
    //self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 -48) collectionViewLayout:layout];
    
    if (self.maximumNumberOfSelectionMedia > 1
        && self.mulSelectionStyle == AssetsPickerMulSelectionMakingMVStyle)//多选
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 120) collectionViewLayout:layout];//去掉多减去的48，以让他覆盖底部工具栏
    }
    else
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:layout];//去掉多减去的48，以让他覆盖底部工具栏
    }
    
    
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[UzysAssetsViewCell class]
            forCellWithReuseIdentifier:kAssetsViewCellIdentifier];
    [self.collectionView registerClass:[UzysCameraViewCell class]
            forCellWithReuseIdentifier:@"AssetsViewCellIdentifierCamera"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.view insertSubview:self.collectionView atIndex:0];
}
#pragma mark - Property
- (void)setAssetsFilter:(ALAssetsFilter *)assetsFilter type:(NSInteger)type
{
    _assetsFilter = assetsFilter;
    _curAssetFilterType = type;
}
#pragma mark - public methods
+ (void)setUpAppearanceConfig:(UzysAppearanceConfig *)config
{
    UzysAppearanceConfig *appearanceConfig = [UzysAppearanceConfig sharedConfig];
    appearanceConfig.assetSelectedImageName = config.assetSelectedImageName;
    appearanceConfig.assetDeselectedImageName = config.assetDeselectedImageName;
    appearanceConfig.cameraImageName = config.cameraImageName;
    appearanceConfig.finishSelectionButtonColor = config.finishSelectionButtonColor;
    appearanceConfig.assetsGroupSelectedImageName = config.assetsGroupSelectedImageName;
    appearanceConfig.closeImageName = config.closeImageName;
}

- (void)changeGroup:(NSInteger)item
{
    self.assetsGroup = self.groups[item];
    [self setupAssets:nil];
    [self.groupPicker.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.groupPicker dismiss:YES];
    [self menuArrowRotate];
}
- (void)changeAssetType:(BOOL)isPhoto endBlock:(voidBlock)endBlock
{
    if(isPhoto)
    {
        self.maximumNumberOfSelection = self.maximumNumberOfSelectionPhoto;
        //        self.assetsFilter = [ALAssetsFilter allPhotos];
        [self setAssetsFilter:[ALAssetsFilter allPhotos] type:1];
        
        [self setupAssets:endBlock];
    }
    else
    {
        self.maximumNumberOfSelection = self.maximumNumberOfSelectionVideo;
        //        self.assetsFilter = [ALAssetsFilter allVideos];
        [self setAssetsFilter:[ALAssetsFilter allVideos] type:2];
        
        [self setupAssets:endBlock];
    }
}
- (void)setupGroup:(voidBlock)endblock withSetupAsset:(BOOL)doSetupAsset
{
    if (!self.assetsLibrary)
    {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    
    __weak typeof(self) weakSelf = self;
    
    ALAssetsFilter *assetsFilter = self.assetsFilter; // number of Asset 메쏘드 호출 시에 적용.
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (group != nil)
        {
            [group setAssetsFilter:assetsFilter];
            NSInteger groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
            if(groupType == ALAssetsGroupSavedPhotos)
            {
                [strongSelf.groups insertObject:group atIndex:0];
                if(doSetupAsset)
                {
                    strongSelf.assetsGroup = group;
                    [strongSelf setupAssets:nil];
                }
            }
            else
            {
                if (group.numberOfAssets > 0)
                    [strongSelf.groups addObject:group];
            }
        }
        //traverse to the end, so reload groupPicker.
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.groupPicker reloadData];
                NSUInteger selectedIndex = [weakSelf indexOfAssetGroup:weakSelf.assetsGroup inGroups:weakSelf.groups];
                if (selectedIndex != NSNotFound) {
                    [weakSelf.groupPicker.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
                if(endblock)
                    endblock();
            });
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //접근이 허락 안되었을 경우
        [strongSelf showNotAllowed];
        strongSelf.segmentedControl.enabled = NO;
        strongSelf.btnDone.enabled = NO;
        strongSelf.btnCamera.enabled = NO;
        [strongSelf setTitle:@"访问失败"];
        strongSelf.btnTitle.enabled = NO;
        
        //[strongSelf setTitle:NSLocalizedStringFromTable(@"Not Allowed", @"UzysAssetsPickerController",nil)];
        //        [self.btnTitle setTitle:NSLocalizedStringFromTable(@"Not Allowed", @"UzysAssetsPickerController",nil) forState:UIControlStateNormal];
        [strongSelf.btnTitle setImage:nil forState:UIControlStateNormal];
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}

- (void)asyncLoadGroupAndAllGroupCompletion:(void (^)(BOOL finished))allGroupCompletion  groupOfSavedPhotosCompletion:(void (^)(BOOL finished))groupOfSavedPhotosCompletion doLoadAsset:(BOOL)doLoadAsset
{
    if (!self.assetsLibrary)
    {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    if (!self.groups)
    {
        self.groups = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.groups removeAllObjects];
    }
    
    __weak typeof(self) weakSelf = self;
    
    ALAssetsFilter *assetsFilter = self.assetsFilter; // number of Asset 메쏘드 호출 시에 적용.
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (group != nil)
        {
            [group setAssetsFilter:assetsFilter];
            NSInteger groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
            if(groupType == ALAssetsGroupSavedPhotos)
            {
                [strongSelf.groups insertObject:group atIndex:0];
                if(doLoadAsset)
                {
                    strongSelf.assetsGroup = group;
                    
                    [strongSelf asyncLoadAssetsAndCompletion:^(BOOL finished) {//异步加载 相册胶卷 里面的全部照片
                        
                        if (finished)
                        {
                            strongSelf.cellAnimated = YES;
                            [strongSelf reloadData];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                strongSelf.cellAnimated = NO;
                            });
                        }
                    }];
                    
                    if (groupOfSavedPhotosCompletion != nil)
                    {
                        groupOfSavedPhotosCompletion(YES);//胶卷相册 加载完成
                    }
                }
                else
                {
                    if (groupOfSavedPhotosCompletion != nil)
                    {
                        groupOfSavedPhotosCompletion(YES);//胶卷相册 加载完成
                    }
                }
            }
            else
            {
                if (group.numberOfAssets > 0)//照片和视频数量为0的不予显示
                {
                    [strongSelf.groups addObject:group];
                }
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.groupPicker reloadData];
                NSUInteger selectedIndex = [weakSelf indexOfAssetGroup:weakSelf.assetsGroup inGroups:weakSelf.groups];
                if (selectedIndex != NSNotFound)
                {
                    [weakSelf.groupPicker.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
                if(allGroupCompletion != nil)
                {
                    allGroupCompletion(YES);
                }
            });
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //접근이 허락 안되었을 경우
        [strongSelf showNotAllowed];
        strongSelf.segmentedControl.enabled = NO;
        strongSelf.btnDone.enabled = NO;
        strongSelf.btnCamera.enabled = NO;
        [strongSelf setTitle:@"访问失败"];
        strongSelf.btnTitle.enabled = NO;
        
        if (groupOfSavedPhotosCompletion != nil)
        {
            groupOfSavedPhotosCompletion(NO);
        }
        
        if(allGroupCompletion != nil)
        {
            allGroupCompletion(NO);
        }
        
        //[strongSelf setTitle:NSLocalizedStringFromTable(@"Not Allowed", @"UzysAssetsPickerController",nil)];
        //        [self.btnTitle setTitle:NSLocalizedStringFromTable(@"Not Allowed", @"UzysAssetsPickerController",nil) forState:UIControlStateNormal];
        [strongSelf.btnTitle setImage:nil forState:UIControlStateNormal];
    };
    
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}


- (void)setupAssets:(voidBlock)successBlock
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    if(!self.assetsGroup)
    {
        self.assetsGroup = self.groups[0];
    }
    [self.assetsGroup setAssetsFilter:self.assetsFilter];
    __weak typeof(self) weakSelf = self;
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (asset)
        {
            [strongSelf.assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                strongSelf.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                strongSelf.numberOfVideos ++;
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
                if(successBlock)
                    successBlock();
            });
            
        }
    };
    [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:resultsBlock];
}

- (void)asyncLoadAssetsAndCompletion:(void (^)(BOOL finished))completion
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    if(!self.assetsGroup)
    {
        self.assetsGroup = self.groups[0];
    }
    [self.assetsGroup setAssetsFilter:self.assetsFilter];
    __weak typeof(self) weakSelf = self;
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (asset)
        {
            [strongSelf.assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                strongSelf.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                strongSelf.numberOfVideos ++;
        }
        
        else
        {
            if(completion != nil)
            {
                completion(YES);
            }
        }
    };
    [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:resultsBlock];
}


- (void)reloadData
{
    [self.collectionView reloadData];
    [self.btnDone setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.collectionView.indexPathsForSelectedItems
                            .count] forState:UIControlStateNormal];
    [self showNoAssetsIfNeeded];
}

- (void)reloadCollectionViewDataWithAnimated:(BOOL)animated
{
    self.cellAnimated = animated;
    
    [self.collectionView reloadData];
    
    [self.btnDone setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.collectionView.indexPathsForSelectedItems
                            .count] forState:UIControlStateNormal];
    
    [self showNoAssetsIfNeeded];
}



- (void)setAssetsCountWithSelectedIndexPaths:(NSArray *)indexPaths
{
    [self.btnDone setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)indexPaths.count] forState:UIControlStateNormal];
}

#pragma mark - Asset Exception View
- (void)initNoAssetView
{
    //UIView *noAssetsView    = [[UIView alloc] initWithFrame:self.collectionView.bounds];
    
    UIView *noAssetsView    = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height-200)];
    
    CGRect rect             = CGRectInset(self.collectionView.bounds, 10, 10);
    UILabel *title          = [[UILabel alloc] initWithFrame:rect];
    UILabel *message        = [[UILabel alloc] initWithFrame:rect];
    
    title.text              = @"没有照片或视频";//NSLocalizedStringFromTable(@"No Photos or Videos", @"UzysAssetsPickerController", nil);
    title.font              = [UIFont systemFontOfSize:19.0];
    title.textColor         = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    title.tag               = kTagNoAssetViewTitleLabel;
    
    message.text            = @"你可以点击相机拍摄照片或视频";//NSLocalizedStringFromTable(@"You can sync photos and videos onto your iPhone using iTunes.", @"UzysAssetsPickerController",nil);
    message.font            = [UIFont systemFontOfSize:15.0];
    message.textColor       = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    message.tag             = kTagNoAssetViewMsgLabel;
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UzysAssetPickerController.bundle/uzysAP_ico_no_image"]];
    titleImage.contentMode = UIViewContentModeCenter;
    titleImage.tag = kTagNoAssetViewImageView;
    
    [title sizeToFit];
    [message sizeToFit];
    
    title.center            = CGPointMake(noAssetsView.center.x, noAssetsView.center.y - 10 - title.frame.size.height / 2 + 40);
    message.center          = CGPointMake(noAssetsView.center.x, noAssetsView.center.y + 10 + message.frame.size.height / 2 + 20);
    titleImage.center       = CGPointMake(noAssetsView.center.x, noAssetsView.center.y - 10 - titleImage.frame.size.height /2);
    [noAssetsView addSubview:title];
    [noAssetsView addSubview:message];
    [noAssetsView addSubview:titleImage];
    
    [self.collectionView addSubview:noAssetsView];
    self.noAssetView = noAssetsView;
    self.noAssetView.hidden = YES;
}

- (void)showNotAllowed
{
    self.title              = nil;
    
    UIView *lockedView      = [[UIView alloc] initWithFrame:self.collectionView.bounds];
    UIImageView *locked     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UzysAssetPickerController.bundle/uzysAP_ico_no_access"]];
    locked.contentMode      = UIViewContentModeCenter;
    
    CGRect rect             = CGRectInset(self.collectionView.bounds, 8, 8);
    UILabel *title          = [[UILabel alloc] initWithFrame:rect];
    UILabel *message        = [[UILabel alloc] initWithFrame:rect];
    
    title.text              = @"没有访问相册权限";//NSLocalizedStringFromTable(@"This app does not have access to your photos or videos.", @"UzysAssetsPickerController",nil);
    title.font              = [UIFont boldSystemFontOfSize:17.0];
    title.textColor         = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = @"您可以在隐私设置中设置相应权限";//NSLocalizedStringFromTable(@"You can enable access in Privacy Settings.", @"UzysAssetsPickerController",nil);
    message.font            = [UIFont systemFontOfSize:14.0];
    message.textColor       = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    locked.center           = CGPointMake(lockedView.center.x, lockedView.center.y - locked.bounds.size.height /2 - 20);
    title.center            = locked.center;
    message.center          = locked.center;
    
    rect                    = title.frame;
    rect.origin.y           = locked.frame.origin.y + locked.frame.size.height + 10;
    title.frame             = rect;
    
    rect                    = message.frame;
    rect.origin.y           = title.frame.origin.y + title.frame.size.height + 5;
    message.frame           = rect;
    
    [lockedView addSubview:locked];
    [lockedView addSubview:title];
    [lockedView addSubview:message];
    [self.collectionView addSubview:lockedView];
    
    [self.imageViewTitleArrow removeFromSuperview];//隐藏标题右边的的图片
    
    
    NSURL *url=[NSURL URLWithString:@"prefs:root=Privacy"];
    
    BOOL ret = [[UIApplication sharedApplication] canOpenURL:url];
    
    if (ret)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有访问相册权限" message:@"点击\"设置\"，允许 有范 访问您的相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0)
    {
        if ([self respondsToSelector:@selector(uzysAssetsPickerControllerDidCancel:)])
        {
            [self.delegate uzysAssetsPickerControllerDidCancel:self];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        
    }
    else if (buttonIndex == 1)
    {
        NSURL *url=[NSURL URLWithString:@"prefs:root=Privacy"];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

- (void)showNoAssetsIfNeeded
{
    __weak typeof(self) weakSelf = self;
    
    voidBlock setNoImage = ^{
        UIImageView *imgView = (UIImageView *)[weakSelf.noAssetView viewWithTag:kTagNoAssetViewImageView];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = [UIImage imageNamed:@"UzysAssetPickerController.bundle/uzysAP_ico_no_image"];
        
        UILabel *title = (UILabel *)[weakSelf.noAssetView viewWithTag:kTagNoAssetViewTitleLabel];
        title.text = @"没有照片或视频";//NSLocalizedStringFromTable(@"No Photos", @"UzysAssetsPickerController",nil);
        UILabel *msg = (UILabel *)[weakSelf.noAssetView viewWithTag:kTagNoAssetViewMsgLabel];
        msg.text = @"你可以点击相机拍摄照片或视频";//;NSLocalizedStringFromTable(@"You can sync photos onto your iPhone using iTunes.",@"UzysAssetsPickerController", nil);
    };
    voidBlock setNoVideo = ^{
        UIImageView *imgView = (UIImageView *)[weakSelf.noAssetView viewWithTag:kTagNoAssetViewImageView];
        imgView.image = [UIImage imageNamed:@"UzysAssetPickerController.bundle/uzysAP_ico_no_video"];
        DLog(@"no video");
        UILabel *title = (UILabel *)[weakSelf.noAssetView viewWithTag:kTagNoAssetViewTitleLabel];
        title.text = NSLocalizedStringFromTable(@"No Videos", @"UzysAssetsPickerController",nil);
        UILabel *msg = (UILabel *)[weakSelf.noAssetView viewWithTag:kTagNoAssetViewMsgLabel];
        msg.text = NSLocalizedStringFromTable(@"You can sync videos onto your iPhone using iTunes.",@"UzysAssetsPickerController", nil);
        
    };
    
    if(self.assets.count ==0)
    {
        self.noAssetView.hidden = NO;
        if(self.segmentedControl.hidden == NO)
        {
            if(self.segmentedControl.selectedSegmentIndex ==0)
            {
                setNoImage();
            }
            else
            {
                setNoVideo();
            }
        }
        else
        {
            if(self.maximumNumberOfSelectionMedia >0)
            {
                UIImageView *imgView = (UIImageView *)[self.noAssetView viewWithTag:kTagNoAssetViewImageView];
                imgView.image = [UIImage imageNamed:@"UzysAssetPickerController.bundle/uzysAP_ico_no_image"];
                DLog(@"no media");
                UILabel *title = (UILabel *)[self.noAssetView viewWithTag:kTagNoAssetViewTitleLabel];
                title.text = NSLocalizedStringFromTable(@"No Videos", @"UzysAssetsPickerController",nil);
                UILabel *msg = (UILabel *)[self.noAssetView viewWithTag:kTagNoAssetViewMsgLabel];
                msg.text = NSLocalizedStringFromTable(@"You can sync media onto your iPhone using iTunes.",@"UzysAssetsPickerController", nil);
                
            }
            else if(self.maximumNumberOfSelectionPhoto == 0)
            {
                setNoVideo();
            }
            else if(self.maximumNumberOfSelectionVideo == 0)
            {
                setNoImage();
            }
        }
    }
    else
    {
        self.noAssetView.hidden = YES;
    }
}


#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.showCameraCell)//第一个cell显示相机cell
    {
        return self.assets.count + 1;
    }
    else
    {
        return self.assets.count;//第一个cell不显示相机cell
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierPhoto = kAssetsViewCellIdentifier;
    
    static NSString *CellIdentifierCamera = @"AssetsViewCellIdentifierCamera";
    
    
    if (self.showCameraCell)//第一个cell显示相机cell
    {
        if (indexPath.row == 0)
        {
            UzysCameraViewCell *cell = nil;
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierCamera forIndexPath:indexPath];
            cell.delegate = self;
            
            if (self.cellAnimated)
            {
                cell.alpha = 0;
                cell.layer.transform = CATransform3DMakeRotation(3.1415926, 0, 1, 0);
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    cell.alpha = 1;
                    
                    CATransform3D transform = cell.layer.transform;
                    
                    transform.m34 = -0.006;
                    
                    transform = CATransform3DRotate(transform, 3.1415926, 0, 1, 0);
                    
                    cell.layer.transform = transform;
                    
                } completion:^(BOOL finished) {
                    
                    cell.layer.transform = CATransform3DIdentity;
                }];
            }
            
            return cell;
        }
        else
        {
            UzysAssetsViewCell *cell = nil;
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierPhoto forIndexPath:indexPath];
            cell.delegate = self;
            [cell applyData:[self.assets objectAtIndex:indexPath.row-1]];
            
            if (self.cellAnimated)
            {
                cell.alpha = 0;
                cell.layer.transform = CATransform3DMakeRotation(3.1415926, 0, 1, 0);
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    cell.alpha = 1;
                    
                    CATransform3D transform = cell.layer.transform;
                    
                    transform.m34 = -0.006;
                    
                    transform = CATransform3DRotate(transform, 3.1415926, 0, 1, 0);
                    
                    cell.layer.transform = transform;
                    
                } completion:^(BOOL finished) {
                    
                    cell.layer.transform = CATransform3DIdentity;
                }];
            }
            
            return cell;
        }
    }
    else
    {
        UzysAssetsViewCell *cell = nil;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierPhoto forIndexPath:indexPath];
        cell.delegate = self;
        [cell applyData:[self.assets objectAtIndex:indexPath.row]];
        
        if (self.cellAnimated)
        {
            cell.alpha = 0;
            cell.layer.transform = CATransform3DMakeRotation(3.1415926, 0, 1, 0);
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                cell.alpha = 1;
                
                CATransform3D transform = cell.layer.transform;
                
                transform.m34 = -0.006;
                
                transform = CATransform3DRotate(transform, 3.1415926, 0, 1, 0);
                
                cell.layer.transform = transform;
                
            } completion:^(BOOL finished) {
                
                cell.layer.transform = CATransform3DIdentity;
            }];
        }
        
        return cell;
    }
}

- (void)uzysCameraViewCellClick:(UzysCameraViewCell *)cell
{
    if([self.delegate respondsToSelector:@selector(uzysAssetsPickerControllerDidPickingCamera:)])
    {
        [self.delegate uzysAssetsPickerControllerDidPickingCamera:self];
    }
}

- (void)doneButtonClick:(id)sender
{
    if ([_selectedAssets count] > self.maximumNumberOfSelectionMedia)
    {
        
    }
    else if ([_selectedAssets count] < self.miniimumNumberOfSelectionMedia)
    {
        UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 100)];
        
        tipView.backgroundColor = [UIColor blackColor];
        tipView.layer.cornerRadius = 10;
        tipView.layer.masksToBounds = YES;
        tipView.alpha = 0.9;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
        titleLabel.text = @"提示";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        
        [tipView addSubview:titleLabel];
        
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 180, 50)];
        infoLabel.text = [NSString stringWithFormat:@"请先选择%ld~%ld张照片", (long)self.miniimumNumberOfSelectionMedia, (long)self.maximumNumberOfSelectionMedia];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.font = [UIFont systemFontOfSize:15];
        infoLabel.textColor = [UIColor whiteColor];
        
        [tipView addSubview:infoLabel];
        
        
        showDialogView(tipView, YES, QFShowDialogViewAnimationFromRight, ^(BOOL finished) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                closeDialogView(QFCloseDialogViewAnimationToRight, ^(BOOL finished) {
                    
                });
                
            });
            
        });
        
        return;
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(uzysAssetsPickerController:didFinishPickingAssets:)])
        {
            [self.delegate uzysAssetsPickerController:self didFinishPickingAssets:_selectedAssets];
        }
        
        if ([self.delegate respondsToSelector:@selector(uzysAssetsPickerController: didFinishPickingAssetsWithURLArray:)])
        {
            NSMutableArray *urlMutableArray = [[NSMutableArray alloc] init];
            
            for (ALAsset *alAsset in _selectedAssets)
            {
                NSURL *url = [alAsset valueForProperty:ALAssetPropertyAssetURL];
                [urlMutableArray addObject: url];
            }
            
            [self.delegate uzysAssetsPickerController:self didFinishPickingAssetsWithURLArray:[urlMutableArray copy]];
        }
        
        [_selectedAssets removeAllObjects];
    }
}

- (void)uzysAssetsViewCellClick:(UzysAssetsViewCell *)cell
{
    if (_selectedAssets == nil)
    {
        _selectedAssets = [[NSMutableArray alloc] init];
    }
    
    if (_selectedThumbnailImageViewMutableArray == nil)
    {
        _selectedThumbnailImageViewMutableArray = [[NSMutableArray alloc] init];
    }
    
    if (_deleteButtonMutableArray == nil)
    {
        _deleteButtonMutableArray = [[NSMutableArray alloc] init];
    }
    
    
    
    if (self.maximumNumberOfSelectionMedia == 1)//单选
    {
        [_selectedAssets addObject:cell.asset];
        
        UzysAssetsPickerController *picker = (UzysAssetsPickerController *)self;
        
        if([picker.delegate respondsToSelector:@selector(uzysAssetsPickerController:didFinishPickingAssets:)])
        {
            [picker.delegate uzysAssetsPickerController:picker didFinishPickingAssets:_selectedAssets];
        }
        
        [_selectedAssets removeAllObjects];
    }
    else if (self.maximumNumberOfSelectionMedia > 1)//多选
    {
        if (self.mulSelectionStyle == AssetsPickerMulSelectionSimpleStyle)
        {
            if (cell.selected)
            {
                cell.selected = NO;
                [_selectedAssets removeObject:cell.asset];
                
                if ([_selectedAssets count] == 0)
                {
                    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        
                        self.rightDoneButton.hidden = YES;
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
                return;
            }
            else
            {
                cell.selected = YES;
            }
        }
        
        int currentSelectedNumberOfSelectionMedia = (int)[_selectedAssets count] + 1;
        
        
        
        
        if (currentSelectedNumberOfSelectionMedia > self.maximumNumberOfSelectionMedia)
        {
            
            cell.selected = NO;
            
            float sizeK = UI_SCREEN_WIDTH/750.0;
            
            
            UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360*sizeK, 200*sizeK)];
            dialogView.backgroundColor = [UIColor blackColor];
            dialogView.layer.cornerRadius = 8;
            dialogView.layer.masksToBounds = YES;
            dialogView.alpha = 1;
            
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/warning"]];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.frame = CGRectMake(158*sizeK, 40*sizeK, 44*sizeK, 44*sizeK);
            [dialogView addSubview:imageView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 114*sizeK, dialogView.frame.size.width, 26*sizeK)];
            titleLabel.text = [NSString stringWithFormat: @"最多只能选择%ld张照片", (long)self.maximumNumberOfSelectionMedia];
            titleLabel.font = FONT_t5;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor whiteColor];
            [dialogView addSubview:titleLabel];

            
            showDialogView(dialogView, YES, QFShowDialogViewAnimationFromCenter, ^(BOOL finished) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    closeDialogView(QFCloseDialogViewAnimationNone, ^(BOOL finished) {
                        
                    });
                });
            });
            return;
        }
        
        
        [_selectedAssets addObject:cell.asset];
        
        if (self.mulSelectionStyle == AssetsPickerMulSelectionSimpleStyle)
        {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.rightDoneButton.hidden = NO;
                
            } completion:^(BOOL finished) {
                
            }];

        }
        else if (self.mulSelectionStyle == AssetsPickerMulSelectionMakingMVStyle)
        {
            UIImageView  *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:cell.asset.thumbnail]];
            
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            
            float imageViewWith = _bottomScrollView.bounds.size.height - 20;
            float imageViewHeight = imageViewWith;
            
            imageView.frame = CGRectMake(10 + (currentSelectedNumberOfSelectionMedia-1) * (imageViewWith+20), _bottomScrollView.bounds.size.height - imageViewHeight, imageViewWith, imageViewHeight);
            
            [_bottomScrollView addSubview:imageView];
            
            [_selectedThumbnailImageViewMutableArray addObject:imageView];
            
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            deleteButton.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width, imageView.frame.origin.y);
            [deleteButton setImage:[UIImage imageNamed:@"Unico/deletePhoto"] forState:UIControlStateNormal];
            deleteButton.tag = currentSelectedNumberOfSelectionMedia-1;
            [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomScrollView addSubview:deleteButton];
            
            [_deleteButtonMutableArray addObject:deleteButton];
            
            
            if (currentSelectedNumberOfSelectionMedia > 0)
            {
                [_doneButton setTitle:[NSString stringWithFormat:@"开始制作(%d)", currentSelectedNumberOfSelectionMedia] forState:UIControlStateNormal];
            }
            else
            {
                [_doneButton setTitle:@"开始制作" forState:UIControlStateNormal];
            }
            
            
            
            //更新滚动视图的参数
            CGSize newContentSize = CGSizeMake(currentSelectedNumberOfSelectionMedia * (imageViewWith + 20), _bottomScrollView.bounds.size.height);
            if (newContentSize.width < _bottomScrollView.bounds.size.width)
            {
                newContentSize.width = _bottomScrollView.bounds.size.width;
                
                _bottomScrollView.contentSize = newContentSize;
                [_bottomScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else
            {
                _bottomScrollView.contentSize = newContentSize;
                [_bottomScrollView scrollRectToVisible:deleteButton.frame animated:YES];
                
            }
        }
    }
}

- (void)deleteButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    if (index >=0 && index < [_selectedAssets count])
    {
        [_selectedAssets removeObjectAtIndex:sender.tag];
        
        UIImageView *waitDeleteImageView = [_selectedThumbnailImageViewMutableArray objectAtIndex:index];
        UIButton *deleteButton = [_deleteButtonMutableArray objectAtIndex:index];
        
        [deleteButton removeFromSuperview];
        [_deleteButtonMutableArray removeObjectAtIndex:index];
        
        //重新更新tag值
        for (int i = 0; i<[_deleteButtonMutableArray count]; i++)
        {
            UIButton *deleteButton = [_deleteButtonMutableArray objectAtIndex:i];
            deleteButton.tag = i;
        }
        
        if ([_deleteButtonMutableArray count] > 0)
        {
            [_doneButton setTitle:[NSString stringWithFormat:@"开始制作(%d)", (int)[_deleteButtonMutableArray count]] forState:UIControlStateNormal];
        }
        else
        {
            [_doneButton setTitle:@"开始制作" forState:UIControlStateNormal];
        }
        
        
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            waitDeleteImageView.layer.transform = CATransform3DScale(waitDeleteImageView.layer.transform, 0.001, 0.001, 1);
            
        } completion:^(BOOL finished) {
            
            [waitDeleteImageView removeFromSuperview];
            [_selectedThumbnailImageViewMutableArray removeObjectAtIndex:index];
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                for (NSInteger i=index; i<[_selectedAssets count]; i++)
                {
                    UIImageView *imageView = [_selectedThumbnailImageViewMutableArray objectAtIndex: i];
                    imageView.center = CGPointMake(imageView.center.x - (imageView.bounds.size.width+20), imageView.center.y);
                    
                    
                    UIButton *deleteButton = [_deleteButtonMutableArray objectAtIndex:i];
                    
                    deleteButton.center = CGPointMake(deleteButton.center.x - (imageView.bounds.size.width+20), deleteButton.center.y);
                }
                
                
                
                //更新滚动视图的参数
                int currentSelectedNumberOfSelectionMedia = (int)[_deleteButtonMutableArray count];
                float imageViewWith = _bottomScrollView.bounds.size.height - 20;
                CGSize newContentSize = CGSizeMake(currentSelectedNumberOfSelectionMedia * (imageViewWith + 20), _bottomScrollView.bounds.size.height);
                if (newContentSize.width < _bottomScrollView.bounds.size.width)
                {
                    newContentSize.width = _bottomScrollView.bounds.size.width;
                    
                    _bottomScrollView.contentSize = newContentSize;
                    _bottomScrollView.contentOffset = CGPointMake(0, 0);
                }
                
            } completion:^(BOOL finished) {
                
                
            }];
        }];
        
    }
}

#pragma mark - Collection View Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return NO;
    }
    else
    {
        BOOL didExceedMaximumNumberOfSelection = [collectionView indexPathsForSelectedItems].count >= self.maximumNumberOfSelection;
        if (didExceedMaximumNumberOfSelection && self.delegate && [self.delegate respondsToSelector:@selector(uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:)]) {
            [self.delegate uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:self];
        }
        return !didExceedMaximumNumberOfSelection;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setAssetsCountWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setAssetsCountWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}


#pragma mark - Actions

- (void)finishPickingAssets
{
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
    {
        [assets addObject:[self.assets objectAtIndex:indexPath.item-1]];
    }
    
    if([assets count]>0)
    {
        UzysAssetsPickerController *picker = (UzysAssetsPickerController *)self;
        
        if([picker.delegate respondsToSelector:@selector(uzysAssetsPickerController:didFinishPickingAssets:)])
        {
            [picker.delegate uzysAssetsPickerController:picker didFinishPickingAssets:assets];
        }
    }
}
#pragma mark - Helper methods
- (NSDictionary *)queryStringToDictionaryOfNSURL:(NSURL *)url
{
    NSArray *urlComponents = [url.query componentsSeparatedByString:@"&"];
    if (urlComponents.count <= 0)
    {
        return nil;
    }
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        [queryDict setObject:pairComponents[1] forKey:pairComponents[0]];
    }
    return [queryDict copy];
}

- (NSUInteger)indexOfAssetGroup:(ALAssetsGroup *)group inGroups:(NSArray *)groups
{
    NSString *targetGroupId = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
    __block NSUInteger index = NSNotFound;
    [groups enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAssetsGroup *g = obj;
        NSString *gid = [g valueForProperty:ALAssetsGroupPropertyPersistentID];
        if ([gid isEqualToString:targetGroupId])
        {
            index = idx;
            *stop = YES;
        }
        
    }];
    return index;
}

#pragma mark - Notification

- (void)assetsLibraryUpdated:(NSNotification *)notification
{
    //recheck here
    if(![notification.name isEqualToString:ALAssetsLibraryChangedNotification])
    {
        return ;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        NSDictionary* info = [notification userInfo];
        NSSet *updatedAssets = [info objectForKey:ALAssetLibraryUpdatedAssetsKey];
        NSSet *updatedAssetGroup = [info objectForKey:ALAssetLibraryUpdatedAssetGroupsKey];
        NSSet *deletedAssetGroup = [info objectForKey:ALAssetLibraryDeletedAssetGroupsKey];
        NSSet *insertedAssetGroup = [info objectForKey:ALAssetLibraryInsertedAssetGroupsKey];
        DLog(@"-------------+");
        DLog(@"updated assets:%@", updatedAssets);
        DLog(@"updated asset group:%@", updatedAssetGroup);
        DLog(@"deleted asset group:%@", deletedAssetGroup);
        DLog(@"inserted asset group:%@", insertedAssetGroup);
        DLog(@"-------------=");
        
        if(info == nil)
        {
            //AllClear
            [strongSelf setupGroup:nil withSetupAsset:YES];
            return;
        }
        
        if(info.count == 0)
        {
            return;
        }
        
        if (deletedAssetGroup.count > 0 || insertedAssetGroup.count > 0 || updatedAssetGroup.count >0)
        {
            BOOL currentAssetsGroupIsInDeletedAssetGroup = NO;
            BOOL currentAssetsGroupIsInUpdatedAssetGroup = NO;
            NSString *currentAssetGroupId = [strongSelf.assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
            //check whether user deleted a chosen assetGroup.
            for (NSURL *groupUrl in deletedAssetGroup)
            {
                NSDictionary *queryDictionInURL = [strongSelf queryStringToDictionaryOfNSURL:groupUrl];
                if ([queryDictionInURL[@"id"] isEqualToString:currentAssetGroupId])
                {
                    currentAssetsGroupIsInDeletedAssetGroup = YES;
                    break;
                }
            }
            for (NSURL *groupUrl in updatedAssetGroup)
            {
                NSDictionary *queryDictionInURL = [strongSelf queryStringToDictionaryOfNSURL:groupUrl];
                if ([queryDictionInURL[@"id"] isEqualToString:currentAssetGroupId])
                {
                    currentAssetsGroupIsInUpdatedAssetGroup = YES;
                    break;
                }
            }
            
            if (currentAssetsGroupIsInDeletedAssetGroup || [strongSelf.assetsGroup numberOfAssets]==0)
            {
                //if user really deletes a chosen assetGroup, make it self.groups[0] to be default selected.
                [strongSelf setupGroup:^{
                    [strongSelf.groupPicker reloadData];
                    [strongSelf.groupPicker.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                } withSetupAsset:YES];
                return;
            }
            else
            {
                if(currentAssetsGroupIsInUpdatedAssetGroup)
                {
                    NSMutableArray *selectedItems = [NSMutableArray array];
                    NSArray *selectedPath = strongSelf.collectionView.indexPathsForSelectedItems;
                    
                    for (NSIndexPath *idxPath in selectedPath)
                    {
                        [selectedItems addObject:[strongSelf.assets objectAtIndex:idxPath.row]];
                    }
                    NSInteger beforeAssets = strongSelf.assets.count;
                    [strongSelf setupAssets:^{
                        for (ALAsset *item in selectedItems)
                        {
                            for(ALAsset *asset in strongSelf.assets)
                            {
                                if([[[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString] isEqualToString:[[item valueForProperty:ALAssetPropertyAssetURL] absoluteString]])
                                {
                                    NSUInteger idx = [strongSelf.assets indexOfObject:asset];
                                    NSIndexPath *newPath = [NSIndexPath indexPathForRow:idx inSection:0];
                                    [strongSelf.collectionView selectItemAtIndexPath:newPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                                }
                            }
                        }
                        [strongSelf setAssetsCountWithSelectedIndexPaths:strongSelf.collectionView.indexPathsForSelectedItems];
                        if(strongSelf.assets.count > beforeAssets)
                        {
                            [strongSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
                        }
                        
                    }];
                    [strongSelf setupGroup:^{
                        [strongSelf.groupPicker reloadData];
                    } withSetupAsset:NO];
                }
                else
                {
                    [strongSelf setupGroup:^{
                        [strongSelf.groupPicker reloadData];
                    } withSetupAsset:NO];
                    return;
                }
            }
        }
    });
}
#pragma mark - Property
- (void)setTitle:(NSString *)title
{
    //[super setTitle:title];
    
    
    //
    
    [self.btnTitle setTitle:title forState:UIControlStateNormal];
    [self.btnTitle setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [self.btnTitle setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [self.btnTitle layoutIfNeeded];
}
- (void)menuArrowRotate
{
    [self menuArrowRotateWithAnimated:NO];
}

- (void)menuArrowRotateWithAnimated:(BOOL)animated
{
    void (^animationsBlock)(void) = ^{
        
        if(self.groupPicker.isOpen)
        {
            self.imageViewTitleArrow.layer.transform = CATransform3DMakeRotation(-180/180.0 * 3.1415926, 0, 0, 1);
        }
        else
        {
            self.imageViewTitleArrow.layer.transform = CATransform3DMakeRotation(0.0/180.0 * 3.1415926, 0, 0, 1);;
        }
        
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            animationsBlock();
            
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        animationsBlock();
    }
    
}

#pragma mark - Control Action
- (IBAction)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case kTagButtonCamera:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSString *title = NSLocalizedStringFromTable(@"Error", @"UzysAssetsPickerController", nil);
                NSString *message = NSLocalizedStringFromTable(@"Device has no camera", @"UzysAssetsPickerController", nil);
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [myAlertView show];
            }
            else
            {
                __weak typeof(self) weakSelf = self;
                [self presentViewController:self.picker animated:YES completion:^{
                    __strong typeof(self) strongSelf = weakSelf;
                    //카메라 화면으로 가면 강제로 카메라 롤로 변경.
                    NSString *curGroupName =[[strongSelf.assetsGroup valueForProperty:ALAssetsGroupPropertyURL] absoluteString];
                    NSString *cameraRollName = [[strongSelf.groups[0] valueForProperty:ALAssetsGroupPropertyURL] absoluteString];
                    
                    if(![curGroupName isEqualToString:cameraRollName] )
                    {
                        strongSelf.assetsGroup = strongSelf.groups[0];
                        [strongSelf changeGroup:0];
                    }
                }];
            }
        }
            break;
        case kTagButtonClose:
        {
            if([self.delegate respondsToSelector:@selector(uzysAssetsPickerControllerDidCancel:)])
            {
                [self.delegate uzysAssetsPickerControllerDidCancel:self];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
        case kTagButtonGroupPicker:
        {
            /* dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             
             UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
             
             CGContextTranslateCTM(UIGraphicsGetCurrentContext(), CGRectGetMinX(self.view.frame), -CGRectGetMinY(self.view.frame));
             [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
             UIImage* backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             
             self.groupPicker.backgroundImage = backgroundImage;
             
             });*/
            
            [self.groupPicker toggle];
            [self menuArrowRotateWithAnimated:YES];
        }
            break;
        case kTagButtonDone:
            [self finishPickingAssets];
            break;
        default:
            break;
    }
}

- (IBAction)indexDidChangeForSegmentedControl:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    if(selectedSegment ==0)
    {
        [self changeAssetType:YES endBlock:nil];
    }
    else
    {
        [self changeAssetType:NO endBlock:nil];
    }
}
- (void)saveAssetsAction:(NSURL *)assetURL error:(NSError *)error isPhoto:(BOOL)isPhoto {
    if(error)
        return;
    __weak typeof(self) weakSelf = self;
    [self.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (asset ==nil)
            {
                return ;
            }
            if(self.curAssetFilterType == 0 || (self.curAssetFilterType ==1 && isPhoto ==YES) || (self.curAssetFilterType == 2 && isPhoto ==NO))
            {
                NSMutableArray *selectedItems = [NSMutableArray array];
                NSArray *selectedPath = self.collectionView.indexPathsForSelectedItems;
                
                for (NSIndexPath *idxPath in selectedPath)
                {
                    [selectedItems addObject:[self.assets objectAtIndex:idxPath.row]];
                }
                
                [self.assets insertObject:asset atIndex:0];
                [self reloadData];
                
                for (ALAsset *item in selectedItems)
                {
                    for(ALAsset *asset in self.assets)
                    {
                        if([[[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString] isEqualToString:[[item valueForProperty:ALAssetPropertyAssetURL] absoluteString]])
                        {
                            NSUInteger idx = [self.assets indexOfObject:asset];
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:idx inSection:0];
                            [self.collectionView selectItemAtIndexPath:newPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                        }
                    }
                }
                [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
                
                if(self.maximumNumberOfSelection > self.collectionView.indexPathsForSelectedItems.count)
                {
                    NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.collectionView selectItemAtIndexPath:newPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                }
                [self setAssetsCountWithSelectedIndexPaths:self.collectionView.indexPathsForSelectedItems];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(assetsLibraryUpdated:) name:ALAssetsLibraryChangedNotification object:nil];
            });
            
            
        });
        
    } failureBlock:^(NSError *err){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(assetsLibraryUpdated:) name:ALAssetsLibraryChangedNotification object:nil];
        });
        
    }];
}

#pragma mark - UIImagerPickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    //사진 촬영 시
    if (CFStringCompare((CFStringRef) [info objectForKey:UIImagePickerControllerMediaType], kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        if(self.segmentedControl.selectedSegmentIndex ==1 && self.segmentedControl.hidden == NO)
        {
            self.segmentedControl.selectedSegmentIndex = 0;
            [self changeAssetType:YES endBlock:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                UIImage *image = info[UIImagePickerControllerOriginalImage];
                [[NSNotificationCenter defaultCenter] removeObserver:strongSelf name:ALAssetsLibraryChangedNotification object:nil];
                [strongSelf.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:info[UIImagePickerControllerMediaMetadata] completionBlock:^(NSURL *assetURL, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self saveAssetsAction:assetURL error:error isPhoto:YES];
                    });
                    DLog(@"writeImageToSavedPhotosAlbum");
                }];
                
            }];
            
        }
        else
        {
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
            [self.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:info[UIImagePickerControllerMediaMetadata] completionBlock:^(NSURL *assetURL, NSError *error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf saveAssetsAction:assetURL error:error isPhoto:YES];
                });
                DLog(@"writeImageToSavedPhotosAlbum");
            }];
        }
    }
    else //비디오 촬영시
    {
        if(self.segmentedControl.selectedSegmentIndex ==0 && self.segmentedControl.hidden == NO)
        {
            self.segmentedControl.selectedSegmentIndex = 1;
            [self changeAssetType:NO endBlock:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                [[NSNotificationCenter defaultCenter] removeObserver:strongSelf name:ALAssetsLibraryChangedNotification object:nil];
                [strongSelf.assetsLibrary writeVideoAtPathToSavedPhotosAlbum:info[UIImagePickerControllerMediaURL] completionBlock:^(NSURL *assetURL, NSError *error) {
                    DLog(@"assetURL %@",assetURL);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self saveAssetsAction:assetURL error:error isPhoto:NO];
                    });
                }];
                
            }];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
            [self.assetsLibrary writeVideoAtPathToSavedPhotosAlbum:info[UIImagePickerControllerMediaURL] completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self saveAssetsAction:assetURL error:error isPhoto:NO];
                });
                
            }];
            
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIViewController Property

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
