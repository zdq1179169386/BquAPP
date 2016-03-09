//
//  CommentDataViewController.h
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyBaseViewController.h"


@interface CommentDataViewController : ClassifyBaseViewController
/**商品id*/
@property (nonatomic,copy)NSString * productId;
/**评分*/
@property (nonatomic,copy)NSString * ReviewMark;
@end
