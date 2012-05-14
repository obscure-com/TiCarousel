/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import "iCarousel.h"

@interface ComObscureTiCarouselModule : TiModule 
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_LINEAR;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_ROTARY;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_INVERTED_ROTARY;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_CYLINDER;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_INVERTED_CYLINDER;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_WHEEL;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_INVERTED_WHEEL;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_COVER_FLOW;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_COVER_FLOW2;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_TIME_MACHINE;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_INVERTED_TIME_MACHINE;
@property (nonatomic, readonly) NSNumber * CAROUSEL_TYPE_CUSTOM;
@end
