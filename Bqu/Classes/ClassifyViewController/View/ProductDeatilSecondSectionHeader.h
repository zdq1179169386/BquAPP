//
//  ProductDeatilSecondSectionHeader.h
//  Bqu
//
//  Created by yb on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductDeatilSecondSectionHeader;

@protocol  ProductDeatilSecondSectionHeaderDelegate<NSObject>

@optional
-(void)ProductDeatilSecondSectionHeaderDelegate:(ProductDeatilSecondSectionHeader*)header withBtn:(UIButton *)selectedBtn withLine:(UILabel*)line withTag:(NSInteger)lastTag;

@end

@interface ProductDeatilSecondSectionHeader : UITableViewHeaderFooterView

@property(nonatomic,assign)id<ProductDeatilSecondSectionHeaderDelegate>delegate;

@property (nonatomic,strong)UIButton * fistBtn;

@property (nonatomic,strong)UIButton * secondBtn;

@property (nonatomic,strong)UIButton * threebtn;

@property (nonatomic,strong)UILabel * buttomLine;


@end

