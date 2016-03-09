//
//  InvitedFriendModel.h
//  Bqu
//
//  Created by wyy on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitedFriendModel : NSObject

@property (nonatomic, copy) NSString *userId;        //用户ID
@property (nonatomic, copy) NSString *mobile;        //联系号码
@property (nonatomic, copy) NSString *createDate;

- (void)invitedFrinedModelFromDictionary:(NSDictionary *)dic;

@end
