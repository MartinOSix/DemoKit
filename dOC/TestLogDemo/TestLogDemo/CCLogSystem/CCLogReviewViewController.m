//
//  CCLogReviewViewController.m
//  CCLogSystem
//
//  Created by Chun Ye on 10/30/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCLogReviewViewController.h"
#import "CCLogSystem.h"
#import <WebKit/WebKit.h>

@import MessageUI;

@interface CCLogReviewViewController () <MFMailComposeViewControllerDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSURL *currentLogPathURL;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CCLogReviewViewController

- (id)initWithLogPathURL:(NSURL *)logPathURL;
{
    self = [super init];
    if (self) {
        self.currentLogPathURL = logPathURL;
        
        self.title = [self.currentLogPathURL lastPathComponent];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    NSMutableArray *constraits = [NSMutableArray array];
    [constraits addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_webView]|" options:0 metrics:nil views:views]];
    [constraits addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:constraits];
    
    [self loadLogData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(handleEmailBarButtonItem)];
}

#pragma mark - Private

- (void)handleEmailBarButtonItem
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSString *processName = [NSProcessInfo processInfo].processName;
        [mailController setSubject:[NSString stringWithFormat:@"%@ Log Report <AppVersion %@ AppBuild %@>", processName, appVersion, appBuild]];
        [mailController setMailComposeDelegate:self];
        
        NSData *logData = [[NSData alloc] initWithContentsOfURL:self.currentLogPathURL];
        [mailController addAttachmentData:logData mimeType:@"com.apple.log" fileName:self.currentLogPathURL.lastPathComponent];
        
        [self presentViewController:mailController animated:YES completion:NULL];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Configure your email account in iOS Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)loadLogData
{
    NSString *string = [NSString stringWithContentsOfURL:self.currentLogPathURL encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:string baseURL:self.currentLogPathURL];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize webviewContentSize = webView.scrollView.contentSize;
    [webView.scrollView scrollRectToVisible:CGRectMake(0, webviewContentSize.height - webView.bounds.size.height, webView.bounds.size.width, webView.bounds.size.height) animated:NO];
}

@end
