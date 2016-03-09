//
//  CommentTablevIewCell.h
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTablevIewCell : UITableViewCell


/**frame模型*/
@property(nonatomic,strong)CommentModelFrame * modelFrame;


/**头像*/
@property(nonatomic,strong)UIImageView  * icon;


/**用户名*/
@property(nonatomic,strong)UILabel * name;


/**评论内容*/
@property(nonatomic,strong)UILabel * content;

/**评论日期*/
@property(nonatomic,strong)UILabel * date;


/**评分*/
@property(nonatomic,strong)UIImageView * mark;

@end
