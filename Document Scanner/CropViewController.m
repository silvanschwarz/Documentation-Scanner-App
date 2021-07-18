//
//  CropViewController.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "CropViewController.h"
#import "CDImageRectangleDetector.h"
#import "CropperConstantValues.h"
#import "ProcessViewController.h"
#import "DefaultValues.h"


@interface CropViewController ()

@end

@implementation CropViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    
    croppedImage = [[CIImage alloc] initWithImage:self.originalImage];
    
    _sharedDetector = [CDImageRectangleDetector sharedDetector];
    _detectedRectangleFeature = [_sharedDetector biggestRectangleInRectangles:[[_sharedDetector highAccuracyRectangleDetector] featuresInImage:croppedImage]];

    croppedImage = [_sharedDetector drawHighlightOverlayForPoints:croppedImage topLeft:_detectedRectangleFeature.topLeft
                                                     topRight:_detectedRectangleFeature.topRight
                                                   bottomLeft:_detectedRectangleFeature.bottomLeft
                                                  bottomRight:_detectedRectangleFeature.bottomRight];
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    static float margin = 0.0;
    CGFloat imageViewHeight =  self.view.frame.size.height -[CropperConstantValues pictureSelectorFooterViewHeight] -[CropperConstantValues pictureSelectorHeaderViewHeight] - margin * 2;
    
    _detectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(margin, [CropperConstantValues pictureSelectorHeaderViewHeight] + margin, self.view.frame.size.width - margin * 2,imageViewHeight)];
    _detectedImage.translatesAutoresizingMaskIntoConstraints = NO;
    _detectedImage.userInteractionEnabled = YES;
    [_detectedImage setImage:self.originalImage];
    [self.view addSubview:_detectedImage];
    
    

    
    if (_detectedRectangleFeature) {
        
        [self magnetActivated];

    }else{
        
        [self magnetDeactivated];
    }
    
    [self initializeHeaderView];
    [self initializeFooterView];
    

    
    NSLayoutConstraint* imgTop = [NSLayoutConstraint constraintWithItem:_detectedImage
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_headerView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0 constant:0.0];
    NSLayoutConstraint* imgLeft = [NSLayoutConstraint constraintWithItem:_detectedImage
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0 constant:margin];
    NSLayoutConstraint* imgRight = [NSLayoutConstraint constraintWithItem:_detectedImage
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0 constant:-margin];
    NSLayoutConstraint* imgBtm = [NSLayoutConstraint constraintWithItem:_detectedImage
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_footerView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0 constant:0.0];
    
    NSArray* imgConstraints = [NSArray arrayWithObjects:imgTop, imgBtm, imgLeft, imgRight, nil];
    
    [self.view addConstraints:imgConstraints];
}


-(void)magnetActivated{
    
    float absoluteHeight = self.originalImage.size.height / _detectedImage.frame.size.height;
    float absoluteWidth = self.originalImage.size.width / _detectedImage.frame.size.width;

    if (!_overlayView) {
        
        _overlayView = [[CDOverlayView alloc] initWithFrame:CGRectZero];
        _overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        [_detectedImage addSubview:_overlayView];

        NSLayoutConstraint* imgTop = [NSLayoutConstraint constraintWithItem:_overlayView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_detectedImage
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0 constant:0.0];
        NSLayoutConstraint* imgLeft = [NSLayoutConstraint constraintWithItem:_overlayView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_detectedImage
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0 constant:0.0];
        NSLayoutConstraint* imgRight = [NSLayoutConstraint constraintWithItem:_overlayView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_detectedImage
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0 constant:0.0];
        NSLayoutConstraint* imgBtm = [NSLayoutConstraint constraintWithItem:_overlayView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_detectedImage
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0 constant:0.0];
        
        NSArray* imgConstraints = [NSArray arrayWithObjects:imgTop, imgBtm, imgLeft, imgRight, nil];
        
        [_detectedImage addConstraints:imgConstraints];

    }

    _overlayView.absoluteHeight = absoluteHeight;
    _overlayView.absoluteWidth = absoluteWidth;
    
    CGPoint detectedTopLeftPoint = CGPointMake(_detectedRectangleFeature.topLeft.x/absoluteWidth, (_detectedImage.frame.size.height - _detectedRectangleFeature.topLeft.y/ absoluteHeight));
    CGPoint detectedTopRightPoint = CGPointMake(_detectedRectangleFeature.topRight.x/absoluteWidth,(_detectedImage.frame.size.height -  _detectedRectangleFeature.topRight.y/ absoluteHeight));
    CGPoint detectedBottomLeftPoint = CGPointMake(_detectedRectangleFeature.bottomLeft.x/absoluteWidth,(_detectedImage.frame.size.height -  _detectedRectangleFeature.bottomLeft.y/ absoluteHeight));
    CGPoint detectedBottomRightPoint = CGPointMake(_detectedRectangleFeature.bottomRight.x/absoluteWidth,(_detectedImage.frame.size.height -  _detectedRectangleFeature.bottomRight.y/ absoluteHeight));

    _overlayView.topLeftPath = [_overlayView correctPoint:detectedTopLeftPoint];
    _overlayView.topRightPath = [_overlayView correctPoint:detectedTopRightPoint];
    _overlayView.bottomLeftPath = [_overlayView correctPoint:detectedBottomLeftPoint];
    _overlayView.bottomRightPath = [_overlayView correctPoint:detectedBottomRightPoint];
    
    [_overlayView initializeSubView];

}

-(void)magnetDeactivated{
    
    static float margin = 60.0f;
    float absoluteHeight = self.originalImage.size.height / _detectedImage.frame.size.height;
    float absoluteWidth = self.originalImage.size.width / _detectedImage.frame.size.width;

    if (!_overlayView) {
        
        _overlayView = [[CDOverlayView alloc] initWithFrame:CGRectZero];
        _overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        [_detectedImage addSubview:_overlayView];
        
        NSLayoutConstraint* imgTop = [NSLayoutConstraint constraintWithItem:_overlayView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_detectedImage
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0 constant:0.0];
        NSLayoutConstraint* imgLeft = [NSLayoutConstraint constraintWithItem:_overlayView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_detectedImage
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0 constant:0.0];
        NSLayoutConstraint* imgRight = [NSLayoutConstraint constraintWithItem:_overlayView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_detectedImage
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0 constant:0.0];
        NSLayoutConstraint* imgBtm = [NSLayoutConstraint constraintWithItem:_overlayView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_detectedImage
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0 constant:0.0];
        
        NSArray* imgConstraints = [NSArray arrayWithObjects:imgTop, imgBtm, imgLeft, imgRight, nil];
        
        [_detectedImage addConstraints:imgConstraints];
        
    }
    
    _overlayView.absoluteHeight = absoluteHeight;
    _overlayView.absoluteWidth = absoluteWidth;

    _overlayView.topLeftPath = CGPointMake(margin, margin);
    _overlayView.topRightPath = CGPointMake(_detectedImage.frame.size.width - margin,margin);
    _overlayView.bottomLeftPath = CGPointMake(margin, _detectedImage.frame.size.height - margin);
    _overlayView.bottomRightPath = CGPointMake(_detectedImage.frame.size.width - margin, _detectedImage.frame.size.height - margin);

    [_overlayView initializeSubView];
}


-(void)initializeHeaderView{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headerView setBackgroundColor:[CropperConstantValues standartBackgroundColor]];
    [self.view addSubview:_headerView];
    
    UILabel* screenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0)/2.0, 33.0, 150.0, 18)];
    screenTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [screenTitleLabel setText:@"Crop image"];
    [screenTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [screenTitleLabel setFont:[UIFont systemFontOfSize:16]];
    [screenTitleLabel setTextColor:[UIColor whiteColor]];
    [_headerView addSubview:screenTitleLabel];

    
    NSLayoutConstraint* headerTop = [NSLayoutConstraint constraintWithItem:_headerView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0 constant:0.0];
    NSLayoutConstraint* headerHeight = [NSLayoutConstraint constraintWithItem:_headerView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0 constant:[CropperConstantValues pictureSelectorHeaderViewHeight]];
    NSLayoutConstraint* headerLeft = [NSLayoutConstraint constraintWithItem:_headerView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0 constant:0.0];
    NSLayoutConstraint* headerRight = [NSLayoutConstraint constraintWithItem:_headerView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0.0];
    
    NSArray* headerViewConstraints = [NSArray arrayWithObjects:headerTop, headerHeight, headerLeft, headerRight, nil];
    
    [self.view addConstraints:headerViewConstraints];
    
    
    //
    
    NSLayoutConstraint* titleTop = [NSLayoutConstraint constraintWithItem:screenTitleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_headerView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0 constant:33.0];

    NSLayoutConstraint* titleCenter = [NSLayoutConstraint constraintWithItem:screenTitleLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_headerView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0 constant:0.0];
    
    NSArray* titleConstraints = [NSArray arrayWithObjects:titleTop, titleCenter, nil];
    
    [_headerView addConstraints:titleConstraints];

}

-(void)initializeFooterView{
    
    _footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_footerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_footerView setBackgroundColor:[CropperConstantValues standartBackgroundColor]];
    [self.view addSubview:_footerView];
    
    UIButton* doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(self.view.frame.size.width - 80.0f, 0.0, 60.0, [CropperConstantValues pictureSelectorFooterViewHeight])];
    doneBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [doneBtn addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[CropperConstantValues doneButtonColor] forState:UIControlStateNormal];
    [_footerView addSubview:doneBtn];
    
    
    
    NSLayoutConstraint* footerBottom = [NSLayoutConstraint constraintWithItem:_footerView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0 constant:0.0];
    NSLayoutConstraint* footerHeight = [NSLayoutConstraint constraintWithItem:_footerView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0 constant:[CropperConstantValues pictureSelectorFooterViewHeight]];
    NSLayoutConstraint* footerLeft = [NSLayoutConstraint constraintWithItem:_footerView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0 constant:0.0];
    NSLayoutConstraint* footerRight = [NSLayoutConstraint constraintWithItem:_footerView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0.0];
    
    NSArray* footerViewConstraints = [NSArray arrayWithObjects:footerBottom, footerHeight, footerLeft, footerRight, nil];
    
    [self.view addConstraints:footerViewConstraints];
    
    
    NSLayoutConstraint* doneTop = [NSLayoutConstraint constraintWithItem:doneBtn
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_footerView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* doneBtm = [NSLayoutConstraint constraintWithItem:doneBtn
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];

    
    NSLayoutConstraint* doneRight = [NSLayoutConstraint constraintWithItem:doneBtn
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_footerView
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:-20.0];
    
    NSLayoutConstraint* doneWidth = [NSLayoutConstraint constraintWithItem:doneBtn
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0 constant:60.0];

    
    NSArray* doneConstraints = [NSArray arrayWithObjects:doneBtm,doneRight , doneWidth , doneTop, nil];
    
    [_footerView addConstraints:doneConstraints];

}

-(void)autoRectangleDetect{
    
    if (_magnetEnabled) {
        
        [self magnetDeactivated];
        _magnetEnabled = NO;
    }else{
        
        if (_detectedRectangleFeature)
        {

            [self magnetActivated];
            _magnetEnabled = YES;

        }else{
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"We can't detect document please retake." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
            _magnetButton.enabled = NO;
            _magnetEnabled = NO;
        }

    }
}

-(void)confirmButtonClicked{
    
    [self.delegate cropperViewdidCropped:[_overlayView cropImage:self.originalImage] cropVC:self];
    [self dismissViewControllerAnimated:NO completion:nil];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) shouldAutorotate {
    
    if (_detectedRectangleFeature) {
        
        [self magnetActivated];
        
    }else{
        
        [self magnetDeactivated];
    }

    return NO;
}


@end
