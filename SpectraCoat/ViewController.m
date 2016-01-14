//
//  ViewController.m
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "ViewController.h"
#import "ColorChooserVCViewController.h"
#import "CollectionViewController.h"
#import "FavouriteViewController.h"
#import "StoreViewController.h"
#import "GlobalConstant.h"
#import "ExploreViewController.h"
#import "AboutViewController.h"
#import "MBProgressHUD.h"
#import "ConfigManager.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize imagePicker, lblCamera, lblExplore, lblLibrary, splashScroll, popoverImageViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    isNextWalk = NO;
    self.navigationController.navigationBarHidden = YES;
    [lblLibrary setFont:[UIFont fontWithName:TITLE_FONT size:15]];
    [lblLibrary setTextColor:colorWithHexString(TITLE_COLOR)];
    [lblExplore setFont:[UIFont fontWithName:TITLE_FONT size:15]];
    [lblExplore setTextColor:colorWithHexString(TITLE_COLOR)];
    [lblCamera setFont:[UIFont fontWithName:TITLE_FONT size:15]];
    [lblCamera setTextColor:colorWithHexString(TITLE_COLOR)];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kShowWalkThrough]) {
        for (int i = 0; i<5; i++) {
            
            NSString * imgName ;
                imgName = [NSString stringWithFormat:@"splash_%d", i+1];
            
            
            UIImage * img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"]];
            UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
            imgView.frame = CGRectMake(768*i, 0, 768, 1004);
            imgView.contentMode = UIViewContentModeCenter;
            imgView.userInteractionEnabled = YES;
            [splashScroll addSubview:imgView];
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(removeSplash) forControlEvents:UIControlEventTouchUpInside];
            [btn setFrame:CGRectMake(300, imgView.frame.size.height - 60,  160, 50)];
            [imgView addSubview:btn];
            
            if (i==4) {
                
                UIImage * img2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dotshow" ofType:@"png"]];
                UIImageView * imgMsg = [[UIImageView alloc] initWithImage:img2];
                imgMsg.frame = CGRectMake(95, 485, 579, 43);
                imgMsg.contentMode = UIViewContentModeScaleAspectFill;
                imgMsg.userInteractionEnabled = YES;
                [imgView addSubview:imgMsg];
                
                UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn1 setImage:[UIImage imageNamed:@"get-started.png"] forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(getStarted:) forControlEvents:UIControlEventTouchUpInside];
                [btn1 setFrame:CGRectMake(210, 563 - 25,  348, 71)];
                [imgView addSubview:btn1];
                
                UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn2 setBackgroundImage:[UIImage imageNamed:@"checkbx.png"] forState:UIControlStateNormal];
                [btn2 setImage:[UIImage imageNamed:@"checkmarks.png"] forState:UIControlStateSelected];
                [btn2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [btn2 addTarget:self action:@selector(CheckBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btn2 setFrame:CGRectMake(195, 516 - 25,  32, 30)];
                [imgView addSubview:btn2];
            }
        }
        [splashScroll setContentSize:CGSizeMake(768*5, 1004)];
    }
    else
    {
        [splashScroll removeFromSuperview];
    }
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)CheckBoxClicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    isNextWalk = !isNextWalk;
    btn.selected = isNextWalk;
}

- (void) getStarted:(id)sender
{
    [UIView animateWithDuration:0.8 animations:^{
        splashScroll.alpha = 0;
    } completion:^(BOOL finished) {
        [splashScroll removeFromSuperview];
    }];
    [[NSUserDefaults standardUserDefaults] setBool:isNextWalk forKey:kShowWalkThrough];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeSplash
{
    [UIView animateWithDuration:0.8 animations:^{
        splashScroll.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)tapOnPhotoButton:(id)sender
{
    if([sender tag] == 1)
    {
        callType = LIBRARY_CALL;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
        popOver.delegate = self;
        self.popoverImageViewController = popOver;
        [self.popoverImageViewController presentPopoverFromRect:CGRectMake(264, 560, 2, 2) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        
    }
    else  if([sender tag] == 2)
    {
        
        if (isCameraAvailable()) {
            callType = CAMERA_CALL;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
            popOver.delegate = self;
            self.popoverImageViewController = popOver;
            [self.popoverImageViewController presentPopoverFromRect:CGRectMake(265, 306, 238, 140) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"There is no camera on your device. Load a picture from Gallery" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        
    }
    
}

- (IBAction)taponExploreButton:(id)sender
{
    ExploreViewController * colorChooser = [[ExploreViewController alloc] initWithNibName:@"ExploreViewController" bundle:nil];
    [self.navigationController pushViewController:colorChooser animated:YES];
    colorChooser = nil;
    
}

- (IBAction)taponCollectionButton:(id)sender
{
    CollectionViewController * colorChooser = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    [self.navigationController pushViewController:colorChooser animated:YES];
    colorChooser = nil;
    
}

- (IBAction)tapOnFavouriteButton:(id)sender
{
    callType = FAV_CALL;
    FavouriteViewController * colorChooser = [[FavouriteViewController alloc] initWithNibName:@"FavouriteViewController" bundle:nil];
    [self.navigationController pushViewController:colorChooser animated:YES];
    colorChooser = nil;
}

- (IBAction)tapOnStoreButton:(id)sender
{
    StoreViewController * storeVC = [[StoreViewController alloc] initWithNibName:@"StoreViewController" bundle:nil];
    [self.navigationController pushViewController:storeVC animated:YES];
    storeVC = nil;
}

- (IBAction)tapOnAboutButton:(id)sender
{
    AboutViewController * storeVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:storeVC animated:YES];
    storeVC = nil;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *original = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.popoverImageViewController dismissPopoverAnimated:YES];
        ColorChooserVCViewController * colorChooser = [[ColorChooserVCViewController alloc] initWithNibName:@"ColorChooserVCViewController" bundle:nil];
    colorChooser.colorImage = callType == LIBRARY_CALL ? original : [self fixrotation:original];
        [self.navigationController pushViewController:colorChooser animated:YES];
        colorChooser.lblTop.text = @"PICK A COLOR";
        colorChooser = nil;
    
}

- (UIImage *)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma -mark memory Handle

- (UIImagePickerController *) imagePicker {
	if (imagePicker != nil) {
		return imagePicker;
	}
	imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.delegate = self;
	return imagePicker;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.imagePicker = nil;
}


@end
