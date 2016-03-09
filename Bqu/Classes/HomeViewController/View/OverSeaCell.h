//
//  ThemeCell.h
//  Bqu
//
//  Created by WONG on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverSeaModel.h"

@protocol OverSeaCellDelegate <NSObject>
@optional
-(void)touchDownAddShoppingButton:(OverSeaModel*)overSeaModel withImageView:(UIImageView *)imageView;

@end


@interface OverSeaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *GoodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *CountryImg;
@property (weak, nonatomic) IBOutlet UILabel *SessionLab;
@property (weak, nonatomic) IBOutlet UILabel *GoodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *NowPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *EXPriceLab;
@property (weak, nonatomic) IBOutlet UIImageView *CancelImg;
@property (weak, nonatomic) IBOutlet UIButton *AddToCarBtn;
@property(nonatomic)OverSeaModel *overSeaModel;
@property(nonatomic,weak)id<OverSeaCellDelegate>delegate;

@property (nonatomic,copy)  void(^shopCartBlock)(UIImageView *imageView,OverSeaModel *overSeaModel);


+(instancetype)overSeaCellWithTableView:(UITableView*)tableView;

@end
