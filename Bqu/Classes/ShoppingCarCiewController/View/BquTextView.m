//
//  BquTextView.m
//  Bqu
//
//  Created by yb on 15/11/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BquTextView.h"

@interface BquTextView ()<UITextViewDelegate>

@property(nonatomic,strong)UILabel * promptLab;

@end

@implementation BquTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        _promptLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, 20)];
        _promptLab.textColor = [UIColor colorWithHexString:@"#dddddd"];
        _promptLab.textAlignment = NSTextAlignmentLeft;
        _promptLab.font = [UIFont systemFontOfSize:14];
        
        self.delegate = self;
        [self addSubview:_promptLab];
    }
    return self;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _promptLab.hidden = YES;
    }
    else _promptLab.hidden = NO;
}

-(void)setPromptLab:(NSString*)prompt
{
    _promptLab.text = prompt;
}

-(void)hasWord
{
    _promptLab.hidden = YES;
}
@end
