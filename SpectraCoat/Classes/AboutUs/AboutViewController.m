//
//  AboutViewController.m
//  SpectraCoat
//
//  Created by NISHANT GUPTA on 06/10/13.
//
//

#import "AboutViewController.h"
#import "TourViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize lblTop, lblversion, lblCopyRight, imgbg;

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
    lblTop.font = [UIFont fontWithName:TITLE_FONT size:30];
    lblTop.textColor = colorWithHexString(TITLE_COLOR);
    lblTop.shadowColor  = [UIColor grayColor];
    lblTop.shadowOffset =  CGSizeMake(1.0, 1.0);
    
    lblCopyRight.font = [UIFont fontWithName:TITLE_FONT size:15];
    lblCopyRight.textColor = colorWithHexString(TITLE_COLOR);
    lblversion.font = [UIFont fontWithName:TITLE_FONT size:15];
    lblversion.textColor = colorWithHexString(TITLE_COLOR);

        UIImage * img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"about-screen"] ofType:@"png"]];
        imgbg.image = img;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)tourButtonPressed:(id)sender
{
    TourViewController * tour = [[TourViewController alloc] initWithNibName:@"TourViewController" bundle:nil];
    [self.navigationController pushViewController:tour animated:YES];
    tour = nil;
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
