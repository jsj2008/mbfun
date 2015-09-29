//
//  PersonalInformationCollectionView.m
//  Designer
//
//  Created by Jiang on 1/19/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "PersonalInformationCollectionView.h"
#import "PersonalInformationCollectionViewCell.h"
#import "PersonalInformationCollectionViewLayout.h"

@interface PersonalInformationCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@end

static NSString *cellIdentifier = @"personalInformationCollectionViewCellIdentifier";
@implementation PersonalInformationCollectionView

- (void)awakeFromNib{
    UICollectionViewFlowLayout *layout = nil;
    if (![[self.collectionViewLayout class] isSubclassOfClass:[PersonalInformationCollectionViewLayout class]]) {
        layout = [[PersonalInformationCollectionViewLayout alloc]init];
        self.collectionViewLayout = layout;
    }else {
        layout = (PersonalInformationCollectionViewLayout*)self.collectionViewLayout;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"PersonalInformationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    PersonalInformationCollectionViewLayout *layout = [[PersonalInformationCollectionViewLayout alloc]init];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PersonalInformationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

@end
