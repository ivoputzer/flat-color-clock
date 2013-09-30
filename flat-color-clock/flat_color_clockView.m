//
//  flat_color_clockView.m
//  flat-color-clock
//
//  Created by Ivo von Putzer Reibegg on 30/09/13.
//  Copyright (c) 2013 Ivo von Putzer Reibegg. All rights reserved.
//

#import "flat_color_clockView.h"

@implementation flat_color_clockView

NSSize displaysize;

- (id) initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) [self setAnimationTimeInterval:0.1];
    
    return self;
}

- (void) startAnimation {
    [super startAnimation];
}

- (void) stopAnimation {
    [super stopAnimation];
}

- (void) drawRect:(NSRect)rect {
    [super drawRect:rect];
}

- (void) animateOneFrame {
    displaysize = [self bounds].size;
    [self set_background_color];
    return;
}

- (float) random_float { return SSRandomFloatBetween(0.0, 1.0); }

- (NSPoint) random_point {
    return NSPointFromCGPoint(CGPointMake(SSRandomFloatBetween(0.0, displaysize.width), SSRandomFloatBetween(0.0, displaysize.height)));
}

- (void) set_background_color
{
    NSDate *current_date = [NSDate date];
    
    NSDateFormatter *hrs_format = [[NSDateFormatter alloc] init]; [hrs_format setDateFormat:@"HH"];
    NSDateFormatter *min_format = [[NSDateFormatter alloc] init]; [min_format setDateFormat:@"mm"];
    NSDateFormatter *sec_format = [[NSDateFormatter alloc] init]; [sec_format setDateFormat:@"ss.SSS"];
    
    [[NSColor colorWithCalibratedRed:[hrs_format stringFromDate:current_date].floatValue / 23.0f
                               green:[min_format stringFromDate:current_date].floatValue / 59.0f
                                blue:[sec_format stringFromDate:current_date].floatValue / 59.0f
                               alpha:1.0] set];
    
    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, displaysize.width, displaysize.height)] fill];
}

- (BOOL) hasConfigureSheet {
    return false;
}

- (NSWindow*) configureSheet {
    return nil;
}

@end
