//
//  UIWindow+SNExtension.h
//  Blissbakery
//
//  Created by 杜晓星 on 2017/9/11.
//  Copyright © 2017年 杜晓星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNBorderView : UIView

- (void)sn_didAppearingAnimationStopped;

@end

@interface UIWindow (SNExtension)

+ (UIWindow*)sn_keyWindow;

@end
