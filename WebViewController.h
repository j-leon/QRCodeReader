//
//  WebViewController.h
//  QRCodeReader
//
//  Created by Shore Excursioneer on 29/06/15.
//  Copyright (c) 2015 Shore Excursioneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSURL * url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)BackToScan:(id)sender;

@end
