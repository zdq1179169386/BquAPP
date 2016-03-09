//
//  UsePreferentialTableViewController.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UsePreferentialDelegate <NSObject>
@optional
-(void)usePreferential:(NSInteger)row;

@end

@interface UsePreferentialTableViewController : UITableViewController
@property (nonatomic)NSArray * preferentialArr;
@property (nonatomic,weak)id<UsePreferentialDelegate>delegate;
@end
