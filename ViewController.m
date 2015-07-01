//
//  ViewController.m
//  QRCodeReader
//
//  Created by Shore Excursioneer on 29/06/15.
//  Copyright (c) 2015 Shore Excursioneer. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;


@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

- (BOOL)startReading;
- (void)stopReading;

@property (strong,nonatomic) NSURL *url;

@end

@implementation ViewController

static NSString *const segueToWebView = @"segueToWebView";

- (void)viewDidLoad {
    [super viewDidLoad];
    _isReading = NO;
    _captureSession = nil;
    [self startReading];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:nil];
    _isReading = NO;
    _captureSession = nil;
    [self startReading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Received a memory warning");
}

-(BOOL)startReading{
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input= [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    _captureSession = [[AVCaptureSession alloc]init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc]init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQ;
    dispatchQ = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQ];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        if ([[metadataObject type]isEqualToString:AVMetadataObjectTypeQRCode]) {
            _url = [[NSURL alloc]initWithString:[metadataObject stringValue]];
            NSLog(@"read QR value: %@", _url );
            _isReading = NO;
            [_videoPreviewLayer removeFromSuperlayer];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"will prepare for segue with identifier: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"segueToWebView"]) {
        [_captureSession stopRunning];
        _captureSession = nil;
        [_viewPreview removeFromSuperview];
        WebViewController *webView = (WebViewController *)[[segue destinationViewController]topViewController];
        [webView setUrl:_url];
    }
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"segueToWebView"]) {
        NSLog(@"Should Perform segue");
        return YES;
    }
    else{
        NSLog(@"Should not Perform segue");
        return NO;
    }
}



-(void)stopReading{
    [self performSegueWithIdentifier:@"segueToWebView" sender:self];
}
@end

