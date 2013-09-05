//
//  ComObscureTiCarouselCarouselView.h
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import "TiUIView.h"
#import "iCarousel.h"

@interface ComObscureTicarouselCarouselView : TiUIView
- (NSInteger)currentItemIndex;
- (CGFloat)scrollOffset;

- (void)setCarouselType:(id)args;
- (void)scrollByNumberOfItems:(id)args;
- (void)scrollToItemAtIndex:(id)args;
@end
