//
//  flat_color_clockView.m
//  flat-color-clock
//
//  Created by Ivo von Putzer Reibegg on 30/09/13.
//  Copyright (c) 2013 Ivo von Putzer Reibegg. All rights reserved.
//

#import "flat_color_clockView.h"

@implementation flat_color_clockView

- (id) initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self)
    {
        /* todo : load fonts dinamycally fron internet or bundle [hint : NSBundle, CTFontManagerRegisterFontsForURL] */
        
        [self setAnimationTimeInterval:0.1];
        
        /* todo : decrease animation interval and handle color animation with something like a timer [hint : NSTimer] */
    }
    
    return self;
}

- (void) startAnimation
{
    [super startAnimation];
}

- (void) stopAnimation
{
    [super stopAnimation];
}

- (BOOL) hasConfigureSheet
{
    return false;
}

- (NSWindow*) configureSheet
{
    return nil;
}

- (void) animateOneFrame
{
    [self setNeedsDisplay:true]; // forces drawRect to be called each iteration
    
    return;
}

- (void) drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    NSDate *current_date = [NSDate date];
    
    [self drawBackgroundColorForDate:current_date];
    
    [self drawCurrentTimeForDate:current_date];
}

- (void) drawCurrentTimeForDate: (NSDate*) date
{
    NSDateFormatter *string_format = [[NSDateFormatter alloc] init]; [string_format setDateFormat:@"HH· mm· ss"];
    
    NSString *string_time = [string_format stringFromDate:date];
  
    // NSShadow *string_shadow = [[NSShadow alloc] init];
    
    // [string_shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.3]];
    
    // [string_shadow setShadowOffset:NSMakeSize(-2.0, -2.0)];
    
    // [string_shadow setShadowBlurRadius:2.0];
    
    
    NSMutableDictionary *string_attributes = [[NSMutableDictionary alloc] init];
    
    [string_attributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	
    [string_attributes setValue:[NSFont fontWithName:@"Century Gothic" size: [self bounds].size.height / 6] forKey:NSFontAttributeName];

    // [string_attributes setValue:string_shadow forKey:NSShadowAttributeName];
    

    NSSize string_size = [string_time sizeWithAttributes:string_attributes];
    
	NSPoint string_point = NSMakePoint([self bounds].size.width / 2 - string_size.width / 2, [self bounds].size.height / 2 - string_size.height / 2);
	
    [string_time drawAtPoint:string_point withAttributes:string_attributes];
}

- (void) drawBackgroundColorForDate: (NSDate*) date
{
    NSDateFormatter *hrs_format = [[NSDateFormatter alloc] init]; [hrs_format setDateFormat:@"HH"];
    NSDateFormatter *min_format = [[NSDateFormatter alloc] init]; [min_format setDateFormat:@"mm"];
    NSDateFormatter *sec_format = [[NSDateFormatter alloc] init]; [sec_format setDateFormat:@"ss.SSS"];
    
    [[NSColor colorWithCalibratedRed:[hrs_format stringFromDate:date].floatValue / 23.0f
                               green:[min_format stringFromDate:date].floatValue / 59.0f
                                blue:[sec_format stringFromDate:date].floatValue / 59.0f
                               alpha:1.0] set];
    
    [[NSBezierPath bezierPathWithRect:[self bounds]] fill]; // fill background
}

@end
