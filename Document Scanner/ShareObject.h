//
//  ShareObject.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    ShareTypeCameraRoll,
    ShareTypeFacebook,
    ShareTypeConvertText,
    ShareTypePDF,
    ShareTypeShareImage
    
} ShareType;



@interface ShareObject : NSObject

@property(nonatomic, strong) NSString* connectionName;
@property(nonatomic, strong) NSString* thumbnail;
@property(nonatomic) ShareType shareType;

-(id)initWithName:(NSString *)name imageName:(NSString *)imgName type:(ShareType)type;
@end
