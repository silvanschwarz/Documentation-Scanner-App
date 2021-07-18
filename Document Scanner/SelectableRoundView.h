//
//  SelectableRoundView.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectableRoundView;

@protocol SelectabeRoundDelegate <NSObject>

-(void)cornerPointDidChangingAt:(CGPoint)point corner:(SelectableRoundView *)cornerView;
-(void)cornerPointDidEndedChangeAt:(CGPoint)point corner:(SelectableRoundView *)cornerView;

-(void)cornerPointDidChanged;

-(BOOL)canSwipeCornerView:(SelectableRoundView *)cornerView point:(CGPoint)point;

@end
@interface SelectableRoundView : UIView{
    
    UIImageView* _pointerView;
}


@property(nonatomic, weak) id<SelectabeRoundDelegate> delegate;

@end
