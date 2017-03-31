//
//  ViewController.m
//  TwoCodeDemo
//
//  Created by Zilu.Ma on 16/9/7.
//  Copyright © 2016年 VSI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIImage *image = [self twoCode];
    NSLog(@"%@",NSStringFromCGSize(image.size));
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    imageView.frame = CGRectMake(0, 0, 300, 300);//image.size.width, image.size.height

    [self.view addSubview:imageView];
}

- (UIImage *)twoCode{

    //1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.恢复默认
    [filter setDefaults];
    //3.给过滤器添加数据
    NSString *dataString = @"sfjasfnsdnsdfnnfldf";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    //通过kvo设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    //5.获取输出二维码
    CIImage *outputImage = [filter outputImage];
    //6.将CIImage转换为UIIImage,并放大
//    UIImage *image = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(outputImage) scale:20.0 orientation:UIImageOrientationUp];

    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];

    return image;
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
