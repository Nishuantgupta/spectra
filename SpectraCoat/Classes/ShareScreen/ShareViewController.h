//
//  ShareViewController.h
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import "FBSharedObject.h"

@interface ShareViewController : UIViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate, FBShareObjectDelegate>

@property (nonatomic, assign) IBOutlet UILabel * lblTop;
@property (nonatomic, assign) IBOutlet UILabel * lbl1;
@property (nonatomic, assign) IBOutlet UILabel * lbl2;
@property (nonatomic, assign) IBOutlet UILabel * lbl3;
@property (nonatomic, assign) IBOutlet UILabel * lbl4;
@property (nonatomic, assign) IBOutlet UILabel * lbl5;
@property (nonatomic, assign) IBOutlet UILabel * lbl6;
@property (nonatomic, assign) IBOutlet UILabel * lbl7;
@property (nonatomic, assign) IBOutlet UILabel * lbl8;
@property (nonatomic, assign) IBOutlet UIView * viewMain;
@property (nonatomic, assign) IBOutlet UIView * ViewStore;
@property (nonatomic, retain) NSMutableDictionary * colorDictionary;
@property (nonatomic, retain) NSMutableDictionary * colorDictionaryStore;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *TopviewBg;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)buyNowButtonClick:(id)sender;
- (IBAction)removeTopButtonPressed:(id)sender;
- (IBAction)colorViewTapped:(id)sender;
- (IBAction)favButtonClick:(id)sender;
@end
