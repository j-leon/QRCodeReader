//
//  WebViewController.m
//  QRCodeReader
//
//  Created by Shore Excursioneer on 29/06/15.
//  Copyright (c) 2015 Shore Excursioneer. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
static NSString *const segueBackToScan = @"segueBackToScan";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *loadUrl = [[NSURLRequest alloc]initWithURL:_url];
    [_webView loadRequest:loadUrl];
    
    // Do any additional setup after loading the view.
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

- (IBAction)BackToScan:(id)sender {
    [self performSegueWithIdentifier:segueBackToScan sender:self];
}
@end
