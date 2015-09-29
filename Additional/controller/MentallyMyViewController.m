//
//  MentallyMyViewController.m
//  Wefafa
//
//  Created by Miaoz on 15/4/7.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MentallyMyViewController.h"
#import "TemplateElement.h"
#import "CollocationInfo.h"
#import "PolyvoreViewController.h"
@interface MentallyMyViewController ()

@end

@implementation MentallyMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetLeftButton:nil Image:@"ion_back"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /*本地数据库时代码
     DraftVO *draftvo = _dataDraftarray[indexPath.row];
     
     if (_delegate && [_delegate respondsToSelector:@selector(callBackMyViewControllerWithDraftvo:)]) {
     [_delegate callBackMyViewControllerWithDraftvo:draftvo];
     }
     */
    
    if (collectionView.tag == 777) {
        
        if (self.isEdit == YES) {
            CollocationInfo *collocationInfo = self.dataCollocationInfoarray1[indexPath.row];
            [self requestHttpdeleteCollocationInfo:collocationInfo];
            
            return;
        }
        
        
        CollocationInfo *collocationInfo = self.dataCollocationInfoarray1[indexPath.row];
        if (collocationInfo.templateId.integerValue != -1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(callBackMyViewControllerWithServiceCollocationInfo:)]) {
                [self.delegate callBackMyViewControllerWithServiceCollocationInfo:collocationInfo];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [self performSegueWithIdentifier:@"PolyvoreViewController2" sender:collocationInfo];
        
        }
        
    }
    
    if (collectionView.tag == 888) {
        
        CollocationInfo *collocationInfo = self.dataCollocationInfoarray2[indexPath.row];
         if (collocationInfo.templateId.integerValue != -1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(callBackMyViewControllerWithServiceCollocationInfo:)]) {
            [self.delegate callBackMyViewControllerWithServiceCollocationInfo:collocationInfo];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
         }else{
         
          [self performSegueWithIdentifier:@"PolyvoreViewController2" sender:collocationInfo];
         
         }
    }
    
    if (collectionView.tag == 999) {
        
        TemplateElement *templateElement = self.datatemplateElementarray[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(callBackMyViewControllerWithServicemubantemplateElement:)]) {
            [self.delegate callBackMyViewControllerWithServicemubantemplateElement:templateElement];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


/**/
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PolyvoreViewController2"]) {
        PolyvoreViewController *vc = segue.destinationViewController;
        [vc callBackMyViewControllerWithServiceCollocationInfo:sender];
    }
}


@end
