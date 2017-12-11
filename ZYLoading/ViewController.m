//
//  ViewController.m
//  ZYLoading
//
//  Created by macOfEthan on 17/12/11.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import "ViewController.h"
#import "ZYLoadingAnimator.h"

@interface ViewController ()
@property (nonatomic, strong) ZYLoadingAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[ZYLoadingAnimator shareAnimator] showLoaddingAnimatorInView:self.view tintColor:[UIColor redColor]];
}

- (IBAction)stop:(id)sender {
    
    [[ZYLoadingAnimator shareAnimator] hiddenLoaddingAnimator];
}

- (IBAction)start:(id)sender {
    
    [[ZYLoadingAnimator shareAnimator] showLoaddingAnimatorInView:self.view tintColor:[UIColor brownColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
