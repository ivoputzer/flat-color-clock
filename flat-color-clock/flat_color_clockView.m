//
//  flat_color_clockView.m
//  flat-color-clock
//
//  Created by Ivo von Putzer Reibegg on 30/09/13.
//  Copyright (c) 2013 Ivo von Putzer Reibegg. All rights reserved.
//

#import "flat_color_clockView.h"

@implementation flat_color_clockView

const float animation_speed = 0.04f; // that's 25 fps

const float animation_frames = 1 / animation_speed;

float animation_progress = 0;

NSColor *color_prior;

NSColor *color_after;

NSDate *current_date;

- (id) initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self)
    {
        // todo : load fonts dinamycally fron internet or buCndle [hint : NSBundle, CTFontManagerRegisterFontsForURL]
        
        [self setAnimationTimeInterval:animation_speed];

        current_date = [NSDate date];
        
        color_prior = [NSColor blackColor];
        
        color_after = [self getColorForCurrentDate];
    }
    
    return self;
}

- (void) animateOneFrame
{
    [self setNeedsDisplay:true]; // forces redraw each iteration
    
    [self prepareDrawOperation];
 
    return;
}

// utility methods

- (void) prepareDrawOperation
{
    if ( animation_progress * animation_speed == 1.0f )
    {
    
        color_prior = color_after;
    
        current_date = [NSDate date];

        color_after = [self getColorForCurrentDate];
        
        animation_progress = 0;
    }
    else
    {
        animation_progress = animation_progress + 1;
    }
}

- (NSColor*) getColorForCurrentDate
{   
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:current_date];
    
    return [NSColor colorWithCalibratedRed: (float)[components hour] / 23.0f green: (float)[components minute] / 59.0f blue: (float)[components second] / 59.0f alpha:1.0];
}

// drawing methods

- (void) drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    [self drawBackground];
    
    [self drawLabel];
}

- (void) drawBackground
{
    [[color_prior blendedColorWithFraction:animation_progress/animation_frames ofColor:color_after] set];
    
    [NSBezierPath fillRect:[self bounds]];
}

- (void) drawLabel
{
    NSDateFormatter *string_format = [[NSDateFormatter alloc] init]; [string_format setDateFormat:@"HH· mm· ss"];
    
    NSString *string_time = [string_format stringFromDate:current_date];
    
    NSMutableDictionary *string_attributes = [[NSMutableDictionary alloc] init];
    
    [string_attributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	
    [string_attributes setValue:[NSFont fontWithName:@"Century Gothic" size: [self bounds].size.height / 6] forKey:NSFontAttributeName];
    
    NSSize string_size = [string_time sizeWithAttributes:string_attributes];
    
	NSPoint string_point = NSMakePoint([self bounds].size.width / 2 - string_size.width / 2, [self bounds].size.height / 2 - string_size.height / 2);
	
    [string_time drawAtPoint:string_point withAttributes:string_attributes];
}

// standard methods

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

@end
