//
//  UIScrollView+Indicator.m
//  ScrollViewLIneDemo
//
//  Created by luoz on 15/8/28.
//  Copyright (c) 2015年 luoz. All rights reserved.
//

#import "UIScrollView+Indicator.h"
#import <objc/runtime.h>

static const void *scrollIndicatorKey = &scrollIndicatorKey;
const CGFloat dis = 50;

@implementation UIScrollView (Indicator)

- (void)showLeftScrollIndicator:(BOOL)isShow
{
    if(isShow)
    {
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectZero];
        vLine.hidden = YES;
        vLine.backgroundColor = [UIColor grayColor];
        vLine.alpha  = 0.7;
        self.scrollIndicator = vLine;
        
        [self addSubview:self.scrollIndicator];
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    else{
        [self releaseSomeData];
    }
}

- (void)releaseSomeData
{
    [self removeObserver:self forKeyPath:@"contentSize"];
    [self removeObserver:self forKeyPath:@"contentOffset"];
    
    self.scrollIndicator = nil;
    objc_removeAssociatedObjects(self);
}

#pragma mark -
- (void)setScrollIndicator:(UIView *)scrollIndicator
{
    objc_setAssociatedObject(self, scrollIndicatorKey, scrollIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)scrollIndicator
{
    return objc_getAssociatedObject(self, scrollIndicatorKey);
}

#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentSize"]){
        CGFloat height = CGRectGetHeight(self.frame) * (CGRectGetHeight(self.frame)/self.contentSize.height);
        CGRect rect    = CGRectMake(2, 0, 2.5, height);
        self.scrollIndicator.frame = rect;
        self.scrollIndicator.hidden = YES;
    }
    else if ([keyPath isEqualToString:@"contentOffset"]){
        
        if(self.contentSize.height >= self.frame.size.height+dis){
            
            CGFloat height = CGRectGetHeight(self.frame) * (CGRectGetHeight(self.frame)/self.contentSize.height);
            self.scrollIndicator.hidden = NO;
            
            CGRect rect = self.scrollIndicator.frame;
            CGFloat y   = self.contentOffset.y+self.contentOffset.y/(self.contentSize.height-self.frame.size.height)*(self.frame.size.height-height)-2;
            
            if(self.contentOffset.y<0)
            {
                height = height-height*(fabs(self.contentOffset.y)/(self.frame.size.height));
                
                self.scrollIndicator.frame = CGRectMake(rect.origin.x, self.contentOffset.y+2, CGRectGetWidth(rect),height);
            }
            else if (self.contentOffset.y>self.contentSize.height-self.frame.size.height)
            {
                height = height-height*(fabs(self.contentOffset.y-(self.contentSize.height-self.frame.size.height))/(self.frame.size.height));
                y      = self.contentOffset.y+self.frame.size.height-height-2;
                
                self.scrollIndicator.frame = CGRectMake(rect.origin.x, y, CGRectGetWidth(rect), height);
            }
            else{
                self.scrollIndicator.frame = CGRectMake(rect.origin.x, y, CGRectGetWidth(rect), height);
            }
        }
        else{
            self.scrollIndicator.hidden = YES;
        }
    }
}


@end
