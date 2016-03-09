//
//  SearchViewController.h
//  Bqu
//
//  Created by WONG on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBaseViewController.h"
#import "BquSearchConditionModel.h"

@interface SearchViewController : HomeBaseViewController

@property (nonatomic,strong)NSString *keyWord;

@property(nonatomic,strong)BquSearchConditionModel * conditions;

@end
