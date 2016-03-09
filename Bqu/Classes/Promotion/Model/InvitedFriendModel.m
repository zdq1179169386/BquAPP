//
//  InvitedFriendModel.m
//  Bqu
//
//  Created by wyy on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "InvitedFriendModel.h"

@implementation InvitedFriendModel

- (void)invitedFrinedModelFromDictionary:(NSDictionary *)dic
{
    if(![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.userId = dic[@"UserId"];
    self.mobile = dic[@"Mobile"];
    self.createDate = dic[@"CreateDate"];
}

@end
