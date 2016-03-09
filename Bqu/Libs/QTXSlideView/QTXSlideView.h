//
//  QTXSlideView.h
//  幻灯片
//
//  Created by yexh on 14-3-7.
//  Copyright (c) 2014年 qiutianxia. All rights reserved.
//

// 提供RGB模式的UIColor定义.
#define     RGBCOLOR(r,g,b)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#import <UIKit/UIKit.h>

@interface SlideItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgURLStr;

@end


@protocol QTXSlideViewDelegate;

@interface QTXSlideView : UIView<UIScrollViewDelegate>
{
    UILabel       *_titleLabel;//标题
    
    UIPageControl *_pageCtl;//分页显示
    
    UIScrollView  *_slideSV;//幻灯片View
    
    NSArray       *_slideArray;//幻灯片数组
    
    NSInteger     _offset;//偏移值
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) id<QTXSlideViewDelegate>slideDelegate;

- (id)initWithFrame:(CGRect)frame withSlideArray:(NSArray *)slideArray slideDelegate:(id<QTXSlideViewDelegate>)slideDelegate;

- (void)startSlideAnimation;


@end

@protocol QTXSlideViewDelegate <NSObject>

- (void)QTXSlideView:(QTXSlideView *)slideView slideIndex:(NSInteger)index;

@end
