//
//  ComObscureTiCarouselCarouselView.m
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import "ComObscureTiCarouselCarouselView.h"

@implementation ComObscureTiCarouselCarouselView

@synthesize carousel=_carousel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds {
    [super frameSizeChanged:frame bounds:bounds];
    [TiUtils setView:self.carousel positionRect:bounds];
}


- (iCarousel *)carousel {
    if (!_carousel) {
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height)];
        _carousel.type = iCarouselTypeLinear;
        _carousel.delegate = self;
        _carousel.dataSource = self;
        
        _carousel.clipsToBounds = YES; // never overflow the carousel bounds
    }
    if (_carousel.superview != self) {
        [self addSubview:_carousel];
    }
    return _carousel;
}

#pragma mark -
#pragma mark View Proxy Methods



#pragma mark -
#pragma mark iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 5;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    if (!view) {
        // temporary test view
        view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
        view.backgroundColor = [UIColor greenColor];
    }
    return view;
}


#pragma mark -
#pragma mark iCarouselDelegate

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return 45;
}

@end
