//
//  FlashButton.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "FlashButton.h"

@implementation FlashButton


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _flashIconView = [[UIImageView alloc] initWithFrame:CGRectMake(22.0, 16.0, 16.0, 24.0)];
        [self addSubview:_flashIconView];
        
        _flashTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 43.0, 60.0, 12.0f)];
        _flashTypeLabel.textAlignment = NSTextAlignmentCenter;
        _flashTypeLabel.font = [UIFont systemFontOfSize:10];
        _flashTypeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_flashTypeLabel];
        
        [self changeFlashType:NO];
    }
    
    return self;
}

-(void)changeFlashType:(BOOL)isOn{
    
    if (isOn) {
        
        [_flashIconView setImage:[UIImage imageNamed:@"flash_on"]];
        [_flashTypeLabel setText:@"FLASH ON"];
    }else{
        
        [_flashIconView setImage:[UIImage imageNamed:@"flash_off_icon"]];
        [_flashTypeLabel setText:@"FLASH OFF"];
    }
    
    _flashIsON = isOn;
}


-(BOOL)flashTypeIsON{
    
    return _flashIsON;
}

@end
