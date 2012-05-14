//
//  ComObscureTiCarouselCarouselView.m
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import "ComObscureTiCarouselCarouselView.h"

#define kCarouselEventObjectName @"carousel"
#define kCarouselScrollEvent @"scroll"
#define kCarouselChangeEvent @"change"

#define PROXY_FLOAT_GETTER

@implementation ComObscureTiCarouselCarouselView

@synthesize carousel=_carousel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)dealloc {
    self.carousel.delegate = nil;
    self.carousel.dataSource = nil;
    
    [super dealloc];
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds {
    [super frameSizeChanged:frame bounds:bounds];
    [TiUtils setView:self.carousel positionRect:bounds];
}


- (iCarousel *)carousel {
    if (!_carousel) {
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height)];
        _carousel.type = iCarouselTypeLinear;
        _carousel.delegate = (id<iCarouselDelegate>) self.proxy;
        _carousel.dataSource = (id<iCarouselDataSource>) self.proxy;
        
        _carousel.clipsToBounds = YES; // never overflow the carousel bounds
    }
    if (_carousel.superview != self) {
        [self addSubview:_carousel];
    }
    return _carousel;
}

#pragma mark -
#pragma mark Public Properties

- (id)index_ {
    return NUMINT(self.carousel.currentItemIndex);
}

- (void)setCarouselType_:(id)val {
    self.carousel.type = [TiUtils intValue:val];
}

- (id)carouselType_ {
    return NUMINT(self.carousel.type);
}

- (void)setPerspective_:(id)val {
    self.carousel.perspective = [TiUtils floatValue:val];
}

- (id)perspective_ {
    return NUMFLOAT(self.carousel.perspective);
}

- (void)setContentOffset_:(id)val {
    ENSURE_TYPE(val, NSDictionary)
    self.carousel.contentOffset = CGSizeMake([TiUtils floatValue:@"width" properties:val def:0.0f], [TiUtils floatValue:@"height" properties:val def:0.0f]);
}

- (id)contentOffset_ {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            NUMFLOAT(self.carousel.contentOffset.width), @"width",
            NUMFLOAT(self.carousel.contentOffset.height), @"height",
            nil];
}

- (void)setViewpointOffset_:(id)val {
    ENSURE_TYPE(val, NSDictionary)
    self.carousel.viewpointOffset = CGSizeMake([TiUtils floatValue:@"width" properties:val def:0.0f], [TiUtils floatValue:@"height" properties:val def:0.0f]);
}

- (id)viewpointOffset_ {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            NUMFLOAT(self.carousel.viewpointOffset.width), @"width",
            NUMFLOAT(self.carousel.viewpointOffset.height), @"height",
            nil];
}

- (void)setDecelerationRate_:(id)val {
    self.carousel.decelerationRate = [TiUtils floatValue:val];
}

- (id)decelerationRate_ {
    return NUMFLOAT(self.carousel.decelerationRate);
}

- (void)setBounces_:(id)val {
    self.carousel.bounces = [TiUtils boolValue:val];
}

- (id)bounces_ {
    return NUMBOOL(self.carousel.bounces);
}

- (void)setBounceDistance_:(id)val {
    self.carousel.bounceDistance = [TiUtils floatValue:val];
}

- (id)bounceDistance_ {
    return NUMFLOAT(self.carousel.bounceDistance);
}

- (void)setScrollEnabled_:(id)val {
    self.carousel.scrollEnabled = [TiUtils boolValue:val];
}

- (id)scrollEnabled_ {
    return NUMBOOL(self.carousel.scrollEnabled);
}

- (id)numberOfItems_ {
    return NUMINT(self.carousel.numberOfItems);
}

- (id)numberOfPlaceholders_ {
    return NUMINT(self.carousel.numberOfPlaceholders);
}

- (id)numberOfVisibleItems_ {
    return NUMINT(self.carousel.numberOfVisibleItems);
}

- (id)scrollOffset_ {
    return NUMFLOAT(self.carousel.scrollOffset);
}

- (id)offsetMultiplier_ {
    return NUMFLOAT(self.carousel.offsetMultiplier);
}

- (id)currentItemView_ {
    return self.carousel.currentItemView;
}

- (id)itemWidth_ {
    return NUMFLOAT(self.carousel.itemWidth);
}

- (void)setCenterItemWhenSelected_:(id)val {
    self.carousel.centerItemWhenSelected = [TiUtils boolValue:val];
}

- (id)centerItemWhenSelected_ {
    return NUMBOOL(self.carousel.centerItemWhenSelected);
}

- (void)setScrollSpeed_:(id)val {
    self.carousel.scrollSpeed = [TiUtils floatValue:val];
}

- (id)scrollSpeed_ {
    return NUMFLOAT(self.carousel.scrollSpeed);
}

- (void)setStopAtItemBoundary_:(id)val {
    self.carousel.stopAtItemBoundary = [TiUtils boolValue:val];
}

- (id)stopAtItemBoundary_ {
    return NUMBOOL(self.carousel.stopAtItemBoundary);
}

- (void)setScrollToItemBoundary_:(id)val {
    self.carousel.scrollToItemBoundary = [TiUtils boolValue:val];
}

- (id)scrollToItemBoundary_ {
    return NUMBOOL(self.carousel.scrollToItemBoundary);
}

- (void)setVertical_:(id)val {
    self.carousel.vertical = [TiUtils boolValue:val];
}

- (id)vertical_ {
    return NUMBOOL(self.carousel.vertical);
}

- (void)setIgnorePerpendicularSwipes_:(id)val {
    self.carousel.ignorePerpendicularSwipes = [TiUtils boolValue:val];
}

- (id)ignorePerpendicularSwipes_ {
    return NUMBOOL(self.carousel.ignorePerpendicularSwipes);
}

- (void)setClipsToBounds_:(id)val {
    self.carousel.clipsToBounds = [TiUtils boolValue:val];
}

- (id)clipsToBounds_ {
    return NUMBOOL(self.carousel.clipsToBounds);
}


#pragma mark -
#pragma mark Public Methods

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
    
    TiUIView * view;
    ENSURE_ARG_AT_INDEX(view, args, 0, TiUIView)
    
    return NUMINT([self.carousel indexOfItemView:view]);
}

- (id)indexOfItemViewOrSubview:(id)args {
    ENSURE_UI_THREAD(indexOfItemViewOrSubview, args)
    
    TiUIView * view;
    ENSURE_ARG_AT_INDEX(view, args, 0, TiUIView)
    
    return NUMINT([self.carousel indexOfItemViewOrSubview:view]);
}

- (id)offsetForItemAtIndex:(id)args {
    ENSURE_UI_THREAD(offsetForItemAtIndex, args)
    
    NSNumber * index;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber)
    
    return NUMFLOAT([self.carousel offsetForItemAtIndex:[index integerValue]]);
}

- (void)removeItemAtIndex:(id)args {
    ENSURE_UI_THREAD(removeItemAtIndex, args)
    
    NSNumber * index;
    NSNumber * animated;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber)
    ENSURE_ARG_OR_NIL_AT_INDEX(animated, args, 1, NSNumber)
    
    [self.carousel removeItemAtIndex:[index integerValue] animated:[animated boolValue]];
}

- (void)insertItemAtIndex:(id)args {
    ENSURE_UI_THREAD(insertItemAtIndex, args)
    
    NSNumber * index;
    NSNumber * animated;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber)
    ENSURE_ARG_OR_NIL_AT_INDEX(animated, args, 1, NSNumber)
    
    [self.carousel insertItemAtIndex:[index integerValue] animated:[animated boolValue]];
}

- (void)reloadItemAtIndex:(id)args {
    ENSURE_UI_THREAD(reloadItemAtIndex, args)
    
    NSNumber * index;
    NSNumber * animated;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber)
    ENSURE_ARG_OR_NIL_AT_INDEX(animated, args, 1, NSNumber)
    
    [self.carousel reloadItemAtIndex:[index integerValue] animated:[animated boolValue]];
}

@end
