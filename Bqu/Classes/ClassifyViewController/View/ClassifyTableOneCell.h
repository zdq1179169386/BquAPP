//
//  ClassifyTableOneCell.h
//  Bqu
//
//  Created by yb on 15/11/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyTableOneCell : UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


/**标题*/
@property(nonatomic,copy)NSString * title;


/**是否被选中*/
@property(nonatomic,assign)BOOL  isSelected;


@end
