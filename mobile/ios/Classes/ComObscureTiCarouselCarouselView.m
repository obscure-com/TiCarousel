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

@end
