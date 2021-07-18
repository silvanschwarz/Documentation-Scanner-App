//
//  FlashButton.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashButton : UIButton{
    
    UIImageView* _flashIconView;
    UILabel* _flashTypeLabel;
    
    BOOL _flashIsON;
}

-(void)changeFlashType:(BOOL)isOn;

-(BOOL)flashTypeIsON;

@end
