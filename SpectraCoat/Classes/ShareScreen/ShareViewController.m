//
//  ShareViewController.m
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "ShareViewController.h"
#import "ResultManager.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorInfoViewController.h"
#import "MBProgressHUD.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize lbl1, lbl2, lbl3, lbl4, lbl5, lbl6, lbl7, lbl8, lblTop, viewMain, ViewStore, colorDictionary, colorDictionaryStore, topView, TopviewBg;

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
    
    lbl1.font = lbl5.font = [UIFont fontWithName:TITLE_FONT size:30];
    lbl1.textColor = lbl5.textColor =  colorWithHexString(TITLE_COLOR);
    
    lbl2.font = lbl3.font = lbl4.font = [UIFont fontWithName:TITLE_FONT size:30];
    lbl2.textColor = lbl3.textColor = lbl4.textColor = colorWithHexString(TITLE_COLOR);
    
    lbl6.font = [UIFont fontWithName:TITLE_FONT size:30]; lbl7.font = [UIFont fontWithName:TITLE_FONT size:26]; lbl8.font = [UIFont fontWithName:TITLE_FONT size:26];
    lbl6.textColor = lbl7.textColor = lbl8.textColor = colorWithHexString(TITLE_COLOR);
    
    int reINT = (int)([[colorDictionary objectForKey:@"R"] floatValue]*255);
    int grINT = (int)([[colorDictionary objectForKey:@"G"] floatValue]*255);
    int blINT = (int)([[colorDictionary objectForKey:@"B"] floatValue]*255);
    
    float re = reINT/255.0;
    float gr = grINT/255.0;
    float bl = blINT/255.0;
    
    lbl2.text = [NSString stringWithFormat:@"Red - %d", reINT];
    lbl3.text = [NSString stringWithFormat:@"Green - %d", grINT];
    lbl4.text = [NSString stringWithFormat:@"Blue - %d", blINT];
    viewMain.backgroundColor = [UIColor colorWithRed:re green:gr blue:bl alpha:1];
    
    colorDictionaryStore = [[NSMutableDictionary alloc] initWithDictionary:[[ResultManager sharedInstance] getSimilorColorforRed:re*255 Green:gr*255 Blue:bl*255]];
    
    float re2 = [[colorDictionaryStore objectForKey:@"R"] intValue]/255.0;
    float gr2 = [[colorDictionaryStore objectForKey:@"G"] intValue]/255.0;
    float bl2 = [[colorDictionaryStore objectForKey:@"B"] intValue]/255.0;
    
    ViewStore.backgroundColor = [UIColor colorWithRed:re2 green:gr2 blue:bl2 alpha:1];
    
    lbl6.text = [NSString stringWithFormat:@"%@", [colorDictionaryStore objectForKey:@"Name"]];
    lbl7.text = [NSString stringWithFormat:@"SKU - %@", [colorDictionaryStore objectForKey:@"SKU"]];
    lbl8.text = [NSString stringWithFormat:@"R - %@ G - %@ B - %@", [colorDictionaryStore objectForKey:@"R"], [colorDictionaryStore objectForKey:@"G"], [colorDictionaryStore objectForKey:@"B"]];
    self.topView.layer.cornerRadius  = 6;
    
    CGSize size =  [[colorDictionaryStore objectForKey:@"Name"] sizeWithFont:[UIFont fontWithName:TITLE_FONT_BOLD size:30] constrainedToSize:CGSizeMake(430, 80) lineBreakMode:NSLineBreakByWordWrapping];
    if(size.height> 40)
    {
        CGRect frame = lbl6.frame;
        frame.size.height = 80;
        lbl6.frame = frame;
        lbl6.numberOfLines=2;
        
        frame = lbl7.frame;
        frame.origin.y = lbl6.frame.size.height + lbl6.frame.origin.y;
        lbl7.frame = frame;
        
        frame = lbl8.frame;
        frame.origin.y = lbl7.frame.size.height + lbl7.frame.origin.y;
        lbl8.frame = frame;
        
    }
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)shareButtonPressed:(id)sender
{
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share via Twitter", @"Share via Facebook", @"Share via Email", nil];
    [sheet setTag:[sender tag]];
    [sheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary * dic;
    if(actionSheet.tag == 1)
    {
        dic = colorDictionary;
    }
    else
    {
        dic = colorDictionaryStore;
    }
    UIImage * img = [self imageWithDictionary:dic];
    NSMutableString * text1 = [[NSMutableString alloc] init];
    int reINT, grINT, blINT;
    int check = [[dic objectForKey:@"R"] intValue]-1;
    if ( check <= 0)
    {
        reINT = (int)([[dic objectForKey:@"R"] floatValue]*255);
        grINT = (int)([[dic objectForKey:@"G"] floatValue]*255);
        blINT = (int)([[dic objectForKey:@"B"] floatValue]*255);
    }
    else
    {
        reINT = [[dic objectForKey:@"R"] intValue];
        grINT = [[dic objectForKey:@"G"] intValue];
        blINT = [[dic objectForKey:@"B"] intValue];
    }
    
    if([[dic allKeys] containsObject:@"SKU"])
    {
        [text1 appendFormat:@"%@",[dic
                                   objectForKey:@"Name"]];
        
        [text1 appendFormat:@"\nSKU - %@",[dic objectForKey:@"SKU"]];
        [text1 appendFormat:@"\n\nR - %d G - %d B - %d",reINT, grINT, blINT];
        
        if([[dic allKeys] containsObject:@"URL"])
        {
            if (isEmptyString([dic objectForKey:@"URL"])== NO) {
                [text1 appendFormat:@"\n\n%@", [dic objectForKey:@"URL"]];
            }
        }
        
    }
    else
    {
        
        [text1 appendFormat:@"\n\nR - %d", reINT];
        [text1 appendFormat:@"\n\nG - %d", grINT];
        [text1 appendFormat:@"\n\nB - %d", blINT];
    }
    
    if(buttonIndex == 0)
    {
        if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet =
            [[TWTweetComposeViewController alloc] init];
            [tweetSheet setInitialText:
             @"Love this color I found on SpectraCoat Snap & Match color by Powder Buy The Pound"];
            [tweetSheet addURL:[NSURL URLWithString:@"http://powderbuythepound.com/spectracoat"]];
            [tweetSheet addImage:img];
            [self presentModalViewController:tweetSheet animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    else if(buttonIndex == 1)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[FBSharedObject getSingleton] setDelegate:self];
        [[FBSharedObject getSingleton] postOnFB:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Love this color I found on SpectraCoat Snap & Match color by Powder Buy The Pound\n\n %@", text1], @"description", [NSString stringWithFormat:@"Love this color I found on SpectraCoat Snap&match color by Powder Buy The Pound \n\n %@", text1], @"title",  @"http://powderbuythepound.com/spectracoat", @"link", img, @"picture", nil]];
        
    }
    else if(buttonIndex == 2)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:@"SpectraCoat Snap & Match Color"];
            NSData *myData = UIImageJPEGRepresentation(img, 1.0);
            [controller addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"Shared Color"];
            [controller setToRecipients:[NSArray arrayWithObject:@"sales@powderbuythepound.com"]];
            [controller setMessageBody:[NSString stringWithFormat:@"Love this color I found on SpectraCoat Snap & Match color by Powder Buy The Pound\nhttp://powderbuythepound.com/spectracoat \n\n %@", text1] isHTML:NO];
            if (controller)
                [self.navigationController presentModalViewController:controller animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send email right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }
    
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithDictionary:(NSDictionary *)dic
{
    NSMutableString * text1 = [[NSMutableString alloc] init];
    int reINT, grINT, blINT;
    int check = [[dic objectForKey:@"R"] intValue]-1;
    if ( check <= 0)
    {
        reINT = (int)([[dic objectForKey:@"R"] floatValue]*255);
        grINT = (int)([[dic objectForKey:@"G"] floatValue]*255);
        blINT = (int)([[dic objectForKey:@"B"] floatValue]*255);
    }
    else
    {
        reINT = [[dic objectForKey:@"R"] intValue];
        grINT = [[dic objectForKey:@"G"] intValue];
        blINT = [[dic objectForKey:@"B"] intValue];
    }
    
    float re = reINT/255.0;
    float gr = grINT/255.0;
    float bl = blINT/255.0;
    
    UIColor * color = [UIColor colorWithRed:re green:gr blue:bl alpha:1];
    
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 500.0f, 500.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextOld = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(contextOld, [color CGColor]);
    CGContextFillRect(contextOld, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    int w = img.size.width;
    
    int h = img.size.height;
    
    //lon = h - lon;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
    
    CGContextSelectFont(context, "Arial", 15, kCGEncodingMacRoman);
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
    
    
    
    //rotate text
    
    //CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
    
    
    if([[dic allKeys] containsObject:@"SKU"])
    {
        char* text	= (char *)[[NSString stringWithFormat:@"%@",[dic objectForKey:@"Name"]] cStringUsingEncoding:NSASCIIStringEncoding];
        CGContextShowTextAtPoint(context, 4, h - 20 - 10, text, strlen(text));
        
        text	= (char *)[[NSString stringWithFormat:@"SKU - %@",[dic objectForKey:@"SKU"]] cStringUsingEncoding:NSASCIIStringEncoding];
        CGContextShowTextAtPoint(context, 4, h - 20 - 30, text, strlen(text));
        
        text	= (char *)[[NSString stringWithFormat:@"R - %d G - %d B - %d",reINT, grINT, blINT] cStringUsingEncoding:NSASCIIStringEncoding];
        CGContextShowTextAtPoint(context, 4, h - 20 - 50, text, strlen(text));
        
        if([[dic allKeys] containsObject:@"URL"])
        {
            if (isEmptyString([dic objectForKey:@"URL"])== NO) {
                [text1 appendFormat:@"\n\n%@", [dic objectForKey:@"URL"]];
                text	= (char *)[[NSString stringWithFormat:@"%@",[dic objectForKey:@"URL"]] cStringUsingEncoding:NSASCIIStringEncoding];
                CGContextShowTextAtPoint(context, 4, h - 20 - 70, text, strlen(text));
            }
        }
        
    }
    else
    {
        
        char* text	= (char *)[[NSString stringWithFormat:@"R - %d", reINT] cStringUsingEncoding:NSASCIIStringEncoding];
        CGContextShowTextAtPoint(context, 4, h - 20 - 30, text, strlen(text));
        
        text	= (char *)[[NSString stringWithFormat:@"G - %d", grINT] cStringUsingEncoding:NSASCIIStringEncoding];
        CGContextShowTextAtPoint(context, 4, h - 20 - 50, text, strlen(text));
        
        text	= (char *)[[NSString stringWithFormat:@"B - %d", blINT]cStringUsingEncoding:NSASCIIStringEncoding];
        CGContextShowTextAtPoint(context, 4, h - 20 - 70, text, strlen(text));
    }
    
    
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
    
    //return image;
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


- (IBAction)removeTopButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        TopviewBg.alpha = 0;
    } completion:^(BOOL finished) {
        TopviewBg.hidden = YES;
    }
     ];
}

- (IBAction)colorViewTapped:(id)sender
{
    
    
    /*
     CGFloat re, gr, bl;
     float h, s, b;
     if ([sender tag] == 1) {
     [viewMain.backgroundColor getRed:&re green:&gr blue:&bl alpha:NULL];
     [viewMain.backgroundColor getHue:&h saturation:&s brightness:&b alpha:NULL];
     }
     else
     {
     [ViewStore.backgroundColor getRed:&re green:&gr blue:&bl alpha:NULL];
     [ViewStore.backgroundColor getHue:&h saturation:&s brightness:&b alpha:NULL];
     }
     
     int reINT = (int)(re*255);
     int grINT = (int)(gr*255);
     int blINT = (int)(bl*255);
     
     re = reINT/255.0;
     gr = grINT/255.0;
     bl = blINT/255.0;
     TopviewBg.alpha = 0;
     topView.backgroundColor = [UIColor colorWithRed:re green:gr blue:bl alpha:1];
     TopviewBg.hidden = NO;
     [UIView animateWithDuration:0.3 animations:^{
     TopviewBg.alpha = 1;
     } completion:^(BOOL finished) {
     
     }
     ];
     */
    
    ColorInfoViewController * color = [[ColorInfoViewController alloc] initWithNibName:@"ColorInfoViewController" bundle:nil];
    if ([sender tag] == 1) {
        color.colorDictionary = colorDictionary;
    }
    else
    {
        color.colorDictionary  = colorDictionaryStore;
    }
    [self.navigationController pushViewController:color animated:YES];
    color = nil;
    
}

- (void)facebookWallPostSuccess
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Status is successfully posted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void)facebookWallPostCancel
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Status post is cancel" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)facebookWallPostFailed
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyNowButtonClick:(id)sender
{
    NSString * url = [colorDictionaryStore objectForKey:@"URL"];
    if (isEmptyString(url) == NO) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)favButtonClick:(id)sender
{
    float h, s, b = 0.0, a;
    CGFloat re, gr, bl;
    if([sender tag] == 1)
    {
        [viewMain.backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a];
        [viewMain.backgroundColor  getRed:&re green:&gr blue:&bl alpha:NULL];
    }
    else
    {
        [ViewStore.backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a];
        [ViewStore.backgroundColor  getRed:&re green:&gr blue:&bl alpha:NULL];
    }
    
    NSString * key = [NSString stringWithFormat:@"%f-%f-%f", h, s, b];
    if([[ResultManager sharedInstance] isFavouriteColor:key]) {
        //        [[ResultManager sharedInstance] deleteFavouritesColorForID:key];
        //        [self.btnFav setSelected:NO];
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:nil message:@"This color already exists in your favorites" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        [dialog show];
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
        
        if([alertView tag] == 1)
        {
            [viewMain.backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a];
            [viewMain.backgroundColor  getRed:&re green:&gr blue:&bl alpha:NULL];
        }
        else
        {
            [ViewStore.backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a];
            [ViewStore.backgroundColor  getRed:&re green:&gr blue:&bl alpha:NULL];
        }
        NSString * key = [NSString stringWithFormat:@"%f-%f-%f", h, s, b];
        
        if(![[ResultManager sharedInstance] isExistColorName:[[[alertView textFieldAtIndex:0]text] uppercaseString]] && isEmptyString([[alertView textFieldAtIndex:0]text]) == NO) {
            [[ResultManager sharedInstance] saveFavouritesColorWithData:[NSDictionary dictionaryWithObjectsAndKeys:key,@"RAL", [NSString stringWithFormat:@"%f", re], @"R", [NSString stringWithFormat:@"%f", gr], @"G", [NSString stringWithFormat:@"%f", bl], @"B",[[[alertView textFieldAtIndex:0]text] uppercaseString], @"Name", nil]];
            UIAlertView * alert =[[ UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ color is added to your favorites", [[alertView textFieldAtIndex:0]text]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            
            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Already Exist." message:@"New name your color to add to favorites" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
            dialog.tag = [alertView tag];
            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [dialog show];
            
        }
    }
    
}



@end
