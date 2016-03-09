//
//  LeveyTabBar.m
//  BquAPP
//
//  Created by yb on 15/10/14.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "LeveyTabBar.h"

@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundView];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.lineView];
        self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
        UIButton *btn;
        CGFloat width = ScreenWidth / [imageArray count];
        for (int i = 0; i < [imageArray count]; i++)
        {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.showsTouchWhenHighlighted = YES;
            btn.tag = i;
            btn.frame = CGRectMake(width * i, 0, width, frame.size.height);
            [btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Default"] forState:UIControlStateNormal];
            [btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
            [btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Seleted"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:btn];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)img
{
    [_backgroundView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
    UIButton *btn = sender;
    
    [self selectTabAtIndex:btn.tag];
}

- (void)selectTabAtIndex:(NSInteger)index
{
    for (int i = 0; i < [self.buttons count]; i++)
    {
        UIButton *b = [self.buttons objectAtIndex:i];
        b.selected = NO;
    }
    UIButton *btn = [self.buttons objectAtIndex:index];
    btn.selected = YES;
    
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:btn.tag];
    }
}

- (void)removeTabAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
    
    // Re-index the buttons
    CGFloat width =ScreenWidth/ [self.buttons count];
    for (UIButton *btn in self.buttons)
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}

- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    // Re-index the buttons
    CGFloat width = ScreenWidth / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons)
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setImage:[dict objectForKey:@"Default"] forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:@"Seleted"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}

@end
