//
//  BuyAndShoppingCarButtomBar.m
//  Bqu
//
//  Created by yb on 15/10/14.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BuyAndShoppingCarButtomBar.h"

@implementation BuyAndShoppingCarButtomBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self addSubview:line];
        self.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
//        CGFloat  shoppingCartW = frame.size.height-20;
        
        CGFloat shoppingCartW = ScreenWidth/5.0;
        CGFloat addShoppingCartW = ScreenWidth/5.0*2;
        CGFloat buyBtntW = ScreenWidth/5.0*2;
        
        self.shoppingCart = [[ZDQBtn alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.shoppingCart setImage:[UIImage imageNamed:@"购物车标志"] forState:UIControlStateNormal];
        self.shoppingCart.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
        self.shoppingCart.tag = 300;
        [self.shoppingCart addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.shoppingCart];
        self.shoppingCart.center = CGPointMake(shoppingCartW/2.0, 49/2.0);

        CGFloat addShoppingCart_X = CGRectGetMaxX(self.shoppingCart.frame);

        self.addShoppingCart = [[UIButton alloc] initWithFrame:CGRectMake(shoppingCartW, 0,addShoppingCartW, frame.size.height)];
        self.addShoppingCart.backgroundColor = [UIColor colorWithHexString:@"#FF8585"];
        [self.addShoppingCart addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        self.addShoppingCart.tag = 200;

        [self.addShoppingCart setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [self.addShoppingCart setTitle:@"加入购物车" forState:UIControlStateNormal];
        self.addShoppingCart.titleLabel.font = [UIFont boldSystemFontOfSize:17];

        CGFloat buyBtnX = CGRectGetMaxX(self.addShoppingCart.frame);

        self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(buyBtnX, 0, buyBtntW, frame.size.height)];
        [self.buyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.buyBtn.tag = 100;

        [self.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [self.buyBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = [UIColor colorWithHexString:@"#F50E38"];
        self.buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
     
        
        CGFloat minX = CGRectGetMidX(self.shoppingCart.frame);
        self.notEnought = [[UILabel alloc] initWithFrame:CGRectMake(shoppingCartW, 0, ScreenWidth-shoppingCartW, 49)];
        self.notEnought.text = @"已售罄,疯狂补货中";
        self.notEnought.font = [UIFont boldSystemFontOfSize:17];
        self.notEnought.textAlignment = NSTextAlignmentCenter;
        self.notEnought.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.notEnought.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        self.notEnought.hidden = YES;
//        self.notEnought.tag = 300;
//        self.notEnought.center = CGPointMake(minX/2.0, 10+ shoppingCartW/2.0);
        [self addSubview:self.notEnought];
        [self addSubview:self.buyBtn];
        [self addSubview:self.addShoppingCart];
    }
    return self;
}
-(void)setProduct:(ProductModel *)product
{
    _product = product;
    if (_product.Stock.intValue==0 || _product.Stock == nil) {
        self.addShoppingCart.hidden = YES;
        self.buyBtn.hidden = YES;
        self.notEnought.hidden = NO;
    }else
    {
        self.addShoppingCart.hidden = NO;
        self.buyBtn.hidden = NO;
        self.notEnought.hidden = YES;
    }

}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delagate respondsToSelector:@selector(BuyAndShoppingCarButtomBarDelegate:withBtn:)]) {
        [self.delagate BuyAndShoppingCarButtomBarDelegate:self withBtn:btn];
    }
}

@end
