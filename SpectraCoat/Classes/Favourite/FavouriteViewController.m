//
//  FavouriteViewController.m
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "FavouriteViewController.h"
#import "ResultManager.h"
#import "MBProgressHUD.h"
#import "ShareViewController.h"

#define ColorWidth 160

@interface FavouriteViewController ()

@end

@implementation FavouriteViewController
@synthesize tblColoection,lblTop;

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
    self.navigationController.navigationBarHidden  = YES;
    lblTop.font = [UIFont fontWithName:TITLE_FONT_BOLD size:30];
    lblTop.textColor = colorWithHexString(TITLE_COLOR);
    lblTop.shadowColor  = [UIColor grayColor];
    lblTop.shadowOffset =  CGSizeMake(1.0, 1.0);
    
    colorsArray = [[NSMutableArray alloc] initWithArray:[[ResultManager sharedInstance] getFavouriteColors]];
    [tblColoection reloadData];
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
    NSDictionary * colorDictionary = [colorsArray objectAtIndex:actionSheet.tag];
    
    UIImage * img = [self imageWithDictionary:colorDictionary];
    NSMutableString * text1 = [[NSMutableString alloc] init];
    int reINT, grINT, blINT;
    int check = [[colorDictionary objectForKey:@"R"] intValue]-1;
    if ( check <= 0)
    {
        reINT = (int)([[colorDictionary objectForKey:@"R"] floatValue]*255);
        grINT = (int)([[colorDictionary objectForKey:@"G"] floatValue]*255);
        blINT = (int)([[colorDictionary objectForKey:@"B"] floatValue]*255);
    }
    else
    {
        reINT = [[colorDictionary objectForKey:@"R"] intValue];
        grINT = [[colorDictionary objectForKey:@"G"] intValue];
        blINT = [[colorDictionary objectForKey:@"B"] intValue];
    }
    
    if([[colorDictionary allKeys] containsObject:@"SKU"])
    {
        [text1 appendFormat:@"%@",[colorDictionary
                                   objectForKey:@"Name"]];
        
        [text1 appendFormat:@"\nSKU - %@",[colorDictionary objectForKey:@"SKU"]];
        [text1 appendFormat:@"\n\nR - %d G - %d B - %d",reINT, grINT, blINT];
        
        if([[colorDictionary allKeys] containsObject:@"URL"])
        {
            if (isEmptyString([colorDictionary objectForKey:@"URL"])== NO) {
                [text1 appendFormat:@"\n\n%@", [colorDictionary objectForKey:@"URL"]];
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
        [[FBSharedObject getSingleton] postOnFB:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Love this color I found on SpectraCoat Snap & Match color by Powder Buy The Pound\n\n %@", text1], @"description", [NSString stringWithFormat:@"Love this color I found on SpectraCoat Snap & Match color by Powder Buy The Pound\n\n %@", text1], @"title",  @"http://powderbuythepound.com/spectracoat", @"link", img, @"picture", nil]];
        
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

- (void)tapOncolor:(id)sender
{
    NSDictionary * dic = [colorsArray objectAtIndex:[sender tag]];
//    ShareViewController * storeVC = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
//    storeVC.colorDictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
//    [self.navigationController pushViewController:storeVC animated:YES];
//    storeVC = nil;
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


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return ColorWidth+40;
	
	
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	
	return [colorsArray count];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
    }
    UIView * bg = [cell viewWithTag:555];
    if(bg != nil)
    {
        [bg removeFromSuperview];
        bg = nil;
    }
    
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, ColorWidth+40)];
    [viewBG setBackgroundColor:[UIColor clearColor]];
    viewBG.tag = 555;
    [cell addSubview:viewBG];
    
    NSDictionary * dic = [colorsArray objectAtIndex:indexPath.row];
    
    int r, g, b;
    
    int check = [[dic objectForKey:@"R"] intValue]-1;
    if ( check <= 0)
    {
        r = [[dic objectForKey:@"R"] floatValue] * 255;
        g = [[dic objectForKey:@"G"] floatValue] * 255;
        b = [[dic objectForKey:@"B"] floatValue] * 255;
    }
    else
    {
        r = [[dic objectForKey:@"R"] intValue];
        g = [[dic objectForKey:@"G"] intValue];
        b = [[dic objectForKey:@"B"] intValue];
    }
    
    UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, ColorWidth, ColorWidth)];
    [view setBackgroundColor:[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]];
    [viewBG addSubview:view];
    
    UIButton * btnColor = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnColor addTarget:self action:@selector(tapOncolor:) forControlEvents:UIControlEventTouchUpInside];
    [btnColor setFrame:CGRectMake(10, 10, ColorWidth, ColorWidth)];
    btnColor.tag = indexPath.row;
    [viewBG addSubview:btnColor];
    
    UILabel * lblColorR = [[UILabel alloc] initWithFrame:CGRectMake(40+ColorWidth, 26, 768 - 60 - ColorWidth, 40)];
    
    lblColorR.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Name"]];
    lblColorR.font = [UIFont fontWithName:TITLE_FONT_BOLD size:30];
    [lblColorR setBackgroundColor:[UIColor clearColor]];
    lblColorR.textColor = colorWithHexString(TITLE_COLOR);
    [viewBG addSubview:lblColorR];
    //    UILabel * lblColorG = [[UILabel alloc] initWithFrame:CGRectMake(20+ColorWidth, 42, 320 - 20 - ColorWidth, 20)];
    //    lblColorG.text = [NSString stringWithFormat:@"RGB"];
    //    lblColorG.font = [UIFont fontWithName:TITLE_FONT size:13];
    //    [lblColorG setBackgroundColor:[UIColor clearColor]];
    //    lblColorG.textColor = colorWithHexString(TITLE_COLOR);
    //    [viewBG addSubview:lblColorG];
    UILabel * lblColorB = [[UILabel alloc] initWithFrame:CGRectMake(40+ColorWidth, 80, 768 - 40 - ColorWidth, 40)];
    lblColorB.text = [NSString stringWithFormat:@"R - %d, G - %d, B - %d",r,g, b];
    lblColorB.font = [UIFont fontWithName:TITLE_FONT size:26];
    lblColorB.textColor = colorWithHexString(TITLE_COLOR);
    [lblColorB setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:lblColorB];
    
    UIButton * btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImage * imgBShare = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share-button" ofType:@"png"]];
    [btnShare setImage:imgBShare forState:UIControlStateNormal];
    [btnShare setFrame:CGRectMake(ColorWidth + 40, ColorWidth + 20 - 53, 210, 53)];
    btnShare.tag = indexPath.row;
    [viewBG addSubview:btnShare];
    
    if (indexPath.row < [colorsArray count] - 1) {
        UIImageView * sepImage = [[UIImageView alloc] initWithFrame:CGRectMake(31, viewBG.frame.size.height-1, 665, 1)];
        sepImage.image = [UIImage imageNamed:@"centerpadding.png"];
        [viewBG addSubview:sepImage];
    }
    
	return cell;
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
