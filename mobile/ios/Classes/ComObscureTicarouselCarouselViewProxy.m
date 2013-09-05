//
//  ComObscureTiCarouselCarouselViewProxy.m
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/10/12.
//  Copyright (c) 2012 Paul Mietz Egli. All rights reserved.
//

#import "ComObscureTiCarouselCarouselViewProxy.h"
#import "ComObscureTiCarouselCarouselView.h"
#import "TransformParser.h"

#define kCarouselEventObjectName @"carousel"
#define kCarouselScrollEvent @"scroll"
#define kCarouselChangeEvent @"change"
#define kCarouselSelectEvent @"select"

@interface ComObscureTicarouselCarouselViewProxy () {
    pthread_rwlock_t viewsLock;
    iCarouselTypeEx extendedType;
}

@property (nonatomic, strong) NSMutableArray * viewProxies;

- (void)lockViews;
- (void)unlockViews;
- (void)lockViewsForWriting;

@end

@implementation ComObscureTicarouselCarouselViewProxy

- (void)_initWithProperties:(NSDictionary *)properties {
    pthread_rwlock_init(&viewsLock, NULL);
    
    // initialize all properties that are delegated to the view
    [self initializeProperty:@"bounceDistance" defaultValue:NUMFLOAT(1.0f)];
    [self initializeProperty:@"bounces" defaultValue:NUMBOOL(YES)];
    [self initializeProperty:@"centerItemWhenSelected" defaultValue:NUMBOOL(YES)];
    [self initializeProperty:@"clipsToBounds" defaultValue:NUMBOOL(YES)];
    [self initializeProperty:@"contentOffset" defaultValue:@{@"x":NUMFLOAT(0.0f), @"y":NUMFLOAT(0.0f)}];
    [self initializeProperty:@"decelerationRate" defaultValue:NUMFLOAT(0.95f)];
    [self initializeProperty:@"ignorePerpendicularSwipes" defaultValue:NUMBOOL(YES)];
    [self initializeProperty:@"perspective" defaultValue:NUMFLOAT(-1.0f/500.0f)];
    [self initializeProperty:@"scrollEnabled" defaultValue:NUMBOOL(YES)];
    [self initializeProperty:@"scrollSpeed" defaultValue:NUMFLOAT(1.0f)];
    [self initializeProperty:@"scrollToItemBoundary" defaultValue:NUMBOOL(YES)];
    [self initializeProperty:@"stopAtItemBoundary" defaultValue:NUMBOOL(YES)];
    [self initializeProperty:@"transformOptions" defaultValue:@{}];
    [self initializeProperty:@"carouselType" defaultValue:NUMINT(iCarouselTypeLinear)];
    [self initializeProperty:@"vertical" defaultValue:NUMBOOL(NO)];
    [self initializeProperty:@"viewpointOffset" defaultValue:@{@"x":NUMFLOAT(0.0f), @"y":NUMFLOAT(0.0f)}];
    
    [super _initWithProperties:properties];
}

- (void)dealloc {
    pthread_rwlock_destroy(&viewsLock);
	[self.viewProxies makeObjectsPerformSelector:@selector(setParent:) withObject:nil];
	[super dealloc];
}

#pragma mark View Management

- (void)lockViews {
    pthread_rwlock_rdlock(&viewsLock);
}

- (void)lockViewsForWriting {
	pthread_rwlock_wrlock(&viewsLock);
}

- (void)unlockViews {
	pthread_rwlock_unlock(&viewsLock);
}

- (NSArray *)items {
	[self lockViews];
	NSArray * result = [self.viewProxies copy];
	[self unlockViews];
	return [result autorelease];
}

- (void)setItems:(id)args {
	ENSURE_ARRAY(args);
	for (id newViewProxy in args) {
		[self rememberProxy:newViewProxy];
		[newViewProxy setParent:self];
	}
	[self lockViewsForWriting];
	for (id oldViewProxy in self.viewProxies) {
		if (![args containsObject:oldViewProxy]) {
			[oldViewProxy setParent:nil];
			TiThreadPerformOnMainThread(^{[oldViewProxy detachView];}, NO);
			[self forgetProxy:oldViewProxy];
		}
	}
	self.viewProxies = [args mutableCopy];
	[self unlockViews];
	[self replaceValue:args forKey:@"views" notification:YES];
	[self makeViewPerformSelector:@selector(reloadData) withObject:nil createIfNeeded:YES waitUntilDone:NO];
}

- (void)addItem:(id)args {
	ENSURE_SINGLE_ARG(args,TiViewProxy);
    
	[self lockViewsForWriting];
	[self rememberProxy:args];
	[args setParent:self];
	if (self.viewProxies) {
		[self.viewProxies addObject:args];
	}
	else {
		self.viewProxies = [[NSMutableArray alloc] initWithObjects:args,nil];
	}
	[self unlockViews];
	[self makeViewPerformSelector:@selector(reloadData) withObject:nil createIfNeeded:YES waitUntilDone:NO];
}

- (void)insertItemAtIndex:(id)args {
    TiViewProxy * viewProxy;
    NSNumber * index;
    ENSURE_ARG_AT_INDEX(viewProxy, args, 0, TiViewProxy)
    ENSURE_ARG_AT_INDEX(index, args, 1, NSNumber)
    
    int i = [index intValue];
    
	[self lockViewsForWriting];
	[self rememberProxy:viewProxy];
	[viewProxy setParent:self];
	if (self.viewProxies) {
        if (i >= 0 && i < [self.viewProxies count]) {
            [self.viewProxies insertObject:viewProxy atIndex:[index integerValue]];
        }
        else {
            [self.viewProxies addObject:viewProxy];
        }
	}
	else {
		self.viewProxies = [[NSMutableArray alloc] initWithObjects:viewProxy,nil];
	}
	[self unlockViews];
	[self makeViewPerformSelector:@selector(reloadData) withObject:nil createIfNeeded:YES waitUntilDone:NO];
}

-(void)removeItem:(id)args {
	ENSURE_SINGLE_ARG(args,NSObject);
    
	[self lockViewsForWriting];
	TiViewProxy * doomedView;
	if ([args isKindOfClass:[TiViewProxy class]]) {
		doomedView = args;
        
		if (![self.viewProxies containsObject:doomedView]) {
			[self unlockViews];
			[self throwException:@"view not in the carousel" subreason:nil location:CODELOCATION];
			return;
		}
	}
	else if ([args respondsToSelector:@selector(intValue)]) {
		int doomedIndex = [args intValue];
		if ((doomedIndex >= 0) && (doomedIndex < [self.viewProxies count])) {
			doomedView = [self.viewProxies objectAtIndex:doomedIndex];
		}
		else {
			[self unlockViews];
			[self throwException:TiExceptionRangeError subreason:@"invalid item index" location:CODELOCATION];
			return;
		}
	}
	else {
		[self unlockViews];
		[self throwException:TiExceptionInvalidType subreason:
         [NSString stringWithFormat:@"argument needs to be a number or view, but was %@ instead.",
          [args class]] location:CODELOCATION];
		return;
	}
    
	TiThreadPerformOnMainThread(^{[doomedView detachView];}, NO);
	[self forgetProxy:doomedView];
	[self.viewProxies removeObject:doomedView];
	[self unlockViews];
	[self makeViewPerformSelector:@selector(reloadData) withObject:nil createIfNeeded:YES waitUntilDone:NO];
}

#pragma mark -
#pragma mark Resizing

- (void)childWillResize:(TiViewProxy *)child {
	BOOL hasChild = [[self children] containsObject:child];
	if (!hasChild) {
		return;
		//In the case of views added with addView, as they are not part of children, they should be ignored.
	}
	[super childWillResize:child];
}

- (void)willChangeSize {
    //Ensure the size change signal goes to children
    for (TiViewProxy * child in self.viewProxies) {
        [child parentSizeWillChange];
    }
    [super willChangeSize];
}

- (CGFloat)autoWidthForSize:(CGSize)size {
    CGFloat result = 0.0;
    for (TiViewProxy * thisChildProxy in self.viewProxies) {
        CGFloat thisWidth = [thisChildProxy minimumParentWidthForSize:size];
        if (result < thisWidth) {
            result = thisWidth;
        }
    }
    return result;
}

- (CGFloat)autoHeightForSize:(CGSize)size {
    CGFloat result = 0.0;
    for (TiViewProxy * thisChildProxy in self.viewProxies) {
        CGFloat thisHeight = [thisChildProxy minimumParentHeightForSize:size];
        if (result < thisHeight) {
            result = thisHeight;
        }
    }
    return result;
}

#pragma mark -
#pragma mark Properties

- (id)currentItemIndex {
    return NUMINT([(ComObscureTicarouselCarouselView *)self.view currentItemIndex]);
}

- (id)currentItemView {
    // n.b. returns the view proxy, not the UIView
    NSInteger index = [(ComObscureTicarouselCarouselView *)self.view currentItemIndex];
    return (index >= 0 && index < [self.viewProxies count]) ? [self.viewProxies objectAtIndex:index] : nil;
}

- (id)itemWidth {
    if (!_itemWidth && [self.viewProxies count] > 0) {
        TiViewProxy * viewProxy = [self.viewProxies objectAtIndex:0];
        _itemWidth = [NSNumber numberWithFloat:viewProxy.view.bounds.size.width];
    }
    return _itemWidth;
}

- (id)numberOfItems {
    return NUMINT([self.viewProxies count]);
}

- (id)scrollOffset {
    return NUMFLOAT([(ComObscureTicarouselCarouselView *)self.view scrollOffset]);
}

- (void)setCarouselType:(id)val {
    int type = [TiUtils intValue:val];
    if (type > iCarouselTypeCustom) {
        extendedType = type;
        [self makeViewPerformSelector:@selector(setCarouselType:) withObject:[NSNumber numberWithInt:iCarouselTypeCustom] createIfNeeded:YES waitUntilDone:NO];
    }
    else {
        extendedType = -1;
        [self makeViewPerformSelector:@selector(setCarouselType:) withObject:val createIfNeeded:YES waitUntilDone:NO];
    }
}

#pragma mark -
#pragma mark Methods

- (void)reloadData:(id)args {
    [self makeViewPerformSelector:@selector(reloadData) withObject:nil createIfNeeded:YES waitUntilDone:NO];
}

- (void)scrollByNumberOfItems:(id)args {
    [self makeViewPerformSelector:@selector(scrollByNumberOfItems:) withObject:args createIfNeeded:YES waitUntilDone:NO];
}

- (void)scrollToIndex:(id)args {
    [self makeViewPerformSelector:@selector(scrollToItemAtIndex:) withObject:args createIfNeeded:YES waitUntilDone:NO];
}

#pragma mark -
#pragma mark iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.viewProxies count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    TiViewProxy * viewProxy = [self.viewProxies objectAtIndex:index];
    return viewProxy.view;
}

#pragma mark -
#pragma mark iCarouselDelegate

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return [self.itemWidth floatValue];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    CGFloat result = value;
    switch (option) {
        case iCarouselOptionAngle:
            // angle depends on offset, maybe remove it?
            result = [TiUtils floatValue:self.transformOptions[@"angle"] def:value];
            break;
        case iCarouselOptionArc:
            result = [TiUtils floatValue:self.transformOptions[@"arc"] def:value];
            break;
        case iCarouselOptionCount:
            result = [TiUtils floatValue:self.transformOptions[@"count"] def:value];
            break;
        case iCarouselOptionFadeMax:
            result = [TiUtils floatValue:self.transformOptions[@"fadeMax"] def:value];
            break;
        case iCarouselOptionFadeMin:
            result = [TiUtils floatValue:self.transformOptions[@"fadeMin"] def:value];
            break;
        case iCarouselOptionFadeRange:
            result = [TiUtils floatValue:self.transformOptions[@"fadeRange"] def:value];
            break;
        case iCarouselOptionOffsetMultiplier:
            result = [TiUtils floatValue:self.transformOptions[@"offsetMultiplier"] def:value];
            break;
        case iCarouselOptionRadius:
            result = [TiUtils floatValue:self.transformOptions[@"radius"] def:value];
            break;
        case iCarouselOptionShowBackfaces:
            result = [TiUtils floatValue:self.transformOptions[@"showBackfaces"] def:value];
            break;
        case iCarouselOptionSpacing:
            result = [TiUtils floatValue:self.transformOptions[@"spacing"] def:value];
            break;
        case iCarouselOptionTilt:
            result = [TiUtils floatValue:self.transformOptions[@"tilt"] def:value];
            break;
        case iCarouselOptionVisibleItems:
            result = [TiUtils floatValue:self.transformOptions[@"visibleItems"] def:value];
            break;
        case iCarouselOptionWrap:
            result = [self.wrap floatValue];
            break;
    }
    return result;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    switch (extendedType) {
        case iCarouselTypeExBump:
        {
            CGFloat dx = carousel.itemWidth * offset;
            CGFloat dy = [TiUtils floatValue:self.transformOptions[@"yoffset"] def:(carousel.itemWidth * -0.95f)];
            CGFloat dz = [TiUtils floatValue:self.transformOptions[@"zoffset"] def:(carousel.itemWidth * -3.0f)];
            
            CGFloat o = ABS(offset);
            if (o < 1.0) {
                dy *= o;
                dz *= o;
            }
            transform = CATransform3DTranslate(transform, dx, dy, dz);
        }
        default:
        {
            NSArray * args = [NSArray arrayWithObject:NUMFLOAT(offset)];
            NSArray * result = [self.itemTransformForOffset call:args thisObject:nil];
            transform = [TransformParser addTransforms:result toTransform:transform];
        }
    }
    
    return transform;
}

#pragma mark Events

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    [self fireEvent:kCarouselSelectEvent withObject:@{ @"selectedIndex": NUMINT(index), @"currentIndex": NUMINT(carousel.currentItemIndex) }];
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    [self fireEvent:kCarouselScrollEvent withObject:@{@"currentIndex": [NSNumber numberWithInt:carousel.currentItemIndex]}];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    [self fireEvent:kCarouselChangeEvent withObject:@{@"currentIndex": [NSNumber numberWithInt:carousel.currentItemIndex]}];
}

@end
