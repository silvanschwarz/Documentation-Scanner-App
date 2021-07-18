//
//  CDCameraOverlayView.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//


#import "CDCameraOverlayView.h"
#import "CropperConstantValues.h"

@implementation CDCameraOverlayView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _topLeftPoint = CGPointZero;
        _topRightPoint = CGPointZero;
        
        _bottomLeftPoint = CGPointZero;
        _bottomRightPoint = CGPointZero;
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(c, YES);
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, _topLeftPoint.x, _topLeftPoint.y);
    CGPathAddLineToPoint(path, nil, _topRightPoint.x, _topRightPoint.y);
    CGPathAddLineToPoint(path, nil, _bottomRightPoint.x, _bottomRightPoint.y);
    CGPathAddLineToPoint(path, nil, _bottomLeftPoint.x, _bottomLeftPoint.y);
    CGPathAddLineToPoint(path, nil, _topLeftPoint.x, _topLeftPoint.y);

    CGPathCloseSubpath(path);
    CGContextAddPath(c, path);
    UIColor *overlayColor = [[CropperConstantValues themeColor] colorWithAlphaComponent:0.3];
    CGContextSetFillColorWithColor(c, overlayColor.CGColor);
    CGContextDrawPath(c, kCGPathFill);
    CGPathRelease(path);
    
    CGContextStrokePath(c);

}

- (void)drawHighLightOverlayWithImage:(CIImage *)image topLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight{
        
    CGFloat absHeight = image.extent.size.height / self.frame.size.height;
    CGFloat absWidth = image.extent.size.width / self.frame.size.width;
    
    _topLeftPoint = CGPointMake(topLeft.x/absWidth, self.frame.size.height - topLeft.y/absHeight);
    _topRightPoint = CGPointMake(topRight.x/absWidth,self.frame.size.height- topRight.y/absHeight);
    _bottomLeftPoint = CGPointMake(bottomLeft.x/absWidth,self.frame.size.height- bottomLeft.y/absHeight);
    _bottomRightPoint = CGPointMake(bottomRight.x/absWidth, self.frame.size.height - bottomRight.y/absHeight);
    
    
    [self setNeedsDisplay];
}

-(void)hideHightLightOverlay{
        
    _topLeftPoint = CGPointZero;
    _topRightPoint = CGPointZero;
    
    _bottomLeftPoint = CGPointZero;
    _bottomRightPoint = CGPointZero;
    
    [self setNeedsDisplay];
}



@end
