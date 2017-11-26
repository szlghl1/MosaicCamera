//
//  MaskFilterWithOriginalPic.h
//  MosaicCamera
//
//  Created by 凌何 on 15/3/23.
//  Copyright (c) 2015年 he. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import CoreImage;
@interface MaskFilterWithOriginalPic : NSObject
@property (strong,nonatomic)UIImage * originalImage;
@property (strong,nonatomic)CIImage * resultImage;
- (CIImage *)detectFaceAndMask : (UIImage *)originalImage;

@end
