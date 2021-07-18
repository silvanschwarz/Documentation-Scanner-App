//
//  CDZoomView.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "CDZoomView.h"

#define kSelectorWidth 60.0f
#define kHideAnimationDuraction 0.15f

@interface CDZoomView ()
{
    float oldX, oldY;
    BOOL dragging;
}
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, assign) CGFloat zoomScale;
@end

@implementation CDZoomView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 120.0, 120.0)];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        
        _zoomScale = 2.0;
        [self setDragingEnabled:NO];
        
        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pgr];
        
        [self setZoomScale:3.0];
        [self setDragingEnabled:YES];
        [self.layer setBorderColor:[UIColor grayColor].CGColor];
        [self.layer setBorderWidth:3.0];
        [self.layer setCornerRadius:60];

    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    _parentView = newSuperview;
}


- (void)setDragingEnabled:(BOOL)enabled
{
    [self setUserInteractionEnabled:enabled];
}

- (void)drawRect:(CGRect)rect
{
    
    // Set the corrext area we want to zoom in to
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, (self.frame.size.width / 2), (self.frame.size.height / 2));
    CGContextScaleCTM(context, _zoomScale, _zoomScale);
    CGContextTranslateCTM(context, -_cornerCenter.x, -_cornerCenter.y);
    
    [self setHidden:YES];

	[_parentView.layer.superlayer renderInContext:context];
    [self setHidden:NO];
}

#pragma mark - Private


-(void)setZoomCenter:(CGPoint)point{
    
    float margin = self.frame.size.width/2.0f + 20.0f;
    
    if (point.y < 200.0f) {
        
        if (point.x < 140.0) {
            
            [self setViewCenter:CGPointMake(_parentView.frame.size.width - margin, margin)];
            
        }else if (point.x < _parentView.frame.size.width - 140.0){
            
            [self setViewCenter:CGPointMake(margin, margin)];

        }else{

            
            [self setViewCenter:CGPointMake(_parentView.frame.size.width/2.0, margin)];

        }
        
    }else{
        
        [self setViewCenter:CGPointMake(_parentView.frame.size.width/2.0, margin)];

    }
        
    _cornerCenter = point;
    [self setNeedsDisplay];
}

-(void)zoomViewHide:(BOOL)hide{
    
    if (hide && !self.isHidden) {
        
        [UIView animateWithDuration:kHideAnimationDuraction animations:^{
            
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
            self.hidden = hide;
        }];

        
    }else if (!hide && self.isHidden){
        
        [UIView animateWithDuration:kHideAnimationDuraction animations:^{
            
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
            self.hidden = hide;
        }];
    }
}
-(void)setViewCenter:(CGPoint)center{
    
    if (_currentCenter.x != center.x) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.center = center;
            
        } completion:^(BOOL finished) {
            
            _currentCenter = center;
        }];
        
    }
}
- (void)handlePan:(UIPanGestureRecognizer*)pgr;
{
    // Here we handle the dragging of the zoom view
    
    if (pgr.state == UIGestureRecognizerStateChanged)
    {
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];
        center = CGPointMake(center.x + translation.x,
                             center.y + translation.y);
        pgr.view.center = center;
        
        [pgr setTranslation:CGPointZero inView:pgr.view];
        [self setNeedsDisplay];
        
    }
}
@end

