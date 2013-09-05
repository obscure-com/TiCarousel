//
//  ComObscureTiCarouselCarouselView.m
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import "ComObscureTiCarouselCarouselView.h"
#import "ComObscureTicarouselCarouselViewProxy.h"

@interface ComObscureTicarouselCarouselView ()
@property (nonatomic, strong) iCarousel * carousel;
@end

@implementation ComObscureTicarouselCarouselView


- (void)initializeState {
    [super initializeState];
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)visibleBounds {
	if (!CGRectIsEmpty(visibleBounds)) {
        [TiUtils setView:self.carousel positionRect:visibleBounds];
        // TODO resize child views?
	}
    [super frameSizeChanged:frame bounds:visibleBounds];
}

- (iCarousel *)carousel {
    if (!_carousel) {
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height)];
        _carousel.type = iCarouselTypeLinear;
        _carousel.delegate = (id<iCarouselDelegate>) self.proxy;
        _carousel.dataSource = (id<iCarouselDataSource>) self.proxy;
        
        [self addSubview:_carousel];
    }
    return _carousel;
}

#pragma mark -
#pragma mark Auto-Dispatched Properties

- (void)setBounceDistance_:(id)value {
    self.carousel.bounceDistance = [TiUtils floatValue:value def:1.0f];
}

- (void)setBounces_:(id)value {
    self.carousel.bounces = [TiUtils boolValue:value def:YES];
}

- (void)setCenterItemWhenSelected_:(id)value {
    self.carousel.centerItemWhenSelected = [TiUtils boolValue:value def:YES];
}

- (void)setClipsToBounds_:(id)value {
    self.carousel.clipsToBounds = [TiUtils boolValue:value def:NO];
}

- (void)setContentOffset_:(id)value {
    ENSURE_DICT(value)
    CGFloat x = [[value objectForKey:@"x"] floatValue];
    CGFloat y = [[value objectForKey:@"y"] floatValue];
    self.carousel.contentOffset = CGSizeMake(x, y);
}

- (void)setDecelerationRate_:(id)value {
    self.carousel.decelerationRate = [TiUtils floatValue:value def:0.95f];
}

- (void)setIgnorePerpendicularSwipes_:(id)value {
    self.carousel.ignorePerpendicularSwipes = [TiUtils boolValue:value def:YES];
}

- (void)setPerspective_:(id)value {
    self.carousel.perspective = [TiUtils floatValue:value def:(-1.0f/500.0f)];
}

- (void)setScrollEnabled_:(id)value {
    self.carousel.scrollEnabled = [TiUtils boolValue:value def:YES];
}

- (void)setScrollOffset_:(id)value {
    self.carousel.scrollOffset = [TiUtils floatValue:value def:0.0f];
}

- (void)setScrollSpeed_:(id)value {
    self.carousel.scrollSpeed = [TiUtils floatValue:value def:1.0f];
}

- (void)setScrollToItemBoundary_:(id)value {
    self.carousel.scrollToItemBoundary = [TiUtils boolValue:value def:YES];
}

- (void)setStopAtItemBoundary_:(id)value {
    self.carousel.stopAtItemBoundary = [TiUtils boolValue:value def:YES];
}

- (void)setTransformOptions_:(id)value {
    // TODO
}

- (void)setVertical_:(id)value {
    self.carousel.vertical = [TiUtils boolValue:value def:NO];
}

- (void)setViewpointOffset_:(id)value {
    ENSURE_DICT(value)
    CGFloat x = [[value objectForKey:@"x"] floatValue];
    CGFloat y = [[value objectForKey:@"y"] floatValue];
    self.carousel.viewpointOffset = CGSizeMake(x, y);
}

#pragma mark -
#pragma mark Other Properties

- (NSInteger)currentItemIndex {
    return self.carousel.currentItemIndex;
}

- (CGFloat)scrollOffset {
    return self.carousel.scrollOffset;
}

#pragma mark -
#pragma mark Methods

- (void)reloadData {
    TiThreadPerformOnMainThread(^{
        [self.carousel reloadData];
    }, NO);
}

- (void)setCarouselType:(id)value {
    int type = [TiUtils intValue:value def:iCarouselTypeLinear];
    TiThreadPerformOnMainThread(^{
        self.carousel.type = type;
    }, NO);
}



- (void)scrollByNumberOfItems:(id)args {
    NSNumber * ct;
    NSNumber * duration;
    ENSURE_ARG_AT_INDEX(ct, args, 0, NSNumber)
    ENSURE_ARG_AT_INDEX(duration, args, 1, NSNumber)
    
    TiThreadPerformOnMainThread(^{
        [self.carousel scrollByNumberOfItems:[ct integerValue] duration:[duration floatValue]];
    }, NO);
}

- (void)scrollToItemAtIndex:(id)args {
    NSNumber * index;
    NSDictionary * options;
    ENSURE_ARG_AT_INDEX(index, args, 0, NSNumber);
    ENSURE_ARG_OR_NIL_AT_INDEX(options, args, 1, NSDictionary)
    
    NSNumber * animated = [options objectForKey:@"animated"];
    NSNumber * duration = [options objectForKey:@"duration"];
    
    TiThreadPerformOnMainThread(^{
        if (duration) {
            [self.carousel scrollToItemAtIndex:[index integerValue] duration:[duration floatValue]];
        }
        else {
            [self.carousel scrollToItemAtIndex:[index integerValue] animated:[animated boolValue]];
        }
    }, NO);
}

@end
