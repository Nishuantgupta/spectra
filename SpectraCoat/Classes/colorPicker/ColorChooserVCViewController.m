//
//  ColorChooserVCViewController.m
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "ColorChooserVCViewController.h"
#import "ResultManager.h"
#import <QuartzCore/QuartzCore.h>
#import "CollectionViewController.h"
#import "FavouriteViewController.h"
#import "StoreViewController.h"
#import "ShareViewController.h"

@interface ColorChooserVCViewController ()

@end

@implementation ColorChooserVCViewController
@synthesize colorImage, colorPatch = _colorPatch, colorPicker = _colorPicker, brightnessSlider = _brightnessSlider, colorView = _colorView, MaincolorView =_MaincolorView, availableColor = _availableColor, btnFav, colorView1, colorView10, colorView2, colorView3,colorView4,colorView5,colorView6,colorView7,colorView8,colorView9, btnFav1,btnFav10,btnFav2,btnFav3,btnFav4,btnFav5,btnFav6,btnFav7,btnFav8,btnFav9, mainScrollview, lblTop;

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
    isFirst = YES;
    lblTop.font = [UIFont fontWithName:TITLE_FONT_BOLD size:30];
    lblTop.textColor = colorWithHexString(TITLE_COLOR);
    lblTop.shadowColor  = [UIColor grayColor];
    lblTop.shadowOffset =  CGSizeMake(1.0, 1.0);
    self.navigationController.navigationBarHidden = YES;
    float yPos = 104;
    float height = 566;
    
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(20, yPos, 728, height)];
    _colorPicker.colorImage = colorImage;
    [_colorPicker setCropToCircle:NO]; // Defaults to YES (and you can set BG color)
	[_colorPicker setDelegate:self];
	[self.view addSubview:_colorPicker];
	
    yPos += height;
    
    UIImage * imgNormal = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fav-icon" ofType:@"png"]];
    UIImage * imgFav = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fav-icon_active" ofType:@"png"]];
    
    UIImage * imgBg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow" ofType:@"png"]];
    
    for (int i = 0; i<10; i++) {
        UIImageView * imgViewBg  = [[UIImageView alloc] initWithImage:imgBg];
        imgViewBg.frame = CGRectMake(i*175+63, 173, 63, 18);
        [mainScrollview addSubview:imgViewBg];
        
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(i*175+40, 45, 110, 110)];
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 2;
        view.transform = CGAffineTransformMakeRotation(M_PI_4);
        UIButton * btnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        btnView.tag= i;
        [btnView addTarget:self action:@selector(tapDiamond:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnView];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*175 + 10, 15, 42 , 41)];
        [btn setImage:imgNormal forState:UIControlStateNormal];
        [btn setImage:imgFav forState:UIControlStateSelected];
        btn.tag= i;
        [btn addTarget:self action:@selector(tapFavouriteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        switch (i) {
            case 0:
            {
                self.btnFav1 = btn;
                self.colorView1 = view;
                break;
            }
            case 1:
            {
                self.btnFav2 = btn;
                self.colorView2 = view;
                break;
            }
            case 2:
            {
                self.btnFav3 = btn;
                self.colorView3 = view;
                break;
            }
            case 3:
            {
                self.btnFav4 = btn;
                self.colorView4 = view;
                break;
            }
            case 4:
            {
                self.btnFav5 = btn;
                self.colorView5 = view;
                break;
            }
            case 5:
            {
                self.btnFav6 = btn;
                self.colorView6 = view;
                break;
            }
            case 6:
            {
                self.btnFav7 = btn;
                self.colorView7 = view;
                break;
            }
            case 7:
            {
                self.btnFav8 = btn;
                self.colorView8 = view;
                break;
            }
            case 8:
            {
                self.btnFav9 = btn;
                self.colorView9 = view;
                break;
            }
            case 9:
            {
                self.btnFav10 = btn;
                self.colorView10 = view;
                break;
            }
            default:
                break;
        }
        [mainScrollview addSubview:view];
        [mainScrollview addSubview:btn];
        
    }
    mainScrollview.contentSize = CGSizeMake(175*10, 200);
    
}

- (void)tapDiamond:(id)sender
{
    float h, s, b, a;
    CGFloat re, gr, bl;
    switch ([sender tag]) {
        case 0:
            [[self.colorView1 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView1 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 1:
            [[self.colorView2 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView2 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 2:
            [[self.colorView3 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView3 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 3:
            [[self.colorView4 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView4 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 4:
            [[self.colorView5 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView5 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 5:
            [[self.colorView6 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView6 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 6:
            [[self.colorView7 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView7 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 7:
            [[self.colorView8 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView8 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 8:
            [[self.colorView9 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView9 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 9:
            [[self.colorView10 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView10 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
    }
    ShareViewController * storeVC = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    storeVC.colorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", re], @"R", [NSString stringWithFormat:@"%f", gr], @"G", [NSString stringWithFormat:@"%f", bl], @"B", nil];
    [self.navigationController pushViewController:storeVC animated:YES];
    storeVC = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (isFirst) {
        UIView * view = [[UIView alloc] initWithFrame:self.view.frame];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        view.tag = 585;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 568, view.frame.size.height)];
        lbl.text = @"Pick a color you love by tapping anywhere on the picture. Then choose different shades of your favorite color shown below";
        lbl.numberOfLines = 5;
        lbl.font = [UIFont fontWithName:TITLE_FONT size:30];
        lbl.textColor = colorWithHexString(TITLE_COLOR);
        [view addSubview:lbl];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:view];
        [self performSelector:@selector(removeText) withObject:nil afterDelay:5];
        isFirst = NO;
    }
}

- (void)removeText
{
    UIView * view = [self.view viewWithTag:585];
    if(view)
    {
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }
         ];
    }
}
- (IBAction)shareButtonPressed:(id)sender
{
    
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RSColorPickerView delegate methods

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{
	_colorPatch.backgroundColor = [cp selectionColor];
    _colorView.backgroundColor =  [cp selectionColor];
    
    
    CGFloat re, gr, bl;
	[[cp selectionColor] getRed:&re green:&gr blue:&bl alpha:NULL];
    
    float h, s, b, a;
    [[cp selectionColor] getHue:&h saturation:&s brightness:&b alpha:&a];
    for (int i = 0; i<10; i++) {
        float brightness = b+(((i)-5)*0.05);
        UIButton * btn;
        switch (i) {
            case 0:
                btn = self.btnFav1;
                [self.colorView1 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];
                break;
            case 1:
                btn = self.btnFav2;
                [self.colorView2 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];                break;
            case 2:
                btn = self.btnFav3;
                [self.colorView3 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];                break;
            case 3:
                btn = self.btnFav4;
                [self.colorView4 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];                break;
            case 4:
                btn = self.btnFav5;
                [self.colorView5 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];
                break;
            case 5:
                btn = self.btnFav6;
                [self.colorView6 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];                break;
            case 6:
                btn = self.btnFav7;
                [self.colorView7 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];                break;
            case 7:
                btn = self.btnFav8;
                [self.colorView8 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];
                break;
            case 8:
                btn = self.btnFav9;
                [self.colorView9 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];                break;
            case 9:
                btn = self.btnFav10;
                [self.colorView10 setBackgroundColor:[UIColor colorWithHue:h saturation:s brightness:brightness alpha:1]];;
                break;
            default:
                break;
        }
        if([[ResultManager sharedInstance] isFavouriteColor:[NSString stringWithFormat:@"%f-%f-%f", h, s, brightness]]) {
            [btn setSelected:YES];
        }
        else
        {
            [btn setSelected:NO];
        }
    }
    
}

- (void)tapFavouriteButton:(id)sender
{
    float h, s, b, a;
    CGFloat re, gr, bl;
    selectedtab = [sender tag];
    switch ([sender tag]) {
        case 0:
            [[self.colorView1 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView1 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 1:
            [[self.colorView2 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView2 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 2:
            [[self.colorView3 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView3 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 3:
            [[self.colorView4 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView4 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 4:
            [[self.colorView5 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView5 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 5:
            [[self.colorView6 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView6 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 6:
            [[self.colorView7 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView7 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 7:
            [[self.colorView8 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView8 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 8:
            [[self.colorView9 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView9 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
        case 9:
            [[self.colorView10 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
            [[self.colorView10 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
            break;
    }
    UIButton * btn = (UIButton *)sender;
    
    NSString * key = [NSString stringWithFormat:@"%f-%f-%f", h, s, b];
    if([[ResultManager sharedInstance] isFavouriteColor:key]) {
        [[ResultManager sharedInstance] deleteFavouritesColorForID:key];
        [btn setSelected:NO];
    }
    else
    {
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:nil message:@"Name your color to add to favorites" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        dialog.tag = [sender tag];
        [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [dialog show];
        
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
        
    {
        float h, s, b, a;
        CGFloat re, gr, bl;
        UIButton * btn;
        switch ([alertView tag]) {
            case 0:
                [[self.colorView1 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView1 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav1;
                break;
            case 1:
                [[self.colorView2 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView2 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav2;
                break;
            case 2:
                [[self.colorView3 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView3 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav3;
                break;
            case 3:
                [[self.colorView4 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView4 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav4;
                break;
            case 4:
                [[self.colorView5 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView5 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav5;
                break;
            case 5:
                [[self.colorView6 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView6 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav6;
                break;
            case 6:
                [[self.colorView7 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView7 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav7;
                break;
            case 7:
                [[self.colorView8 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView8 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav8;
                break;
            case 8:
                [[self.colorView9 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView9 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav9;
                break;
            case 9:
                [[self.colorView10 backgroundColor] getRed:&re green:&gr blue:&bl alpha:NULL];
                [[self.colorView10 backgroundColor] getHue:&h saturation:&s brightness:&b alpha:&a];
                btn=btnFav10;
                break;
        }
        NSString * key = [NSString stringWithFormat:@"%f-%f-%f", h, s, b];
        if(![[ResultManager sharedInstance] isExistColorName:[[[alertView textFieldAtIndex:0]text] uppercaseString]] && isEmptyString([[alertView textFieldAtIndex:0]text]) == NO)
        {
            [[ResultManager sharedInstance] saveFavouritesColorWithData:[NSDictionary dictionaryWithObjectsAndKeys:key,@"RAL", [NSString stringWithFormat:@"%f", re], @"R", [NSString stringWithFormat:@"%f", gr], @"G", [NSString stringWithFormat:@"%f", bl], @"B",[[[alertView textFieldAtIndex:0]text] uppercaseString], @"Name", nil]];
            [btn setSelected:YES];
            UIAlertView * alert =[[ UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ color is added to your favorites", [[alertView textFieldAtIndex:0]text]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            
            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Already Exist." message:@"Rename your color to add to favorites" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
            dialog.tag = [alertView tag];
            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [dialog show];
            
        }
    }
}

- (IBAction)taponCollectionButton:(id)sender
{
    CollectionViewController * colorChooser = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    [self.navigationController pushViewController:colorChooser animated:YES];
    colorChooser = nil;
    
}

- (IBAction)tapOnFavouriteButton:(id)sender
{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
