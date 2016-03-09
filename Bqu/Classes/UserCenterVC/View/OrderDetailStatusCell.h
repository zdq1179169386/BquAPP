//
//  OrderDetailStatusCell.h
//  Bqu
//
//  Created by 张胜瀚 on 15/12/3.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailStatusCell : UITableViewCell

@property (nonatomic,strong) UILabel *orderStatusLab;
@property (nonatomic,strong) UILabel *orderInfoLab;
@property (nonatomic,strong) UIView *line;


@property (nonatomic,strong) NSDictionary *dataDic;
- (void)setValue:(id)value;
-(void)setStr:(NSString*)s1 str2:(NSString*)str2;
@end
