//
//  TourViewController.m
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "TourViewController.h"

@interface TourViewController ()

@end

@implementation TourViewController
@synthesize splashScroll;
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
        
    }
    [splashScroll setContentSize:CGSizeMake(768*5, 1004)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapOnGetStarted
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)removeSplash
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
