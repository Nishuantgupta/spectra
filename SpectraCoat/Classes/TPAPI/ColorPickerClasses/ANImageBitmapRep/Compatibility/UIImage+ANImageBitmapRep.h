//
//  UIImage+ANImageBitmapRep.h
//  ImageBitmapRep
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#if TARGET_OS_IPHONE

@class ANImageBitmapRep;

#import <UIKit/UIKit.h>

@interface UIImage (ANImageBitmapRep)

#if __has_feature(objc_arc) == 1
+ (UIImage *)imageFromImageBitmapRep:(ANImageBitmapRep *)ibr __attribute__((ns_returns_autoreleased));
- (ANImageBitmapRep *)imageBitmapRep __attribute__((ns_returns_autoreleased));
- (UIImage *)imageByScalingToSize:(CGSize)sz __attribute__((ns_returns_autoreleased));
- (UIImage *)imageFittingFrame:(CGSize)sz __attribute__((ns_returns_autoreleased));
- (UIImage *)imageFillingFrame:(CGSize)sz __attribute__((ns_returns_autoreleased));
#else
+ (UIImage *)imageFromImageBitmapRep:(ANImageBitmapRep *)ibr;
- (ANImageBitmapRep *)imageBitmapRep;
- (UIImage *)imageByScalingToSize:(CGSize)sz;
- (UIImage *)imageFittingFrame:(CGSize)sz;
- (UIImage *)imageFillingFrame:(CGSize)sz;
#endif

@end

#endif
