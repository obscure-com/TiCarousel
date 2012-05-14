/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComObscureTiCarouselModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "iCarousel.h"

@implementation ComObscureTiCarouselModule

#pragma mark Internal

-(id)moduleGUID {
	return @"2295ea8d-38ef-4786-b48b-b76c27e14fbb";
}

-(NSString*)moduleId {
	return @"com.obscure.TiCarousel";
}

#pragma mark Lifecycle

-(void)startup {
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender {
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc {
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification {
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Constants

MAKE_SYSTEM_PROP(CAROUSEL_TYPE_LINEAR, iCarouselTypeLinear)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_ROTARY, iCarouselTypeRotary)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_INVERTED_ROTARY, iCarouselTypeInvertedRotary)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_CYLINDER, iCarouselTypeCylinder)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_INVERTED_CYLINDER, iCarouselTypeInvertedCylinder)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_WHEEL, iCarouselTypeWheel)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_INVERTED_WHEEL, iCarouselTypeInvertedWheel)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_COVER_FLOW, iCarouselTypeCoverFlow)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_COVER_FLOW2, iCarouselTypeCoverFlow2)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_TIME_MACHINE, iCarouselTypeTimeMachine)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_INVERTED_TIME_MACHINE, iCarouselTypeInvertedTimeMachine)
MAKE_SYSTEM_PROP(CAROUSEL_TYPE_CUSTOM, iCarouselTypeCustom)

@end
