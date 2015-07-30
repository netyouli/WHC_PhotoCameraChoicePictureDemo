//
//  ViewController.m
//  WHC_PhotoCameraChoicePictureDemo
//
//  Created by 吴海超 on 15/7/30.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*
 *  qq:712641411
 *  iOS大神qq群:460122071
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */


#import "ViewController.h"
#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "WHC_CameraVC.h"

#define kWHC_CellName     (@"WHC_PhotoListCellName")

@interface ViewController ()<WHC_ChoicePictureVCDelegate,WHC_CameraVCDelegate>

@property  (nonatomic , strong)IBOutlet UIScrollView  * imageSV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"WHC：iOS技术群 460122071";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickButton:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{//从相册选择一张
            WHC_PictureListVC  * vc = [WHC_PictureListVC new];
            vc.delegate = self;
            vc.choiceMorePicture = NO;
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
        }
            break;
        case 1:{//从相册选择多张
            WHC_PictureListVC  * vc = [WHC_PictureListVC new];
            vc.delegate = self;
            vc.choiceMorePicture = YES;
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
        }
            break;
        case 2:{//从相机选择
            WHC_CameraVC * vc = [WHC_CameraVC new];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - WHC_ChoicePictureVCDelegate
- (void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{
    for (UIView * subView in _imageSV.subviews) {
        if([subView isKindOfClass:[UIImageView class]]){
            [subView removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < photoArr.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * CGRectGetWidth(_imageSV.frame), 0, CGRectGetWidth(_imageSV.frame), CGRectGetHeight(_imageSV.frame))];
        imageView.image = photoArr[i];
        [_imageSV addSubview:imageView];
    }
    _imageSV.contentSize = CGSizeMake(photoArr.count * CGRectGetWidth(_imageSV.frame), 0);
}

#pragma mark - WHC_CameraVCDelegate
- (void)WHCCameraVC:(WHC_CameraVC *)cameraVC didSelectedPhoto:(UIImage *)photo{
    [self WHCChoicePictureVC:nil didSelectedPhotoArr:@[photo]];
}
@end
