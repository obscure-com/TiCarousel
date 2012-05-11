//
//  ComObscureTiCarouselCarouselViewProxy.m
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import "ComObscureTiCarouselCarouselViewProxy.h"
#import "ComObscureTiCarouselCarouselView.h"

#define kCarouselEventObjectName @"carousel"
#define kCarouselScrollEvent @"scroll"
#define kCarouselChangeEvent @"change"

NSArray * carouselKeySequence;


@implementation ComObscureTiCarouselCarouselViewProxy

// probably manage the views here

- (void)dealloc {
    RELEASE_TO_NIL(carouselKeySequence)
    [super dealloc];
}

- (NSArray *)keySequence {
    if (!carouselKeySequence) {
        carouselKeySequence = [NSArray arrayWithObjects:nil]; // TODO custom properties
    }
    return carouselKeySequence;
}

#pragma mark -
#pragma mark iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 5;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)_view {
    if (!_view) {
        // temporary test view
        _view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
        _view.backgroundColor = [UIColor greenColor];
    }
    return _view;
}

#pragma mark -
#pragma mark iCarouselDelegate

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return 45;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    NSDictionary * obj = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInteger:carousel.currentItemIndex], @"currentPage",
                          nil];
    [self fireEvent:kCarouselScrollEvent withObject:obj];
}

- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carousel {
    NSDictionary * obj = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInteger:carousel.currentItemIndex], @"currentPage",
                          nil];
    [self fireEvent:kCarouselChangeEvent withObject:obj];
}

@end
