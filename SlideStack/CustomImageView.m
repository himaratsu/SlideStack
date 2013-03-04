//
//  CustomImageView.m
//  dollerme
//
//  Created by 平松 亮介 on 2013/02/13.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "CustomImageView.h"

typedef enum LazyImageViewTag_ {
    LazyImageViewTagIndicatorView = 1,
} LazyImageViewTag;

@interface CustomImageView ()

- (void)setLoadingImage;
- (void)setLoadErrorImage;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation CustomImageView

- (id)initWithFrame:(CGRect)frame withUrl:(NSURL *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        // 画像URLをセット
        [self setImageUrl:url];
        _isLoaded = NO;
    }
    return self;
}

- (void)startLoadImage {
    
    if (self.image) return;
    
    if (self.connection) {
        [self.connection cancel];
    }
    
    [self setData:[NSMutableData data]];
    
    LOG(@"imageUrl[%@]", self.imageUrl);
    
    NSURLRequest *req = [NSURLRequest requestWithURL:self.imageUrl];
    NSURLConnection *con = [NSURLConnection connectionWithRequest:req delegate:self];
    LOG (@"%@", con);
    [self setConnection:con];
    
    [self setLoadingImage];
}

- (void)reloadImage {
    [self setImage:nil];
    [self startLoadImage];
}

- (void)cancelLoading {
    [self.connection cancel];
    [self setConnection:nil];
    
    if (self.image == nil) {
        [self setLoadErrorImage];
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self setLoadErrorImage];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIActivityIndicatorView *iv = (UIActivityIndicatorView *)
    [self viewWithTag:LazyImageViewTagIndicatorView];
    if (iv) [iv removeFromSuperview];
    
//    if (_isLoaded == NO) {
        self.alpha = 0.3;
        [self setImage:[UIImage imageWithData:self.data]];
        [UIView animateWithDuration:0.5f
                         animations:^(void) {
                             self.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             _isLoaded = YES;
                         }];
//    }
}

#pragma mark -

- (void)setLoadingImage {
    UIActivityIndicatorView *iv = (UIActivityIndicatorView *)
    [self viewWithTag:LazyImageViewTagIndicatorView];
    if (iv == nil) {
        iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [iv setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [iv setTag:LazyImageViewTagIndicatorView];
//        [self addSubview:iv];
    }
//    [iv startAnimating];
    [iv setHidden:NO];
    
    self.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:0.5];
//    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3]];
    //[self setBackgroundColor:[UIColor whiteColor]];
}

- (void)setLoadErrorImage {
    UIActivityIndicatorView *iv = (UIActivityIndicatorView *)
    [self viewWithTag:LazyImageViewTagIndicatorView];
    [iv removeFromSuperview];
    
    [self setImage:nil];
    [self setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.4]];
//    [self setBackgroundColor:[UIColor redColor]];
}


@end
