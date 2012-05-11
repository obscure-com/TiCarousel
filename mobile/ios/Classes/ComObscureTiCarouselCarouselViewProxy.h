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
    NSInteger horizontalPadding;
}
@end
