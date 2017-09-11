//
//  UIWindow+SNExtension.m
//  Blissbakery
//
//  Created by 杜晓星 on 2017/9/11.
//  Copyright © 2017年 杜晓星. All rights reserved.
//

#import "UIWindow+SNExtension.h"
#import <objc/runtime.h>

#define SN_SHOW_BORDER 0

@implementation SNBorderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.layer.borderWidth = 2.0f;
        self.layer.borderColor = [UIColor redColor].CGColor;
    }
    return self;
}

- (void)sn_startAnimation {
    self.alpha = 1.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:.75f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(sn_didAppearingAnimationStopped)];
    
    self.alpha = 0.0f;
    
    [UIView commitAnimations];
}

- (void)sn_didAppearingAnimationStopped
{
    [self removeFromSuperview];
}

@end

@implementation UIWindow (SNExtension)

+ (UIWindow*)sn_keyWindow
{
    return [UIApplication sharedApplication].windows.firstObject;
}


+ (void)load
{   [super load];
    
#ifdef DEBUG
    if (SN_SHOW_BORDER) {
        Method normalMethod = class_getInstanceMethod(self, @selector(sendEvent:));
        Method borderMethod = class_getInstanceMethod(self, @selector(sn_borderViewSendEvent:));
        
        method_exchangeImplementations(normalMethod, borderMethod);
    }

#else
    
#endif
    
    
}


- (void)sn_borderViewSendEvent:(UIEvent*)event {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ( self == keyWindow && UIEventTypeTouches == event.type)
    {
        NSSet *allTouches = [event allTouches];
        if ( 1 == [allTouches count] )
        {
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
            if ( 1 == [touch tapCount] && UITouchPhaseBegan == touch.phase )
            {
                SNBorderView *border = [[SNBorderView alloc] initWithFrame:touch.view.bounds];
                [touch.view addSubview:border];
                [border sn_startAnimation];
            }
        }
    }
    [self sn_borderViewSendEvent:event];
}

@end


