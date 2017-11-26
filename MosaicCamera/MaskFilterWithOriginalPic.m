//
//  MaskFilterWithOriginalPic.m
//  MosaicCamera
//
//  Created by 凌何 on 15/3/23.
//  Copyright (c) 2015年 he. All rights reserved.
//

#import "MaskFilterWithOriginalPic.h"

@implementation MaskFilterWithOriginalPic
@synthesize originalImage,resultImage;
- (CIImage *)detectFaceAndMask : (UIImage *)originalPic
{
    //UIImage *resultPic;
    //return resultPic;
    
    /*CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
     context:nil
     options:nil];
     */
    
    //传入参数是UIImage类型，但是detector需要CIImage类型
    //CIImage *originalCIPic = originalPic.CIImage;
    self.originalImage = originalPic;
    CIImage *originalCIPic = [[CIImage alloc]init];
    if (originalPic.CGImage)
    {
        originalCIPic = [CIImage imageWithCGImage:originalPic.CGImage];
        //NSLog(@"the original CGImage,width %zu, height %zu",CGImageGetWidth(originalPic.CGImage),CGImageGetHeight(originalPic.CGImage));
        //经测试，此时的CGImage的比例是正常的
    }
    else if (originalPic.CIImage)
    {
        originalCIPic = originalPic.CIImage;
        NSLog(@"this is an CIImage");
    }
    //经测试，CIImage是nil
    else
    {
        NSLog(@"this is an error");
        return nil;
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    NSDictionary *optsForInitDetector = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:context
                                              options:optsForInitDetector];
    NSNumber *numorientation;
    switch (originalPic.imageOrientation) {
        case UIImageOrientationUp:
            numorientation=[NSNumber numberWithInt:1];
            break;
        case UIImageOrientationDown:
            numorientation=[NSNumber numberWithInt:3];
            break;
        case UIImageOrientationLeft:
            numorientation=[NSNumber numberWithInt:8];
            break;
        case UIImageOrientationRight:
            numorientation=[NSNumber numberWithInt:6];
            break;
        case UIImageOrientationUpMirrored:
            numorientation=[NSNumber numberWithInt:2];
            break;
        case UIImageOrientationDownMirrored:
            numorientation=[NSNumber numberWithInt:4];
            break;
        case UIImageOrientationLeftMirrored:
            numorientation=[NSNumber numberWithInt:5];
            break;
        case UIImageOrientationRightMirrored:
            numorientation=[NSNumber numberWithInt:7];
            break;
        default:
            break;
    }
    NSDictionary *optsForOrientation = [NSDictionary dictionaryWithObjectsAndKeys:numorientation,@"CIDetectorImageOrientation", nil];
    NSArray *faceArray = [detector featuresInImage:originalCIPic options:optsForOrientation];
    //NSArray *faceArray = [detector featuresInImage:originalCIPic options:[NSDictionary dictionaryWithObject:numorientation forKey:@"CIDetectorImageOrientation"]];
    //NSLog(@"this is numorientaion %@",numorientation);
    //NSLog(@"this is dicnumorientaion %@",optsForOrientation);
    //NSArray *faceArray = [detector featuresInImage:originalCIPic options:nil];
    
    // Create a green circle to cover the rects that are returned.
    
    CIImage *maskImage = nil;
    CGFloat maxWidth=0,maxHeight=0;
    
    for (CIFeature *f in faceArray) {
        CGFloat centerX = f.bounds.origin.x + f.bounds.size.width / 2.0;
        CGFloat centerY = f.bounds.origin.y + f.bounds.size.height / 2.0;
        CGFloat radius = (MIN(f.bounds.size.width, f.bounds.size.height) / 2);
        if (f.bounds.size.width > maxWidth) {
            maxWidth = f.bounds.size.width;
        }
        if (f.bounds.size.height > maxHeight) {
            maxHeight = f.bounds.size.height;
        }
        
        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" keysAndValues:
                                    @"inputRadius0", @(radius-1.0f),
                                    @"inputRadius1", @(radius),
                                    @"inputColor0", [CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                    //@"inputColor1", [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],//这是apple官方
                                    @"inputColor1", [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],//这是stackoverflow
                                    kCIInputCenterKey, [CIVector vectorWithX:centerX Y:centerY],
                                    nil];
        CIImage *circleImage = [radialGradient valueForKey:kCIOutputImageKey];
        if (nil == maskImage)
            maskImage = circleImage;
        else
            maskImage = [[CIFilter filterWithName:@"CIMaximumCompositing" keysAndValues:
                          kCIInputImageKey, circleImage,
                          kCIInputBackgroundImageKey, maskImage,
                          nil] valueForKey:kCIOutputImageKey];
        
        
    }
    /*
    CIFilter *mosaic = [CIFilter filterWithName:@"CIPixellate" keysAndValues:@"inputImage", originalCIPic,@"inputScale",[NSNumber numberWithFloat:fmax(originalPic.size.width,originalPic.size.height )/60],nil];
     */
    CIFilter *mosaic = [CIFilter filterWithName:@"CIPixellate" keysAndValues:@"inputImage", originalCIPic,@"inputScale",[NSNumber numberWithFloat:fmax(maxHeight,maxWidth)/10],nil];

    CIImage *mosaicImage = [mosaic valueForKey:kCIOutputImageKey];
    CIFilter *blender = [CIFilter filterWithName:@"CIBlendWithMask" keysAndValues:@"inputImage",mosaicImage,@"inputBackgroundImage",originalCIPic,@"inputMaskImage",maskImage, nil];
    CIImage *finalResultImage = [blender valueForKey:kCIOutputImageKey];
    //NSArray *testarray=[NSArray arrayWithObjects:@"this is an array",nil];//说明array自带的description是没有问题的
    //NSLog(@"this is facearray %@",faceArray);
    //NSLog(@"this is a test array OK? %@",testarray);
    // NSLog(@"this is the result pic.Width is %@. Height is %@",CGImageGet)
    self.resultImage = finalResultImage;
    return finalResultImage;
    //return mosaicImage;
    //return maskImage;
    //return originalCIPic;

}
@end
