//
//  HotHistoryCollectionReusableView.m
//  Bqu
//
//  Created by yb on 15/11/20.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "HotHistoryCollectionReusableView.h"

@implementation HotHistoryCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
        _textLab.font = [UIFont systemFontOfSize:14];
        _textLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_textLab];
        
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-30, 20, 17.5, 17.5)];
        [_deleteBtn setImage:[UIImage imageNamed:@"清空最近搜素"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(yy) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_deleteBtn];
    }
    return self;
}

-(void)yy
{
    if (_block) {
         _block();
    }
}

-(void)setBlock:(clearBlock)block
{
    _block = block;
}

@end
