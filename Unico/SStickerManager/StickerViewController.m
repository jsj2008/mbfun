//
//  StickerViewController.m
//  StickerManager
//
//  Created by sdx on 15/4/21.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "StickerViewController.h"
#import "StickerCollectionViewCell.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "CoverEditViewController.h"

@interface StickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
//    NSArray *_list;
    UICollectionView *_collectionView;
    int _nColumnCount;
}

@end

@implementation StickerViewController
static NSString* TopicReuseIdentifier = @"StickerCellReuseIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _nColumnCount = 3;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    float viewWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    float gap = 24;
    float size = viewWidth - gap * (_nColumnCount-1);
    size /= _nColumnCount;
    //    size = (int)size;
    layout.sectionInset = UIEdgeInsetsMake(gap/2, gap/2, gap/2, gap/2);
    layout.itemSize = CGSizeMake(100,100);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView registerClass:[StickerCollectionViewCell class] forCellWithReuseIdentifier:TopicReuseIdentifier];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    
    // 暂时可以外部设置，用在文章编辑那里
    if (!_list)
    _list =@[@"doo_apple",
             @"doo_balloon",
             @"doo_bee",
             @"doo_bird",
             @"doo_bolts",
             @"doo_bow1",
             @"doo_bow2",
             @"doo_bulb",
             @"doo_bunny",
             @"doo_camera1",
             @"doo_camera2",
             @"doo_candy",
             @"doo_car",
             @"doo_coffee",
             @"doo_cup",
             @"doo_cupcake",
             @"doo_diamond",
             @"doo_doll",
             @"doo_flowers",
             @"doo_g_dance",
             @"doo_g_kiss",
             @"doo_g_love",
             @"doo_g_loveit",
             @"doo_g_magic",
             @"doo_g_meow",
             @"doo_g_party",
             @"doo_g_rad",
             @"doo_g_sweet",
             @"doo_glasses",
             @"doo_heart",
             @"doo_home",
             @"doo_kitty",
             @"doo_lips",
             @"doo_night",
             @"doo_pizza",
             @"doo_ship",
             @"doo_skull1",
             @"doo_skull2",
             @"doo_stache",
             @"doo_stormy",
             @"doo_tulips",
             @"doo_umbrella",
             @"du_beard1",
             @"du_beard2",
             @"du_beard3",
             @"du_beard4",
             @"du_beard5",
             @"du_beard6",
             @"du_bowtie",
             @"du_eyebrows1",
             @"du_eyebrows2",
             @"du_eyelashes",
             @"du_eyepatch",
             @"du_glasses1",
             @"du_glasses2",
             @"du_glasses3",
             @"du_glasses4",
             @"du_glasses5",
             @"du_glasses6",
             @"du_glasses7",
             @"du_glasses8",
             @"du_lips",
             @"du_mustache",
             @"du_mustache2",
             @"du_mustache3",
             @"du_mustache4",
             @"du_propellerhat",
             @"du_wig1",
             @"du_wig2",
             @"du_wig3",
             @"du_wig4",
             @"du_wig5",
             @"du_wig6",
             @"du_wig7",
             @"du_wig8",
             @"frame_arrows",
             @"frame_banner",
             @"frame_brushedheavy",
             @"frame_brushedthin",
             @"frame_buddingcorners",
             @"frame_circle",
             @"frame_concavecorners",
             @"frame_crisscross",
             @"frame_dashed",
             @"frame_dotted",
             @"frame_double",
             @"frame_grunge",
             @"frame_intersect",
             @"frame_photoholder",
             @"frame_scribbled",
             @"frame_shadeddouble",
             @"frame_stamp",
             @"frame_triple",
             @"frame_wavy",
             @"frame_zigzag",
             @"hand_3d_box",
             @"hand_3d_rectangle",
             @"hand_3d_triangle",
             @"hand_arrow",
             @"hand_asterisk",
             @"hand_asterisk_filled",
             @"hand_at",
             @"hand_at_filled",
             @"hand_banner",
             @"hand_banner_arched",
             @"hand_banner_arched_filled",
             @"hand_banner_filled",
             @"hand_banner_wrapped",
             @"hand_braces",
             @"hand_burst",
             @"hand_circle_w_heart",
             @"hand_curvy_brace",
             @"hand_curvy_brace_filled",
             @"hand_curvy_line",
             @"hand_curvy_line_filled",
             @"hand_dizzy",
             @"hand_flags",
             @"hand_flower",
             @"hand_flowers",
             @"hand_frame_circle",
             @"hand_frame_oval",
             @"hand_frame_rectangle",
             @"hand_frame_square",
             @"hand_hash",
             @"hand_hash_filled",
             @"hand_heart",
             @"hand_heart_filled",
             @"hand_jumble",
             @"hand_loops",
             @"hand_loops_filled",
             @"hand_money",
             @"hand_money_filled",
             @"hand_notebook_paper",
             @"hand_olive_branch",
             @"hand_olive_branch_circle",
             @"hand_olive_branch_w_circles",
             @"hand_olive_branches",
             @"hand_sun",
             @"hand_waves",
             @"hv_belt1",
             @"hv_belt2",
             @"hv_belt3",
             @"hv_bomb",
             @"hv_emblem1",
             @"hv_emblem2",
             @"hv_emblem3",
             @"hv_emblem4",
             @"hv_emblem5",
             @"hv_emblem6",
             @"hv_g_amazing",
             @"hv_g_bam",
             @"hv_g_boom",
             @"hv_g_incredible",
             @"hv_g_pow",
             @"hv_g_zap",
             @"hv_mask1",
             @"hv_mask2",
             @"hv_mask3",
             @"hv_mask4",
             @"hv_mask5",
             @"hv_mask6",
             @"hv_mask7",
             @"hv_mask8",
             @"hv_mask9",
             @"Line_Arrow",
             @"Line_Beads",
             @"Line_Bowed",
             @"Line_Brushed",
             @"Line_Chalk",
             @"Line_Dashed",
             @"Line_Diamonds",
             @"Line_Distorted",
             @"Line_Distressed",
             @"Line_Dotted",
             @"Line_Double_Line",
             @"Line_Etched",
             @"Line_Olive_Branch",
             @"Line_Wave_Large",
             @"Line_Wave_Thick",
             @"Line_Wave_Thin",
             @"Line_Zig_Zag_Large",
             @"Line_Zig_Zag_Thick",
             @"Line_Zig_Zag_Thin",
             @"man_beamazing",
             @"man_bebrave",
             @"man_behappy",
             @"man_bekind",
             @"man_cestlavie",
             @"man_dowhatyoulove",
             @"man_dream",
             @"man_dreambig",
             @"man_enjoytheride",
             @"man_fight",
             @"man_followbliss",
             @"man_forareason",
             @"man_goodwork",
             @"man_hustle",
             @"man_keepitcool",
             @"man_live",
             @"man_livewell",
             @"man_liveyourlife",
             @"man_lovesomeone",
             @"man_loveyourself",
             @"man_makeithappen",
             @"man_maketoday",
             @"man_masses",
             @"man_moment",
             @"man_nevergiveup",
             @"man_nevertoolate",
             @"man_partyhearty",
             @"man_prioritize",
             @"man_relax",
             @"man_rockon",
             @"man_seethebeauty",
             @"man_shineon",
             @"man_simplify",
             @"man_stayclassy",
             @"man_staygolden",
             @"man_stopandlisten",
             @"man_takeachance",
             @"man_takeiteasy",
             @"man_todayisgood",
             @"man_tooshort",
             @"Ribbon",
             @"Ribbon_Arrows",
             @"Ribbon_Badge",
             @"Ribbon_Badge_Line",
             @"Ribbon_Circle",
             @"Ribbon_Circle_Line",
             @"Ribbon_Egg",
             @"Ribbon_Egg_Line",
             @"Ribbon_Heart",
             @"Ribbon_Heart_Line",
             @"Ribbon_Hexagon",
             @"Ribbon_Hexagon_Line",
             @"Ribbon_Line",
             @"Ribbon_No",
             @"Ribbon_Paddles",
             @"Ribbon_Pencil",
             @"Ribbon_Perspective",
             @"Ribbon_Perspective_Line",
             @"Ribbon_Pinched",
             @"Ribbon_Pinched_Line",
             @"Ribbon_Rectangle",
             @"Ribbon_Rectangle_Line",
             @"Ribbon_Seal",
             @"Ribbon_Seal_Line",
             @"Ribbon_Shield",
             @"Ribbon_Shield_Line",
             @"Ribbon_Square",
             @"Ribbon_Square_Line",
             @"Ribbon_Squeeze_Line",
             @"Ribbon_Squeezed",
             @"Ribbon_Triangle",
             @"Ribbon_Triangle_Line",
             @"Ribbon_Wave",
             @"Ribbon_Wave_Line",
             @"Rounded_Rectangle",
             @"Rounded_Rectangle_Line",
             @"Rounded_Square",
             @"Rounded_Square_Line",
             @"Rounded_Triangle",
             @"Rounded_Triangle_Line",
             @"Saw",
             @"Saw_Line",
             @"Seal",
             @"Seal_Line",
             @"sj_ballin",
             @"sj_bffs",
             @"sj_boss",
             @"sj_comeatme",
             @"sj_coolstory",
             @"sj_fml",
             @"sj_fresh",
             @"sj_ftw",
             @"sj_haters",
             @"sj_jk",
             @"sj_lmao",
             @"sj_lol",
             @"sj_omg",
             @"sj_rofl",
             @"sj_stayfly",
             @"sj_swerve",
             @"sj_umad",
             @"sj_word",
             @"sj_wtf",
             @"sj_yo",
             @"Square",
             @"Square_Line",
             @"Star",
             @"Star_Line",
             @"Tex_Checkerboard",
             @"Tex_Diagonal_Lines",
             @"Tex_Dots",
             @"Tex_Grid",
             @"Tex_Grid_Diagonal",
             @"Tex_Hearts",
             @"Tex_Plus_Signs",
             @"Tex_Repeating_Circle",
             @"Tex_Repeating_Diamond",
             @"Tex_Repeating_Square",
             @"Tex_Repeating_Waves",
             @"Tex_Starfield",
             @"Tex_Straight_Lines",
             @"Tex_Wavy",
             @"Tex_Zig_Zag",
             @"Thought_Bubble_1",
             @"Thought_Bubble_1_Line",
             @"Thought_Bubble_2",
             @"Thought_Bubble_2_Line",
             @"Voice_Round_1",
             @"Voice_Round_1_Line",
             @"Voice_Round_2",
             @"Voice_Round_2_Line",
             @"Voice_Round_Center",
             @"Voice_Round_Center_Line",
             @"Voice_Round_Zap",
             @"Voice_Round_Zap_Line",
             @"Voice_Square_1",
             @"Voice_Square_1_Line",
             @"Voice_Square_2",
             @"Voice_Square_2_Line",
             @"Voice_Square_Centered",
             @"Voice_Square_Centered_Line",
             @"Voice_Square_Zap",
             @"Voice_Square_Zap_Line",
             ];
    
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

// #pragma mark - Navigation
//
//  In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  Get the new view controller using [segue destinationViewController].
//  Pass the selected object to the new view controller.
// }



- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_list count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    StickerCollectionViewCell* cell = (StickerCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:TopicReuseIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    UIImage *img = [UIImage imageNamed:[_list objectAtIndex:indexPath.row]];
    if (_imageColor) {
//        img = [img changeColor:_imageColor];
        // 这里是在处理文章中用到的模式，临时，最好分新类处理。
        cell.imageView.contentMode = UIViewContentModeCenter;
    }
    cell.imageView.image = img;
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return CGSizeMake(50,50);
//}

#pragma mark - collection delagate
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    
    
    NSString *info = _list[indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    _cellFrame = cell.frame;
    
    if (_selectFunc) {
        _selectFunc(info);
    }
    
}

//  no status
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
