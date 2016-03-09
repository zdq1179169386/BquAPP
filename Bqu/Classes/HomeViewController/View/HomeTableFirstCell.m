//
//  HomeTableFirstCell.m
//  Bqu
//
//  Created by yb on 15/11/13.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "HomeTableFirstCell.h"
#import "QTXSlideView.h"
#import "ButtonsView.h"

#define slideViewHeight 158/375.0f

#define buttonsHeight 85

#define  MaxCount 3

typedef BOOL  direction;


@interface HomeTableFirstCell ()<UIScrollViewDelegate>
{
    NSInteger _offset;

}

@property(nonatomic,strong)UIScrollView *scrollview;

@property(nonatomic,strong)UIPageControl *control;
@property (nonatomic,strong)NSTimer * timer;
@end

@implementation HomeTableFirstCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, slideViewHeight * ScreenWidth)];
        _scrollview.delegate=self;
        _scrollview.pagingEnabled=YES;
        _scrollview.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageViewClick:)];
        [_scrollview addGestureRecognizer:tapGesture];
        [self.contentView addSubview:_scrollview];
        
        self.control=[[UIPageControl alloc]initWithFrame:CGRectMake(0, slideViewHeight * ScreenWidth-10 , 100, 10)];
        //设置未选中的颜色
        _control.pageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"unSelectedPagePoint"]];
        //选中的颜色
        _control.currentPageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"selectedPagePoint"]];
//        [_control addTarget:self action:@selector(CellpageControl) forControlEvents:UIControlEventValueChanged];
        //        _control.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_control];
        _control.center = CGPointMake(ScreenWidth/2.0, slideViewHeight * ScreenWidth-5);
    
      
        
    }
    return self;
}
-(void)startTimer
{
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
-(void)stopTimer
{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}
-(void)nextPage
{
    CGPoint newOffset = CGPointMake(self.scrollview.contentOffset.x + CGRectGetWidth(self.scrollview.frame)  , 0);
    [self.scrollview setContentOffset:newOffset animated:YES];
}
-(void)setSourceArray:(NSMutableArray *)sourceArray
{
    _sourceArray = [self getImageUrl:sourceArray];
    for (UIView * view in self.scrollview.subviews) {
        [view removeFromSuperview];
    }
    CGSize contentSize;
    CGPoint startPoint;
    //    NSLog(@"%d",_isWebImage);
    //    NSLog(@"array=%lu",array.count);
    if (_sourceArray.count > 1)
    {     //多张图片
        for (int i = 0 ; i < _sourceArray.count + 2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            if (i == 0) {
                //第一个imageview放最后一张
                //                imageView.image = [UIImage imageNamed:array[array.count - 1]]
                [imageView sd_setImageWithURL:[NSURL URLWithString:[_sourceArray lastObject]] placeholderImage:nil];
                
            }else if(i == _sourceArray.count + 1){
                //最后一个imageview放第一张
                //                imageView.image = [UIImage imageNamed:array[0]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[_sourceArray firstObject]] placeholderImage:nil];
            }else{
                //4，1，2，3，4，1类似
                //                imageView.image = [UIImage imageNamed:array[i - 1]];
                 [imageView sd_setImageWithURL:[NSURL URLWithString:_sourceArray[i-1]] placeholderImage:nil];
            }
            [self.scrollview addSubview:imageView];
            //            contentSize = CGSizeMake((array.count + 2) * self.frame.size.width,0);
            //            startPoint = CGPointMake(self.frame.size.width, 0);
        }
        contentSize = CGSizeMake((_sourceArray.count + 2) * self.frame.size.width,0);
        startPoint = CGPointMake(self.frame.size.width, 0);
    }
    else
    { //1张图片
        for (int i = 0; i < _sourceArray.count; i ++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            //            imageView.image = [UIImage imageNamed:array[i]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_sourceArray[i]] placeholderImage:nil];
            [self addSubview:imageView];
        }
        contentSize = CGSizeMake(self.frame.size.width, 0);
        startPoint = CGPointZero;
    }
    //开始的偏移量跟内容尺寸
    self.scrollview.contentOffset = startPoint;
    self.scrollview.contentSize = contentSize;
    
    _control.numberOfPages = _sourceArray.count;
    CGSize size = [_control sizeForNumberOfPages:_sourceArray.count];
    _control.bounds = CGRectMake(0, 0, size.width, size.height);
    _control.center = CGPointMake(ScreenWidth/2.0, self.scrollview.frame.size.height-10);
    
    [self startTimer];
}
-(NSMutableArray *)getImageUrl:(NSMutableArray*)sliveAry
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (int i=0 ; i< sliveAry.count; i++) {
        NSDictionary * dic = sliveAry[i];
        NSString * str = dic[@"ImageUrl"];
        [array addObject:str];
    }
    return array;
}
#pragma markpageControl的绑定方法

#pragma mark - scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x < self.frame.size.width) {
        [self.scrollview setContentOffset:CGPointMake(self.frame.size.width * (self.sourceArray.count + 1), 0) animated:NO];
    }
    //偏移超过
    if (scrollView.contentOffset.x > self.frame.size.width * (self.sourceArray.count + 1)) {
        [self.scrollview setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    }
//    NSLog(@"scrollView.contentOffset.x=%f",scrollView.contentOffset.x);
    int pageCount = scrollView.contentOffset.x / self.frame.size.width;
//    NSLog(@"pageCount=%d",pageCount);
    if (pageCount > self.sourceArray.count) {
        pageCount = 0;
    }else if (pageCount == 0){
        pageCount = (int)self.sourceArray.count - 1;
    }else{
        pageCount--;
    }
//    NSLog(@"pageCountNEW=%d",pageCount);
    self.control.currentPage = pageCount;
}
//停止滚动时
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTimer];
}
//开始拖动时
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

#pragma mark -- pagecontrol的代理
-(void)pageViewClick:(UITapGestureRecognizer *)tap
{
    if([self.delegate respondsToSelector:@selector(HomeTableFirstCellDelegate:withSelectedPage:)])
    {
        [self.delegate HomeTableFirstCellDelegate:self withSelectedPage:_control.currentPage];
    }
}

@end
