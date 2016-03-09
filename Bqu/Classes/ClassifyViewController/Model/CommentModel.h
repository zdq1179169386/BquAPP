//
//  CommentModel.h
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/**评论用户*/
@property(nonatomic,copy)NSString * UserName;
/**评论内容*/
@property(nonatomic,copy)NSString * ReviewContent;
/**评论日期*/
@property(nonatomic,copy)NSString * ReviewDate;
/**回复内容*/
@property(nonatomic,copy)NSString * ReplyContent;
/**评分*/
@property(nonatomic,copy)NSString * ReviewMark;
/**购买日期*/
@property(nonatomic,copy)NSString * BuyDate;
/**用户的头像*/
@property(nonatomic,copy)NSString * UserPhoto;


@end

@interface CommentModelFrame : NSObject

/**评论*/
@property(nonatomic,strong)CommentModel * comment;

/**评论用户*/
@property(nonatomic,assign)CGRect  UserNameF;
/**评论内容*/
@property(nonatomic,assign)CGRect  ReviewContentF;
/**评论日期*/
@property(nonatomic,assign)CGRect  ReviewDateF;
/**回复内容*/
@property(nonatomic,assign)CGRect  ReplyContentF;
/**评分*/
@property(nonatomic,assign)CGRect  ReviewMarkF;
/**购买日期*/
@property(nonatomic,assign)CGRect  BuyDateF;
/**用户的头像*/
@property(nonatomic,assign)CGRect  UserPhotoF;

/**cellde高度*/
@property(nonatomic,assign)CGFloat  cellHeight;

@end