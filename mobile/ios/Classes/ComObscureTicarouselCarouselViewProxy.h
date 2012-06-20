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

@interface ComObscureTicarouselCarouselViewProxy : TiViewProxy <iCarouselDataSource,iCarouselDelegate> {
	pthread_rwlock_t viewsLock;
    NSArray * viewProxies;
    
    iCarouselTypeEx extendedType;
    NSDictionary * transformOptionNames;
}
@property (nonatomic, assign) NSInteger itemWidth;
@property (nonatomic, assign) NSUInteger numberOfVisibleItems;
@property (nonatomic, assign) NSNumber * wrap;
@property (nonatomic, assign) NSNumber * doubleSided;
@property (nonatomic, retain) NSDictionary * transformOptions;
@property (nonatomic, strong) KrollCallback * itemTransformForOffset;
@property (nonatomic, strong) KrollCallback * itemAlphaForOffset;
@end
