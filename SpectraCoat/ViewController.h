//
//  ViewController.h
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <UIKit/UIKit.h>


enum
{
    FAV_CALL,
    CAMERA_CALL,
    LIBRARY_CALL
}typedef CALL_TYPE;

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    CALL_TYPE callType;
    BOOL isNextWalk;
    UIPopoverController *popoverImageViewController;
}

@property(nonatomic, retain) UIImagePickerController * imagePicker;
@property(nonatomic, retain) UIPopoverController *popoverImageViewController;
@property(nonatomic, assign) IBOutlet UILabel * lblCamera;
@property(nonatomic, assign) IBOutlet UILabel * lblLibrary;
@property(nonatomic, assign) IBOutlet UILabel * lblExplore;
@property(nonatomic, assign) IBOutlet UIScrollView * splashScroll;

- (IBAction)tapOnPhotoButton:(id)sender;
- (IBAction)taponExploreButton:(id)sender;
- (IBAction)taponCollectionButton:(id)sender;
- (IBAction)tapOnFavouriteButton:(id)sender;
- (IBAction)tapOnStoreButton:(id)sender;
- (IBAction)tapOnAboutButton:(id)sender;
- (void)tapOnGetStarted;

@end