//
//  RSBrightnessSlider.h
//  RSColorPicker
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <Foundation/Foundation.h>

extern CGContextRef RSBitmapContextCreateDefault(CGSize size);

@class RSColorPickerView;

@interface RSBrightnessSlider : UISlider

@property (nonatomic) RSColorPickerView *colorPicker;

@end
