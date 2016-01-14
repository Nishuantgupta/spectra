//
//  CollectionViewController.h
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import "FBSharedObject.h"

@interface CollectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, FBShareObjectDelegate, UISearchBarDelegate>
{
    NSMutableArray * colorsArray ;
    NSMutableArray * colorsMainArray ;
    int selectedtab;
    IBOutlet UISearchBar * searchBar;
    IBOutlet UIButton * btnrefresh;
}

@property (nonatomic, assign) IBOutlet UITableView * tblColoection;
@property (nonatomic, assign) IBOutlet UILabel * lblTop;

- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end
