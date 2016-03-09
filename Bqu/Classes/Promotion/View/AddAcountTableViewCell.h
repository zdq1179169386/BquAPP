//
//  AddAcountTableViewCell.h
//  Bqu
//
//  Created by yingbo on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAcountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UITextField *accountInfo;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
