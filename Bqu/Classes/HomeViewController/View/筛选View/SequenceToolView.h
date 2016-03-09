//
//  SequenceToolView.h
//  Bqu
//
//  Created by yb on 15/11/20.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SequenceToolBlock) (NSInteger tag);


@interface SequenceToolView : UIView

-(void)setBlock:(SequenceToolBlock)block;
-(void)setImage:(BOOL)sift;
@end
