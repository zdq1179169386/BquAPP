//
//  ApplyForRefundCell.h
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplyForRefundCell;

@protocol   ApplyForRefundCellDelegate<NSObject>

@optional
-(void)ApplyForRefundCellBtnClick:(ApplyForRefundCell*)cell ;

@end

@interface ApplyForRefundCell : UITableViewCell


/**<#description#>*/
@property(nonatomic,weak)id<ApplyForRefundCellDelegate> delegate;

/***/
@property(nonatomic,strong)UILabel * label;


/**description*/
@property(nonatomic,strong)UILabel * btn;

/**<#description#>*/
@property(nonatomic,strong)UIImageView * rightImage;


/**<#description#>*/
@property(nonatomic,strong)UITextField * textField;


/**<#description#>*/
@property(nonatomic,strong)UITextView * textView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
