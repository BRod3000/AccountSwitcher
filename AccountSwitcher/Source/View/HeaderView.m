//
//  HeaderView.m
//  AccountSwitcher
//
//  Created by Jonah Grant on 2/14/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

@import QuartzCore;
@import Accelerate;

#import "HeaderView.h"

@interface HeaderView ()

@property (strong, nonatomic) UIImageView *imageView, *profileImageView;
@property (strong, nonatomic) UIImage *baseImage;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *blurredImages;
@property (nonatomic, readwrite) BOOL shouldSwitch;
@property (strong, nonatomic) UIView *dimmerView;

@end

@implementation HeaderView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView profileImage:(UIImage *)profileImage {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 150)]) {
        _baseImage = [UIImage imageNamed:@"bg"];
        
        _shouldSwitch = NO;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _imageView.image = _baseImage;
        [self addSubview:_imageView];
        
        _dimmerView = [[UIView alloc] initWithFrame:_imageView.frame];
        _dimmerView.backgroundColor = [UIColor blackColor];
        _dimmerView.alpha = 0;
        [self addSubview:_dimmerView];

        _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        _profileImageView.image = profileImage;
        _profileImageView.center = _imageView.center;
        _profileImageView.layer.masksToBounds = YES;
        _profileImageView.layer.cornerRadius = 5.0f;
        _profileImageView.layer.borderWidth = 5.0f;
        _profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_profileImageView];
        
        _blurredImages = [[NSMutableArray alloc] initWithCapacity:25];
        
        [self blurAndCachImage];
        
        _scrollView = scrollView;
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)blurAndCachImage {
    CGFloat radius = 0.1;
    for (int i = 0; i < 20; i++) {
        [_blurredImages addObject:[self blurredImageForImage:_baseImage withRadius:radius]];
        radius += 0.04;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateImageFrame];
}

- (void)updateImageFrame {
    // this will control the "switch" action
   /* if (-180 >= _scrollView.contentOffset.y && !_shouldSwitch) {
        _shouldSwitch = YES;
    } else if (-180 <= _scrollView.contentOffset.y && _shouldSwitch) {
        _shouldSwitch = NO;
    }*/
    
    if (!_shouldSwitch) {
        CGFloat offset = - _scrollView.contentOffset.y - 64;
        
        if (0 > -offset) {
            CGRect newFrame = CGRectMake(-offset, -offset, 320 + offset * 2, CGRectGetHeight(self.frame) + offset);
            
            _imageView.frame = newFrame;
            
            _profileImageView.center = _imageView.center;
            
            _dimmerView.frame = newFrame;
            _dimmerView.alpha = offset / 300.0;

            NSInteger index = offset / 10;
            
            if (index < 0) {
                index = 0;
            } else if (index >= _blurredImages.count) {
                index = _blurredImages.count - 1;
            }
            
            UIImage *image = _blurredImages[index];
            
            if (_baseImage != image) {
                [_imageView setImage:image];
            }
            
        } else if (_shouldSwitch) {
            [_imageView setImage:_blurredImages.lastObject];
        }
    }
}

- (UIImage *)blurredImageForImage:(UIImage *)image withRadius:(CGFloat)blurRadius {
    UIImage *destImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1)];
    
    if (blurRadius < 0.f || blurRadius > 1.f) {
        blurRadius = 0.5f;
    }
    
    int boxSize = (int)(blurRadius * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
   
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
