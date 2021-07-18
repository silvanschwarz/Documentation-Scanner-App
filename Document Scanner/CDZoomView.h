//
//  CDZoomView.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDZoomView : UIView{
    
    CGPoint _currentCenter;
    CGPoint _cornerCenter;
}

-(void)setZoomScale:(CGFloat)scale;

-(void)setZoomCenter:(CGPoint)point;
-(void)zoomViewHide:(BOOL)hide;

-(void)setDragingEnabled:(BOOL)enabled;

@end
