//
//  BitmapContextManip.m
//  ImageBitmapRep
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "BitmapContextManipulator.h"

@implementation BitmapContextManipulator

@synthesize bitmapContext;

- (id)initWithContext:(BitmapContextRep *)aContext {
	if ((self = [super init])) {
		self.bitmapContext = aContext;
	}
	return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	[anInvocation invokeWithTarget:bitmapContext];
}

#if __has_feature(objc_arc) != 1

- (void)dealloc {
	self.bitmapContext = nil;
	[super dealloc];
}

#endif

@end
