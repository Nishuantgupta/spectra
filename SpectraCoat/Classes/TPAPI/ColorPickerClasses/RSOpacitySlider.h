//
//  RSOpacitySlider.h
//  RSColorPicker
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "RSColorPickerView.h"

extern UIImage* RSOpacityBackgroundImage(CGFloat length, UIColor *color);

@interface RSOpacitySlider : UISlider

@property (nonatomic) RSColorPickerView *colorPicker;

@end
