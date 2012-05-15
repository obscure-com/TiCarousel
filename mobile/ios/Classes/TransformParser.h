//
//  TransformParser.h
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TransformParser : NSObject
+ (CATransform3D)addTransforms:(NSArray *)dicts toTransform:(CATransform3D)transform;
@end
