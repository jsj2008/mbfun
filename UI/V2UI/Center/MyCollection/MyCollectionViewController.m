//
//  MyCollectionViewController.m
//  Designer
//
//  Created by Charles on 15/1/16.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionCollectionViewCell.h"

static NSString *REUSE_CELL_ID = @"MyCollectionCollectionViewCell";

@interface MyCollectionViewController ()

@property(nonatomic,strong)NSArray *dataAry;

@property(nonatomic,weak)IBOutlet UICollectionView *collectionView;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerNib];
    self.title = @"我的收藏";
}

-(void)registerNib
{
    UINib *cellNib = [UINib nibWithNibName:REUSE_CELL_ID bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:REUSE_CELL_ID];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSE_CELL_ID forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
