//
//  StoreViewController.m
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "StoreViewController.h"

@interface StoreViewController ()

@end

@implementation StoreViewController
@synthesize lblTop,lblEmail,lblMobile,lblPhone,lblText,lblWebsite, lblTollfree, btnEmail, btnPhone, btnTollfree, btnWebsite, btnMobile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTop.font = [UIFont fontWithName:TITLE_FONT_BOLD size:30];
    lblTop.textColor = colorWithHexString(TITLE_COLOR);
    lblTop.shadowColor  = [UIColor grayColor];
    lblTop.shadowOffset =  CGSizeMake(1.0, 1.0);
    
    lblWebsite.font = [UIFont fontWithName:TITLE_FONT size:28];
    lblWebsite.textColor = colorWithHexString(TITLE_COLOR);
    lblEmail.font = [UIFont fontWithName:TITLE_FONT size:28];
    lblEmail.textColor = colorWithHexString(TITLE_COLOR);
    lblMobile.font = [UIFont fontWithName:TITLE_FONT size:28];
    lblMobile.textColor = colorWithHexString(TITLE_COLOR);
    lblPhone.font = [UIFont fontWithName:TITLE_FONT size:28];
    lblPhone.textColor = colorWithHexString(TITLE_COLOR);
    lblText.font = [UIFont fontWithName:TITLE_FONT size:28];
    lblText.textColor = colorWithHexString(TITLE_COLOR);
    lblTollfree.font = [UIFont fontWithName:TITLE_FONT size:28];
    lblTollfree.textColor = colorWithHexString(TITLE_COLOR);
    
    btnWebsite.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:28];
    btnWebsite.titleLabel.textColor = colorWithHexString(TITLE_COLOR);
    btnPhone.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:28];
    btnPhone.titleLabel.textColor = colorWithHexString(TITLE_COLOR);
    btnEmail.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:28];
    btnEmail.titleLabel.textColor = colorWithHexString(TITLE_COLOR);
    btnTollfree.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:28];
    btnTollfree.titleLabel.textColor = colorWithHexString(TITLE_COLOR);
    btnMobile.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:28];
    btnMobile.titleLabel.textColor = colorWithHexString(TITLE_COLOR);
    self.navigationController.navigationBarHidden = YES;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)shareButtonPressed:(id)sender
{
    
}

- (IBAction)phoneButtonPressed:(id)sender
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:6157767600"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:6157767600"]];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"This device does not support voice calls" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)tollfreeButtonPressed:(id)sender
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:18559769337"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:1 855 976 9337"]];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"This device does not support voice calls" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)emailButtonPressed:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"SpectraCoat Snap & Match Color – Contact"];
        [controller setToRecipients:[NSArray arrayWithObject:@"sales@powderbuythepound.com"]];
        if (controller)
            [self.navigationController presentModalViewController:controller animated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check your email settin in device setting" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)webButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.powderbuythepound.com"]];
}

- (IBAction)mapButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://maps.google.co.in/maps?q=2011+johnson+industrial+blvd+nolensville+tn+3715+USA&ie=UTF-8&ei=W1swUu6ADYLBrAe40YGwBQ&ved=0CAoQ_AUoAg"]];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
