//
//  ViewController.m
//  MosaicCamera
//
//  Created by he on 15/3/11.
//  Copyright (c) 2015年 he. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong,nonatomic) UIImage *originalImage;
@property (weak, nonatomic) IBOutlet UIButton *buttonCamera;
@property (weak, nonatomic) IBOutlet UIButton *buttonAlbum;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;


- (IBAction)buttonCamera:(UIButton *)sender;
- (IBAction)buttonAlbum:(UIButton *)sender;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;
- (BOOL) startAlbumSelectorFromViewController: (UIViewController*) controller
                                usingDelegate: (id <UIImagePickerControllerDelegate,
                                                UINavigationControllerDelegate>) delegate;
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info;
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker;

@end

@implementation ViewController

@synthesize originalImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect frameScreen = [UIScreen mainScreen].bounds;
    
    self.imageViewBackground.center = CGPointMake(frameScreen.size.width/2, frameScreen.size.height/2-60);
    self.buttonCamera.center = CGPointMake(76.0f, frameScreen.size.height/2 +160);
    self.buttonAlbum.center = CGPointMake(frameScreen.size.width - 76.0f, frameScreen.size.height/2 +160);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonCamera:(UIButton *)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];
}
- (IBAction)buttonAlbum:(UIButton *)sender {
    [self startAlbumSelectorFromViewController:self usingDelegate:self];
}

//此为启动CameraController的method
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to capture picture
    //cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    //default is image. so it is not needed
    
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController: cameraUI animated: YES completion:nil];
    return YES;
}

//此为启动相册选择的method
- (BOOL) startAlbumSelectorFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypePhotoLibrary] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays a control that allows the user to capture picture
    //cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    //default is image. so it is not needed
    
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController: cameraUI animated: YES completion:nil];
    return YES;
}


//委托函数中cancel的handler
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
    //[picker release];
    //picker指针的生命周期仅限于本method，method结束后会释放，ARC会release掉
}

//成功拍照后的handler
// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    //UIImage *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
       // editedImage = (UIImage *) [info objectForKey:
       //                            UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        /*
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        */
        
        //UIImage * finalResultUIImage = [[UIImage alloc]init];
        
        /*
        MaskFilterWithOriginalPic *maskFace = [[MaskFilterWithOriginalPic alloc]init];
        CIImage *finalResultCIImage =[maskFace detectFaceAndMask:originalImage];
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *finalResultUIImage = [[UIImage alloc]init];
        finalResultUIImage = [UIImage imageWithCGImage:[context createCGImage:finalResultCIImage fromRect:finalResultCIImage.extent]
                                                 scale:originalImage.scale
                                           orientation:originalImage.imageOrientation];
*/
        
        //NSLog(@"the original UIImage size is %@",NSStringFromCGSize(originalImage.size));
        //NSLog(@"the original left%ld , top%ld",(long)originalImage.leftCapWidth,(long)originalImage.topCapHeight);
        //NSLog(@"the final UIImage size is %@ ",NSStringFromCGSize(finalResultUIImage.size)); //我靠，这个size是没错的，看来是显示的时候出错
        //NSLog(@"the final left%ld , top%ld",(long)finalResultUIImage.leftCapWidth,(long)finalResultUIImage.topCapHeight);
        //NSLog(@"the original scale is %f",originalImage.scale);
        //NSLog(@"the final scale is %f",finalResultUIImage.scale);
        //NSLog(@"original resizing mode is %ld",originalImage.resizingMode);
        //NSLog(@"final resizing mode is %ld",finalResultUIImage.resizingMode);
        //NSLog(@"originnal traitCollectionis %@",originalImage.traitCollection);
        //NSLog(@"final traitcollection is %@",finalResultUIImage.traitCollection);
        //NSLog(@"orgin alignment is %@",NSStringFromUIEdgeInsets(originalImage.alignmentRectInsets));
        //NSLog(@"final alignment is %@", NSStringFromUIEdgeInsets(finalResultUIImage.alignmentRectInsets));
        
        
        //self.viewOfImage.contentMode = UIViewContentModeScaleAspectFit; //不用考虑imageview的问题了，就是转换出了问题
        //self.viewSecImage.contentMode = UIViewContentModeScaleAspectFit;
        //self.viewOfImage.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        //self.viewOfImage.image = originalImage;
        //CGSize tempViewSecFrame = self.viewSecImage.frame.size;
        //CGPoint tempViewSecPoint = self.viewSecImage.frame.origin;
        //[self.viewSecImage setFrame:CGRectMake(tempViewSecPoint.x, tempViewSecPoint.y, originalImage.size.width, originalImage.size.height)];
        //tempViewSecFrame.height = originalImage.size.height;
        //tempViewSecFrame.width = originalImage.size.width;
        
        //self.viewSecImage.image = finalResultUIImage;
        
        //self.viewSecImage.image=tempUIImage;
        //[self MaskFilterWithOriginalPic:originalImage];
        
        //self.viewOfImage.image=[self MaskFilterWithOriginalPic:originalImage]; //经此条测试，UIImage转CIImage再转UIImage没有问题，除了脸会变扁
        
        }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
        // Save the new image (original or edited) to the Camera Roll
        //UIImageWriteToSavedPhotosAlbum (originalImage, nil, nil , nil);
    switch (picker.sourceType) {
        case UIImagePickerControllerSourceTypeCamera:
            UIImageWriteToSavedPhotosAlbum (originalImage, nil, nil , nil);
            break;
            
        case UIImagePickerControllerSourceTypePhotoLibrary:
            break;
                
        default:
            break;
    }
    /*
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        }
    }
    */
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[picker release];
    //picker指针的生命周期仅限于本method，method结束后会释放，ARC会release掉
    /*
    if(!self.resultView)
    {
        self.resultView = [[ResultViewController alloc]init];
    }
     */
    //self.resultView = [self.storyboard instantiateViewControllerWithIdentifier:@"Result"];
    
    [self performSegueWithIdentifier:@"segueFromOriginalToResult" sender:nil];
    //self.resultView.imageResult.image = originalImage;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueFromOriginalToResult"])
    {
        ResultViewController *resultView = segue.destinationViewController;
        //resultView.imageViewInSec.image = self.originalImage;
        //[resultView getImage : self.originalImage];
        resultView.tempUIImageFromMainView = self.originalImage;
        //NSLog(@"this is self.originalImage %@",self.originalImage);
        //NSLog(@"this is self.imageview %@",self.viewOfImage.image);
        //NSLog(@"this is imageResult %@",resultView.imageViewInSec.image);
    }
}

@end
