//
//  CGContextCreator.h
//  ImageBitmapRep
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <Foundation/Foundation.h>

/**
 * This class has several static methods for creating bitmap contexts.
 * These methods are pretty much only called when creating a new
 * ANImageBitmapRep.
 */
@interface CGContextCreator : NSObject {
    
}

+ (CGContextRef)newARGBBitmapContextWithSize:(CGSize)size;
+ (CGContextRef)newARGBBitmapContextWithImage:(CGImageRef)image;

@end
