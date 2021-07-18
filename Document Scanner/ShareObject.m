//
//  ShareObject.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "ShareObject.h"

@implementation ShareObject
@synthesize connectionName;
@synthesize thumbnail,shareType;

-(id)initWithName:(NSString *)name imageName:(NSString *)imgName type:(ShareType)type{
    
    self = [super init];
    if (self) {

        self.connectionName = name;
        self.thumbnail = imgName;
        self.shareType = type;
    }
    return self;
}

@end
