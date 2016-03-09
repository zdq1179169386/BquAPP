//
//  ProductDetailBaseinformationCell.m
//  Bqu
//
//  Created by yb on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductDetailBaseinformationCell.h"
#define gapW 5
@implementation ProductDetailBaseinformationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat itemH = 40;
        
        UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, gapW, 100, itemH)];
        lable1.text = @"商品品牌:";
        lable1.textColor = [UIColor colorWithHexString:@"#999999"];
        
        UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, gapW+itemH-1, ScreenWidth-20, 1)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line1];
        
        UILabel * lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, itemH+gapW, 100, itemH)];
        lable2.text = @"计量单位:";
        lable2.textColor = [UIColor colorWithHexString:@"#999999"];
        
        UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, gapW+itemH*2-1, ScreenWidth-20, 1)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line2];

        UILabel * lable3 = [[UILabel alloc] initWithFrame:CGRectMake(10, itemH*2+gapW, 100, itemH)];
        lable3.text = @"重量:";
        lable3.textColor = [UIColor colorWithHexString:@"#999999"];
        

        UILabel * line3 = [[UILabel alloc] initWithFrame:CGRectMake(10, gapW+itemH*3-1, ScreenWidth-20, 1)];
        line3.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line3];

        UILabel * lable4 = [[UILabel alloc] initWithFrame:CGRectMake(10, itemH*3+gapW, 100, itemH)];
        lable4.text = @"体积:";
        lable4.textColor = [UIColor colorWithHexString:@"#999999"];

        [self.contentView addSubview:lable1];
        [self.contentView addSubview:lable2];
        [self.contentView addSubview:lable3];
        [self.contentView addSubview:lable4];
        
        CGFloat Y = CGRectGetMaxY(lable4.frame);
        UILabel * line4 = [[UILabel alloc] initWithFrame:CGRectMake(10, Y, ScreenWidth-20, 1)];
        line4.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line4];

        
        self.productBrand = [[UILabel alloc] initWithFrame:CGRectMake(100, gapW, 200, itemH)];
//        self.productBrand.font = [UIFont fontWithName:LightFONT size:17];
        self.productUnit = [[UILabel alloc] initWithFrame:CGRectMake(100, gapW+itemH, 200, itemH)];
//        self.productUnit.font = [UIFont fontWithName:LightFONT size:17];
        self.weight = [[UILabel alloc] initWithFrame:CGRectMake(100, gapW+itemH*2, 200, itemH)];
//        self.weight.font = [UIFont fontWithName:LightFONT size:17];
        self.volume = [[UILabel alloc] initWithFrame:CGRectMake(100, gapW+itemH*3, 200, itemH)];
//        self.volume.font = [UIFont fontWithName:LightFONT size:17];
        [self.contentView addSubview:self.productBrand];
        [self.contentView addSubview:self.productUnit];
        [self.contentView addSubview:self.weight];
        [self.contentView addSubview:self.volume];
        
  
    }
    return self;
}
-(void)setModel:(ProductModel *)model
{
    _model = model;
    self.productBrand.text = model.BrandName;
    self.productUnit.text = model.MeasureUnit;
    self.weight.text = model.Weight;
    self.volume.text = model.Volume;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
