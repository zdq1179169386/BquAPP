//
//  OrderDetailLogisticCell.h
//  Bqu
//
//  Created by 张胜瀚 on 15/12/3.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailLogisticCell : UITableViewCell

@property (nonatomic,strong) UIImageView *redlogImg;
@property (nonatomic,strong) UILabel *logisticTipLab;
@property (nonatomic,strong) UILabel *logidticLab;
@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UIView *verticalLine;
@property (nonatomic,strong) UIView *horazonLine;
@property (nonatomic,strong) UIImageView *arrowImg;

@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *expressArrArray;
@property (nonatomic,strong) NSDictionary *OrderAuditDic;


- (void)setValue:(id)value;

@end
