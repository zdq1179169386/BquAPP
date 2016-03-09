//
//  OrderDetailLogisticCell.m
//  Bqu
//
//  Created by 张胜瀚 on 15/12/3.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "OrderDetailLogisticCell.h"

@implementation OrderDetailLogisticCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.logisticTipLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 15)];
        self.logisticTipLab.font = [UIFont systemFontOfSize:12];
        self.logisticTipLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.logisticTipLab.text = @"物流信息:";

        self.redlogImg =  [[UIImageView alloc] initWithFrame:CGRectMake(39, 10+15+10, 14, 14)];
        self.redlogImg.image = [UIImage imageNamed:@"log"];

        self.horazonLine = [[UIView alloc] initWithFrame:CGRectMake(39+6, 43, 1, 32)];
        self.horazonLine.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
        
        self.logidticLab = [[UILabel alloc] initWithFrame:CGRectMake(39+14+10, 10+15+10, ScreenWidth-39-14-5-5-29-10, 15)];
        self.logidticLab.textAlignment = NSTextAlignmentLeft;
        self.logidticLab.font = [UIFont systemFontOfSize:12];
        self.logidticLab.textColor = [UIColor colorWithHexString:@"#e8103c"];

        self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(self.logidticLab.frame.origin.x, self.logidticLab.frame.origin.y+self.logidticLab.frame.size.height +5, 150, 15)];
        self.dateLab.font = [UIFont systemFontOfSize:12];
        self.dateLab.numberOfLines = 2;
        self.dateLab.textColor = [UIColor colorWithHexString:@"#888888"];
        
        self.arrowImg =  [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-(5+29), 75/2-29/2, 29, 29)];
        self.arrowImg.image = [UIImage imageNamed:@"箭头"];
        

        
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 74, ScreenWidth, 1)];
        self.verticalLine.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5];
        
        [self.contentView addSubview:self.redlogImg];
        [self.contentView addSubview:self.logidticLab];
        [self.contentView addSubview:self.logisticTipLab];
        [self.contentView addSubview:self.dateLab];
        [self.contentView addSubview:self.arrowImg];
        [self.contentView addSubview:self.verticalLine];
        [self.contentView addSubview:self.horazonLine];

        self.expressArrArray = [NSMutableArray array];
        self.OrderAuditDic = [NSDictionary dictionary];
        
        
    }
    return self;
}

- (void)setValue:(id)value
{
    _dataDic = value;
    NSString *isSuccess = [NSString stringWithFormat:@"%@",_dataDic[@"Express"][@"Success"]];
    self.expressArrArray = _dataDic[@"Express"][@"ExpressDataItems"];
    self.OrderAuditDic = _dataDic[@"OrderAudit"];


    if (self.expressArrArray.count == 0)
    {
        self.dateLab.text = self.OrderAuditDic[@"OpData"];
        self.logidticLab.text = self.OrderAuditDic[@"ExpressMsg"];
    }
    else
    {
        if ([isSuccess isEqualToString:@"1" ])
        {
            if (self.expressArrArray.count > 0)
            {
                NSDictionary *dicc = self.expressArrArray[0];
                self.dateLab.text = dicc[@"Time"];
                self.logidticLab.text = dicc[@"Content"];
            }
            else
            {
                self.logidticLab.text = @"暂无物流信息";
                self.dateLab.text = @"";
                
            }
        }
        else
        {
            self.logidticLab.text = @"暂无物流信息";
            self.dateLab.text = @"";
            
        }
        
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
