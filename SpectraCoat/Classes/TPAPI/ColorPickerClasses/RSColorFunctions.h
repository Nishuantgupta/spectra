//
//  RSColorFunctions.h
//  RSColorPicker
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <UIKit/UIKit.h>
#import "ANImageBitmapRep.h"

BMPixel RSPixelFromHSV(CGFloat H, CGFloat S, CGFloat V);
void RSHSVFromPixel(BMPixel pixel, CGFloat *h, CGFloat *s, CGFloat *v);

void RSGetComponentsForColor(float components[3], UIColor *color);

CGSize RSCGSizeWithScale(CGSize size, CGFloat scale);
CGPoint RSCGPointWithScale(CGPoint point, CGFloat scale);
UIImage* RSUIImageWithScale(UIImage *img, CGFloat scale);
