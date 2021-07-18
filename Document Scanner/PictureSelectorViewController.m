//
//  PictureSelectorViewController.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "PictureSelectorViewController.h"
#import "ProcessViewController.h"

@interface PictureSelectorViewController ()

@end

@implementation PictureSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    [self initializeMainScreen];
    [self initializePhotoPicker];
    [self initializeHeaderView];
    [self initializeFooterView];

}


-(void)focusGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint location = [sender locationInView:self.cameraViewController];
        
        [self focusIndicatorAnimateToPoint:location];
        
        [self.cameraViewController focusAtPoint:location completionHandler:^
         {
             [self focusIndicatorAnimateToPoint:location];
         }];
    }
}

- (void)focusIndicatorAnimateToPoint:(CGPoint)targetPoint
{
    [self.focusImageView setCenter:targetPoint];
    self.focusImageView.alpha = 0.0;
    self.focusImageView.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^
     {
         self.focusImageView.alpha = 1.0;
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.4 animations:^
          {
              self.focusImageView.alpha = 0.0;
          }];
     }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cameraViewController start];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.cameraViewController stop];
}

-(void)initializeHeaderView{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headerView setBackgroundColor:[CropperConstantValues standartBackgroundColor]];
    [self.view addSubview:_headerView];
    
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"DocScan"];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, 3)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(3, 4)];

    
    UILabel* screenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0)/2.0, 33.0, 150.0, 18)];
    [screenTitleLabel setAttributedText:attrString];
    [screenTitleLabel setTextAlignment:NSTextAlignmentCenter];
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
}

-(void)initializeFooterView{
    
    _footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_footerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_footerView setBackgroundColor:[CropperConstantValues standartBackgroundColor]];
    [self.view addSubview:_footerView];
    
    cameraRollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraRollBtn setFrame:CGRectMake(20.0, 15.0, 42.0, 42.0)];
    [cameraRollBtn addTarget:self action:@selector(selectFromCameraRollClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [cameraRollBtn setBackgroundImage:[UIImage imageNamed:@"camera_roll"] forState:UIControlStateNormal];
    cameraRollBtn.contentMode = UIViewContentModeCenter;
    [cameraRollBtn setBackgroundColor:[UIColor whiteColor]];
    [_footerView addSubview:cameraRollBtn];
    
    cameraRollBtn.clipsToBounds = YES;
    cameraRollBtn.layer.cornerRadius = 3.0f;
    cameraRollBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cameraRollBtn.imageView.contentMode = UIViewContentModeCenter;
    cameraRollBtn.layer.borderWidth = 1.0f;
    
    UIButton* captureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [captureBtn setFrame:CGRectMake((self.view.frame.size.width - 62.0)/2.0f, 6.0, 62.0, 62.0)];
    [captureBtn addTarget:self action:@selector(captureImageClicked) forControlEvents:UIControlEventTouchUpInside];
    [captureBtn setBackgroundImage:[UIImage imageNamed:@"capture_button_icon"] forState:UIControlStateNormal];
    [_footerView addSubview:captureBtn];
    
    _flashButton = [[FlashButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80.0, 0.0, 60.0, 74.0)];
    [_flashButton addTarget:self action:@selector(flashButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_flashButton];
    
    
    [self createGalleryButton];
    
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
}


- (void)createGalleryButton
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                [cameraRollBtn setBackgroundImage:latestPhoto forState:UIControlStateNormal];
                // Stop the enumerations
                *stop = YES; *innerStop = YES;
                
                // Do something interesting with the AV asset.
            }
        }];
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
    }];}

-(void)flashButtonClicked{
    
    [self.cameraViewController setCaptureFlashType:!_flashButton.flashTypeIsON];
    [_flashButton changeFlashType:!_flashButton.flashTypeIsON];
}

-(void)selectFromCameraRollClicked{
    
    [self presentViewController:self.picker animated:YES completion:^{
       
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
}

-(void)captureImageClicked{
    
    [self.cameraViewController captureImageWithCompletionHander:^(id data) {
        
        UIImage *image = ([data isKindOfClass:[NSData class]]) ? [UIImage imageWithData:data] : data;
        
        CGImageRef imgRefCrop = image.CGImage;
        UIImage *photo = [UIImage imageWithCGImage:imgRefCrop scale:image.scale orientation:UIImageOrientationUp];

        [self imageSelected:photo];
    }];
}


-(void)imageSelected:(UIImage *)image{
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    _selectedImage = [UIImage imageWithCGImage:[image CGImage]
                                         scale:1.0
                                   orientation: UIImageOrientationUp];
    
    [_cameraOverlayView hideHightLightOverlay];

    
    
    CropViewController* cropperVC = [[CropViewController alloc] init];
    cropperVC.originalImage = _selectedImage;
    cropperVC.delegate = self;
    cropperVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cropperVC animated:YES completion:nil];

}

-(void)cropperViewdidCropped:(UIImage *)croppedImage cropVC:(CropViewController *)cropVC{
    
    ProcessViewController* processVC = [[ProcessViewController alloc] init];
    processVC.orignalImage = _selectedImage;
    processVC.croppedImage = croppedImage;
    processVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:processVC animated:YES];
}

#pragma mark
#pragma mark initializing views

-(void)initializeMainScreen{
    
    self.cameraViewController = [[CDCameraView alloc] initWithFrame:CGRectMake(0.0, [CropperConstantValues pictureSelectorHeaderViewHeight], self.view.frame.size.width, self.view.frame.size.height -[CropperConstantValues pictureSelectorFooterViewHeight] -[CropperConstantValues pictureSelectorHeaderViewHeight] )];
    [self.view addSubview:self.cameraViewController];
    
    [self.cameraViewController initializeCameraScreen];
    [self.cameraViewController setCameraViewType:CDCameraViewTypeColorful];
    [self.cameraViewController setEnableBorderDetection:YES];
    [self.cameraViewController setCaptureFlashType:NO];
    
    
    self.focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 75.0, 75.0)];
    [self.focusImageView setImage:[UIImage imageNamed:@"focus_icon"]];
    [self.cameraViewController addSubview:_focusImageView];
    self.focusImageView.alpha = 0.0;
    
    UIImageView* brithnessIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brithness_icon"]];
    [brithnessIcon setFrame:CGRectMake(80.0, 25.0, 25.0, 25.0)];
    [self.focusImageView addSubview:brithnessIcon];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
    tapRecognizer.numberOfTapsRequired = 1;
    
    [self.cameraViewController addGestureRecognizer:tapRecognizer];
}

-(void)initializePhotoPicker{
    
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    self.picker.navigationBar.tintColor = [UIColor whiteColor];
    self.picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.picker.navigationBar.barTintColor = [CropperConstantValues standartBackgroundColor];
    self.picker.navigationBar.translucent = NO;
}


#pragma mark image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Check point 123");
    UIImage* selectedImage=[info objectForKey:UIImagePickerControllerOriginalImage];

    NSLog(@"Check point 123 : %@",NSStringFromCGSize(selectedImage.size));
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self imageSelected:selectedImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate
{
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
