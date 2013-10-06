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

NSColor *_color_prior, *_color_after;

NSDate *_current_date;

-(void) log: (NSString*)m
{
    NSString *s = [NSString stringWithFormat:@"echo \"%@\" >> /Users/ivo/Documents/workspace/flat-color-clock/.app-logs", m];
    
    [[NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:[NSArray arrayWithObjects:@"-c", s, nil]] waitUntilExit];
}


// screensaver initialisation methods

- (id) initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self)
    {
        [self setAnimationTimeInterval:_animation_vel];
        
        _color_prior = [NSColor blackColor];
        
        _color_after = [self getColorForCurrentDate: _current_date = [NSDate date]];
        
        [self log:@"-------------------------------------------------------------"];
                
        [self log: [[[[NSFontManager sharedFontManager] availableFontFamilies] description] stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }

    return self;
}


// screensaver animation callbacks

- (void) animateOneFrame
{
    [self setNeedsDisplay:true]; // forces redraw for each animation-iteration
    
    [self prepareDrawOperation];
}


// custom utility methods

- (BOOL) isTransitioning { return 1.0 != (_animation_cur * _animation_vel); }

- (float) width { return [self bounds].size.width; }

- (float) height { return [self bounds].size.height; }

- (void) prepareDrawOperation
{
    if ( [self isTransitioning] ){ _animation_cur = _animation_cur + 1; return; }
    
    _animation_cur = 0; _color_prior = _color_after; _color_after = [self getColorForCurrentDate: _current_date = [NSDate date]];
}

- (NSColor*) getColorForCurrentDate:(NSDate*) date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    
    return [NSColor colorWithCalibratedRed:(float)[components hour] / 23.0f green:(float)[components minute] / 59.0f blue:(float)[components second] / 59.0f alpha:1.0];
}


// standard and custom drawing methods

- (void) drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    [self drawBackground]; [self drawTimeLabel]; [self drawColorInfoLabel];
}

- (void) drawBackground
{
    [[_color_prior blendedColorWithFraction:_animation_cur/_animation_fps ofColor:_color_after] set];
    
    [NSBezierPath fillRect:[self bounds]];
}

- (void) drawTimeLabel
{
    NSDateFormatter *string_format = [[NSDateFormatter alloc] init]; [string_format setDateFormat:@"HH · mm · ss"];
    
    NSString *string_time = [string_format stringFromDate:_current_date];
    
    NSMutableDictionary *string_attributes = [[NSMutableDictionary alloc] init];
    
    [string_attributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	
    [string_attributes setValue:[NSFont fontWithName:@"TR Century Gothic" size:[self height] / 6] forKey:NSFontAttributeName];
    
    NSSize string_size = [string_time sizeWithAttributes:string_attributes];
    
    [string_time drawAtPoint:NSMakePoint([self width] / 2 - string_size.width / 2, [self height] / 2 - string_size.height / 2) withAttributes:string_attributes];
}

- (void) drawColorInfoLabel
{
    NSString *string_rgb = [NSString stringWithFormat:@"R %03i · G %03i · B %03i", (int)(255 * [_color_after redComponent]), (int)(255 * [_color_after greenComponent]), (int)(255 * [_color_after blueComponent])];

    NSMutableDictionary *string_attributes = [[NSMutableDictionary alloc] init];
    
    [string_attributes setValue:[NSColor colorWithCalibratedWhite:1 alpha:0.5] forKey:NSForegroundColorAttributeName];

    [string_attributes setValue:[NSFont fontWithName:@"Arial" size:[self height] / 50] forKey:NSFontAttributeName];
    
    NSSize string_size = [string_rgb sizeWithAttributes:string_attributes];
    
    [string_rgb drawAtPoint:NSMakePoint([self width] - (string_size.width + 10), 10) withAttributes:string_attributes];
}

// unused standard callback-methods

- (void) startAnimation { [super startAnimation]; }

- (void) stopAnimation { [super stopAnimation]; }

- (BOOL) hasConfigureSheet { return false; }

- (NSWindow*) configureSheet { return nil; }

@end
