//
//  ComObscureTiCarouselCarouselViewProxy.h
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiViewProxy.h"
#import "iCarousel.h"
#import "iCarouselEx.h"


@interface  ComObscureTicarouselCarouselViewProxy : TiViewProxy <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) NSNumber * itemWidth;
@property (nonatomic, strong) NSDictionary * transformOptions;
@property (nonatomic, strong) NSNumber * wrap;

// custom transforms
@property (nonatomic, strong) KrollCallback * itemTransformForOffset;
@property (nonatomic, strong) KrollCallback * itemAlphaForOffset;

@end
