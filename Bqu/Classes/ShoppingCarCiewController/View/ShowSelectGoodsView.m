//
//  ShowSelectGoodsView.m
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ShowSelectGoodsView.h"
#import "GoodsTool.h"


#define WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ShowSelectGoodsView ()
{
    BOOL open;
}

@end

@implementation ShowSelectGoodsView


-(instancetype)init
{
    if (self = [super init])
    {
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 130)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        //选择商品个数
        open = 0;
        self.selectGoodsCountLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 100, 15)];
        self.selectGoodsCountLab.backgroundColor = [UIColor clearColor];
        self.selectGoodsCountLab.font = [UIFont systemFontOfSize:13];
        self.selectGoodsCountLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [bgView addSubview:self.selectGoodsCountLab];
        
        //商品总额
        self.allGoodsPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-160, 12, 80, 14)];
        //self.allGoodsPriceLab.backgroundColor = [UIColor clearColor];
        self.allGoodsPriceLab.text = @"商品总额：";
        self.allGoodsPriceLab.font = [UIFont systemFontOfSize:13];
        self.allGoodsPriceLab.textColor = [UIColor colorWithHexString:@"#999999"];
        self.allGoodsPriceLab.textAlignment =NSTextAlignmentRight;
        [bgView addSubview:self.allGoodsPriceLab];
        
        //显示商品总额
        self.showGoodsPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-80, 12, 70, 14)];
        self.showGoodsPriceLab.backgroundColor =[UIColor clearColor];
        self.showGoodsPriceLab.font = [UIFont systemFontOfSize:13];
        self.showGoodsPriceLab.textColor = [UIColor colorWithHexString:@"#999999"];
        self.showGoodsPriceLab.textAlignment =NSTextAlignmentRight;
        [bgView addSubview:self.showGoodsPriceLab];
        
        //税金
        self.tax = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-160,37, 80, 14)];
        self.tax.backgroundColor = [UIColor clearColor];
        self.tax.text = @"税金：";
        self.tax.font = [UIFont systemFontOfSize:13];
        self.tax.textColor = [UIColor colorWithHexString:@"#999999"];
        self.tax.textAlignment =NSTextAlignmentRight;
        [bgView addSubview:self.tax];
        
        self.view = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-240, 33, 114, 23)];
        self.view.image = [UIImage imageNamed:@"关税小于50免征_无字"];
        [bgView addSubview:self.view];
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 104, 21)];
        self.lable.backgroundColor = [UIColor whiteColor];
        self.lable.text =@"关税≤50，免征哦!";
        self.lable.font = [UIFont systemFontOfSize:12];
        self.lable.textColor = [UIColor colorWithHexString:@"#e8103c"];
        self.lable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.lable];
        
        
        //显示税金
        self.showTax = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-80,37, 70, 14)];
        self.showTax.backgroundColor = [UIColor clearColor];
        self.showTax.font = [UIFont systemFontOfSize:13];
        self.showTax.textColor = [UIColor colorWithHexString:@"#999999"];
        self.showTax.textAlignment =NSTextAlignmentRight;
        [bgView addSubview:self.showTax];
        
        //点击 显示税金计算方法
        self.showCalculateRateBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, 10, 100, 40)];
        self.showCalculateRateBtn.backgroundColor = [UIColor clearColor];
        [self.showCalculateRateBtn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchDown];
        [bgView addSubview:self.showCalculateRateBtn];
        
        self.showCalculateRateImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
        self.showCalculateRateImage.backgroundColor = [UIColor redColor];
        self.showCalculateRateImage.hidden = !open;
        self.showCalculateRateImage.backgroundColor = [UIColor clearColor];    
        [bgView addSubview:self.showCalculateRateImage];
        
        
        //所有的价格
        self.allPrice = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-187,60, 100, 14)];
        self.allPrice.backgroundColor = [UIColor clearColor];
        self.allPrice.text = @"总计(不含运费):";
        self.allPrice.font = [UIFont systemFontOfSize:13];
        self.allPrice.textColor = [UIColor colorWithHexString:@"#333333"];
        self.allPrice.textAlignment =NSTextAlignmentRight;
        [bgView addSubview:self.allPrice];
        
        //显示所有价格
        self.showAllPrice = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-80,60,70, 14)];
        self.showAllPrice.backgroundColor = [UIColor clearColor];
        self.showAllPrice.font = [UIFont systemFontOfSize:14];
        self.showAllPrice.textColor = [UIColor colorWithHexString:@"#E8103C"];
        self.showAllPrice.textAlignment =NSTextAlignmentRight;
        [bgView addSubview:self.showAllPrice];
        
        //结算
        self.settleBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-120, 83, 110, 38)];
        [self.settleBtn setTitle:@"去结算" forState:UIControlStateNormal];
        self.settleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.settleBtn.layer.cornerRadius = 3;
        self.settleBtn.backgroundColor = [UIColor colorWithHexString:@"#E8103C"];
        [self.settleBtn addTarget:self action:@selector(settleTouchDown:)forControlEvents:UIControlEventTouchDown];
        [self.settleBtn setExclusiveTouch:YES];
        [bgView addSubview:self.settleBtn];
        
        
        self.promptPrice = [[PromptPriceView alloc] initWithFrame:CGRectMake(10, 83, ScreenWidth-140, 38)];
        [bgView addSubview:self.promptPrice];
        [self addSubview:bgView];
        
    }
    return self;
}

-(void)show:(UIButton*)sender
{
    open = !open;
    self.showCalculateRateImage.hidden = !open;
}

-(void)settleTouchDown:(UIButton *)sender
{

    if ([self.delegate respondsToSelector:@selector(SettlebtnClick:andFlag:)]) {
        [self.delegate SettlebtnClick:self andFlag:(int)self.tag];//点击按钮之后 执行代理语句
    }
}


//划去的税金=商品销售价*税率*数量  总和      后面显示的税金=海关推送价*税率*数量  总和
-(void) buildLine:(NSArray*)Allgoods
{
    GoodsTool * goodsTool = [[GoodsTool alloc] initWithArray:Allgoods];
    
    UILabel * LineLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-80,51, 70, 1)];
    LineLab.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:LineLab]; //在价格上划线
    
    UILabel *tureLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-300, 30, 150, 10)];
    tureLab.text= [NSString stringWithFormat:@"¥优惠后价格：%.2f",[goodsTool selectCustomsGoodsTax]];
    tureLab.font = [UIFont systemFontOfSize:11];
    tureLab.textAlignment = NSTextAlignmentRight;
    tureLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:tureLab];//真实的税金
}


-(void)setValue:(NSArray *)Allgoods
{
    [self buildLine:Allgoods];
    [self setValueNOLine:Allgoods];
}


-(void)setValueNOLine:(NSArray *)Allgoods
{
    GoodsTool * goodsTool = [[GoodsTool alloc] initWithArray:Allgoods];
    // 显示购买的商品个数
    _selectGoodsCountLab.text = [NSString stringWithFormat:@"已选择商品%ld件",(long)[goodsTool selectGoodsNum]];
    // 显示购买的商品的价格
    _showGoodsPriceLab.text = [NSString stringWithFormat:@"¥ %.2f",[goodsTool selectgoodsPrice]];
    //显示购买的商品的税金
    double tax = [goodsTool selectCustomsGoodsTaxTure];
    _showTax.text = [NSString stringWithFormat:@"¥ %.2f",tax];
    
    //税金小于50
    if (tax <= 50 )
    {
        if (tax <=0.01) {
            self.view.hidden = YES;
        }
        else
        {
        
        UILabel * LineLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-60,43, 50, 1)];
        CGSize size = [_showTax sizeThatFits:CGSizeMake(_showTax.width, MAXFLOAT)];
        LineLab.x = ScreenWidth - 10 - size.width;
        LineLab.width = size.width;
        LineLab.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        
        [self addSubview:LineLab];
        
//        UILabel * tureTaxLab =[[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-170, 37, 70, 14)];
//        tureTaxLab.text = @"¥: 0.00";
//        tureTaxLab.font = [UIFont systemFontOfSize:13];
//        tureTaxLab.textColor = [UIColor colorWithHexString:@"#999999"];
//        [self addSubview:tureTaxLab];
        self.view.hidden = NO;
        }
        
    }
    else if (tax >50)
    {
        self.view.hidden = NO;
        self.view.x = self.view.x - 60;
        self.view.width = self.view.width+60;
        self.lable.width = self.lable.width+55;
        //self.lable.backgroundColor = [UIColor blueColor];
        self.lable.text = @"亲,关税已超50,≤50免征哦！";
    }
    _showAllPrice.text = [NSString stringWithFormat:@"¥ %.2f",[goodsTool selectAllPrice]] ;
    BOOL y =[goodsTool isOutOfPrice];
    if (  !y ) {
        _promptPrice.hidden = YES;
    }
    else
    {
        _promptPrice.hidden = NO;
    }
    
    if ([goodsTool selectGoodsNum] < 0.01)
    {
        self.settleBtn.enabled = NO;
        self.settleBtn.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    }
}
@end
