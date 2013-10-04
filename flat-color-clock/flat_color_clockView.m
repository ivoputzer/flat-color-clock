//
//  flat_color_clockView.m
//  flat-color-clock
//
//  Created by Ivo von Putzer Reibegg on 30/09/13.
//  Copyright (c) 2013 Ivo von Putzer Reibegg. All rights reserved.
//

#import "flat_color_clockView.h"

@implementation flat_color_clockView

const float _animation_fps = 25.0f;                   // [25.0f] animation frames per second

const float _animation_vel = 1 / _animation_fps;      // [0.04f] animation velocity

      float _animation_cur = 0;                       // [0.00f] generic frame counter

NSColor *_color_prior;                                // [NSColor blackColor]

NSColor *_color_after;

NSDate *_current_date;


- (id) initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    // todo : load font from bundle instead of using the system one
    
    if (self)
    {
        [self setAnimationTimeInterval:_animation_vel];

        _current_date = [NSDate date];
        
        _color_prior = [NSColor blackColor];
        
        _color_after = [self getColorForCurrentDate];
    }
    
    return self;
}

- (void) animateOneFrame
{
    [self setNeedsDisplay:true]; // forces redraw for each animation-iteration
    
    [self prepareDrawOperation];
 
    return;
}


// custom utility methods

- (void) prepareDrawOperation
{
    if ( _animation_cur * _animation_vel != 1.0f )
    {
        // transitioning from one second to another
        
        _animation_cur = _animation_cur + 1; return;
    }
    
    // transition is over, reload date reference and reset counter
    
    _current_date = [NSDate date];

    _color_prior = _color_after; // exchanging values
    
    _color_after = [self getColorForCurrentDate];
        
    _animation_cur = 0;
}

- (NSColor*) getColorForCurrentDate
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:_current_date];
    
    return [NSColor colorWithCalibratedRed: (float)[components hour] / 23.0f green: (float)[components minute] / 59.0f blue: (float)[components second] / 59.0f alpha:1.0];
}

- (float) width { return [self bounds].size.width; }

- (float) height { return [self bounds].size.height; }


// standard and custom drawing methods

- (void) drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    [self drawBackground];
    
    [self drawTimeLabel];
}

- (void) drawBackground
{
    [[_color_prior blendedColorWithFraction:_animation_cur / _animation_fps ofColor:_color_after] set];
    
    [NSBezierPath fillRect:[self bounds]];
}

- (void) drawTimeLabel
{
    NSDateFormatter *string_format = [[NSDateFormatter alloc] init]; [string_format setDateFormat:@"HH· mm· ss"];
    
    NSString *string_time = [string_format stringFromDate:_current_date];
    
    NSMutableDictionary *string_attributes = [[NSMutableDictionary alloc] init];
    
    [string_attributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	
    [string_attributes setValue:[NSFont fontWithName:@"Century Gothic" size: [self bounds].size.height / 6] forKey:NSFontAttributeName];
    
    NSSize string_size = [string_time sizeWithAttributes:string_attributes];
    
	NSPoint string_point = NSMakePoint([self width] / 2 - string_size.width / 2, [self height] / 2 - string_size.height / 2);
	
    [string_time drawAtPoint:string_point withAttributes:string_attributes];
}


// unused standard callback-methods

- (void) startAnimation { [super startAnimation]; }

- (void) stopAnimation { [super stopAnimation]; }

- (BOOL) hasConfigureSheet { return false; }

- (NSWindow*) configureSheet { return nil; }

@end
