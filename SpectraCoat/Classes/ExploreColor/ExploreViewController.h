//
//  ExploreViewController.h
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <UIKit/UIKit.h>

@interface ExploreViewController : UIViewController
{
    BOOL isFirst;
}

@property (nonatomic, assign) IBOutlet UILabel * lblTop;
@property (nonatomic, assign) IBOutlet UIScrollView * colorScroll;
@property (weak, nonatomic) IBOutlet UILabel *selectedColorLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *TopviewBg;
@property (nonatomic, assign) IBOutlet UIButton * btnFav;


- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)taponCollectionButton:(id)sender;
- (IBAction)tapOnFavouriteButton:(id)sender;
- (IBAction)tapOnStoreButton:(id)sender;
- (IBAction)removeTopButtonPressed:(id)sender;
@end
