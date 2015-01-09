//
//  ComObscureTiCarouselCarouselViewProxy.m
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import "ComObscureTiCarouselCarouselViewProxy.h"
#import "ComObscureTiCarouselCarouselView.h"
#import "TransformParser.h"

#define kCarouselEventObjectName @"carousel"
#define kCarouselScrollEvent @"scroll"
#define kCarouselChangeEvent @"change"
#define kCarouselSelectEvent @"select"


@interface ComObscureTicarouselCarouselViewProxy (PrivateMethods)
@property (nonatomic, readonly) iCarousel * carousel;
@end


@implementation ComObscureTicarouselCarouselViewProxy

@synthesize itemWidth=_itemWidth;
@synthesize numberOfVisibleItems=_numberOfVisibleItems;
@synthesize wrap=_wrap;
@synthesize doubleSided=_doubleSided;
@synthesize itemTransformForOffset=_itemTransformForOffset;
@synthesize itemAlphaForOffset=_itemAlphaForOffset;
@synthesize transformOptions=_transformOptions;

- (id)init {
    if (self = [super init]) {
        self.wrap = false;
        self.itemWidth = 0;
        self.numberOfVisibleItems = 3;
        self.doubleSided = [NSNumber numberWithBool:YES];
        
        transformOptionNames = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"angle", [NSNumber numberWithInt:iCarouselOptionAngle],
                                @"arc", [NSNumber numberWithInt:iCarouselOptionArc],
                                @"count", [NSNumber numberWithInt:iCarouselOptionCount],
                                @"radius", [NSNumber numberWithInt:iCarouselOptionRadius],
                                @"spacing", [NSNumber numberWithInt:iCarouselOptionSpacing],
                                @"tilt", [NSNumber numberWithInt:iCarouselOptionTilt],
                                @"yoffset", [NSNumber numberWithInt:iCarouselOptionExYOffset],
                                @"zoffset", [NSNumber numberWithInt:iCarouselOptionExZOffset], nil];
    }
    return self;
}

- (void)dealloc {
    // clean up views
	pthread_rwlock_destroy(&viewsLock);
	[viewProxies makeObjectsPerformSelector:@selector(setParent:) withObject:nil];
	//[viewProxies release];
    //[transformOptionNames release];
    //[super dealloc];
}

- (iCarousel *)carousel {
    return ((ComObscureTicarouselCarouselViewProxy *)[self view]).carousel;
}

#pragma mark View Management

- (void)lockViews {
	pthread_rwlock_rdlock(&viewsLock);
}

- (void)lockViewsForWriting {
	pthread_rwlock_wrlock(&viewsLock);
}

- (void)unlockViews {
	pthread_rwlock_unlock(&viewsLock);
}

#pragma mark -
#pragma mark Public API

#pragma mark Titanium-specific Methods

- (void)setViews:(id)args {
	ENSURE_ARRAY(args);
	for (id newViewProxy in args) {
		[self rememberProxy:newViewProxy];
        [newViewProxy view].layer.doubleSided = [self.doubleSided boolValue];
	}
	[self lockViewsForWriting];
	for (id oldViewProxy in viewProxies) {
		if (![args containsObject:oldViewProxy]) {
			[self forgetProxy:oldViewProxy];
		}
	}
//	[viewProxies autorelease];
	viewProxies = [args mutableCopy];
	[self unlockViews];
	[self replaceValue:args forKey:@"views" notification:YES];
}

- (void)childWillResize:(TiViewProxy *)child {
	BOOL hasChild = [[self children] containsObject:child];
    
	if (!hasChild) {
		return;
		//In the case of views added with addView, as they are not part of children, they should be ignored.
	}
	[super childWillResize:child];
}

// TODO placeholders

#pragma mark iCarousel Properties

- (id)currentItemIndex {
    return NUMINT(self.carousel.currentItemIndex);
}

- (id)carouselType {
    return NUMINT(self.carousel.type);
}

- (void)setCarouselType:(id)val {
    ENSURE_UI_THREAD(setCarouselType, val)
    int type = [TiUtils intValue:val];
    if (type > iCarouselTypeCustom) {
        extendedType = type;
        self.carousel.type = iCarouselTypeCustom;
    }
    else {
        extendedType = -1;
        self.carousel.type = type;
    }
}

- (id)perspective {
    return NUMFLOAT(self.carousel.perspective);
}

- (void)setPerspective:(id)val {
    ENSURE_UI_THREAD(setPerspective, val)
    self.carousel.perspective = [TiUtils floatValue:val];
}

- (id)contentOffset {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            NUMFLOAT(self.carousel.contentOffset.width), @"x",
            NUMFLOAT(self.carousel.contentOffset.height), @"y",
            nil];
}

- (void)setContentOffset:(id)val {
    ENSURE_UI_THREAD(setContentOffset, val)
    ENSURE_TYPE(val, NSDictionary)
    self.carousel.contentOffset = CGSizeMake([TiUtils floatValue:@"x" properties:val def:0.0f], [TiUtils floatValue:@"y" properties:val def:0.0f]);
}

- (id)viewpointOffset {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            NUMFLOAT(self.carousel.viewpointOffset.width), @"x",
            NUMFLOAT(self.carousel.viewpointOffset.height), @"y",
            nil];
}

- (void)setViewpointOffset:(id)val {
    ENSURE_UI_THREAD(setViewpointOffset, val)
    ENSURE_TYPE(val, NSDictionary)
    self.carousel.viewpointOffset = CGSizeMake([TiUtils floatValue:@"x" properties:val def:0.0f], [TiUtils floatValue:@"y" properties:val def:0.0f]);
}

- (id)decelerationRate {
    return NUMFLOAT(self.carousel.decelerationRate);
}

- (void)setDecelerationRate:(id)val {
    ENSURE_UI_THREAD(setDecelerationRate, val)
    self.carousel.decelerationRate = [TiUtils floatValue:val];
}

- (id)bounces {
    return NUMBOOL(self.carousel.bounces);
}

- (void)setBounces:(id)val {
    ENSURE_UI_THREAD(setBounces, val)
    self.carousel.bounces = [TiUtils boolValue:val];
}

- (id)bounceDistance {
    return NUMFLOAT(self.carousel.bounceDistance);
}

- (void)setBounceDistance:(id)val {
    ENSURE_UI_THREAD(setBounceDistance, val)
    self.carousel.bounceDistance = [TiUtils floatValue:val];
}

- (id)scrollEnabled {
    return NUMBOOL(self.carousel.scrollEnabled);
}

- (void)setScrollEnabled:(id)val {
    ENSURE_UI_THREAD(setScrollEnabled, val)
    self.carousel.scrollEnabled = [TiUtils boolValue:val];
}

- (id)numberOfItems {
    return NUMINT(self.carousel.numberOfItems);
}

- (id)numberOfPlaceholders {
    return NUMINT(self.carousel.numberOfPlaceholders);
}

- (id)scrollOffset {
    return NUMFLOAT(self.carousel.scrollOffset);
}

- (id)offsetMultiplier {
    return NUMFLOAT(self.carousel.offsetMultiplier);
}

- (id)currentItemView {
    return self.carousel.currentItemView;
}

- (id)centerItemWhenSelected {
    return NUMBOOL(self.carousel.centerItemWhenSelected);
}

- (void)setCenterItemWhenSelected:(id)val {
    ENSURE_UI_THREAD(setCenterItemWhenSelected, val)
    self.carousel.centerItemWhenSelected = [TiUtils boolValue:val];
}

- (id)scrollSpeed {
    return NUMFLOAT(self.carousel.scrollSpeed);
}

- (void)setScrollSpeed:(id)val {
    self.carousel.scrollSpeed = [TiUtils floatValue:val];
}

- (id)stopAtItemBoundary {
    return NUMBOOL(self.carousel.stopAtItemBoundary);
}

- (void)setStopAtItemBoundary:(id)val {
    ENSURE_UI_THREAD(setStopAtItemBoundary, val)
    self.carousel.stopAtItemBoundary = [TiUtils boolValue:val];
}

- (id)scrollToItemBoundary {
    return NUMBOOL(self.carousel.scrollToItemBoundary);
}

- (void)setScrollToItemBoundary:(id)val {
    ENSURE_UI_THREAD(setScrollToItemBoundary, val)
    self.carousel.scrollToItemBoundary = [TiUtils boolValue:val];
}

- (id)vertical {
    return NUMBOOL(self.carousel.vertical);
}

- (void)setVertical:(id)val {
    ENSURE_UI_THREAD(setVertical, val)
    self.carousel.vertical = [TiUtils boolValue:val];
}

- (id)ignorePerpendicularSwipes {
    return NUMBOOL(self.carousel.ignorePerpendicularSwipes);
}

- (void)setIgnorePerpendicularSwipes:(id)val {
    ENSURE_UI_THREAD(setIgnorePerpendicularSwipes, val)
    self.carousel.ignorePerpendicularSwipes = [TiUtils boolValue:val];
}

- (id)clipsToBounds {
    return NUMBOOL(self.carousel.clipsToBounds);
}

- (void)setClipsToBounds:(id)val {
    ENSURE_UI_THREAD(setClipsToBounds, val)
    self.carousel.clipsToBounds = [TiUtils boolValue:val];
}


#pragma mark iCarousel Methods

// both scrollToItemAtIndex variants are supported:
// - (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;
// - (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)scrollDuration;
- (void)scrollToIndex:(id)args {
    ENSURE_UI_THREAD(scrollToIndex, args);
    
    NSNumber * index;
    NSDictionary * options;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber);
    ENSURE_ARG_OR_NIL_AT_INDEX(options, args, 1, NSDictionary)
    
    BOOL animated = [TiUtils boolValue:@"animated" properties:options def:YES];
    float duration = [TiUtils floatValue:@"duration" properties:options def:-1.0];
    
    if (duration < 0.0) {
        [self.carousel scrollToItemAtIndex:[index integerValue] animated:animated];
    }
    else {
        [self.carousel scrollToItemAtIndex:[index integerValue] duration:duration];
    }    
}

// - (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollByNumberOfItems:(id)args {
    ENSURE_UI_THREAD(scrollByNumberOfItems, args)
    
    NSNumber * itemCount;
    NSNumber * duration;
    ENSURE_ARG_AT_INDEX(itemCount, args, 0, NSNumber);
    ENSURE_ARG_AT_INDEX(duration, args, 1, NSNumber);
    
    [self.carousel scrollToItemAtIndex:[itemCount integerValue] duration:[duration floatValue]];
}

- (void)reloadData:(id)args {
    ENSURE_UI_THREAD(reloadData, args)
    [self.carousel reloadData];
}

- (id)itemViewAtIndex:(id)args {
    ENSURE_UI_THREAD(itemViewAtIndex, args)
    
    NSNumber * index;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber);
    
    return [self.carousel itemViewAtIndex:[index integerValue]];
}

- (id)indexOfItemView:(id)args {
    ENSURE_UI_THREAD(indexOfItemView, args)
    
    TiUIView * v;
    ENSURE_ARG_AT_INDEX(v, args, 0, TiUIView)
    
    NSInteger result = [self.carousel indexOfItemView:v];
    return result != NSNotFound ? NUMINT(result) : nil;
}

- (id)indexOfItemViewOrSubview:(id)args {
    ENSURE_UI_THREAD(indexOfItemViewOrSubview, args)
    
    TiUIView * v;
    ENSURE_ARG_AT_INDEX(v, args, 0, TiUIView)
    
    return NUMINT([self.carousel indexOfItemViewOrSubview:v]);
}

- (id)offsetForItemAtIndex:(id)args {
    ENSURE_UI_THREAD(offsetForItemAtIndex, args)
    
    NSNumber * index;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber)
    
    return NUMFLOAT([self.carousel offsetForItemAtIndex:[index integerValue]]);
}

- (id)removeItemAtIndex:(id)args {
    ENSURE_UI_THREAD(removeItemAtIndex, args)
    
    NSNumber * index;
    NSNumber * animated;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber)
    ENSURE_ARG_OR_NIL_AT_INDEX(animated, args, 1, NSNumber)
    
    [self.carousel removeItemAtIndex:[index integerValue] animated:[animated boolValue]];
}

- (id)insertItemAtIndex:(id)args {
    ENSURE_UI_THREAD(insertItemAtIndex, args)
    
    NSNumber * index;
    NSNumber * animated;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber)
    ENSURE_ARG_OR_NIL_AT_INDEX(animated, args, 1, NSNumber)
    
    [self.carousel insertItemAtIndex:[index integerValue] animated:[animated boolValue]];
}

- (id)reloadItemAtIndex:(id)args {
    ENSURE_UI_THREAD(reloadItemAtIndex, args)
    
    NSNumber * index;
    NSNumber * animated;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber)
    ENSURE_ARG_OR_NIL_AT_INDEX(animated, args, 1, NSNumber)
    
    [self.carousel reloadItemAtIndex:[index integerValue] animated:[animated boolValue]];
}

#pragma mark -
#pragma mark iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [viewProxies count];
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel {
    return self.numberOfVisibleItems;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)_view {
    // since we build the views in js-land, we don't reuse anything here
    TiViewProxy * proxy = [viewProxies objectAtIndex:index];
    return proxy.view;
}

#pragma mark -
#pragma mark iCarouselDelegate

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return self.itemWidth;
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel {
    return [self.wrap boolValue];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForTransformOption:(iCarouselOption)option withDefault:(CGFloat)value {
    NSString * name = [transformOptionNames objectForKey:[NSNumber numberWithInt:option]];
    id result = [self.transformOptions objectForKey:name];
    return result ? [result floatValue] : value;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset {
    CGFloat result = 1.0f;
    
    switch (extendedType) {
        case iCarouselTypeExBump:
        {
            CGFloat o = ABS(offset);
            result = o < 1.0 ? (1.0 - 0.4 * o) : 0.6;
        }
        default:
            if (self.itemAlphaForOffset) {
                NSArray * args = [NSArray arrayWithObject:NUMFLOAT(offset)];
                result = [[self.itemAlphaForOffset call:args thisObject:nil] floatValue];
            }
    }
    
    return result;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    switch (extendedType) {
        case iCarouselTypeExBump:
        {
            CGFloat dx = _carousel.itemWidth * offset;
            CGFloat dy = [self carousel:_carousel valueForTransformOption:iCarouselOptionExYOffset withDefault:(_carousel.itemWidth * -0.95f)];
            CGFloat dz = [self carousel:_carousel valueForTransformOption:iCarouselOptionExZOffset withDefault:(_carousel.itemWidth * -3.0f)];

            CGFloat o = ABS(offset);
            if (o < 1.0) {
                dy *= o;
                dz *= o;
            }
            transform = CATransform3DTranslate(transform, dx, dy, dz);
        }
        default:
        {
            NSArray * args = [NSArray arrayWithObject:NUMFLOAT(offset)];
            NSArray * result = [self.itemTransformForOffset call:args thisObject:nil];
            transform = [TransformParser addTransforms:result toTransform:transform];
        }
    }
    
    return transform;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    NSDictionary * obj = [NSDictionary dictionaryWithObjectsAndKeys:
                          NUMINT(carousel.currentItemIndex), @"currentIndex",
                          nil];
    [self fireEvent:kCarouselScrollEvent withObject:obj];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    NSDictionary * obj = [NSDictionary dictionaryWithObjectsAndKeys:
                          NUMINT(carousel.currentItemIndex), @"currentIndex",
                          nil];
    [self fireEvent:kCarouselChangeEvent withObject:obj];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    NSDictionary * obj = [NSDictionary dictionaryWithObjectsAndKeys:
                          NUMINT(index), @"selectedIndex",
                          NUMINT(carousel.currentItemIndex), @"currentIndex",
                          nil];
    [self fireEvent:kCarouselSelectEvent withObject:obj];
}

@end
