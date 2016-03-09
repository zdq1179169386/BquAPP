//
//  BuyButtomView.m
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BuyButtomView.h"

#define buyView_H 205

@interface BuyButtomView ()<AddAndCutBtnDelegate>
{
    //限购商品的最大数量
    NSInteger _maxCount;
}
/**灰色*/
@property(nonatomic,strong)UIView * topbgView;

/**价格*/
@property(nonatomic,strong)UILabel * price;

/**运费*/
@property (nonatomic,strong)UILabel * billBtn;

/**税费*/
@property (nonatomic,strong)UILabel * taxBtn;

@property(nonatomic,strong)UIView * allView;
/**消失按钮*/
@property(nonatomic,strong)UIButton * disappearBtn;

/**确认购买按钮*/
@property(nonatomic,strong)UIButton * buyBtn;

@property (nonatomic,strong) UILabel * tax;

@property (nonatomic,strong) UIImageView * taxImage;
/**关税大于50，*/
@property (nonatomic,strong) UILabel * taxLine;
@end

@implementation BuyButtomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.allView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - buyView_H, ScreenWidth, buyView_H)];
        self.allView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.allView];
        
        [self initUI];
    }
    return self;
}
-(void)initUI
{
    CGFloat cellH = self.allView.height/4.0;
    UILabel * price = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 59)];
    price.textColor = [UIColor colorWithHexString:@"#333333"];
//    price.backgroundColor = [UIColor redColor];
    [self.allView addSubview:price];
    price.font = [UIFont systemFontOfSize:15];
    self.price = price;
    
    UIButton * disappearBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-10, 10, 30, 30)];
     disappearBtn.tag = 111;
//    disappearBtn.layer.borderWidth= 1;
    disappearBtn.layer.borderColor = [UIColor colorWithHexString:@"#333333" alpha:0.3].CGColor;
    [disappearBtn setImage:[UIImage imageNamed:@"B区详情页03-立即购买弹窗"] forState:UIControlStateNormal];
//    disappearBtn.backgroundColor = [UIColor redColor];
    [disappearBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.allView addSubview:disappearBtn];
    disappearBtn.center = CGPointMake(ScreenWidth-25, price.center.y);
    self.disappearBtn = disappearBtn;
    
    CGFloat line1_Y = CGRectGetMaxY(price.frame) ;
    UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, line1_Y , ScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];
    [self.allView addSubview:line1];
    
    CGFloat number_Y = CGRectGetMaxY(line1.frame) ;
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(10, line1_Y , 50, 44)];
    number.text = @"数量";
    number.textColor = [UIColor colorWithHexString:@"#333333"];
//    number.backgroundColor = [UIColor redColor];
    number.font = [UIFont systemFontOfSize:15];
    [self.allView addSubview:number];

    AddAndCutBtn * numberBtn = [[AddAndCutBtn alloc] initWithFrame:CGRectMake(ScreenWidth-100, line1_Y, 90, cellH-26)];
    numberBtn.delegate = self;
    [self.allView addSubview:numberBtn];
    numberBtn.center = CGPointMake(ScreenWidth-60, number.center.y);
    self.numberBtn = numberBtn;
    
    CGFloat line2_Y = CGRectGetMaxY(number.frame) ;
    UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, line2_Y , ScreenWidth, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];
    [self.allView addSubview:line2];
    
    
//    CGFloat line3_Y = CGRectGetMaxY(billBtn.frame) ;
    UILabel * line3 = [[UILabel alloc] initWithFrame:CGRectMake(0, line2_Y , ScreenWidth, 1)];
    line3.backgroundColor =  [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];
    [self.allView addSubview:line3];
    
    CGFloat tax_Y = CGRectGetMaxY(line3.frame) ;
    UILabel * tax = [[UILabel alloc] initWithFrame:CGRectMake(10, tax_Y , 50, 44)];
    tax.text = @"税费";
    tax.textColor = [UIColor colorWithHexString:@"#333333"];
//    tax.backgroundColor = [UIColor redColor];
    tax.font = [UIFont systemFontOfSize:15];
    [self.allView addSubview:tax];
    self.tax = tax;
    
    
    UILabel * taxBtn = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-110, tax_Y, 100, cellH)];
//    taxBtn.backgroundColor = [UIColor grayColor];
    taxBtn.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.allView addSubview:taxBtn];
    taxBtn.font = [UIFont systemFontOfSize:15];
    self.taxBtn = taxBtn;
    
    UIImageView * taxImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"关税小于50免征"]];
    [self.allView addSubview:taxImage];
    self.taxImage = taxImage;
    
    CGFloat line4_Y = CGRectGetMaxY(tax.frame) ;
    UILabel * line4 = [[UILabel alloc] initWithFrame:CGRectMake(0, line4_Y , ScreenWidth, 1)];
    line4.backgroundColor =  [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];
    [self.allView addSubview:line4];

    CGFloat buyBtn_Y = CGRectGetMaxY(line4.frame)+10;
    UIButton * buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, buyBtn_Y, ScreenWidth-30, 34)];
    [buyBtn setTitle:@"确认购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor colorWithHexString:@"E9113D"] forState:UIControlStateNormal];
    buyBtn.layer.borderWidth = 1.0;
    buyBtn.layer.borderColor = [UIColor colorWithHexString:@"E9113D"].CGColor;
    buyBtn.layer.cornerRadius = 5;
    buyBtn.clipsToBounds = YES;
    buyBtn.tag = 333;
    [buyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.allView addSubview:buyBtn];
    self.buyBtn = buyBtn;
    self.productCount = @"1";
    
    UILabel * taxLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 0, 1)];
    taxLine.backgroundColor =  [UIColor grayColor];
    taxLine.hidden = YES;
    [taxBtn addSubview:taxLine];
    self.taxLine = taxLine;
    
}
-(void)btnClick:(UIButton *)selectedBtn
{
    //实现block
    if (self.buyViewBlock) {
        self.buyViewBlock(selectedBtn);
    }
}
+(instancetype)creatBuyButtomView
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
}

-(void)setProduct:(ProductModel *)product
{
    _product = product;
    self.price.text = [NSString stringWithFormat:@"¥ %@",_product.SalePrice];
    NSString * tax = [_product.TaxRate stringByReplacingOccurrencesOfString:@"%" withString:@""];
    NSLog(@"%lf",tax.floatValue);
    self.taxBtn.text = [NSString stringWithFormat:@"%0.2lf",_product.CustomPushPrice.floatValue * tax.floatValue /100.0];
    [self.taxBtn sizeToFit];
    self.taxBtn.center = CGPointMake(ScreenWidth-10-self.taxBtn.size.width/2.0, self.tax.center.y);
    if (self.taxBtn.text.floatValue>=50.0) {
        self.taxLine.hidden = NO;
        self.taxLine.size = CGSizeMake(CGRectGetWidth(self.taxBtn.frame)+2, 1);
        self.taxLine.center = CGPointMake(self.taxBtn.width/2.0, self.taxBtn.height/2.0);
    }
    CGFloat miniX = CGRectGetMinX(self.taxBtn.frame);
    self.taxImage.center = CGPointMake(miniX-5-self.taxImage.size.width/2.0, self.taxBtn.center.y);
    if ( _product.MaxBuyCount.intValue>0) {        
        _maxCount = _product.MaxBuyCount.intValue;
    }
    
    
}
#pragma mark -- AddAndCutBtnDelegate
-(void)AddAndCutBtn:(AddAndCutBtn *)selfView withBtn:(UIButton *)btn withLabel:(UILabel *)label
{
    if (btn.tag ==111) {
        //减
        if ([label.text isEqualToString:@"1"]) {
            return;
        }else
        {
            label.text = [NSString stringWithFormat:@"%ld",label.text.integerValue -1];
        }
    }else
    {
        if (_maxCount > 0 && label.text.intValue >= _maxCount) {
            NSString * maxCount = [NSString stringWithFormat:@"限购%ld件",_maxCount];
            [ProgressHud addProgressHudWithView:self andWithTitle:maxCount withTime:1 withType:MBProgressHUDModeText];
            return;
            
        }else{
            if (label.text.intValue>=50) {
                
                [ProgressHud addProgressHudWithView:self andWithTitle:@"限购50件" withTime:1 withType:MBProgressHUDModeText];
                return;
            }
        }
        
        label.text = [NSString stringWithFormat:@"%ld",label.text.integerValue + 1];
        
    }
    self.productCount = label.text;
    //改变总价
    double priceNum = label.text.intValue * self.product.SalePrice.doubleValue;
    self.price.text = [NSString stringWithFormat:@"¥ %.2f",priceNum];
    //改变税费
    NSString * tax = [_product.TaxRate stringByReplacingOccurrencesOfString:@"%" withString:@""];
    self.taxBtn.text = [NSString stringWithFormat:@"%0.2lf",_product.CustomPushPrice.floatValue * tax.floatValue /100.0 *label.text.intValue];
    [self.taxBtn sizeToFit];
    self.taxBtn.center = CGPointMake(ScreenWidth-10-self.taxBtn.size.width/2.0, self.tax.center.y);
    if (self.taxBtn.text.floatValue>=50.0) {
        self.taxLine.hidden = NO;
        self.taxLine.size = CGSizeMake(CGRectGetWidth(self.taxBtn.frame), 1);
        self.taxLine.center = CGPointMake(self.taxBtn.width/2.0, self.taxBtn.height/2.0);
    }else
    {
        self.taxLine.hidden = YES;
    }

    //改变图片的位置
    CGFloat miniX = CGRectGetMinX(self.taxBtn.frame);
    self.taxImage.center = CGPointMake(miniX-5-self.taxImage.size.width/2.0, self.taxBtn.center.y);

}
@end
