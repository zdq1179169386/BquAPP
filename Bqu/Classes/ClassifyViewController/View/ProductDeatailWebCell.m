
//
//  ProductDeatailWebCell.m
//  Bqu
//
//  Created by yb on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductDeatailWebCell.h"

@interface ProductDeatailWebCell ()<UIWebViewDelegate>

@end

@implementation ProductDeatailWebCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        NSString * information = @"产品信息 INFORMATION";
        
        NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:information];
        // 添加属性
        [attrStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[information rangeOfString:@"产品信息 "]];
        [attrStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[information rangeOfString:@"产品信息 "]];
        [attrStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:[information rangeOfString:@"INFORMATION"]];
        [attrStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:[information rangeOfString:@"INFORMATION"]];

        UILabel * productData = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        productData.attributedText = attrStr2;
//        [self.contentView addSubview:productData];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth-20, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
//        [self.contentView addSubview:line];
        
        UILabel * productName = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, ScreenWidth-40, 30)];
        productName.text = @"产品名称:";
        productName.font = [UIFont systemFontOfSize:14];
//        [self.contentView addSubview:productName];
        self.productName = productName;
        
        
        UILabel * productId = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 200, 30)];
        productId.text = @"商品货号:";
        productId.font = [UIFont systemFontOfSize:14];
//        [self.contentView addSubview:productId];
        self.productId = productId;
        
        NSString * string = @"温馨提示: 海外进口商品经常更换包装和附件，若更新不及时，敬请谅解！详情里的商品参数、外包装、功能、产地及附件仅供参考，请以实物为准。B区保证网站经营商品均为海外原装正品，且与当下市场同款主流新品一致。";
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] maxW:ScreenWidth-40];
        
        UILabel * tip = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, 100, 30)];
        tip.numberOfLines = 0;
        tip.text = string;
        tip.font = [UIFont systemFontOfSize:14];
//        [self.contentView addSubview:tip];
        tip.size = size;
        
        NSString * str = @"商品实拍 GOODSWILL";
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[str rangeOfString:@"商品实拍 "]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str rangeOfString:@"商品实拍 "]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:[str rangeOfString:@"GOODSWILL"]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:[str rangeOfString:@"GOODSWILL"]];

        CGFloat Y = CGRectGetMaxY(tip.frame);
        UILabel * photos = [[UILabel alloc] initWithFrame:CGRectMake(10, Y +10, 200, 30)];
        photos.attributedText = attrStr;
//        [self.contentView addSubview:photos];
        
        UILabel * lineTwo = [[UILabel alloc] initWithFrame:CGRectMake(10, Y+39, ScreenWidth-20, 1)];
        lineTwo.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
//        [self.contentView addSubview:lineTwo];
        
        UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        web.backgroundColor = [UIColor grayColor];
        web.scalesPageToFit = YES;
//        web.scrollView.scrollEnabled = YES;
//        web.delegate = self;
        [self.contentView addSubview:web];
        self.web = web;
    }
    return self;
}
-(void)setModel:(ProductModel *)model
{
    _model = model;
//    CGFloat documentWidth = [[self.web stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
//    CGFloat documentHeight = [[self.web stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
//    NSLog(@"%f,%f",documentHeight,documentWidth);
    self.productName.text = [NSString stringWithFormat:@"产品名称: %@",_model.ProductName];
    self.productId.text = [NSString stringWithFormat:@"商品货号: %@",_model.Id];
    if (_model.ProductDescription) {
//        self.web.size = CGSizeMake(ScreenWidth, documentHeight);
//        [self.web loadHTMLString:_model.ProductDescription baseURL:[NSURL URLWithString:TEST_URL]];
    }
}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    CGFloat documentWidth = [[self.web stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
//        CGFloat documentHeight = [[self.web stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
//        NSLog(@"--%f,--%f",documentHeight,documentWidth);
//
//      self.web.size = CGSizeMake(ScreenWidth, documentHeight);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
