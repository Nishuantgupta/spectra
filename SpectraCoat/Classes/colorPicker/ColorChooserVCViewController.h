//
//  ColorChooserVCViewController.h
//  SpectraCoat
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"
#import "RSBrightnessSlider.h"

@interface ColorChooserVCViewController : UIViewController<RSColorPickerViewDelegate>
{
    BOOL isFirst;
    int selectedtab;
}

@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) UIView *colorPatch;
@property (nonatomic, retain) UIImage * colorImage;
@property (nonatomic, retain) UIView * colorView;
@property (nonatomic, retain) UIView * MaincolorView;
@property (nonatomic, retain) NSDictionary * availableColor;
@property (nonatomic, retain) UIButton * btnFav;
@property (nonatomic, retain) UIView * colorView1, * colorView2, * colorView3, * colorView4, * colorView5, * colorView6, * colorView7, * colorView8, * colorView9, * colorView10;
@property (nonatomic, retain) UIButton * btnFav1, * btnFav2, * btnFav3, * btnFav4, * btnFav5, * btnFav6, * btnFav7, * btnFav8, * btnFav9, * btnFav10;
@property (nonatomic, retain) IBOutlet UIScrollView * mainScrollview;
@property (nonatomic, assign) IBOutlet UILabel * lblTop;

- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)taponCollectionButton:(id)sender;
- (IBAction)tapOnFavouriteButton:(id)sender;
- (IBAction)tapOnStoreButton:(id)sender;
@end
