//
//  OnTimeCell.m
//  Bqu
//
//  Created by WONG on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "OnTimeCell.h"
//#import <UIKit/UIKit.h>

@implementation OnTimeCell

- (void)awakeFromNib {
//    self.xxxLable.layer.borderWidth = 1;
//    self.xxxLable.layer.borderColor = [UIColor colorWithHexString:@"d9e0e3"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setOnTimeModel:(OntimeModel *)onTimeModel
{
    _onTimeModel = onTimeModel;
    NSString * str = @"http://";
    //NSLog(@"%@",onTimeModel.ImageUrl);
    NSString *storage = [[NSString alloc]init];
    if ([_onTimeModel.ImageUrl rangeOfString:str].location != NSNotFound)
    {
        _onTimeModel.ImageUrl = _onTimeModel.ImageUrl;
    }
    else
    {
        _onTimeModel.ImageUrl = [NSString stringWithFormat:@"%@%@",TEST_URL,_onTimeModel.ImageUrl];
    }
    [self.OnTimeImg sd_setImageWithURL:[NSURL URLWithString:_onTimeModel.ImageUrl] placeholderImage:[UIImage imageNamed:@"1106首页占位图-02限时特卖"]];
    // 仓库标
    storage = _onTimeModel.Storage;
    if ([storage isKindOfClass:[NSNull class]]) {
        self.StorageLable.hidden = YES;
        self.xxxLable.hidden = YES;
    }else
    {
        self.StorageLable.hidden = NO;
        self.xxxLable.hidden = NO;
        
        self.xxxLable.layer.masksToBounds =YES;
        self.xxxLable.layer.borderWidth = 1;
        self.xxxLable.layer.borderColor = [UIColor colorWithHexString:@"#d9e0e3"].CGColor ;
        self.xxxLable.layer.cornerRadius = 7;
    }
    
    
  

    
}


+(instancetype)OnTimeCellWithTableView:(UITableView*)tableView
{
    static NSString *identifier= @"Ontime";
    OnTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"OnTimeCell" owner:nil options:nil]firstObject];
    }
    return cell;
}
@end