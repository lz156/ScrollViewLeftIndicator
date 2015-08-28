//
//  UIScrollView+Indicator.h
//  ScrollViewLIneDemo
//
//  Created by luoz on 15/8/28.
//  Copyright (c) 2015年 luoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Indicator)<UIScrollViewDelegate>

@property(nonatomic, strong) UIView *scrollIndicator;

- (void)showLeftScrollIndicator:(BOOL)isShow;
- (void)releaseSomeData;

@end
