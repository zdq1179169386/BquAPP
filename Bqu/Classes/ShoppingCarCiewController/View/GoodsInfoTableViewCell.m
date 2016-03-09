//
//  GoodsInfoTableViewCell.m
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "GoodsInfoTableViewCell.h"
#define PWIDTH WIDTH/375
#import "ShoppingCarTool.h"



@implementation GoodsInfoTableViewCell
#pragma mark - cell 初始化

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //布局界面
        double per = 1;
        if ( ScreenWidth == 414) {
            per = 1.16;
        }
        
        double pwidth = PWIDTH;
        double cellHigh = 91*per;
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, cellHigh)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        //是否选中图片
        _isSelectImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*per, cellHigh*0.5-8.5, 17, 17)];
        [bgView addSubview:_isSelectImg];
        
        
        //添加商品图片
        _goodsImgV = [[UIImageView alloc]initWithFrame:CGRectMake(17+20*per, 15*per, 60*per, 60*per)];
        [bgView addSubview:_goodsImgV];
        
        
        //商品价格
        _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-75, 15*per, 65, 10)];
        _priceLab.text = @"100";
        _priceLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [_priceLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13*per]];
        _priceLab.textAlignment = NSTextAlignmentRight;
        _priceLab.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [_priceLab sizeThatFits:CGSizeMake(_priceLab.width, MAXFLOAT)];
        _priceLab.height = size.height;
        [bgView addSubview:_priceLab];
        
        
        //添加商品标题
        
        _goodsTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(17+90*per, 15*per,_priceLab.x-(17+90*per), 10)];
        _goodsTitleLab.text = @"商品介绍...商品介绍...商品介绍...商品介绍...商品介绍...商品介绍...";
        _goodsTitleLab.backgroundColor = [UIColor whiteColor];
        _goodsTitleLab.font = [UIFont systemFontOfSize:13*per];
        _goodsTitleLab.numberOfLines= 2;
        _goodsTitleLab.textColor= [UIColor colorWithHexString:@"#333333"];
        _goodsTitleLab.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:_goodsTitleLab];
        
        
        _CountLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-75, _priceLab.y+_priceLab.height+6*per, 65, 10)];
        _CountLab.text = @"1990";
        _CountLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _CountLab.font = [UIFont systemFontOfSize:10*per];
        _CountLab.textAlignment = NSTextAlignmentRight;
        _CountLab.lineBreakMode = NSLineBreakByWordWrapping;
        size = [_CountLab sizeThatFits:CGSizeMake(_CountLab.width, MAXFLOAT)];
        _CountLab.height = size.height;
        
        [bgView addSubview:_CountLab];
        
        
        //商品税率
        _rateOfTaxationLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-75, _CountLab.y+_CountLab.height+13*per, 65,10)];
        _rateOfTaxationLab.text = @"税率：";
        _rateOfTaxationLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _rateOfTaxationLab.font = [UIFont systemFontOfSize:10*per];
        _rateOfTaxationLab.textAlignment = NSTextAlignmentRight;
        _rateOfTaxationLab.lineBreakMode = NSLineBreakByWordWrapping;
        size = [_rateOfTaxationLab sizeThatFits:CGSizeMake(_rateOfTaxationLab.width, MAXFLOAT)];
        _rateOfTaxationLab.height = size.height;
        [bgView addSubview:_rateOfTaxationLab];
        
        
        //减按钮
        //double btnW = 22*per;
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(_goodsTitleLab.x, 50                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               *per, 27*per, 27*per);
        [_deleteBtn addTarget:self action:@selector(deleteAddBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        [_deleteBtn setImage:[UIImage imageNamed:@"Red-click"] forState:UIControlStateNormal];
        _deleteBtn.tag = 11;
        [_deleteBtn.layer setBorderWidth:1.0];   //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.9, 0.9, 0.9, 1 });
        [_deleteBtn.layer setBorderColor:colorref];//边框颜色
        [_deleteBtn setExclusiveTouch:YES];
        [bgView addSubview:_deleteBtn];
        
        //购买商品的数量
        _numCountLab = [[UILabel alloc]initWithFrame:CGRectMake(_deleteBtn.x+_deleteBtn.width-1, _deleteBtn.y,37*per, 27*per)];
        _numCountLab.textAlignment = NSTextAlignmentCenter;
        _numCountLab.font = [UIFont systemFontOfSize:13*per];
        _numCountLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _numCountLab.textAlignment = NSTextAlignmentCenter;
        [_numCountLab.layer setBorderWidth:1.0];   //边框宽度
        [_numCountLab.layer setBorderColor:colorref];//边框颜色
        [bgView addSubview:_numCountLab];
        
        //加按钮
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(_numCountLab.x+_numCountLab.width-1, _numCountLab.y, 27*per, 27*per);
        [_addBtn addTarget:self action:@selector(deleteAddBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.tag = 12;
        [_addBtn setImage:[UIImage imageNamed:@"Add-click"] forState:UIControlStateNormal];
        [_addBtn.layer setBorderWidth:1.0];   //边框宽度
        [_addBtn.layer setBorderColor:colorref];//边框颜色
//        _addBtn.backgroundColor = [UIColor redColor];
        [_addBtn setExclusiveTouch:YES];
        [bgView addSubview:_addBtn];
        
        
        //设置失效的商品 ，显示失效
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(_deleteBtn.x, _deleteBtn.y, _deleteBtn.width+_numCountLab.width+_addBtn.width-2, _deleteBtn.height)];
        _lable.text = @"失效";
        _lable.font = [UIFont systemFontOfSize:11*per];
        _lable.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        _lable.textColor = [UIColor colorWithHexString:@"#999999"];
        _lable.layer.cornerRadius = 2;
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.layer.cornerRadius = 6;
        _lable.hidden = YES;
        [bgView addSubview:_lable];
        
        
        [self addSubview:bgView];
    }
    return self;
}

-(void)setGoodsModel:(GoodsInfomodel *)goodsModel
{
    _goodsModel = goodsModel;
    [self addTheValue:goodsModel];
}
/**
 *  给单元格赋值
 *
 *  @param goodsModel 里面存放各个控件需要的数值
 */
-(void)addTheValue:(GoodsInfomodel *)goodsModel
{

    [_goodsImgV sd_setImageWithURL:[NSURL URLWithString:goodsModel.imgUrl] placeholderImage:[UIImage imageNamed:@"购物车&提交订单&支付失败-商品占位图120x120-"]] ;
    _rateOfTaxationLab.text = [NSString stringWithFormat:@"税率:%@%%",goodsModel.taxRate];
    _goodsTitleLab.text = goodsModel.name;
    _priceLab.text = [NSString stringWithFormat:@"￥ %0.2f",goodsModel.price.doubleValue];
    _numCountLab.text = [NSString stringWithFormat:@" %@",goodsModel.count];
    _CountLab.text = [NSString stringWithFormat:@" x %@",goodsModel.count];
    
    if (goodsModel.selectState)
    {
        _selectState = YES;
        _isSelectImg.image = [UIImage imageNamed:@"xuntrue"];
    }else{
        _selectState = NO;
        _isSelectImg.image = [UIImage imageNamed:@"xunfalse"];
    }
    _deleteBtn.hidden = NO;
    _numCountLab.hidden = NO;
    _addBtn.hidden = NO;
    _lable.hidden = YES;
    //商品状态为正常时
    if(goodsModel.status.boolValue == 0 || (goodsModel.tradeType.boolValue == 1 && goodsModel.taxRate.integerValue == 0&&goodsModel.isVirtualProduct.boolValue== 0) )
    {
        _deleteBtn.hidden = YES;
        _numCountLab.hidden = YES;
        _addBtn.hidden = YES;
        _lable.hidden = NO;
    }
    
    _goodsTitleLab.textAlignment = NSTextAlignmentLeft;
    _goodsTitleLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [_goodsTitleLab sizeThatFits:CGSizeMake(_goodsTitleLab.width, MAXFLOAT)];
    _goodsTitleLab.height = size.height;
    
}

/**
 *  点击减按钮实现数量的减少
 *
 *  @param sender 减按钮
 */
-(void)deleteAddBtnAction:(UIButton *)sender
{
//    判断是否选中，选中才能点击
//    调用代理
    
    NSInteger count = self.goodsModel.count.integerValue;
    switch ((int)sender.tag)
    {
        case 11:
        {
            //做减法
            //先获取到当期行数据源内容，改变数据源内容，刷新表格
            if (count > 1)
            {
                count--;
                self.goodsModel.count = [NSString stringWithFormat:@"%ld",(long)count] ;
            }
        }
            break;
        case 12:
        {
            //做加法
            count++;
            if (count > [self.goodsModel.maxSale integerValue] )
            {
                count--;
                UIAlertView * view = [[UIAlertView alloc] initWithTitle:nil message:@"对不起,您购买的商品没有这么多库存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [view show];
            }
            if (count > 50)
            {
                count--;
                UIAlertView * view = [[UIAlertView alloc] initWithTitle:nil message:@"对不起,您最多只能买50件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [view show];
            }
            self.goodsModel.count = [NSString stringWithFormat:@"%ld",(long)count] ;
            
        }
            break;
        default:
            break;
    }
    self.numCountLab.text =self.goodsModel.count;
    [self updateCartInfo];
    if ([self.delegate respondsToSelector:@selector(btnClick:andFlag:)]) {
        [self.delegate btnClick:self andFlag:(int)sender.tag];
    }
}

#pragma  mark——————每次更新购物车内物品数量的时候 发送请求信息————————开始
-(void)updateCartInfo
{
    [ShoppingCarTool updateCartInfo:self.goodsModel.skuId count:self.goodsModel.count success:^(id json) {
        //NSString *resultCode = json[@"resultCode"];
        //请求成功
        
        } failure:^(NSError *error) {
        
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
