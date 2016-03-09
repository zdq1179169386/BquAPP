//
//  MyOrderHeader.h
//  Bqu
//
//  Created by yingbo on 15/11/23.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderHeader : UITableViewHeaderFooterView
{
    NSTimer *_headerTimer;
    NSMutableAttributedString *timeStr;
}
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UILabel *stateLab;
@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UIImageView *imageV;

@property (nonatomic,strong) MyOrder_Model *order;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section
;
- (void)setValue:(id)value;

@end
