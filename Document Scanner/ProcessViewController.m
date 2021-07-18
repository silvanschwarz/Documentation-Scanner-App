//
//  ProcessViewController.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "ProcessViewController.h"
#import "CropViewController.h"
#import "CropperConstantValues.h"

#import "ShareViewController.h"

#define kButtonChangeDelay 0.15

@interface ProcessViewController ()

@end

@implementation ProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _sharedHelper = [CDImageRectangleDetector sharedDetector];
    self.view.backgroundColor = [UIColor colorWithWhite:33.0/255.0 alpha:1.0];
    

    _imageViewer = [[UIImageView alloc] initWithImage:self.croppedImage];
    _imageViewer.translatesAutoresizingMaskIntoConstraints = NO;
    _imageViewer.clipsToBounds = YES;
        _imageViewer.backgroundColor = [UIColor colorWithWhite:33.0/255.0 alpha:1.0];

    NSLayoutConstraint* imgTop = [NSLayoutConstraint constraintWithItem:_imageViewer
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0 constant:64.0];
    NSLayoutConstraint* imgBtm = [NSLayoutConstraint constraintWithItem:_imageViewer
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0 constant:-49.0];
    NSLayoutConstraint* imgLeft = [NSLayoutConstraint constraintWithItem:_imageViewer
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0 constant:0.0];
    NSLayoutConstraint* imgRight = [NSLayoutConstraint constraintWithItem:_imageViewer
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0 constant:0.0];
    
    NSArray* imgViewConstraints = [NSArray arrayWithObjects:imgBtm, imgLeft, imgRight, imgTop, nil];
    
    


    _imageViewer.contentMode = UIViewContentModeScaleAspectFit;
    //    _imageViewer.image = self.croppedImage;
    
    [self.view addSubview:_imageViewer];
    [self.view addConstraints:imgViewConstraints];
    

    
    [self initializeHeaderView];
    [self initializeFooterView];
    

    // Do any additional setup after loading the view.
}

-(void)initializeHeaderView{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headerView setBackgroundColor:[CropperConstantValues standartBackgroundColor]];
    [self.view addSubview:_headerView];
    
    UILabel* screenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0)/2.0, 33.0, 150.0, 18)];
    screenTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [screenTitleLabel setText:@"Process"];
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
    
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_editBtn addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_footerView addSubview:_editBtn];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_saveBtn setTitle:@"Share" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[CropperConstantValues doneButtonColor] forState:UIControlStateNormal];
    [_footerView addSubview:_saveBtn];
    
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"trash_button_normal"] forState:UIControlStateNormal];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"trash_button_selected"] forState:UIControlStateSelected];
    [_deleteBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_deleteBtn addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_deleteBtn];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.alpha = 0.0;
    [_footerView addSubview:_cancelBtn];


    _rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rotateBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_rotateBtn setBackgroundImage:[UIImage imageNamed:@"rotate_button_normal"] forState:UIControlStateNormal];
    [_rotateBtn setBackgroundImage:[UIImage imageNamed:@"rotate_button_selected"] forState:UIControlStateSelected];
    [_rotateBtn addTarget:self action:@selector(rotateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _rotateBtn.alpha = 0.0;
    [_footerView addSubview:_rotateBtn];


    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[CropperConstantValues doneButtonColor] forState:UIControlStateNormal];
    [_doneBtn addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _doneBtn.alpha = 0.0;
    [_footerView addSubview:_doneBtn];

    
    UIView* leftBGView = [[UIView alloc] init];
    leftBGView.translatesAutoresizingMaskIntoConstraints = NO;
    [_footerView addSubview:leftBGView];
    
    UIView* rightBGView = [[UIView alloc] init];
    rightBGView.translatesAutoresizingMaskIntoConstraints = NO;
    [_footerView addSubview:rightBGView];
    
    _cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cropBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_cropBtn setBackgroundImage:[UIImage imageNamed:@"crop_button_normal"] forState:UIControlStateNormal];
    [_cropBtn setBackgroundImage:[UIImage imageNamed:@"crop_button_selected"] forState:UIControlStateSelected];
    [_cropBtn addTarget:self action:@selector(cropButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _cropBtn.alpha = 0.0;
    [leftBGView addSubview:_cropBtn];

    _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _filterBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_filterBtn setBackgroundImage:[UIImage imageNamed:@"color_change_normal"] forState:UIControlStateNormal];
    [_filterBtn setBackgroundImage:[UIImage imageNamed:@"color_change_selected"] forState:UIControlStateSelected];
    [_filterBtn addTarget:self action:@selector(filterChangeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _filterBtn.alpha = 0.0;
    [rightBGView addSubview:_filterBtn];
    
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
                                                                   multiplier:1.0 constant:[CropperConstantValues processFooterViewHeight]];
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
    
    
    NSLayoutConstraint* editTop = [NSLayoutConstraint constraintWithItem:_editBtn
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* editBtm = [NSLayoutConstraint constraintWithItem:_editBtn
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* editRight = [NSLayoutConstraint constraintWithItem:_editBtn
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_footerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0 constant:20.0];
    
    NSLayoutConstraint* editWidth = [NSLayoutConstraint constraintWithItem:_editBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0 constant:60.0];
    
    
    NSArray* editConstraints = [NSArray arrayWithObjects:editBtm,editRight , editTop , editWidth, nil];
    
    [_footerView addConstraints:editConstraints];
    
    
    
    NSLayoutConstraint* saveTop = [NSLayoutConstraint constraintWithItem:_saveBtn
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* saveBtm = [NSLayoutConstraint constraintWithItem:_saveBtn
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* saveRight = [NSLayoutConstraint constraintWithItem:_saveBtn
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_footerView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* saveWidth = [NSLayoutConstraint constraintWithItem:_saveBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0 constant:60.0];
    
    
    NSArray* saveeConstraints = [NSArray arrayWithObjects:saveBtm,saveRight , saveWidth , saveTop, nil];
    
    [_footerView addConstraints:saveeConstraints];
    
    
    NSLayoutConstraint* deleteTop = [NSLayoutConstraint constraintWithItem:_deleteBtn
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* deleteBtm = [NSLayoutConstraint constraintWithItem:_deleteBtn
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* deleteRight = [NSLayoutConstraint constraintWithItem:_deleteBtn
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_footerView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0 constant:-20.0];
    
    NSLayoutConstraint* deleteWidth = [NSLayoutConstraint constraintWithItem:_deleteBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0 constant:60.0];
    
    
    NSArray* deleteConstraints = [NSArray arrayWithObjects:deleteBtm,deleteRight , deleteWidth , deleteTop, nil];
    
    [_footerView addConstraints:deleteConstraints];

    NSLayoutConstraint* cancelTop = [NSLayoutConstraint constraintWithItem:_cancelBtn
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* cancelBtm = [NSLayoutConstraint constraintWithItem:_cancelBtn
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* cancelRight = [NSLayoutConstraint constraintWithItem:_cancelBtn
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_footerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0 constant:10.0];
    
    NSLayoutConstraint* cancelWidth = [NSLayoutConstraint constraintWithItem:_cancelBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0 constant:60.0];
    
    
    NSArray* cancelConstraints = [NSArray arrayWithObjects:cancelTop,cancelBtm , cancelRight, cancelWidth, nil];
    
    [_footerView addConstraints:cancelConstraints];
    
    
    
    NSLayoutConstraint* rotateTop = [NSLayoutConstraint constraintWithItem:_rotateBtn
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* rotateBtm = [NSLayoutConstraint constraintWithItem:_rotateBtn
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* rotateRight = [NSLayoutConstraint constraintWithItem:_rotateBtn
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_footerView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* rotateWidth = [NSLayoutConstraint constraintWithItem:_rotateBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0 constant:60.0];
    
    
    NSArray* rotateConstraints = [NSArray arrayWithObjects:rotateBtm,rotateRight , rotateWidth , rotateTop, nil];
    
    [_footerView addConstraints:rotateConstraints];
    
    
    NSLayoutConstraint* doneTop = [NSLayoutConstraint constraintWithItem:_doneBtn
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_footerView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* doneBtm = [NSLayoutConstraint constraintWithItem:_doneBtn
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_footerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* doneRight = [NSLayoutConstraint constraintWithItem:_doneBtn
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_footerView
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:-10.0];
    
    NSLayoutConstraint* doneWidth = [NSLayoutConstraint constraintWithItem:_doneBtn
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0 constant:60.0];
    
    
    NSArray* doneConstraints = [NSArray arrayWithObjects:doneBtm,doneRight , doneWidth , doneTop, nil];
    
    [_footerView addConstraints:doneConstraints];


    
    NSLayoutConstraint* leftTop = [NSLayoutConstraint constraintWithItem:leftBGView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_footerView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* leftBtm = [NSLayoutConstraint constraintWithItem:leftBGView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_footerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* leftLeft = [NSLayoutConstraint constraintWithItem:leftBGView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_cancelBtn
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* leftRight = [NSLayoutConstraint constraintWithItem:leftBGView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_rotateBtn
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0 constant:0.0];
    
    
    NSArray* leftConstraints = [NSArray arrayWithObjects:leftBtm,leftRight , leftTop, leftLeft, nil];
    
    [_footerView addConstraints:leftConstraints];
    
    NSLayoutConstraint* rightTop = [NSLayoutConstraint constraintWithItem:rightBGView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* rightBtm = [NSLayoutConstraint constraintWithItem:rightBGView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_footerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* rightLeft = [NSLayoutConstraint constraintWithItem:rightBGView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_rotateBtn
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* rightRight = [NSLayoutConstraint constraintWithItem:rightBGView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_doneBtn
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0 constant:0.0];
    
    
    NSArray* rightConstraints = [NSArray arrayWithObjects:rightBtm, rightLeft, rightTop, rightRight, nil];
    
    [_footerView addConstraints:rightConstraints];
    
    
    
    NSLayoutConstraint* cropTop = [NSLayoutConstraint constraintWithItem:_cropBtn
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:leftBGView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* cropBtm = [NSLayoutConstraint constraintWithItem:_cropBtn
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:leftBGView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* cropCenter = [NSLayoutConstraint constraintWithItem:_cropBtn
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:leftBGView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* cropWidth = [NSLayoutConstraint constraintWithItem:_cropBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0 constant:60.0];
    
    
    NSArray* cropConstraints = [NSArray arrayWithObjects:cropBtm, cropCenter, cropTop, cropWidth, nil];
    
    [leftBGView addConstraints:cropConstraints];

    
    NSLayoutConstraint* filterTop = [NSLayoutConstraint constraintWithItem:_filterBtn
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:rightBGView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* filterBtm = [NSLayoutConstraint constraintWithItem:_filterBtn
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:rightBGView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];
    
    
    NSLayoutConstraint* filterCenter = [NSLayoutConstraint constraintWithItem:_filterBtn
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:rightBGView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* filterWidth = [NSLayoutConstraint constraintWithItem:_filterBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0 constant:60.0];
    
    
    NSArray* filterConstraints = [NSArray arrayWithObjects:filterBtm, filterCenter, filterTop, filterWidth, nil];
    
    [rightBGView addConstraints:filterConstraints];
    

}

-(void)editButtonClicked{
    
    [UIView animateWithDuration:kButtonChangeDelay animations:^{
        
        
        _editBtn.alpha = 0.0f;
        _saveBtn.alpha = 0.0f;
        _deleteBtn.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
       
        _cancelBtn.alpha = 1;
        _cropBtn.alpha = 1.0f;
        _rotateBtn.alpha = 1.0;
        _filterBtn.alpha = 1.0f;
        _doneBtn.alpha = 1.0f;
        
    }];
}

-(void)cancelButtonClicked{
    
    [UIView animateWithDuration:kButtonChangeDelay animations:^{
        
        
        _cancelBtn.alpha = 0;
        _cropBtn.alpha = 0.0f;
        _rotateBtn.alpha = 0.0;
        _filterBtn.alpha = 0.0f;
        _doneBtn.alpha = 0.0f;

        
    } completion:^(BOOL finished) {
        
        
        
        _editBtn.alpha = 1.0f;
        _saveBtn.alpha = 1.0f;
        _deleteBtn.alpha = 1.0f;

        
    }];
}
-(void)disableEditSection{
    
    _cancelBtn.enabled = NO;
    _cropBtn.enabled = NO;
    _rotateBtn.enabled = NO;
    _filterBtn.enabled = NO;
    _doneBtn.enabled = NO;

}

-(void)enableEditSection{
    
    _cancelBtn.enabled = YES;
    _cropBtn.enabled = YES;
    _rotateBtn.enabled = YES;
    _filterBtn.enabled = YES;
    _doneBtn.enabled = YES;
    
}

-(void)cropButtonClicked{
    
    CropViewController* cropperVC = [[CropViewController alloc] init];
    cropperVC.originalImage = self.orignalImage;
    cropperVC.delegate = self;
    cropperVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cropperVC animated:YES completion:nil];

}


-(void)rotateButtonClicked{
    
    if (_rotatedDegree == 270.0) {
        
        _rotatedDegree = 0.0;
    }else
        _rotatedDegree += 90.0;
    
    UIImage *img = [self editedImage];
    
    [self disableEditSection];
    [UIView animateWithDuration:0.5 animations:^{
        
        _imageViewer.transform = CGAffineTransformMakeRotation(90.0 * M_PI/180);
        
    } completion:^(BOOL finished) {
        
        _imageViewer.transform = CGAffineTransformMakeRotation(0);
        _imageViewer.image = img;
        
        [self enableEditSection];
    }];


}


-(void)saveImage{
    
    
    ShareViewController* shareVC = [[ShareViewController alloc] init];
    shareVC.savedImage = [self editedImage];
    [self.navigationController pushViewController:shareVC animated:YES];
}

-(void)deleteButtonClicked{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Document Scanner"
                                                    message:@"Are you sure to delete current session?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    alert.tag = 321;
    [alert show];
}

#pragma mark - Other Methods
- (void)               image:(UIImage *)image
    didFinishSavingWithError:(NSError *)error
                 contextInfo:(void *)contextInfo;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Document Scanner"
                                                    message:@"Image Saved Successfully."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = 123;
    [alert show];
}

-(void)filterChangeButtonClicked{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choice adjustment" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Colorful",@"Grayscale",@"Black and white", nil];
    [actionSheet showInView:self.view];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 123) {

        NSLog(@"Switch to share screen");

    }else{
        
        if (buttonIndex == 1) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  
    if (buttonIndex == 0) {
        
        [self changeImageColorWithType:ImageFilterTypeColorful];
    }else if (buttonIndex == 1){
        
        [self changeImageColorWithType:ImageFilterTypeGrayScale];
    }else if (buttonIndex == 2){

        [self changeImageColorWithType:ImageFilterTypeBlackAndWhite];
    }
}

-(void)changeImageColorWithType:(ImageFilterType)type{
    
    _filterType = type;
    _imageViewer.image = [self editedImage];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)cropperViewdidCropped:(UIImage *)croppedImage cropVC:(CropViewController *)cropVC{
    
    self.croppedImage = croppedImage;
    _imageViewer.image = [self editedImage];
}


-(UIImage *)editedImage{
    
    UIImage *rotatedImage = [_sharedHelper rotatedImageWithDegree:_rotatedDegree image:self.croppedImage];
    UIImage* filteredImage = [_sharedHelper imageFilter:rotatedImage type:_filterType];

    return filteredImage;
}


@end
