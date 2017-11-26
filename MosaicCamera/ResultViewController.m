//
//  ResultViewController.m
//  MosaicCamera
//
//  Created by 凌何 on 15/3/22.
//  Copyright (c) 2015年 he. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()


@end

@implementation ResultViewController
@synthesize tempUIImageFromMainView,finalResultUIImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    MaskFilterWithOriginalPic *maskFace = [[MaskFilterWithOriginalPic alloc]init];
    CIImage *finalResultCIImage =[maskFace detectFaceAndMask:tempUIImageFromMainView];
    CIContext *context = [CIContext contextWithOptions:nil];
    self.finalResultUIImage = [[UIImage alloc]init];
    self.finalResultUIImage = [UIImage imageWithCGImage:[context createCGImage:finalResultCIImage fromRect:finalResultCIImage.extent]
                                             scale:tempUIImageFromMainView.scale
                                       orientation:tempUIImageFromMainView.imageOrientation];
    
    CGRect frameScreen = [UIScreen mainScreen].bounds;
    //NSLog(@"this is frameScreen %@",NSStringFromCGRect(frameScreen));
    CGFloat width = frameScreen.size.width - 32;
    CGFloat height = (frameScreen.size.height - 72)/2;
    CGRect frameOriginal = CGRectMake(16.0f, 20.0f, width, height);
    CGRect frameResult = CGRectMake(16.0f, 20.0f + height, width, height);

    //NSLog(@"this is frameResult %@",NSStringFromCGRect(frameResult));
    //NSLog(@"this is frameOriginal %@",NSStringFromCGRect(frameOriginal));
    
    self.resultImageViewInSec.frame = frameResult;
    self.originalImageViewInSec.frame = frameOriginal;
    
    //NSLog(@"this is frameResult %@",NSStringFromCGRect(self.resultImageViewInSec.frame));
    //NSLog(@"this is frameOriginal %@",NSStringFromCGRect(self.originalImageViewInSec.frame));

    self.resultImageViewInSec.contentMode = UIViewContentModeScaleAspectFit;
    self.originalImageViewInSec.contentMode = UIViewContentModeScaleAspectFit;
    self.resultImageViewInSec.image = self.finalResultUIImage;
    self.originalImageViewInSec.image = tempUIImageFromMainView;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.finalResultUIImage = nil;
    self.tempUIImageFromMainView = nil;
    self.resultImageViewInSec.image = nil;
    self.originalImageViewInSec.image = nil;
    UIAlertView *alertMemoryWarning = [[UIAlertView alloc]
                                       initWithTitle:@"内存不足"
                                       message:nil
                                       delegate:nil
                                       cancelButtonTitle:@"朕知道了"
                                       otherButtonTitles:nil, nil];
    [alertMemoryWarning show];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ButtonAbandon:(UIButton *)sender {
    self.originalImageViewInSec.image = nil;
    self.resultImageViewInSec.image = nil;
    [self performSegueWithIdentifier:@"segueFromResultToOriginal" sender:nil];
}
- (IBAction)buttonSave:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum (self.finalResultUIImage, nil, nil , nil);
    UIAlertView *alertImageSaved = [[UIAlertView alloc]
                                    initWithTitle:@"图片已保存"
                                    message:nil
                                    delegate:nil
                                    cancelButtonTitle:@"好的"
                                    otherButtonTitles:nil, nil];
    [alertImageSaved show];
    [self performSegueWithIdentifier:@"segueFromResultToOriginal" sender:nil];
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
