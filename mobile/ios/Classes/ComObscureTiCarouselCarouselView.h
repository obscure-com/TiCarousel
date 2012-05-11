//
//  ComObscureTiCarouselCarouselView.h
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import "TiUIView.h"
#import "iCarousel.h"

@interface ComObscureTiCarouselCarouselView : TiUIView <iCarouselDataSource, iCarouselDelegate> {
}
@property (nonatomic, strong) iCarousel * carousel;

#pragma mark iCarousel
// TODO iCarousel methods

@end
