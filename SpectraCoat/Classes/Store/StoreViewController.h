//
//  StoreViewController.h
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface StoreViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic, assign) IBOutlet UILabel * lblTop;
@property (nonatomic, assign) IBOutlet UILabel * lblText;
@property (nonatomic, assign) IBOutlet UILabel * lblPhone;
@property (nonatomic, assign) IBOutlet UILabel * lblMobile;
@property (nonatomic, assign) IBOutlet UILabel * lblEmail;
@property (nonatomic, assign) IBOutlet UILabel * lblWebsite;
@property (nonatomic, assign) IBOutlet UILabel * lblTollfree;
@property (nonatomic, assign) IBOutlet UIButton * btnPhone;
@property (nonatomic, assign) IBOutlet UIButton * btnMobile;
@property (nonatomic, assign) IBOutlet UIButton * btnEmail;
@property (nonatomic, assign) IBOutlet UIButton * btnWebsite;
@property (nonatomic, assign) IBOutlet UIButton * btnTollfree;


- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)phoneButtonPressed:(id)sender;
- (IBAction)tollfreeButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)webButtonPressed:(id)sender;
- (IBAction)mapButtonPressed:(id)sender;
@end
