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
        [self setAnimationTimeInterval:0.1];
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
    [self setNeedsDisplay:true]; // call drawRect and stuff each frame
    
    return;
}

- (void) drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    NSDate *current_date = [NSDate date];
    
    [self drawBackgroundColor:rect forDate:current_date];
    
    [self drawCurrentTime:rect forDate:current_date];

}

- (void) drawCurrentTime: (NSRect) rect forDate: (NSDate*) date
{
    NSDateFormatter *time_format = [[NSDateFormatter alloc] init]; [time_format setDateFormat:@"HH : mm : ss"];
    
    NSString *time = [time_format stringFromDate:date];
    
    NSMutableDictionary *string_attributes = [[NSMutableDictionary alloc] init];
    
    [string_attributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	
    [string_attributes setValue:[NSFont fontWithName:@"Verdana" size:30] forKey:NSFontAttributeName];
    
    // Do we really need shadows along the way?
    
    // NSShadow *string_shadow = [[NSShadow alloc] init];
    
    // [string_shadow setShadowColor:[NSColor blackColor]];
    
    // NSSize string_shadow_size; string_shadow_size.width = 2; string_shadow_size.height = -2;
    
    // [string_shadow setShadowOffset:string_shadow_size];
    
    // [string_shadow setShadowBlurRadius:6];
	
    // [string_attributes setValue:string_shadow forKey:NSShadowAttributeName];
    
    NSSize string_size = [time sizeWithAttributes:string_attributes];
    
	NSPoint center_point;
    
    center_point.x = (rect.size.width / 2) - (string_size.width / 2);
	
    center_point.y = (rect.size.height / 2) - (string_size.height / 2);
	
    [time drawAtPoint:center_point withAttributes:string_attributes];
}

- (void) drawBackgroundColor:(NSRect) rect forDate: (NSDate*) date
{
    NSDateFormatter *hrs_format = [[NSDateFormatter alloc] init]; [hrs_format setDateFormat:@"HH"];
    NSDateFormatter *min_format = [[NSDateFormatter alloc] init]; [min_format setDateFormat:@"mm"];
    NSDateFormatter *sec_format = [[NSDateFormatter alloc] init]; [sec_format setDateFormat:@"ss.SSS"];
    
    [[NSColor colorWithCalibratedRed:[hrs_format stringFromDate:date].floatValue / 23.0f
                               green:[min_format stringFromDate:date].floatValue / 59.0f
                                blue:[sec_format stringFromDate:date].floatValue / 59.0f alpha:1.0] set]; // todo // setFill?!
    
    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, [self bounds].size.width, [self bounds].size.height)] fill];
}

@end
