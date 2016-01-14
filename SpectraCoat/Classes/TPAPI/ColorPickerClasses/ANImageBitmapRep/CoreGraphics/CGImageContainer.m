//
//  CGImageContainer.m
//  ImageBitmapRep
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "CGImageContainer.h"

#if __has_feature(objc_arc) != 1

@implementation CGImageContainer

@synthesize image;

- (id)initWithImage:(CGImageRef)anImage {
	if ((self = [super init])) {
		image = CGImageRetain(anImage);
	}
	return self;
}

+ (CGImageContainer *)imageContainerWithImage:(CGImageRef)anImage {
	CGImageContainer * container = [(CGImageContainer *)[CGImageContainer alloc] initWithImage:anImage];
	return [container autorelease];
}

- (void)dealloc {
	CGImageRelease(image);
	[super dealloc];
}

@end

#else

__attribute__((ns_returns_autoreleased))
id CGImageReturnAutoreleased (CGImageRef original) {
	// CGImageRetain(original);
	return (__bridge id)original;
}

#endif
