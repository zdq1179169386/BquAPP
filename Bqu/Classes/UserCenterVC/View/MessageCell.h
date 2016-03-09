//
//  MessageCell.h
//  Bqu
//
//  Created by yingbo on 15/11/30.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic,strong) UIImageView *messageImgView;
@property (nonatomic,strong) UILabel *messageLab;
@property (nonatomic,strong) NSString *dataDic;


- (void)setValue:(id)value;
@end
