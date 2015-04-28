//
//  main.m
//  icontool
//
//  Created by HanShaokun on 17/4/15.
//  Copyright (c) 2015 HanShaokun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#define ALL_IOS_SIZE @[@(29),@(40),@(50),@(57),@(58),@(72),@(76),@(80),@(100),@(108),@(114),@(120),@(124),@(144),@(152)]

#define ALL_ANDROID_FOLDER @[@"drawable-hdpi", @"drawable-ldpi", @"drawable-mdpi", @"drawable-xhdpi"]
#define ALL_ANDROID_SIZE   @[@(72),            @(32),            @(48),            @(256)]

BOOL CGImageWriteToFile(CGImageRef image, NSString *path) {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    if (!destination) {
        NSLog(@"Failed to create CGImageDestination for %@", path);
        return NO;
    }
    
    CGImageDestinationAddImage(destination, image, nil);
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
        CFRelease(destination);
        return NO;
    }
    
    CFRelease(destination);
    return YES;
}

void saveIOSImg(CGImageRef imageRef, int size, NSString* prefix, NSString* folderPath)
{
    printf("saveIOSImg: %d \n", size);
    //get src size
    size_t w = 0, h = 0;
    w = CGImageGetWidth(imageRef);
    h = CGImageGetHeight(imageRef);
    
    NSSize desSize = NSMakeSize(size, size);
    
    NSString *desPath = [[[folderPath stringByAppendingPathComponent:prefix] stringByAppendingFormat:@"-%d", (int)desSize.width] stringByAppendingPathExtension:@"png"];
    [[NSFileManager defaultManager] removeItemAtPath:desPath error:nil];
    
    //create des bit map
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(NULL,
                                                     desSize.width,
                                                     desSize.height,
                                                     8,
                                                     desSize.width * 8,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    if( destContext == NULL ) {
        printf("failed to create the output bitmap context! %s \n", NSStringFromSize(desSize).UTF8String);
    }
    
    CGRect destTile = CGRectMake(0.f, 0.f, desSize.width, desSize.height);
    CGContextDrawImage(destContext, destTile, imageRef);
    
    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    CGImageWriteToFile(destImage, desPath);
    CGImageRelease(destImage);
}

void saveAndroidImg(CGImageRef imageRef, int size, NSString* name, NSString* folderPath)
{
    printf("saveAndroidImg: %d \n", size);
    //get src size
    size_t w = 0, h = 0;
    w = CGImageGetWidth(imageRef);
    h = CGImageGetHeight(imageRef);
    
    NSSize desSize = NSMakeSize(size, size);
    
    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                              withIntermediateDirectories:YES
                                               attributes:nil error:nil];
    NSString *desPath = [folderPath stringByAppendingPathComponent:name];
    [[NSFileManager defaultManager] removeItemAtPath:desPath error:nil];
    
    //create des bit map
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(NULL,
                                                     desSize.width,
                                                     desSize.height,
                                                     8,
                                                     desSize.width * 8,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    if( destContext == NULL ) {
        printf("failed to create the output bitmap context! %s \n", NSStringFromSize(desSize).UTF8String);
    }
    
    CGRect destTile = CGRectMake(0.f, 0.f, desSize.width, desSize.height);
    CGContextDrawImage(destContext, destTile, imageRef);
    
    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    CGImageWriteToFile(destImage, desPath);
    CGImageRelease(destImage);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        if (argc == 2) {
//            NSString *appPath = [NSString stringWithUTF8String:argv[0]];
            NSString *filePath = [NSString stringWithUTF8String:argv[1]];
            
            printf("filePath: %s\n", filePath.UTF8String);
            
            NSFileManager *mgr = [NSFileManager defaultManager];
            
            CGImageRef srcImgRef = NULL;
            if ([mgr fileExistsAtPath:filePath]) {
                //get cgimage
                NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
                CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
                
                srcImgRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
            }
            
            if (!srcImgRef) {
                printf("image file is not supported: %s", filePath.UTF8String);
                exit(-1);
            }
            
            NSString *folderPath = [filePath stringByDeletingPathExtension];
            
            [mgr removeItemAtPath:folderPath error:nil];
            
            [mgr createDirectoryAtPath:[filePath stringByDeletingPathExtension]
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
            
            
            for (NSNumber *n in ALL_IOS_SIZE) {
                int s = n.intValue;
                saveIOSImg(srcImgRef,
                           s,
                           @"Icon",
                           folderPath);
            }
            
            for (int i = 0; i < ALL_ANDROID_FOLDER.count; i++) {
                saveAndroidImg(srcImgRef,
                               [ALL_ANDROID_SIZE[i] intValue],
                               @"icon.png",
                               [folderPath stringByAppendingPathComponent:ALL_ANDROID_FOLDER[i]]);
            }
            
            CGImageRelease(srcImgRef);
        }
        else {
            printf("\n**************************************\n");
            printf("Please use \"icontool file-path\" to generate icons.");
            printf("\n**************************************\n");
        }
    }
    return 0;
}
