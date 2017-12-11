//
//  CALayer+ZYTextAnimationGenerator.h
//  ZYLoading
//
//  Created by macOfEthan on 17/12/11.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (ZYTextAnimationGenerator)

- (CAShapeLayer *)setupAnimationTextLayerWithText:(NSString *)text fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor;

@end
