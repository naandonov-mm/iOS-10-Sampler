//
//  ViewController.m
//  GraphicsRenderer
//
//  Created by Dobrinka Tabakova on 12/8/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsPDFRenderer *pdfRenderer = [[UIGraphicsPDFRenderer alloc] initWithBounds:self.view.bounds];
        
        NSData *pdfData = [pdfRenderer PDFDataWithActions:^(UIGraphicsPDFRendererContext * _Nonnull rendererContext) {
            NSInteger pageCount = 500;
            UIImage *image = [UIImage imageNamed:@"black-cat.jpg"];
            CGRect pdfPageBounds = CGRectMake(.0f, .0f, image.size.width, image.size.height);
            for (NSUInteger i = 0; i < pageCount; ++i) {
                [rendererContext beginPageWithBounds:pdfPageBounds pageInfo:@{}];
                [image drawInRect:pdfPageBounds];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:[NSURL new]];
            [self.activityIndicator stopAnimating];
            self.webView.hidden = NO;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
