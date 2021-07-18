//
//  OverlayView.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//


#import "CDOverlayView.h"
#import "CropperConstantValues.h"

#define cornerHeight 30.0f

@implementation CDOverlayView

@synthesize topLeftPath, topRightPath, bottomLeftPath, bottomRightPath;
@synthesize absoluteHeight = _absoluteHeight;
@synthesize absoluteWidth = _absoluteWidth;

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)initializeSubView{
    
    if (!_topLeftCornerView) {

        _topLeftCornerView = [[SelectableRoundView alloc] initWithFrame:CGRectZero];
        _topLeftCornerView.delegate = self;
        [self addSubview:_topLeftCornerView];
        
        _topRightCornerView = [[SelectableRoundView alloc] initWithFrame:CGRectZero];
        _topRightCornerView.delegate = self;
        [self addSubview:_topRightCornerView];
        
        _bottomLeftCornerView = [[SelectableRoundView alloc] initWithFrame:CGRectZero];
        _bottomLeftCornerView.delegate = self;
        [self addSubview:_bottomLeftCornerView];
        
        _bottomRightCornerView = [[SelectableRoundView alloc] initWithFrame:CGRectZero];
        _bottomRightCornerView.delegate = self;
        [self addSubview:_bottomRightCornerView];
        
        
        _zoomView = [[CDZoomView alloc] init];
        [self addSubview:_zoomView];
        [_zoomView zoomViewHide:YES];

    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
    }];
    [self setNeedsDisplay];

    [UIView transitionWithView:self
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        
                        [_topLeftCornerView setFrame:CGRectMake(topLeftPath.x - cornerHeight/2.0, topLeftPath.y - cornerHeight/2.0, cornerHeight, cornerHeight)];
                        [_topRightCornerView setFrame:CGRectMake(topRightPath.x - cornerHeight/2.0, topRightPath.y - cornerHeight/2.0, cornerHeight, cornerHeight)];
                        [_bottomLeftCornerView setFrame:CGRectMake(bottomLeftPath.x - cornerHeight/2.0, bottomLeftPath.y - cornerHeight/2.0, cornerHeight, cornerHeight)];
                        [_bottomRightCornerView setFrame:CGRectMake(bottomRightPath.x - cornerHeight/2.0, bottomRightPath.y - cornerHeight/2.0, cornerHeight, cornerHeight)];

                        // Change the view's state
                    }
                    completion:^(BOOL finished) {
                        // Completion block
                    }];
}

-(UIImage *)cropImage:(UIImage *)image{
    
    CGFloat overlayHeight = self.frame.size.height;
    CIImage* rawImage = [[CIImage alloc] initWithImage:image];
    
    NSMutableDictionary *rectangleCoordinates = [NSMutableDictionary new];
    rectangleCoordinates[@"inputTopLeft"] = [CIVector vectorWithCGPoint:CGPointMake(topLeftPath.x * _absoluteWidth, (overlayHeight - topLeftPath.y) * _absoluteHeight)];
    rectangleCoordinates[@"inputTopRight"] = [CIVector vectorWithCGPoint:CGPointMake(topRightPath.x * _absoluteWidth, (overlayHeight - topRightPath.y) * _absoluteHeight)];
    rectangleCoordinates[@"inputBottomLeft"] = [CIVector vectorWithCGPoint:CGPointMake(bottomLeftPath.x * _absoluteWidth, (overlayHeight - bottomLeftPath.y) * _absoluteHeight)];
    rectangleCoordinates[@"inputBottomRight"] = [CIVector vectorWithCGPoint:CGPointMake(bottomRightPath.x * _absoluteWidth, (overlayHeight - bottomRightPath.y) * _absoluteHeight)];
    rawImage = [rawImage imageByApplyingFilter:@"CIPerspectiveCorrection" withInputParameters:rectangleCoordinates];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:rawImage fromRect:[rawImage extent]];

    return [UIImage imageWithCGImage:cgImage];
}


-(void)cornerPointDidChangingAt:(CGPoint)point corner:(SelectableRoundView *)cornerView{
    
    CGFloat orignY = point.y;
    
    if (point.y < 30.0) {
        
        orignY = 30.0f;
    }else if (point.y > self.frame.size.height - 30.0f){
        
        orignY = self.frame.size.height - 30.0f;
    }
    
    topLeftPath = _topLeftCornerView.center;
    topRightPath = _topRightCornerView.center;
    bottomLeftPath = _bottomLeftCornerView.center;
    bottomRightPath = _bottomRightCornerView.center;

    [self setNeedsDisplay];
    
    CGPoint newCenter = CGPointMake(point.x, orignY);
    [_zoomView zoomViewHide:NO];
    [_zoomView setZoomCenter:newCenter];
}
-(BOOL)canSwipeCornerView:(SelectableRoundView *)cornerView point:(CGPoint)point{
    
    topLeftPath = _topLeftCornerView.center;
    topRightPath = _topRightCornerView.center;
    bottomLeftPath = _bottomLeftCornerView.center;
    bottomRightPath = _bottomRightCornerView.center;

    NSLog(@"\n\n\nView size: %@",NSStringFromCGSize(self.frame.size));
    NSLog(@"can pan top left %@",NSStringFromCGPoint(topLeftPath));
    NSLog(@"can pan top right %@",NSStringFromCGPoint(topRightPath));
    NSLog(@"can pan bottom left %@",NSStringFromCGPoint(bottomLeftPath));
    NSLog(@"can pan bottom right %@\n\n",NSStringFromCGPoint(bottomRightPath));
    
    
    if (cornerView == _topLeftCornerView) {

        topLeftPath = point;
    }else if (cornerView == _topRightCornerView){
        
        topRightPath = point;
    }else if (cornerView == _bottomLeftCornerView){
        
        bottomLeftPath = point;
    }else{
        
        bottomRightPath =point;
    }
    CGPoint _vertices[4];
    
    _vertices[0] = topLeftPath;
    _vertices[1] = topRightPath;
    _vertices[2] = bottomRightPath;
    _vertices[3] = bottomLeftPath;
    
    
    BOOL sign=false;
    int n = 4;
    for(int i=0;i<n;i++)
    {
        double dx1 = _vertices[(i+2)%n].x - _vertices[(i+1)%n].x;
        double dy1 = _vertices[(i+2)%n].y-_vertices[(i+1)%n].y;
        double dx2 = _vertices[i].x-_vertices[(i+1)%n].x;
        double dy2 = _vertices[i].y-_vertices[(i+1)%n].y;
        double zcrossproduct = dx1*dy2 - dy1*dx2;
        if (i==0)
            sign=zcrossproduct>0;
        else
        {
            if (sign!=(zcrossproduct>0))
                
                return NO;
        }
    }
    return YES;
}

-(void)cornerPointDidEndedChangeAt:(CGPoint)point corner:(SelectableRoundView *)cornerView{
    
    if (cornerView == _topLeftCornerView) {

        //last dragged topLeftCornerView
        topLeftPath = [self correctPoint:topLeftPath];
        [_topLeftCornerView setCenter:topLeftPath];
        
    }else if (cornerView == _topRightCornerView){
        
        //last dragged topRightCornerView
        topRightPath = [self correctPoint:topRightPath];
        [_topRightCornerView setCenter:topRightPath];
    }else if (cornerView == _bottomLeftCornerView){
        
        //last dragged bottomLeftCornerView
        bottomLeftPath = [self correctPoint:bottomLeftPath];
        [_bottomLeftCornerView setCenter:bottomLeftPath];
        
    }else{
        
        //last dragged bottomRightCornerView
        bottomRightPath = [self correctPoint:bottomRightPath];
        [_bottomRightCornerView setCenter:bottomRightPath];
    }
    [self setNeedsDisplay];

}

-(CGPoint)correctPoint:(CGPoint )point{

    CGPoint thePoint = point;
    
    if (point.x < 0.0 || point.y < 0.0) {

        if (point.x < 0.0) {
            
            thePoint.x = 0.0;
        }
        if (point.y < 0.0) {
            
            thePoint.y = 0.0;
        }
    }else if (point.x < self.frame.size.width || point.y < self.frame.size.height){

        if (point.x > self.frame.size.width) {
            
            thePoint.x = self.frame.size.width;
        }
        if (point.y > self.frame.size.height) {

            thePoint.y = self.frame.size.height;
        }

    }
    return thePoint;
}

-(BOOL)isPathCanDrag:(CGPoint)point{
    
    if (0.0 < point.x < self.frame.size.width && 0.0 < point.y < self.frame.size.height) {
        
        return YES;
    }else{
        
        return NO;
    }
}


-(void)cornerPointDidChanged{
    
    [_zoomView zoomViewHide:YES];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
        
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(c, YES);
  
    
    CGContextSetStrokeColorWithColor(c, [CropperConstantValues themeColor].CGColor);
    CGContextSetLineWidth(c, 1.0);
    float lineMargin = 0.0f;
    
    
    CGContextMoveToPoint(c,topLeftPath.x + lineMargin, topLeftPath.y + lineMargin);
    CGContextAddLineToPoint(c,topRightPath.x - lineMargin, topRightPath.y + lineMargin);
    CGContextAddLineToPoint(c, bottomRightPath.x - lineMargin, bottomRightPath.y - lineMargin);
    CGContextAddLineToPoint(c,bottomLeftPath.x +lineMargin , bottomLeftPath.y - lineMargin);
    CGContextAddLineToPoint(c,topLeftPath.x + lineMargin, topLeftPath.y + lineMargin);
    CGContextStrokePath(c);

    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, rect.origin.x, rect.origin.y);
    CGPathAddLineToPoint(path, nil, rect.origin.x + rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path, nil, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, nil, rect.origin.x, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, nil, rect.origin.x, bottomLeftPath.y);
    CGPathAddLineToPoint(path, nil, bottomLeftPath.x, bottomLeftPath.y);
    CGPathAddLineToPoint(path, nil, bottomRightPath.x, bottomRightPath.y);
    CGPathAddLineToPoint(path, nil, topRightPath.x, topRightPath.y);
    CGPathAddLineToPoint(path, nil, topLeftPath.x, topLeftPath.y);
    CGPathAddLineToPoint(path, nil, bottomLeftPath.x, bottomLeftPath.y);
    CGPathAddLineToPoint(path, nil, rect.origin.x, bottomLeftPath.y);
    CGPathCloseSubpath(path);
    CGContextAddPath(c, path);
    UIColor *overlayColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    CGContextSetFillColorWithColor(c, overlayColor.CGColor);
    CGContextDrawPath(c, kCGPathFill);
    CGPathRelease(path);

    CGContextStrokePath(c);
    
}
@end
