//
//  Bqu_SiftTypeView.h
//  Bqu
//
//  Created by yb on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Bqu_SiftTypeViewBlock) (NSUInteger index);

@interface Bqu_SiftTypeView : UIView

-(void)setBqu_SiftTypeViewBlock:(Bqu_SiftTypeViewBlock)block;
@end
