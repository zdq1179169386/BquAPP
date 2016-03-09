//
//  CommentHeaderCell.h
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentHeaderCell;

@protocol CommentHeaderCellDelegate <NSObject>

-(void)CommentHeaderCellBtnClick:(CommentHeaderCell*)cell withBtn:(UIButton *)btn;

@end

@interface CommentHeaderCell : UITableViewCell

@property(nonatomic,assign)id<CommentHeaderCellDelegate>delegate;

@property (nonatomic,assign) NSInteger isSelecctedBtn;

@property (nonatomic,strong) UIButton * btnOne;

@property (nonatomic,strong) UIButton * btnTwo;

@property (nonatomic,strong) UIButton * btnThree;
@property (nonatomic,strong) UIButton * btnFour;
/**评分lable*/
@property (nonatomic,strong) UILabel * ReviewMarkLabel;

/**评分*/
@property (nonatomic,copy)NSString * ReviewMark;

/**好评数*/
@property (nonatomic,copy)NSString * goodComment;
/**坏评数*/
@property (nonatomic,copy)NSString * badComment;
/**中评数*/
@property (nonatomic,copy)NSString * comment;
/**总评数*/
@property (nonatomic,copy)NSString * allComment;
@end

