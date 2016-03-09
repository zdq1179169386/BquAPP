
//
//  HomeViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/9.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"
#import "QTXSlideView.h"


@interface HomeViewController : HSViewController<UITableViewDataSource,UITableViewDelegate>
{
    QTXSlideView   *_slideView;         //滑动幻灯片
    NSMutableArray *_homeGoodsArray;    //首页商品列表数组
    NSMutableArray *_adverArray;        //广告数组
    
}
//@property (nonatomic,strong)UIScrollView *bigScrollView;       //最底部的滑动视图


@end

