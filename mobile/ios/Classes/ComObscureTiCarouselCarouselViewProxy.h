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

@interface ComObscureTiCarouselCarouselViewProxy : TiViewProxy <iCarouselDataSource,iCarouselDelegate> {
	pthread_rwlock_t viewsLock;
    NSArray * viewProxies;
}
@property (nonatomic, assign) NSInteger itemWidth;
@property (nonatomic, assign) NSUInteger numberOfVisibleItems;
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, assign) BOOL doubleSided;
@property (nonatomic, strong) KrollCallback * itemTransformForOffset;
@property (nonatomic, strong) KrollCallback * itemAlphaForOffset;
@end
