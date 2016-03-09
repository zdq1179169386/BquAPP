//
//  CommentTablevIewCell.m
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "CommentTablevIewCell.h"

@interface CommentTablevIewCell ()


#define  garpW 10
@end

@implementation CommentTablevIewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.icon = [[UIImageView alloc] init];
        self.icon.layer.cornerRadius = 2;
        self.icon.clipsToBounds = YES;
//        self.icon.backgroundColor = [UIColor redColor];
        self.name = [[UILabel alloc] init];
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = [UIColor colorWithHexString:@"#333333"];
//        self.name.backgroundColor = [UIColor yellowColor];
        self.content = [[UILabel alloc] init];
        self.content.textColor = [UIColor colorWithHexString:@"#333333"];
        self.content.font = [UIFont systemFontOfSize:16];
//        self.content.backgroundColor = [UIColor blueColor];
        self.content.numberOfLines = 0;
        self.date = [[UILabel alloc] init];
        self.date.textColor = [UIColor colorWithHexString:@"#888888"];
        self.date.font = [UIFont systemFontOfSize:15];
//        self.date.backgroundColor = [UIColor grayColor];
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.date];
    }
    return self;
}
-(void)setModelFrame:(CommentModelFrame *)modelFrame
{
    _modelFrame = modelFrame;
    CommentModel * model = _modelFrame.comment;

    self.icon.frame = modelFrame.UserPhotoF;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.UserPhoto]];
    
    self.name.frame = modelFrame.UserNameF;
    self.name.text = model.UserName;
   
    self.content.frame = modelFrame.ReviewContentF;
    self.content.text = model.ReviewContent;

    self.date.frame = modelFrame.ReviewDateF;
    self.date.text = model.ReviewDate;
    
    if (model.ReviewMark.intValue>1) {
        for (int i=10; i<15; i++) {
            UIImageView * image = (UIImageView *)[self.contentView viewWithTag:i];
            [image removeFromSuperview];
            
        }
        for (int i=0; i<model.ReviewMark.intValue; i++) {
            CGFloat  starW = 10;
            CGFloat boardW = 2;
            UIImageView * star = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-80+i*(starW+boardW), modelFrame.ReviewDateF.origin.y+5, starW, starW)];
            star.tag = i +10;
            star.image = [UIImage imageNamed:@"B区详情页五角星"];
            [self.contentView addSubview:star];
           
        }
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
