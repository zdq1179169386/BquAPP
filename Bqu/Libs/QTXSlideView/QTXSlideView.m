//
//  QTXSlideView.m
//  test世界杯
//
//  Created by yexh on 14-3-7.
//  Copyright (c) 2014年 qiutianxia. All rights reserved.
//

#import "QTXSlideView.h"
#import "Header.h"

@implementation SlideItem

@end

#pragma mark - QTXSlideView

@implementation QTXSlideView

- (id)initWithFrame:(CGRect)frame withSlideArray:(NSArray *)slideArray slideDelegate:(id<QTXSlideViewDelegate>)slideDelegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _slideArray = slideArray;
        self.slideDelegate = slideDelegate;
        
        _offset = 1;//默认1
        
        _slideSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _slideSV.pagingEnabled = YES;
        _slideSV.delegate = self;
        _slideSV.userInteractionEnabled = YES;
        _slideSV.showsHorizontalScrollIndicator = NO;
        _slideSV.bounces = NO;
        _slideSV.contentSize = CGSizeMake(_slideArray.count * frame.size.width, frame.size.height);
        
        for (int i=0; i < _slideArray.count ; i++)
        {
            SlideItem *item = _slideArray[i];
            
            //图片
            UIImageView *slideImage = [[UIImageView alloc]initWithFrame:CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height)];
            
            [slideImage sd_setImageWithURL:[NSURL URLWithString:item.imgURLStr]
                          placeholderImage:[UIImage imageNamed:@"1106首页占位图-01首焦"]];//无数据时显示
            
            slideImage.backgroundColor = RGBCOLOR(i*30, i*30, i*50);
            [_slideSV addSubview:slideImage];
            
            //按钮 进行跳转用
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame = CGRectMake( i * frame.size.width, 0, frame.size.width, frame.size.height);
//            btn.backgroundColor = [UIColor clearColor];
            //[btn addTarget:self action:@selector(slideButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //[_slideSV addSubview:btn];
        }
        [self addSubview:_slideSV];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 35, frame.size.width, 35)];
        //bgView.backgroundColor = HEXACOLOR(0x5685ad, 0.8);
        //        bgView.backgroundColor = HEXACOLOR(0x076e34, 0.8);
        
        [self addSubview:bgView];
        
        
        //标题
        //_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, frame.size.width - 10, 20)];
        //_titleLabel.backgroundColor = [UIColor clearColor];
        //_titleLabel.textColor = [UIColor whiteColor];
        //_titleLabel.font = [UIFont systemFontOfSize:13];
        //_titleLabel.textAlignment = NSTextAlignmentCenter;
        //_titleLabel.text = ((SlideItem *)_slideArray[0]).title;
        //[bgView addSubview:_titleLabel];
        
        
        //分页控制器
        _pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
        _pageCtl.numberOfPages = _slideArray.count;
        _pageCtl.userInteractionEnabled = NO;
        [_pageCtl addTarget:self action:@selector(pageCtlClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_pageCtl];
        _pageCtl.center = CGPointMake(ScreenWidth/2.0, 20);
        
    }
    return self;
}

#pragma mark - timer 生成和清除

//开始滚动动画
- (void)startSlideAnimation
{
    //如果计时器存在则清除
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3
                                              target:self
                                            selector:@selector(scrollViewSlide)
                                            userInfo:nil
                                             repeats:YES];
}

//停止滚动
- (void)stopSlideAnimation
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark - 滚动视图的定时方法和手动方法
//定时滚动方法
- (void)scrollViewSlide
{
    if (_pageCtl.currentPage == 0)
    {
        _offset = 1;
    }
    
    if (_pageCtl.currentPage == _slideArray.count - 1)
    {
        _offset = -1;
    }
    _pageCtl.currentPage = _offset + _pageCtl.currentPage;
    
    //滑动
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         _slideSV.contentOffset = CGPointMake(_pageCtl.currentPage * self.frame.size.width, 0);
                         
                     } completion:nil];
    
    //    _titleLabel.text = [_slideArray[_pageCtl.currentPage] valueForKey:@"title"];
    
}

- (void)pageCtlClick
{
    //    if (_pageCtl.currentPage / 2 < _slideArray.count / 2)
    //    {
    //        _offset = 1;
    //    }
    //
    //    if (_pageCtl.currentPage / 2 > _slideArray.count/2)
    //    {
    //        _offset = -1;
    //    }
    //
    //    NSLog(@"%d",_pageCtl.currentPage/2);
    //    NSLog(@"%d",_slideArray.count/2);
    //
    //
    //    _pageCtl.currentPage = _offset + _pageCtl.currentPage;
    //
    //    //滑动
    //    [UIView animateWithDuration:1
    //                          delay:0
    //                        options:UIViewAnimationOptionAllowUserInteraction
    //                     animations:^{
    //                         _slideSV.contentOffset = CGPointMake(_pageCtl.currentPage * self.frame.size.width, 0);
    //
    //                     } completion:nil];
    //
    //    _titleLabel.text = [NSString stringWithFormat:@"标题%d",_pageCtl.currentPage];
    
}


#pragma mark - QTXSlideViewDelegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageCtl.currentPage = _slideSV.contentOffset.x/self.frame.size.width;
    
    _titleLabel.text = ((SlideItem *)_slideArray[_pageCtl.currentPage]).title;
    
    [self stopSlideAnimation];
}

//左侧按钮事件
//- (void)slideButtonClicked:(UIButton *)btn
//{
//    if (_slideDelegate && [_slideDelegate respondsToSelector:@selector(QTXSlideView:slideIndex:)])
//    {
//        [_slideDelegate QTXSlideView:self slideIndex:_pageCtl.currentPage];
//    }
//}

@end
