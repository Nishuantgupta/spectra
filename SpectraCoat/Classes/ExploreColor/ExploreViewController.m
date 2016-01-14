//
//  ExploreViewController.m
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "ExploreViewController.h"
#import "CollectionViewController.h"
#import "FavouriteViewController.h"
#import "StoreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareViewController.h"
#import "ResultManager.h"

@interface ExploreViewController ()
@property (nonatomic, weak) CALayer *selectedColorLayer;
@property (nonatomic, strong) NSMutableArray *hueColors;
@property (nonatomic, strong) UIColor *selectedColor;
@end

@implementation ExploreViewController
@synthesize lblTop, topView, TopviewBg, btnFav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hueColors = [NSMutableArray array];
        
        for (int i = 0 ; i < 12; i++) {
            CGFloat hue = i * 30 / 360.0;
            int colorCount =  144;
            for (int x = 0; x < colorCount; x++) {
                int row = x / 9;
                int column = x % 9;
                
                CGFloat saturation = column * 0.11 + 0.11;
                CGFloat luminosity = 1.0 - row * 0.05;
                UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:luminosity alpha:1.0];
                [self.hueColors addObject:color];
            }
        }
        
    }
    return self;
}


- (void) setupShadow:(CALayer *)layer {
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.8;
    layer.shadowOffset = CGSizeMake(0, 2);
    CGRect rect = layer.frame;
    rect.origin = CGPointZero;
    layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:layer.cornerRadius].CGPath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirst = YES;
    lblTop.font = [UIFont fontWithName:TITLE_FONT_BOLD size:30];
    lblTop.textColor = colorWithHexString(TITLE_COLOR);
    lblTop.shadowColor  = [UIColor grayColor];
    lblTop.shadowOffset =  CGSizeMake(1.0, 1.0);
    
    self.selectedColorLabel.font = [UIFont fontWithName:TITLE_FONT size:13];
    self.selectedColorLabel.textColor = colorWithHexString(TITLE_COLOR);
    
    
    int index = 0;
    for (int i = 0; i < 12; i++) {
        int colorCount = 144;
        for (int x = 0; x < colorCount && index < self.hueColors.count; x++) {
            CALayer *layer = [CALayer layer];
            layer.cornerRadius = 6.0;
            UIColor *color = [self.hueColors objectAtIndex:index++];
            CGFloat re, gr, bl;
            [color getRed:&re green:&gr blue:&bl alpha:NULL];
            
            int reINT = (int)(re*255);
            int grINT = (int)(gr*255);
            int blINT = (int)(bl*255);
            
            re = reINT/255.0;
            gr = grINT/255.0;
            bl = blINT/255.0;
            
            layer.backgroundColor = [UIColor colorWithRed:re green:gr blue:bl alpha:1].CGColor;
            
            int column = x % 9;
            int row = x / 9;
            layer.frame = CGRectMake(i * 768 + 18 + (column * 83), 18 + row * 49, 70, 40);
            [self setupShadow:layer];
            [self.colorScroll.layer addSublayer:layer];
            
        }
    }
    //    self.selectedColor = [self.hueColors objectAtIndex:0];
    //    CALayer *layer = [CALayer layer];
    //    layer.frame = CGRectMake(162, 8, 150, 40);
    //    layer.cornerRadius = 6.0;
    //    layer.shadowColor = [UIColor blackColor].CGColor;
    //    layer.shadowOffset = CGSizeMake(0, 2);
    //    layer.shadowOpacity = 0.8;
    //
    //    [self.topView.layer addSublayer:layer];
    //    self.selectedColorLayer = layer;
    //    self.selectedColorLayer.backgroundColor = self.selectedColor.CGColor;
    self.topView.layer.cornerRadius  = 6;
    
    self.colorScroll.contentSize = CGSizeMake(768*12, 808);
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [self.colorScroll addGestureRecognizer:recognizer];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    if (isFirst) {
        UIView * view = [[UIView alloc] initWithFrame:self.view.frame];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        view.tag = 585;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, view.frame.size.height)];
        lbl.text = @"Swipe to explore colors and choose";
        lbl.numberOfLines = 5;
        lbl.font = [UIFont fontWithName:TITLE_FONT size:30];
        lbl.textColor = colorWithHexString(TITLE_COLOR);
        [view addSubview:lbl];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:view];
        [self performSelector:@selector(removeText) withObject:nil afterDelay:3];
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
    UIColor * color = self.selectedColor;
    CGFloat re, gr, bl;
    [color getRed:&re green:&gr blue:&bl alpha:NULL];
    
    int reINT = (int)(re*255);
    int grINT = (int)(gr*255);
    int blINT = (int)(bl*255);
    
    re = reINT/255.0;
    gr = grINT/255.0;
    bl = blINT/255.0;
    
    ShareViewController * storeVC = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    storeVC.colorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", re], @"R", [NSString stringWithFormat:@"%f", gr], @"G", [NSString stringWithFormat:@"%f", bl], @"B", nil];
    [self.navigationController pushViewController:storeVC animated:YES];
    storeVC = nil;
    
    [UIView animateWithDuration:0.6 animations:^{
        TopviewBg.alpha = 0;
    } completion:^(BOOL finished) {
        TopviewBg.hidden = YES;
    }
     ];
}


- (IBAction)removeTopButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.6 animations:^{
        TopviewBg.alpha = 0;
    } completion:^(BOOL finished) {
        TopviewBg.hidden = YES;
    }
     ];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.colorScroll];
    int page = point.x / 768;
    int delta = (int)point.x % 768;
    
    int row = (int)((point.y - 18) / 49);
    int column = (int)((delta - 18) / 83);
    int colorCount = 144;
    int index = colorCount * page + row * 9 + column;
	if (index < self.hueColors.count)
    {
		self.selectedColor = [self.hueColors objectAtIndex:index];
        UIColor * color = self.selectedColor;
        CGFloat re, gr, bl;
        [color getRed:&re green:&gr blue:&bl alpha:NULL];
        
        int reINT = (int)(re*255);
        int grINT = (int)(gr*255);
        int blINT = (int)(bl*255);
        
        re = reINT/255.0;
        gr = grINT/255.0;
        bl = blINT/255.0;
        
        ShareViewController * storeVC = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
        storeVC.colorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", re], @"R", [NSString stringWithFormat:@"%f", gr], @"G", [NSString stringWithFormat:@"%f", bl], @"B", nil];
        [self.navigationController pushViewController:storeVC animated:YES];
        storeVC = nil;
        //		self.selectedColorLayer.backgroundColor = self.selectedColor.CGColor;
        //		[self.selectedColorLayer setNeedsDisplay];
        /*
         UIColor * color = self.selectedColor;
         CGFloat re, gr, bl;
         [color getRed:&re green:&gr blue:&bl alpha:NULL];
         
         int reINT = (int)(re*255);
         int grINT = (int)(gr*255);
         int blINT = (int)(bl*255);
         
         re = reINT/255.0;
         gr = grINT/255.0;
         bl = blINT/255.0;
         TopviewBg.alpha = 0;
         topView.backgroundColor = [UIColor colorWithRed:re green:gr blue:bl alpha:1];
         
         float h, s, b;
         [self.selectedColor getHue:&h saturation:&s brightness:&b alpha:NULL];
         if([[ResultManager sharedInstance] isFavouriteColor:[NSString stringWithFormat:@"%f-%f-%f", h, s, b]]) {
         [btnFav setSelected:YES];
         }
         else
         {
         [btnFav setSelected:NO];
         }
         TopviewBg.hidden = NO;
         [UIView animateWithDuration:0.3 animations:^{
         TopviewBg.alpha = 1;
         } completion:^(BOOL finished) {
         
         }
         ];
         */
        
    }
}


- (IBAction)tapFavIcon:(id)sender
{
    float h, s, b, a;
    CGFloat re, gr, bl;
    [self.selectedColor getHue:&h saturation:&s brightness:&b alpha:&a];
    [self.selectedColor  getRed:&re green:&gr blue:&bl alpha:NULL];
    NSString * key = [NSString stringWithFormat:@"%f-%f-%f", h, s, b];
    if([[ResultManager sharedInstance] isFavouriteColor:key]) {
        [[ResultManager sharedInstance] deleteFavouritesColorForID:key];
        [btnFav setSelected:NO];
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
        
        [self.selectedColor getHue:&h saturation:&s brightness:&b alpha:&a];
        [self.selectedColor getRed:&re green:&gr blue:&bl alpha:NULL];
        NSString * key = [NSString stringWithFormat:@"%f-%f-%f", h, s, b];
        
        if(![[ResultManager sharedInstance] isExistColorName:[[[alertView textFieldAtIndex:0]text] uppercaseString]] && isEmptyString([[alertView textFieldAtIndex:0]text]) == NO) {
            [[ResultManager sharedInstance] saveFavouritesColorWithData:[NSDictionary dictionaryWithObjectsAndKeys:key,@"RAL", [NSString stringWithFormat:@"%f", re], @"R", [NSString stringWithFormat:@"%f", gr], @"G", [NSString stringWithFormat:@"%f", bl], @"B",[[[alertView textFieldAtIndex:0]text] uppercaseString], @"Name", nil]];
            [btnFav setSelected:YES];
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
