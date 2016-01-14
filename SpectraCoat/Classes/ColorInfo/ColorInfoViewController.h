//
//  ColorInfoViewController.h
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import "FBSharedObject.h"

@interface ColorInfoViewController : UIViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate, FBShareObjectDelegate>

@property (nonatomic, assign) IBOutlet UILabel * lblTop;
@property (nonatomic, assign) IBOutlet UILabel * lbl1;
@property (nonatomic, assign) IBOutlet UILabel * lbl2;
@property (nonatomic, assign) IBOutlet UILabel * lblMessage;
@property (nonatomic, assign) IBOutlet UILabel * lbl3;
@property (nonatomic, assign) IBOutlet UIButton * btnFav;
@property (nonatomic, assign) IBOutlet UIButton * btnBuy;
@property (nonatomic, assign) IBOutlet UIButton * btnShare;
@property (nonatomic, assign) IBOutlet UIView * viewMain;
@property (nonatomic, retain) NSMutableDictionary * colorDictionary;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)buyNowButtonClick:(id)sender;
- (IBAction)favButtonClick:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
@end
