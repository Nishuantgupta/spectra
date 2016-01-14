//
//  CollectionViewController.m
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "CollectionViewController.h"
#import "ResultManager.h"
#import "MBProgressHUD.h"
#import "ColorInfoViewController.h"
#import "ConfigManager.h"

#define ColorWidth 160
#define buttonIndexr 999

@interface CollectionViewController ()

@end

@implementation CollectionViewController
@synthesize tblColoection, lblTop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (IBAction)shareButtonPressed:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ConfigManager sharedInstance] hitIfConnected];
}

- (void)DownloadSuccesfull
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    btnrefresh.hidden = [ConfigManager sharedInstance].isLoadedFromNetwork;
    colorsArray = nil;
    colorsMainArray = nil;
    colorsMainArray = [[NSMutableArray alloc] initWithArray:[[ResultManager sharedInstance] getAllColors]];
    
    colorsArray = [[NSMutableArray alloc] initWithArray:colorsMainArray];
    [tblColoection reloadData];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    btnrefresh.hidden = [ConfigManager sharedInstance].isLoadedFromNetwork;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DownloadSuccesfull) name:@"kComplete" object:nil];
    lblTop.font = [UIFont fontWithName:TITLE_FONT_BOLD size:30];
    lblTop.textColor = colorWithHexString(TITLE_COLOR);
    lblTop.shadowColor  = [UIColor grayColor];
    lblTop.shadowOffset =  CGSizeMake(1.0, 1.0);
    
    colorsMainArray = [[NSMutableArray alloc] initWithArray:[[ResultManager sharedInstance] getAllColors]];
    
    colorsArray = [[NSMutableArray alloc] initWithArray:colorsMainArray];
    [tblColoection reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    //addObserver:self selector:@selector(DownloadSuccesfull) name:@"kComplete" object:nil];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [colorsArray removeAllObjects];
    colorsArray = nil;
    if (isEmptyString(searchText) == NO) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name Contains[c]  %@",searchText];
        colorsArray = [[NSMutableArray alloc] initWithArray:[colorsMainArray  filteredArrayUsingPredicate:predicate]];
    }
    else
    {
        colorsArray = [[NSMutableArray alloc] initWithArray:colorsMainArray];
    }
    [tblColoection reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBars
{
    [colorsArray removeAllObjects];
    colorsArray = nil;
    if (isEmptyString(searchBars.text) == NO) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name Contains[c]  %@",searchBars.text];
        colorsArray = [[NSMutableArray alloc] initWithArray:[colorsMainArray  filteredArrayUsingPredicate:predicate]];
    }
    else
    {
        colorsArray = [[NSMutableArray alloc] initWithArray:colorsMainArray];
    }
    [tblColoection reloadData];
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBars
{
    searchBars.text = @"";
    [colorsArray removeAllObjects];
    colorsArray = nil;
    colorsArray = [[NSMutableArray alloc] initWithArray:colorsMainArray];
    [tblColoection reloadData];
    [self.view endEditing:YES];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return ColorWidth + 110;
	
	
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
    
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, ColorWidth + 110)];
    [viewBG setBackgroundColor:[UIColor clearColor]];
    viewBG.tag = 555;
    [cell addSubview:viewBG];
    
    NSDictionary * dic = [colorsArray objectAtIndex:indexPath.row];
    
    float yPos = 20;
    if(isEmptyString([dic objectForKey:@"Name"]) == NO)
    {
        CGSize size =  [[dic objectForKey:@"Name"] sizeWithFont:[UIFont fontWithName:TITLE_FONT_BOLD size:30] constrainedToSize:CGSizeMake(728 - 90 - ColorWidth, 80) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel * lblColorR = [[UILabel alloc] initWithFrame:CGRectMake(40+ColorWidth, yPos, 728 - 90 - ColorWidth, 40)];
        lblColorR.minimumFontSize = 20;
        yPos = 62;
        if(size.height > 40)
        {
            lblColorR.frame = CGRectMake(40+ColorWidth, 20, 768 - 90 - ColorWidth, 80);
            lblColorR.numberOfLines = 2;
            yPos = 110;
        }
        lblColorR.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Name"]];
        lblColorR.font = [UIFont fontWithName:TITLE_FONT_BOLD size:30];
        [lblColorR setBackgroundColor:[UIColor clearColor]];
        lblColorR.textColor = colorWithHexString(TITLE_COLOR);
        [viewBG addSubview:lblColorR];
    }
    
    
    UILabel * lblColorG = [[UILabel alloc] initWithFrame:CGRectMake(40+ColorWidth, yPos, 768 - 90 - ColorWidth, 40)];
    lblColorG.text = [NSString stringWithFormat:@"SKU : %@", [dic objectForKey:@"SKU"]];
    lblColorG.font = [UIFont fontWithName:TITLE_FONT size:24];
    [lblColorG setBackgroundColor:[UIColor clearColor]];
    lblColorG.textColor = [UIColor whiteColor];
    [viewBG addSubview:lblColorG];
    
    yPos += 40;
    
    UILabel * lblColorB = [[UILabel alloc] initWithFrame:CGRectMake(40+ColorWidth, yPos, 768 - 90 - ColorWidth, 40)];
    lblColorB.text  = [NSString stringWithFormat:@"R - %@ G - %@ B - %@", [dic objectForKey:@"R"], [dic objectForKey:@"G"], [dic objectForKey:@"B"]];
    lblColorB.font = [UIFont fontWithName:TITLE_FONT size:24];
    [lblColorB setBackgroundColor:[UIColor clearColor]];
    lblColorB.textColor = [UIColor whiteColor];
    [viewBG addSubview:lblColorB];

    
    UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, ColorWidth, ColorWidth)];
    [view setBackgroundColor:[UIColor colorWithRed:[[dic objectForKey:@"R"] intValue]/255.0 green:[[dic objectForKey:@"G"] intValue]/255.0 blue:[[dic objectForKey:@"B"] intValue]/255.0 alpha:1]];
    [viewBG addSubview:view];
    
    UIButton * btnColor = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnColor addTarget:self action:@selector(tapOncolor:) forControlEvents:UIControlEventTouchUpInside];
    [btnColor setFrame:CGRectMake(20, 20, ColorWidth, ColorWidth)];
    btnColor.tag = indexPath.row;
    [viewBG addSubview:btnColor];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(tapOnBuyNow:) forControlEvents:UIControlEventTouchUpInside];
    UIImage * imgBuy = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"buy-now" ofType:@"png"]];
    [btn setImage:imgBuy forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(498, ColorWidth + 90 - 53, 210, 53)];
    btn.tag = indexPath.row;
    [viewBG addSubview:btn];
    
    UIButton * btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare addTarget:self action:@selector(tapOnShare:) forControlEvents:UIControlEventTouchUpInside];
    UIImage * imgBShare = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share-button" ofType:@"png"]];
    [btnShare setImage:imgBShare forState:UIControlStateNormal];
    [btnShare setFrame:CGRectMake(20, ColorWidth + 90 - 53, 210, 53)];
    btnShare.tag = indexPath.row;
    [viewBG addSubview:btnShare];
    
    
    UIButton * btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFav.tag = buttonIndexr +  indexPath.row;
    UIImage * imgNormal = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"add-to-fav" ofType:@"png"]];
    UIImage * imgFav = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"add-to-fav" ofType:@"png"]];
    
    [btnFav setFrame:CGRectMake(259, ColorWidth + 90 - 53, 210, 53)];
    [btnFav setImage:imgNormal forState:UIControlStateNormal];
    [btnFav setImage:imgFav forState:UIControlStateSelected];
    float h, s, b;
    [view.backgroundColor getHue:&h saturation:&s brightness:&b alpha:NULL];
    //    if([[ResultManager sharedInstance] isFavouriteColor:[NSString stringWithFormat:@"%f-%f-%f", h, s, b]]) {
    //        [btnFav setSelected:YES];
    //    }
    //    else
    //    {
    //        [btnFav setSelected:NO];
    //    }
    
    [btnFav addTarget:self action:@selector(tapFavouriteButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:btnFav];
    
    if (indexPath.row < [colorsArray count] - 1) {
        UIImageView * sepImage = [[UIImageView alloc] initWithFrame:CGRectMake(31, viewBG.frame.size.height-1, 665, 1)];
        sepImage.image = [UIImage imageNamed:@"centerpadding.png"];
        [viewBG addSubview:sepImage];
    }
	return cell;
	
}

- (void)tapOncolor:(id)sender
{
    NSDictionary * dic = [colorsArray objectAtIndex:[sender tag]];
    ColorInfoViewController * color = [[ColorInfoViewController alloc] initWithNibName:@"ColorInfoViewController" bundle:nil];
    color.colorDictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:color animated:YES];
    color = nil;
}

- (void)tapOnShare:(id)sender
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



- (void)tapOnBuyNow:(id)sender
{
    NSDictionary * dic = [colorsArray objectAtIndex:[sender tag]];
    NSString * url = [dic objectForKey:@"URL"];
    if (isEmptyString(url) == NO) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}


- (void)tapFavouriteButton:(id)sender
{
    float h, s, b, a;
    CGFloat re, gr, bl;
    selectedtab = [sender tag] - buttonIndexr;
    UIButton * btn = (UIButton *)sender;
    NSDictionary * dic = [colorsArray objectAtIndex:selectedtab];
    UIColor * color = [UIColor colorWithRed:[[dic objectForKey:@"R"] intValue]/255.0 green:[[dic objectForKey:@"G"] intValue]/255.0 blue:[[dic objectForKey:@"B"] intValue]/255.0 alpha:1];
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    [color getRed:&re green:&gr blue:&bl alpha:NULL];
    NSString * key = [NSString stringWithFormat:@"%f-%f-%f", h, s, b];
    if([[ResultManager sharedInstance] isFavouriteColor:key]) {
        //        [[ResultManager sharedInstance] deleteFavouritesColorForID:key];
        //        [btn setSelected:NO];
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:nil message:@"This color already exists in your favorites" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        dialog.tag = [sender tag];
        [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
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
        
        //        UITableViewCell* cell = [self.tblColoection cellForRowAtIndexPath:[NSIndexPath indexPathForItem:selectedtab inSection:0]];
        //UIButton * btn = (UIButton *)[[cell viewWithTag:555] viewWithTag:selectedtab+buttonIndexr];
        NSDictionary * dic = [colorsArray objectAtIndex:selectedtab];
        UIColor * color = [UIColor colorWithRed:[[dic objectForKey:@"R"] intValue]/255.0 green:[[dic objectForKey:@"G"] intValue]/255.0 blue:[[dic objectForKey:@"B"] intValue]/255.0 alpha:1];
        [color getHue:&h saturation:&s brightness:&b alpha:&a];
        [color getRed:&re green:&gr blue:&bl alpha:NULL];
        NSString * key = [NSString stringWithFormat:@"%f-%f-%f", h, s, b];
        
        if(![[ResultManager sharedInstance] isExistColorName:[[[alertView textFieldAtIndex:0]text] uppercaseString]] && isEmptyString([[alertView textFieldAtIndex:0]text]) == NO) {
            [[ResultManager sharedInstance] saveFavouritesColorWithData:[NSDictionary dictionaryWithObjectsAndKeys:key,@"RAL", [NSString stringWithFormat:@"%f", re], @"R", [NSString stringWithFormat:@"%f", gr], @"G", [NSString stringWithFormat:@"%f", bl], @"B",[[[alertView textFieldAtIndex:0]text] uppercaseString], @"Name", nil]];
            //[btn setSelected:YES];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
