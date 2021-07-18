//
//  ShareViewController.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "ShareViewController.h"
#import "CropperConstantValues.h"
#import "OCRViewController.h"

#import "ShareObject.h"

#import "DefaultValues.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize interstitial = _interstitial;
@synthesize bannerView = _bannerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initializeContents];
    
    [self initializeHeaderView];
    [self initializeMainView];
    
    [self checkAndRunAdsense];

    // Do any additional setup after loading the view.
}

-(void)initializeContents{
    
    ShareObject* cameraRoll = [[ShareObject alloc] initWithName:@"Camera roll" imageName:@"save_image" type:ShareTypeCameraRoll];
    ShareObject* fb = [[ShareObject alloc] initWithName:@"Facebook" imageName:@"share_fb" type:ShareTypeFacebook];
    ShareObject* ocr = [[ShareObject alloc] initWithName:@"Read image" imageName:@"convert_text" type:ShareTypeConvertText];
    ShareObject* pdf = [[ShareObject alloc] initWithName:@"Share as PDF" imageName:@"share_pdf" type:ShareTypePDF];
    ShareObject* image = [[ShareObject alloc] initWithName:@"Share as image" imageName:@"image_read" type:ShareTypeShareImage];
    
    _contentArray =  [NSArray arrayWithObjects:cameraRoll, fb, ocr,pdf,image, nil];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        ShareObject* object = [_contentArray objectAtIndex:indexPath.row];
        [self shareWithType:object.shareType];
        
    }else{
        
        [self backButtonClicked];
    }
}

-(void)shareWithType:(ShareType)type{

    switch (type) {
        case ShareTypeCameraRoll:

            UIImageWriteToSavedPhotosAlbum(self.savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

            break;
            

        case ShareTypeFacebook:
            
            [self shareWithFacebook];

            break;
            
        case ShareTypeConvertText:
            
            [self putToOCRScreen];
            break;
            
        case ShareTypePDF:
            
            [self createPDFfromImage:self.savedImage];
            break;
            
        default:{
            //Share image
            [self shareImage];

        }
            break;
    }
}

//camera roll

- (void)               image:(UIImage *)image
    didFinishSavingWithError:(NSError *)error
                 contextInfo:(void *)contextInfo;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Document Scanner"
                                                    message:@"Image Saved Successfully."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)shareWithFacebook{
    
    NSLog(@"fb");
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbSheet setInitialText:@"Shared from Document Scanner"];
        [fbSheet addImage:self.savedImage];
        [self presentViewController:fbSheet animated:YES completion:nil];
    }
}

-(void)shareWithTwitter{
    NSLog(@"twitter");
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Shared from Document Scanner"];
        [tweetSheet addImage:self.savedImage];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    
}

-(void)putToOCRScreen{
    
    OCRViewController* ocrVC = [[OCRViewController alloc] init];
    ocrVC.rawImage = self.savedImage;
    [self.navigationController pushViewController:ocrVC animated:YES];
}


-(void)shareImage{
    
    NSArray *activityItems = @[self.savedImage];

    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];

    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = excludeActivities;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //iPhone
        [self presentViewController:activityController animated:YES completion:nil];
    }
    else {
        //iPad
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height*0.4 + 250.0, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark
#pragma mark Admob delegate


-(void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
    
}


#pragma mark
#pragma mark uitableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if (section == 0) {
         return _contentArray.count;
    }else{
        return 1;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 42.0;
    }else{
        
        return 52.0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"DraftCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel* doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 15.0, self.view.frame.size.width, 22.0)];
        doneLabel.tag = 123;
        doneLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0f alpha:1.0];
        doneLabel.textAlignment = NSTextAlignmentCenter;
        doneLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        [cell addSubview:doneLabel];
        
    }

    UILabel* doneLabel = (UILabel *)[cell viewWithTag:123];
    
    if (indexPath.section == 0) {
    
        doneLabel.hidden = YES;
        ShareObject* object = [_contentArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:object.thumbnail];
        cell.textLabel.text = object.connectionName;
        
    }else{
        
        doneLabel.text = @"Done";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)initializeMainView{
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectZero];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bannerView.adUnitID =  kAdmobAdsenseBannerUnitID;
    self.bannerView.backgroundColor = [UIColor clearColor];
    self.bannerView.rootViewController = self;
    
    GADRequest* request = [GADRequest request];
    request.testDevices = [DefaultValues adsenseTestDevices];
    
    [self.bannerView loadRequest:request];
    [self.view addSubview:_bannerView];

    _bannerHeight = [NSLayoutConstraint constraintWithItem:_bannerView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint* bannerBtm = [NSLayoutConstraint constraintWithItem:_bannerView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeBottom
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
    
    NSArray* bnrConstraints = [NSArray arrayWithObjects:bannerBtm, _bannerHeight, bannerLeft, bannerRight, nil];
    
    [self.view addConstraints:bnrConstraints];

    
    
    _shareListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _shareListView.translatesAutoresizingMaskIntoConstraints = NO;
    _shareListView.delegate = self;
    _shareListView.dataSource = self;
    [self.view addSubview:_shareListView];
    
    CGSize screenSize = self.view.frame.size;
    CGFloat imgViewHeight = screenSize.height*0.4;
    
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenSize.width, imgViewHeight)];
    _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    _thumbnailImageView.backgroundColor = [UIColor colorWithWhite:33.0/255.0 alpha:1.0];
    _thumbnailImageView.image = self.savedImage;

    
    _shareListView.tableHeaderView = _thumbnailImageView;
    
    NSLayoutConstraint* listTop = [NSLayoutConstraint constraintWithItem:_shareListView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_headerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0 constant:0.0];
    NSLayoutConstraint* listBtm = [NSLayoutConstraint constraintWithItem:_shareListView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_bannerView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0 constant:0.0];
    NSLayoutConstraint* listLeft = [NSLayoutConstraint constraintWithItem:_shareListView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0 constant:0.0];
    NSLayoutConstraint* listRight = [NSLayoutConstraint constraintWithItem:_shareListView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0.0];
    
    NSArray* listConstraints = [NSArray arrayWithObjects:listBtm, listLeft, listRight, listTop, nil];
    
    [self.view addConstraints:listConstraints];

}
-(void)initializeHeaderView{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headerView setBackgroundColor:[CropperConstantValues standartBackgroundColor]];
    [self.view addSubview:_headerView];
    
    UILabel* screenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0)/2.0, 33.0, 150.0, 18)];
    screenTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [screenTitleLabel setText:@"Share"];
    [screenTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [screenTitleLabel setFont:[UIFont systemFontOfSize:16]];
    [screenTitleLabel setTextColor:[UIColor whiteColor]];
    [_headerView addSubview:screenTitleLabel];
    
    
    UIButton* backBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_btn_normal"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_btn_selected"] forState:UIControlStateSelected];
    [backBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
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
    

    NSLayoutConstraint* backTop = [NSLayoutConstraint constraintWithItem:backBtn
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_headerView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0 constant:20.0];
    
    NSLayoutConstraint* backLeft = [NSLayoutConstraint constraintWithItem:backBtn
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_headerView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0 constant:0.0];
    
    
    NSArray* backConstraints = [NSArray arrayWithObjects:backTop, backLeft, nil];
    
    [_headerView addConstraints:backConstraints];
    

    
}

-(void)checkAndRunAdsense{
    
    if ([DefaultValues isAdmobActive]) {
        
        _bannerHeight.constant = 50.0f;
        self.interstitial = [self createInterstitial];
    }else{
        
        _bannerHeight.constant = 0.0f;
    }
    [self.view layoutIfNeeded];
}

-(void)createPDFfromImage:(UIImage*)image
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, imageView.bounds, nil);
    UIGraphicsBeginPDFPage();
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"covertedPDF.pdf"];
    
    // instructs the mutable data object to write its context to a file on disk
    if ([pdfData writeToFile:documentDirectoryFilename atomically:YES]) {
        
    }
    
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    
    NSArray *activityItems = @[[NSURL fileURLWithPath:documentDirectoryFilename]];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //iPhone
        [self presentViewController:activityController animated:YES completion:nil];
    }
    else {
        //iPad
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height*0.4 + 200.0, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}


-(GADInterstitial *)createInterstitial{
    
    GADInterstitial* interst = [[GADInterstitial alloc] initWithAdUnitID:kAdmobAdsenseFullScreenUnitID];
    interst.delegate = self;
    

    GADRequest *request = [GADRequest request];
    // Requests test ads on test devices.
    request.testDevices = [DefaultValues adsenseTestDevices];
    [interst loadRequest:request];
    
    return interst;
}


-(void)backButtonClicked{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotate{
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
