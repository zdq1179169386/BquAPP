//
//  UIButton+Bootstrap.m
//  UIButton+Bootstrap
//
//  Created by Oskur on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//
#import "UIButton+Bootstrap.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIButton (Bootstrap)

-(void)onlyCornerRadius
{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

-(void)whiteStyle
{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}


//默认黑色
-(void)blackStyle
{
    [self onlyCornerRadius];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

// 默认桔红
-(void)redStyle
{
    [self onlyCornerRadius];
    [self setTitleColor:[UIColor colorWithRed:228/255.0 green:14/255.0 blue:64/255.0 alpha:1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:228/255.0 green:14/255.0 blue:64/255.0 alpha:1] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [[UIColor colorWithRed:228/255.0 green:14/255.0 blue:64/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
}

-(void)grayStyle
{
    [self onlyCornerRadius];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:30/255.0 green:100/255.0 blue:170/255.0 alpha:1]] forState:UIControlStateHighlighted];
}


- (UIImage *) buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
