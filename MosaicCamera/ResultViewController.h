//
//  ResultViewController.h
//  MosaicCamera
//
//  Created by 凌何 on 15/3/22.
//  Copyright (c) 2015年 he. All rights reserved.
//

@import UIKit;
#import "MaskFilterWithOriginalPic.h"
@interface ResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *originalImageViewInSec;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageViewInSec;
@property UIImage *tempUIImageFromMainView;
@property UIImage *finalResultUIImage;
@end
