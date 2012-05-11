/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComObscureTiCarouselModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation ComObscureTiCarouselModule

#pragma mark Internal

-(id)moduleGUID {
	return @"2295ea8d-38ef-4786-b48b-b76c27e14fbb";
}

-(NSString*)moduleId {
	return @"com.obscure.TiCarousel";
}

#pragma mark Lifecycle

-(void)startup {
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender {
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc {
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification {
	[super didReceiveMemoryWarning:notification];
}

@end
