//
//  NSImage+ANImageBitmapRep.m
//  ImageBitmapRep
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#if TARGET_OS_IPHONE != 1

#import "NSImage+ANImageBitmapRep.h"
#import "ANImageBitmapRep.h"

@implementation NSImage (ANImageBitmapRep)


+ (NSImage *)imageFromImageBitmapRep:(ANImageBitmapRep *)ibr {
	return [ibr image];
}

- (ANImageBitmapRep *)imageBitmapRep {
#if __has_feature(objc_arc) == 1
	return [[ANImageBitmapRep alloc] initWithImage:self];
#else
	return [[[ANImageBitmapRep alloc] initWithImage:self] autorelease];
#endif
}

- (NSImage *)imageByScalingToSize:(CGSize)sz {
	ANImageBitmapRep * imageBitmap = [[ANImageBitmapRep alloc] initWithImage:self];
	[imageBitmap setSize:BMPointMake(round(sz.width), round(sz.height))];
	NSImage * scaled = [imageBitmap image];
#if __has_feature(objc_arc) != 1
	[imageBitmap release];
#endif
	return scaled;
}

- (NSImage *)imageFittingFrame:(CGSize)sz {
	ANImageBitmapRep * imageBitmap = [[ANImageBitmapRep alloc] initWithImage:self];
	[imageBitmap setSizeFittingFrame:BMPointMake(round(sz.width), round(sz.height))];
	NSImage * scaled = [imageBitmap image];
#if __has_feature(objc_arc) != 1
	[imageBitmap release];
#endif
	return scaled;
}

- (NSImage *)imageFillingFrame:(CGSize)sz {
	ANImageBitmapRep * imageBitmap = [[ANImageBitmapRep alloc] initWithImage:self];
	[imageBitmap setSizeFillingFrame:BMPointMake(round(sz.width), round(sz.height))];
	NSImage * scaled = [imageBitmap image];
#if __has_feature(objc_arc) != 1
	[imageBitmap release];
#endif
	return scaled;
}

@end

#endif
