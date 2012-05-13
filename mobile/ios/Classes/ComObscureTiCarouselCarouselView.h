//
//  ComObscureTiCarouselCarouselView.h
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import "TiUIView.h"
#import "iCarousel.h"

@interface ComObscureTiCarouselCarouselView : TiUIView <iCarouselDelegate>
@property (nonatomic, strong) iCarousel * carousel;

#pragma mark Public API

- (void)scrollToIndex:(id)args;
- (void)scrollByNumberOfItems:(id)args;
- (void)reloadData:(id)args;
- (id)itemViewAtIndex:(id)args;
- (id)indexOfItemView:(id)args;
- (id)indexOfItemViewOrSubview:(id)args;
- (id)offsetForItemAtIndex:(id)args;
- (void)removeItemAtIndex:(id)args;
- (void)insertItemAtIndex:(id)args;
- (void)reloadItemAtIndex:(id)args;
@end
