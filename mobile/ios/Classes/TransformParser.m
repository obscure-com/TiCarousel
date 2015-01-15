//
//  TransformParser.m
//  ticarousel
//
//  Created by Paul Mietz Egli on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransformParser.h"

#define kTypeKey @"type"
#define kValuesKey @"values"

@implementation TransformParser

+ (CATransform3D)addTransforms:(NSArray *)dicts toTransform:(CATransform3D)transform {
    for (NSDictionary * dict in dicts) {
        NSString * type = [dict objectForKey:kTypeKey];
        NSArray * values = [dict objectForKey:kValuesKey];
        
        if ([@"translate" isEqualToString:type]) {
            if ([values count] == 3) {
                transform = CATransform3DTranslate(transform, [[values objectAtIndex:0] floatValue], [[values objectAtIndex:1] floatValue], [[values objectAtIndex:2] floatValue]);
            }
            else {
                NSLog(@"[ERROR] incorrect number of values (%lu), skipping translate", [values count]);
            }
        }
        else if ([@"rotate" isEqualToString:type]) {
            if ([values count] == 4) {
                transform = CATransform3DRotate(transform, [[values objectAtIndex:0] floatValue], [[values objectAtIndex:1] floatValue], [[values objectAtIndex:2] floatValue], [[values objectAtIndex:3] floatValue]);
            }
            else {
                NSLog(@"[ERROR] incorrect number of values (%lu), skipping rotate", [values count]);
            }
        }
        else if ([@"scale" isEqualToString:type]) {
            if ([values count] == 3) {
                transform = CATransform3DScale(transform, [[values objectAtIndex:0] floatValue], [[values objectAtIndex:1] floatValue], [[values objectAtIndex:2] floatValue]);
            }
            else {
                NSLog(@"[ERROR] incorrect number of values (%lu), skipping scale", [values count]);
            }
        }
    }
    
    return transform;
}

@end
