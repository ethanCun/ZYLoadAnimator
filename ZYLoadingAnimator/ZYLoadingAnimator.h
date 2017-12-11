//
//  ZYLoadingAnimator.h
//  ZYLoading
//
//  Created by macOfEthan on 17/12/11.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZYLoadingAnimator : UIView

@property (nonatomic, strong) UIColor *tintColor;

+ (instancetype)shareAnimator;

- (instancetype)showLoaddingAnimatorInView:(UIView *)targetView tintColor:(UIColor *)tintColor;

- (void)hiddenLoaddingAnimator;

@end
