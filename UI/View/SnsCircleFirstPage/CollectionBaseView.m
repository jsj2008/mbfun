//
//  CollectionBaseView.m
//  Wefafa
//
//  Created by mac on 13-10-10.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "CollectionBaseView.h"
#import "ImageGridCell.h"
#import "AppSetting.h"
#import "WeFaFaGet.h"
#import "ASIHTTPRequest.h"

@implementation CollectionBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configView];
    }
    return self;
}
-(void)awakeFromNib
{
    [self configView];
}

-(void)configView
{
    CollectionViewCellIdentifier = @"CellViewId";
    _onDidSelectedCell=[[CommonEventHandler alloc] init];
    download_lock=[[NSCondition alloc] init];
    self.dataArray=[[NSMutableArray alloc] init];
    
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _gridView = [[PSUICollectionView alloc] initWithFrame:[self bounds] collectionViewLayout:layout];
    
    layout.scrollDirection=PSTCollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing=0; //行分割
    layout.minimumInteritemSpacing=0;//列分割
    
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.000];
    [self addSubview:_gridView];
    
    _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _actView.frame = CGRectMake((_gridView.frame.size.width-20.0)/2, (_gridView.frame.size.height-20.0)/2, 20.0f, 20.0f);
    [self stopAnimating];
    [self addSubview:_actView];
}

#pragma mark -
#pragma mark Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionViewCell *)collectionView
{
    return 1;
}

- (NSString *)formatIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"P{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    cell.label.text = [self formatIndexPath:indexPath];
    
    // load the image for this cell
    cell.image.image = [UIImage imageNamed:@"icon.png"];
    return cell;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

//- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//	NSString *identifier = nil;
//
//	if ([kind isEqualToString:PSTCollectionElementKindSectionHeader]) {
//        HeaderView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
//
//        // TODO Setup view
//        headview.titleLabel.text=@"sdf";
//        return headview;
//	} else if ([kind isEqualToString:PSTCollectionElementKindSectionFooter]) {
//		identifier = @"footer";
//        PSUICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
//        return supplementaryView;
//	}
//}

#pragma mark -
#pragma mark Collection View Delegate

- (void)collectionView:(PSTCollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Delegate cell %d : HIGHLIGHTED", indexPath.row);
}

- (void)collectionView:(PSTCollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Delegate cell %d : UNHIGHLIGHTED", indexPath.row);
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Delegate cell %d : SELECTED", indexPath.row);
    [_onDidSelectedCell fire:self eventData:indexPath];
}

- (void)collectionView:(PSTCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Delegate cell %d : DESELECTED", indexPath.row);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Check delegate: should cell %d highlight?", indexPath.row);
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"Check delegate: should cell %d be selected?", indexPath.row);
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Check delegate: should cell %d be deselected?", indexPath.row);
    return YES;
}

//////////////////////////////
-(UIImage *) getImageAsyn:(NSString *)fileID ImageCallback:(void (^)(UIImage * image,NSObject *recv_img_id))imageBlock ErrorCallback:(void (^)(void))errorBlock
{
    if (fileID.length==0)
    {
        return nil;
    }
    
    NSArray *s_url =[fileID componentsSeparatedByString:@"/"];
    BOOL isURL=NO;
    NSString *filename=fileID; //SNS数据文件
    if (s_url.count>1) //是否URL
    {
        NSString *https=[s_url[0] lowercaseString];
        if ([https isEqualToString:@"http:"] || [https isEqualToString:@"https:"])
        {
            isURL=YES;
            filename=[s_url lastObject];
            
//            NSString *filepath = [NSString stringWithFormat:@"%@/%@", [AppSetting getSNSHeadImgFilePath], filename];
//            
//            NSFileManager *fileManager = [[NSFileManager alloc] init];
//            if ([fileManager fileExistsAtPath:filepath]) {
//                NSError *removeError = nil;
//                [fileManager removeItemAtPath:filepath error:&removeError];
//            }

//            UIImage *image=nil;
//            NSData * filedata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:fileID]] ;
//            image = [[UIImage alloc] initWithData:filedata];
//            if (filedata!=nil)
//                [filedata writeToFile: filepath atomically: NO];

//            UIImage *image=nil;
//            NSURL *url = [NSURL URLWithString:fileID];
//            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
//            [request startSynchronous];
//            NSError *error = [request error];
//            if (!error) {
//                NSData *filedata=[request responseData];
//                image = [[UIImage alloc] initWithData:filedata];
//                [filedata writeToFile:filepath atomically:YES];
//            }
            
//            UIImage *image=nil;
//            NSURL *url = [NSURL URLWithString:[fileID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//            NSHTTPURLResponse *response;
//            NSError *error;
//            NSData* filedata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            if (response.statusCode == 200) {
//                image = [UIImage imageWithData:filedata];
//                [filedata writeToFile:filepath atomically:YES];
//            }
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", [AppSetting getMBCacheFilePath], filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
    {
        return [[UIImage alloc] initWithContentsOfFile:filepath];
    }
    else
    {
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                       {
                           [download_lock lock];
                           //缓存图片数据
                           UIImage *image=nil;
                           if (isURL)
                           {
                               //下载缓存图片
                               NSURL *url = [NSURL URLWithString:fileID];
                               ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
                               [request startSynchronous];
                               NSError *error = [request error];
                               if (!error) {
                                   NSData * filedata=[request responseData];
                                   if (filedata!=nil)
                                   {
                                       image = [[UIImage alloc] initWithData:filedata];
                                       [filedata writeToFile:filepath atomically:YES];
                                   }
                               }

//                               NSData * filedata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:fileID]] ;
//                               image = [[UIImage alloc] initWithData:filedata];
//                               if (filedata!=nil)
//                                   [filedata writeToFile: filepath atomically: NO];
                           }
                           else
                           {
                               NSData *filedata = [sns getImage:SNS_IMAGE_ORIGINAL ImageName:filename];
                               if (filedata!=nil)
                               {
                                   [filedata writeToFile: filepath atomically: NO];
                               }
                               
                               image = [[UIImage alloc] initWithData:filedata];
                           }
                           
                           dispatch_async( dispatch_get_main_queue(), ^(void){
                               if( image != nil )
                               {
                                   imageBlock( image,fileID );
                               } else {
                                   errorBlock();
                               }
                           });
                           [download_lock unlock];
                       });
    }
    return nil;
}

-(CGSize)contentSize
{
    PSUICollectionViewFlowLayout *layout=(PSUICollectionViewFlowLayout *)_gridView.collectionViewLayout;
    return layout.collectionViewContentSize;
}

-(void)reloadData
{
    [_gridView reloadData];
}

-(void)startAnimating
{
    [_actView setHidden:NO];
    [_actView startAnimating];
}

-(void)stopAnimating;
{
    [_actView setHidden:YES];
    [_actView stopAnimating];
}
-(PSUICollectionView *)getGridView
{
    return _gridView;
}

@end
