//
//  SelectableRoundView.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "SelectableRoundView.h"
#import "CropperConstantValues.h"

@implementation SelectableRoundView

@synthesize delegate = _delegate;

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
                
        self.backgroundColor = [[CropperConstantValues themeColor] colorWithAlphaComponent:0.3];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 15.f;
        self.layer.borderColor = [CropperConstantValues themeColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        _pointerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointer"]];
        _pointerView.center = self.center;
        [self addSubview:_pointerView];
        
        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pgr];
        
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer*)pgr;
{
    // Here we handle the dragging of the zoom view
    
    if (pgr.state == UIGestureRecognizerStateChanged)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.borderColor = [UIColor clearColor].CGColor;
        _pointerView.hidden = NO;
        
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];
        center = CGPointMake(center.x + translation.x,
                             center.y + translation.y);

        
        if ([self.delegate canSwipeCornerView:self point:center]) {
            

            pgr.view.center = center;
            [pgr setTranslation:CGPointZero inView:pgr.view];
            [self setNeedsDisplay];
            
            [self.delegate cornerPointDidChangingAt:center corner:self];
        }
        
    }else{
        
        [self.delegate cornerPointDidEndedChangeAt:pgr.view.center corner:self];
        
        self.backgroundColor = [[CropperConstantValues themeColor] colorWithAlphaComponent:0.3];
        self.layer.borderColor = [CropperConstantValues themeColor].CGColor;
        _pointerView.hidden = YES;
        [self.delegate cornerPointDidChanged];
    }
}

@end
