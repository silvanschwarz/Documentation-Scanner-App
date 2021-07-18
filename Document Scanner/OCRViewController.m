//
//  OCRViewController.m
//  Document Scanner
//
//  Created by CoDesign on 8/25/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//



#import "OCRViewController.h"
#import "CropperConstantValues.h"
#import "ImageRecognizer.h"
#import "DefaultValues.h"

#define kMinHeight 400.0

@interface OCRViewController ()

@end

@implementation OCRViewController

@synthesize rawImage = _rawImage;
@synthesize bannerView = _bannerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initializeHeaderView];
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectZero];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bannerView.adUnitID =  kAdmobAdsenseBannerUnitID;
    self.bannerView.rootViewController = self;
    
    GADRequest* request = [GADRequest request];
    request.testDevices = [DefaultValues adsenseTestDevices];
    
    [self.bannerView loadRequest:request];
    [self.view addSubview:_bannerView];

    NSLayoutConstraint* bannerTop = [NSLayoutConstraint constraintWithItem:_bannerView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_headerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0 constant:0.0];
    _bannerHeight = [NSLayoutConstraint constraintWithItem:_bannerView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0 constant:0.0];
    NSLayoutConstraint* bannerLeft = [NSLayoutConstraint constraintWithItem:_bannerView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0 constant:0.0];
    NSLayoutConstraint* bannerRight = [NSLayoutConstraint constraintWithItem:_bannerView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0.0];
    
    NSArray* bannerConstraints = [NSArray arrayWithObjects:bannerRight, bannerLeft , bannerTop, _bannerHeight, nil];
    
    [self.view addConstraints:bannerConstraints];

    
    _resultView = [[UITextView alloc] initWithFrame:CGRectZero];
    _resultView.textColor = [UIColor blackColor];
    _resultView.translatesAutoresizingMaskIntoConstraints = NO;
    [_resultView setEditable:YES];
    [_resultView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    _resultView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_resultView];
    
    NSLayoutConstraint* resultTop = [NSLayoutConstraint constraintWithItem:_resultView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_bannerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0 constant:20.0];
    _resultBtm = [NSLayoutConstraint constraintWithItem:_resultView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0 constant:-20.0];
    NSLayoutConstraint* resultLeft = [NSLayoutConstraint constraintWithItem:_resultView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0 constant:20.0];
    NSLayoutConstraint* resultRight = [NSLayoutConstraint constraintWithItem:_resultView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:-20.0];
    
    NSArray* resultConstraints = [NSArray arrayWithObjects:_resultBtm, resultLeft , resultRight, resultTop, nil];
    
    [self.view addConstraints:resultConstraints];

    
    if (self.rawImage) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Reading...";
        

        UIImage* imageToRead = [self scaleToSize:CGSizeMake(self.rawImage.size.width/ (self.rawImage.size.height/kMinHeight), kMinHeight)];
        
        [[ImageRecognizer sharedRecognizer] recognizeImage:imageToRead completion:^(NSString *result) {
           

            if (![result isEqualToString:@""]) {

                _shareButton.enabled = YES;
                _resultView.text = result;
                hud.labelText = @"Converted successful!";
            }else{

                hud.labelText = @"Cant read image!";
            }


            [hud hide:YES afterDelay:2.0];
        }];
    }

    if ([DefaultValues isAdmobActive]) {
        
        _bannerHeight.constant = 50.0;
        [self.view layoutIfNeeded];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardAppeared:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDismissed:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    // Do any additional setup after loading the view.
}

- (UIImage *) scaleToSize: (CGSize)size
{
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(self.rawImage.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.rawImage.CGImage);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.rawImage.CGImage);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage: scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeHeaderView{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headerView setBackgroundColor:[CropperConstantValues standartBackgroundColor]];
    [self.view addSubview:_headerView];
    
    UILabel* screenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0)/2.0, 33.0, 150.0, 18)];
    screenTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [screenTitleLabel setText:@"Read image"];
    [screenTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [screenTitleLabel setFont:[UIFont systemFontOfSize:16]];
    [screenTitleLabel setTextColor:[UIColor whiteColor]];
    [_headerView addSubview:screenTitleLabel];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(self.view.frame.size.width - 60.0, 20.0, 45, 44);
    [_shareButton setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _shareButton.enabled = NO;
    [_headerView addSubview:_shareButton];

    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15.0f, 20.0, 45, 44);
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:backBtn];

    
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

-(void)shareButtonClicked{
    
    NSData* convertedString = [_resultView.text dataUsingEncoding:NSUTF8StringEncoding];

    NSString* documentsFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* fileName = @"convertedFile.txt";
    
    NSString* path = [documentsFolder stringByAppendingPathComponent:fileName];
    NSURL* filePath = [NSURL fileURLWithPath:path];
    
    [[NSFileManager defaultManager] createFileAtPath:path contents:convertedString attributes:nil];
    
    NSArray *activityItems = @[filePath];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
//    [self presentViewController:activityController animated:YES completion:nil];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //iPhone
        [self presentViewController:activityController animated:YES completion:nil];
    }
    else {
        //iPad
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width-200.0, 50.0, 0, 0)inView:self.view
             permittedArrowDirections:UIPopoverArrowDirectionUnknown
                             animated:YES];
    }
}

-(void)backButtonClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark UIKeyboard notification

-(void)keyboardDismissed:(NSNotification *)notification{
    
    //UIKeyboard hidden
    [UIView animateWithDuration:0.3 animations:^{
        
        
        _resultBtm.constant = -20.0;
        
        [self.view layoutIfNeeded];
    }];
    
}
-(void)keyboardAppeared:(NSNotification *)notification{
    
    //UIKeyboard appeared
    NSDictionary* ss = [notification userInfo];
    NSValue* value = [ss valueForKeyPath:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBegin = [value CGRectValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _resultBtm.constant = -keyboardFrameBegin.size.height - 20.0;
        
        [self.view layoutIfNeeded];
    }];
    
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
