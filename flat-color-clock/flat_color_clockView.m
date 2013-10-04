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
        // todo : load fonts dinamycally fron internet or bundle [hint : NSBundle, CTFontManagerRegisterFontsForURL]
        
        [self setAnimationTimeInterval:animation_speed];
        
        [self loadFont:@"Century Gothic"];

        color_prior = color_after = [self getColorForNow];
        
        current_date = [NSDate date];
    }
    
    return self;
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
    return true;
}

- (NSWindow*) configureSheet
{
    if (!config_sheet && ![NSBundle loadNibNamed:@"ConfigureSheet" owner:self])
    {
        NSLog( @"Failed to load configure sheet." ); NSBeep();
    }
    
    return config_sheet;
}

// screensaver animation callback

- (void) animateOneFrame
{
    [self setNeedsDisplay:true]; // forces redraw each iteration
 
    if ( animation_progress * animation_speed == 1.0f ) [self prepareDrawOperation];
    
    animation_progress = animation_progress + 1;
    
    [config_logger stringByAppendingString:@"bla bla this is a log\n"];
    
    return;
}

// utility methods

- (void) prepareDrawOperation
{
    color_prior = color_after;
    
    color_after = [self getColorForNow];
    
    current_date = [NSDate date];
    
    animation_progress = 0;
}

- (NSColor*) getColorForNow
{
    NSDate* color_date = [current_date dateByAddingTimeInterval:3600.0]; // fix, colors need to be 1s ahead
    
    NSDateFormatter *h = [[NSDateFormatter alloc] init]; [h setDateFormat:@"HH"];
    NSDateFormatter *m = [[NSDateFormatter alloc] init]; [m setDateFormat:@"mm"];
    NSDateFormatter *s = [[NSDateFormatter alloc] init]; [s setDateFormat:@"ss"];
    
    return [NSColor colorWithCalibratedRed:[h stringFromDate:color_date].floatValue / 23.0f
                                     green:[m stringFromDate:color_date].floatValue / 59.0f
                                      blue:[s stringFromDate:color_date].floatValue / 59.0f alpha:1.0];
}

// drawing methods

- (void) drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    [self drawBackground];
    
    [self drawLabel];
    
    [self drawDebugLabel];
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
	
    [string_attributes setValue:[NSFont fontWithName:@"CenturyGothic" size: [self bounds].size.height / 6] forKey:NSFontAttributeName];
    
    NSSize string_size = [string_time sizeWithAttributes:string_attributes];
    
	NSPoint string_point = NSMakePoint([self bounds].size.width / 2 - string_size.width / 2, [self bounds].size.height / 2 - string_size.height / 2);
	
    [string_time drawAtPoint:string_point withAttributes:string_attributes];
}

NSString *__devbug;

// bundle font loader

-(void) loadFont:(NSString*) font_name
{
    __devbug = [[NSBundle mainBundle] pathForResource:@"CenturyGothic" ofType:@"ttf"];
    
//    assert(font_url);
    
//    CFErrorRef error = NULL;
    
//    if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)font_url, kCTFontManagerScopeProcess, &error))
//    {
//        CFShow(error); abort();
//    }

}

- (void) drawDebugLabel
{
    NSString *string = [NSString stringWithFormat:@"-- %@ --", __devbug];
    
    NSMutableDictionary *string_attributes = [[NSMutableDictionary alloc] init];
    
    [string_attributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	
    [string_attributes setValue:[NSFont fontWithName:@"Verdana" size:10] forKey:NSFontAttributeName];
    
    NSSize string_size = [string sizeWithAttributes:string_attributes];
    
	NSPoint string_point = NSMakePoint([self bounds].size.width / 2 - string_size.width / 2, 10);
	   
    [string drawAtPoint:string_point withAttributes:string_attributes];
}

@end
