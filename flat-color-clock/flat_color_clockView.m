//
//  flat_color_clockView.m
//  flat-color-clock
//
//  Created by Ivo von Putzer Reibegg on 30/09/13.
//  Copyright (c) 2013 Ivo von Putzer Reibegg. All rights reserved.
//

#import "flat_color_clockView.h"

@implementation flat_color_clockView

const int _animation_fps = 25; // [25] animation frames per second

      int _animation_cur = 0;  // [0] generic frame counter

NSColor *_color_prior, *_color, *_color_after;

NSDate  *_date;

- (id) initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self)
    {
        [self setAnimationTimeInterval:1.0 / _animation_fps];
        
        _color_prior = [NSColor blackColor];
        
        _color_after = [self color];
    }

    return self;
}

- (void) animateOneFrame {
    
    [self setNeedsDisplay:true];
    
    [self prepareToDraw];
}

- (void) drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    [self drawBackground];
    
    [self drawColorInfoLabel];
    
    [self drawTimeLabel];
}

- (void) prepareToDraw
{
    _animation_cur = _animation_cur + 1;
    
    if ( 0 == _animation_cur % _animation_fps )
    {
        _color_prior = _color_after;
        
        _color_after = [self color];
    }
}

- (void) drawBackground
{
    [_color = [_color_prior blendedColorWithFraction: (float) (_animation_cur % _animation_fps) / (float) _animation_fps ofColor:_color_after] set];
    
    [NSBezierPath fillRect:[self bounds]];
}

- (void) drawTimeLabel
{
    NSDateFormatter *time_format = [[NSDateFormatter alloc] init];
    
    [time_format setDateFormat:@"HH· mm· ss"];
    
    NSString *time = [time_format stringFromDate:_date];
    
    NSMutableDictionary *str_attributes = [[NSMutableDictionary alloc] init];
    
    [str_attributes setValue:[NSColor colorWithCalibratedWhite:1 alpha:1] forKey:NSForegroundColorAttributeName];
	
    [str_attributes setValue:[NSFont fontWithName:@"Century Gothic" size:[self height] / 6] forKey:NSFontAttributeName];
    
    NSSize str_size = [time sizeWithAttributes:str_attributes];
    
    [time drawAtPoint:NSMakePoint([self width] / 2 - str_size.width / 2, [self height] / 2 - str_size.height / 2) withAttributes:str_attributes];
}

- (void) drawColorInfoLabel
{
    NSString *info = [NSString stringWithFormat:@"R %03.0f· G %03.0f· B %03.0f", 255 * [_color redComponent], 255 * [_color greenComponent], 255 * [_color blueComponent]];
    
    NSMutableDictionary *str_attributes = [[NSMutableDictionary alloc] init];
    
    [str_attributes setValue:[NSColor colorWithCalibratedWhite:1 alpha:1] forKey:NSForegroundColorAttributeName];

    [str_attributes setValue:[NSFont fontWithName:@"Century Gothic" size:[self height] / 50] forKey:NSFontAttributeName];
    
    [info drawAtPoint:NSMakePoint([self width] - ([info sizeWithAttributes:str_attributes].width + 10), 10) withAttributes:str_attributes];
}

- (NSColor*) color
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:_date = [NSDate date]];
    
    return [NSColor colorWithCalibratedRed:[components hour] / 23.0 green:[components minute] / 59.0 blue:[components second] / 59.0 alpha:1.0];
}

- (float) width
{
    return [self bounds].size.width;
}

- (float) height
{
    return [self bounds].size.height;
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

@end
