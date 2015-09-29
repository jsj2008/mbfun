//
//  DataBase.m
//  newdesigner
//
//  Created by Miaoz on 14-9-24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "DataBase.h"
#import "GesturesImageView.h"
#import "AppDelegate.h"
#import "PhotoVO.h"
#import "DraftVO.h"
#import "GesturesView.h"
#import "PhotoObj.h"
@implementation DataBase


+ (DataBase *)sharedDataBaseManager
{
    static DataBase *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//插入、更新数据photovo
- (void)addAndupdatePothVOSourceWithGesturesImageViewArray:(id)sender withGestureView:(GesturesView *)_gesturesView
{
    
    NSMutableArray *tmpdataArray = (NSMutableArray *)sender;
    GesturesImageView *tmpview = [tmpdataArray objectAtIndex:0];
    [self deletephotoVObydraftid:tmpview.draftid];

    for (int i = 0; i<tmpdataArray.count; i++) {
            GesturesImageView *view = [tmpdataArray objectAtIndex:i];
            PhotoVO *photovo=[NSEntityDescription insertNewObjectForEntityForName:@"PhotoVO" inManagedObjectContext:[AppDelegate shareAppdelegate].managedObjectContext];
            
            [photovo setValue:view.draftid forKey:@"draftid"];
            [photovo setValue:view.savetag forKey:@"savetag"];
            
            [photovo setValue:[NSString stringWithFormat:@"%d",view.gesturePosition] forKey:@"position"];
            [photovo setValue:[NSString stringWithFormat:@"%f",view.height] forKey:@"height"];
            [photovo setValue:[NSString stringWithFormat:@"%f",view.width] forKey:@"width"];
            [photovo setValue:NSStringFromCGAffineTransform(view.transform) forKey:@"transform"];
            
            //重新定义center
            CGPoint translation = [view.panGesture translationInView:_gesturesView];
            view.center = CGPointMake(view.center.x + translation.x,
                                      view.center.y + translation.y);
            NSLog(@"center %f----%f",view.center.x,view.center.y);
            [view.panGesture setTranslation:CGPointZero inView:_gesturesView];
            
            [photovo setValue:NSStringFromCGPoint(view.center) forKey:@"center"];
            [photovo setValue:[NSString stringWithFormat:@"%f",view.pinchGesturescale] forKey:@"pinchGesturescale"];
            [photovo setValue:[NSString stringWithFormat:@"%f",view.rotationGesturerotation] forKey:@"rotation"];
            //        photovo.center = NSStringFromCGPoint(view.centerpoint);
            NSLog(@"center   ---- %@",photovo.center);
//            [photovo setValue:[NSString stringWithFormat:@"%dimage",i] forKey:@"imageURL"];
            if (view.imageurl != nil) {
             [photovo setValue:view.imageurl forKey:@"imageURL"];
            }
        
            [photovo setValue:UIImageJPEGRepresentation(view.image, 1.0f) forKey:@"imageData"];
            [self saveDBmethods];
   
    }
}
//插入、更新数据photovo根据photoarray
- (void)addAndupdatePothVOSourceWithphotoArray:(id)sender
{
    
    NSArray *photodataArray =(NSArray *)sender;
    for (PhotoVO *photovo in photodataArray)
    {
        NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"PhotoVO"];
        [fetch setReturnsObjectsAsFaults:NO];
        //加入查询条件
        fetch.predicate=[NSPredicate predicateWithFormat:@"draftid==%@",[photovo valueForKey:@"draftid"]];
        NSError* error=nil;
        NSArray *mutableFetchResult=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:fetch error:&error];
        if (mutableFetchResult != nil) {
            [photovo setValue:[photovo valueForKey:@"draftid"] forKey:@"draftid"];
            [photovo setValue:[photovo valueForKey:@"savetag"] forKey:@"savetag"];
            
            [photovo setValue:[photovo valueForKey:@"position"] forKey:@"position"];
            [photovo setValue:[photovo valueForKey:@"height"] forKey:@"height"];
            [photovo setValue:[photovo valueForKey:@"width"] forKey:@"width"];
            [photovo setValue:[photovo valueForKey:@"transform"] forKey:@"transform"];
            
            
            [photovo setValue:[photovo valueForKey:@"center"] forKey:@"center"];
            [photovo setValue:[photovo valueForKey:@"pinchGesturescale"] forKey:@"pinchGesturescale"];
            [photovo setValue:[photovo valueForKey:@"rotation"] forKey:@"rotation"];
            //        photovo.center = NSStringFromCGPoint(view.centerpoint);
            NSLog(@"center   ---- %@",photovo.center);
            [photovo setValue:[photovo valueForKey:@"imageURL"] forKey:@"imageURL"];
            [photovo setValue:[photovo valueForKey:@"imageData"] forKey:@"imageData"];
        }else{
            PhotoVO *photovo=[NSEntityDescription insertNewObjectForEntityForName:@"PhotoVO" inManagedObjectContext:[AppDelegate shareAppdelegate].managedObjectContext];
            [photovo setValue:[photovo valueForKey:@"draftid"] forKey:@"draftid"];
            [photovo setValue:[photovo valueForKey:@"savetag"] forKey:@"savetag"];
            
            [photovo setValue:[photovo valueForKey:@"position"] forKey:@"position"];
            [photovo setValue:[photovo valueForKey:@"height"] forKey:@"height"];
            [photovo setValue:[photovo valueForKey:@"width"] forKey:@"width"];
            [photovo setValue:[photovo valueForKey:@"transform"] forKey:@"transform"];
            
            
            [photovo setValue:[photovo valueForKey:@"center"] forKey:@"center"];
            [photovo setValue:[photovo valueForKey:@"pinchGesturescale"] forKey:@"pinchGesturescale"];
            [photovo setValue:[photovo valueForKey:@"rotation"] forKey:@"rotation"];
            //        photovo.center = NSStringFromCGPoint(view.centerpoint);
            NSLog(@"center   ---- %@",photovo.center);
            [photovo setValue:[photovo valueForKey:@"imageURL"] forKey:@"imageURL"];
            [photovo setValue:[photovo valueForKey:@"imageData"] forKey:@"imageData"];
        
        }
            [self saveDBmethods];

    }

}


//通过draftvo添加更新
-(void)addAndUpdateDraftVO:(DraftVO *)draftvo{
    
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"DraftVO"];
    [fetch setReturnsObjectsAsFaults:NO];
    //加入查询条件
    fetch.predicate=[NSPredicate predicateWithFormat:@"draftid==%@",[draftvo valueForKey:@"draftid"]];
    NSError* error=nil;
    NSArray *mutableFetchResult=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:fetch error:&error];
    if (mutableFetchResult != nil) {
        for (DraftVO* draft in mutableFetchResult) {
            [draft setValue:[draftvo valueForKey:@"draftid"] forKey:@"draftid"];
            [draft setValue:[draftvo valueForKey:@"draftname"] forKey:@"draftname"];
            [draft setValue:[draftvo valueForKey:@"savetag"] forKey:@"savetag"];
            [draft setValue:[draftvo valueForKey:@"draftimageData"] forKey:@"draftimageData"];
        }
    }else{
        
        DraftVO* draft=(DraftVO *)[NSEntityDescription insertNewObjectForEntityForName:@"DraftVO" inManagedObjectContext:[AppDelegate shareAppdelegate].managedObjectContext];
        
        //未设置截屏imagedata
        [draft setValue:[draftvo valueForKey:@"draftid"] forKey:@"draftid"];
        [draft setValue:[draftvo valueForKey:@"draftname"] forKey:@"draftname"];
        [draft setValue:[draftvo valueForKey:@"savetag"] forKey:@"savetag"];
        [draft setValue:[draftvo valueForKey:@"draftimageData"] forKey:@"draftimageData"];
    }
    
  
    [self saveDBmethods];
    
//    [self deleteDraftVObydraftid:[draftvo valueForKey:@"draftid"]];
}
//添加或更新draftvo
-(void)addAndUpdateDraftVOwithGesturesImageView:(id)sender {
   GesturesImageView *tmpview = (GesturesImageView *)sender;
    
    [self deleteDraftVObydraftid:tmpview.draftid];
    
    DraftVO* draft=(DraftVO *)[NSEntityDescription insertNewObjectForEntityForName:@"DraftVO" inManagedObjectContext:[AppDelegate shareAppdelegate].managedObjectContext];
    //未设置截屏imagedata
    [draft setValue:tmpview.draftid forKey:@"draftid"];
    if (tmpview.draftname != nil ) {
            [draft setValue:tmpview.draftname forKey:@"draftname"];
    }
    [draft setValue:tmpview.savetag forKey:@"savetag"];
    if (tmpview.jiepingImageData != nil) {
            [draft setValue:tmpview.jiepingImageData forKey:@"draftimageData"];
    }

    [self saveDBmethods];
}

////查询photovo
-(NSArray *)queryPhotoVObysavetag:(NSString *)savetag{
    
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"PhotoVO"];
    [fetch setReturnsObjectsAsFaults:NO];
    //加入查询条件
    fetch.predicate=[NSPredicate predicateWithFormat:@"savetag==%@",savetag];
    NSError* error=nil;
    NSArray *mutableFetchResult=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:fetch error:&error];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSMutableArray *array = [NSMutableArray new];
    for (PhotoVO *photovo in mutableFetchResult) {
        [array addObject:photovo];
    }
    
    NSLog(@"photovomutableFetchResult %ld",(unsigned long)mutableFetchResult.count);
    return array;
}

//查询photovo
- (NSArray *)queryPhotoArraybyDrftvo:(id)sender {
    DraftVO *drftvo = (DraftVO *)sender;
    
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"PhotoVO"];
    //加入查询条件
    fetch.predicate=[NSPredicate predicateWithFormat:@"draftid==%@",[drftvo valueForKey:@"draftid"]];
    NSError* error=nil;
    NSArray *mutableFetchResult=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:fetch error:&error];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"photovomutableFetchResult %ld",(unsigned long)mutableFetchResult.count);
    return mutableFetchResult;
}

//查询photovo根据dratvoid
- (NSArray *)queryPhotoArraybyDrftvoid:(NSString *)dratvoid {

    
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"PhotoVO"];
    //加入查询条件
    fetch.predicate=[NSPredicate predicateWithFormat:@"draftid==%@",dratvoid];
    NSError* error=nil;
    NSArray *mutableFetchResult=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:fetch error:&error];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"photovomutableFetchResult %d",(int)mutableFetchResult.count);
    return mutableFetchResult;
}
//查询全部DraftVO
- (NSArray *)queryDraftVOArray:(id)sender {
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"DraftVO"];
    //    //加入查询条件
    //    fetch.predicate=[NSPredicate predicateWithFormat:@"draftid==%@",drftvo.draftid];
    NSError* error=nil;
    NSArray *mutableFetchResult=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:fetch error:&error];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"mutableFetchResult %d",(int)mutableFetchResult.count);
    
    return mutableFetchResult;
    
    
}
//根据savetag查询DraftVO
-(NSArray *)queryDraftVObysavetag:(NSString *)savetag{
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"DraftVO"];
    //    //加入查询条件
    fetch.predicate=[NSPredicate predicateWithFormat:@"savetag==%@",savetag];
    NSError* error=nil;
    NSArray *mutableFetchResult=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:fetch error:&error];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"mutableFetchResult %d",(int)mutableFetchResult.count);
    return mutableFetchResult;
    
}


//删除根据driftid删除
- (void)deletephotoVObydraftid:(NSString *)draftid {
    
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"PhotoVO"];
    fetch.predicate = [NSPredicate predicateWithFormat:@"draftid=%@",draftid];
    NSError* error=nil;
    NSArray *mutableFetchResult=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:fetch error:&error];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"mutableFetchResult %d",(int)mutableFetchResult.count);
    for (NSManagedObject *mode in mutableFetchResult) {
        
        [[AppDelegate shareAppdelegate].managedObjectContext deleteObject:mode];
    }
    //同步数据库
    [self saveDBmethods];
}
//根据transform 删除photovo
- (void)deletephotoVObydtransform:(NSString *)transform {
    
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"PhotoVO"];
    fetch.predicate = [NSPredicate predicateWithFormat:@"transform==%@",transform];
    NSError* error=nil;
    NSArray *mutableFetchResult=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:fetch error:&error];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"mutableFetchResult %d",mutableFetchResult.count);
    for (NSManagedObject *mode in mutableFetchResult) {
        
        [[AppDelegate shareAppdelegate].managedObjectContext deleteObject:mode];
    }
    //同步数据库
    [self saveDBmethods];
}


//删除相对应的DraftVO
-(void)deleteDraftVObydraftid:(NSString *)draftid{

    NSFetchRequest *FectchRequest=[NSFetchRequest fetchRequestWithEntityName:@"DraftVO"];
    FectchRequest.predicate=[NSPredicate predicateWithFormat:@"draftid==%@",draftid];
    NSArray *arr=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:FectchRequest error:nil];
    for (NSManagedObject *obj in arr) {
        [[AppDelegate shareAppdelegate].managedObjectContext deleteObject:obj];
    }
    [self saveDBmethods];

}

//删除相对应的DraftVO根据savetag
-(void)deleteDraftVObydraftsavetag:(NSString *)savetag{
    
    NSFetchRequest *FectchRequest=[NSFetchRequest fetchRequestWithEntityName:@"DraftVO"];
    FectchRequest.predicate=[NSPredicate predicateWithFormat:@"savetag==%@",savetag];
    NSArray *arr=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:FectchRequest error:nil];
    for (NSManagedObject *obj in arr) {
        [[AppDelegate shareAppdelegate].managedObjectContext deleteObject:obj];
    }
    [self saveDBmethods];
    
}
//根据savetag 删除photovo
- (void)deletephotoVObydraftsavetag:(NSString *)savetag{

    NSFetchRequest *FectchRequest=[NSFetchRequest fetchRequestWithEntityName:@"PhotoVO"];
    FectchRequest.predicate=[NSPredicate predicateWithFormat:@"savetag==%@",savetag];
    NSArray *arr=[[AppDelegate shareAppdelegate].managedObjectContext executeFetchRequest:FectchRequest error:nil];
    for (NSManagedObject *obj in arr) {
        [[AppDelegate shareAppdelegate].managedObjectContext deleteObject:obj];
    }
    [self saveDBmethods];

}

//保存db
-(void)saveDBmethods{
    NSError* error;
    BOOL isSaveSuccess=[[AppDelegate shareAppdelegate].managedObjectContext save:nil];
    
    if (!isSaveSuccess)
    {
        NSLog(@"Error:%@",error);
    }else
    {
        NSLog(@"Save successful!");
        
    }
}
@end
