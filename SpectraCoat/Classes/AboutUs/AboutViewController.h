//
//  AboutViewController.h
//  SpectraCoat
//
//  Created by NISHANT GUPTA on 06/10/13.
//
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
@property (nonatomic, assign) IBOutlet UILabel * lblTop;
@property (nonatomic, assign) IBOutlet UILabel * lblversion;
@property (nonatomic, assign) IBOutlet UILabel * lblCopyRight;
@property (nonatomic, assign) IBOutlet UIImageView * imgbg;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)tourButtonPressed:(id)sender;
@end
