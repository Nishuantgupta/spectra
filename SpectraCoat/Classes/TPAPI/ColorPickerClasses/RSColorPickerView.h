//
//  RSColorPickerView.h
//  RSColorPicker
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class RSColorPickerView, BGRSLoupeLayer;

@protocol RSColorPickerViewDelegate <NSObject>
-(void)colorPickerDidChangeSelection:(RSColorPickerView*)cp;
@end

@interface RSColorPickerView : UIView

@property (nonatomic) UIImage * colorImage;
@property (nonatomic) BOOL cropToCircle;
@property (nonatomic) CGFloat brightness;
@property (nonatomic) CGFloat opacity;
@property (nonatomic) UIColor *selectionColor;
@property (nonatomic, assign) id <RSColorPickerViewDelegate> delegate;
@property (nonatomic, readonly) CGPoint selection;

-(UIColor*)colorAtPoint:(CGPoint)point; //Returns UIColor at a point in the RSColorPickerView

@end
