//
//  main.m
//  icontool
//
//  Created by HanShaokun on 17/4/15.
//  Copyright (c) 2015 HanShaokun. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#define IMAGE_ASSETS @"Images.xcassets"
#define ICON_ASSETS @"AppIcon.appiconset"
#define LAUNCH_ASSETS @"Brand Assets.launchimage"
#define JSON_NAME @"Contents.json"

#define ICON_JSON @"{\n\
    \"images\" : [\n\
        {\n\
            \"idiom\" : \"iphone\",\n\
            \"size\" : \"20x20\",\n\
            \"filename\" : \"Icon-40.png\",\n\
            \"scale\" : \"2x\"\n\
        },\n\
        {\n\
            \"idiom\" : \"iphone\",\n\
            \"size\" : \"20x20\",\n\
            \"filename\" : \"Icon-60.png\",\n\
            \"scale\" : \"3x\"\n\
        },\n\
        {\n\
            \"size\" : \"29x29\",\n\
            \"idiom\" : \"iphone\",\n\
            \"filename\" : \"Icon-58.png\",\n\
            \"scale\" : \"2x\"\n\
        },\n\
        {\n\
            \"size\" : \"29x29\",\n\
            \"idiom\" : \"iphone\",\n\
            \"filename\" : \"Icon-87.png\",\n\
            \"scale\" : \"3x\"\n\
        },\n\
        {\n\
            \"size\" : \"40x40\",\n\
            \"idiom\" : \"iphone\",\n\
            \"filename\" : \"Icon-80.png\",\n\
            \"scale\" : \"2x\"\n\
        },\n\
        {\n\
            \"size\" : \"40x40\",\n\
            \"idiom\" : \"iphone\",\n\
            \"filename\" : \"Icon-120.png\",\n\
            \"scale\" : \"3x\"\n\
        },\n\
        {\n\
            \"size\" : \"60x60\",\n\
            \"idiom\" : \"iphone\",\n\
            \"filename\" : \"Icon-120.png\",\n\
            \"scale\" : \"2x\"\n\
        },\n\
        {\n\
            \"size\" : \"60x60\",\n\
            \"idiom\" : \"iphone\",\n\
            \"filename\" : \"Icon-180.png\",\n\
            \"scale\" : \"3x\"\n\
        },\n\
        {\n\
            \"idiom\" : \"ipad\",\n\
            \"size\" : \"20x20\",\n\
            \"filename\" : \"Icon-20.png\",\n\
            \"scale\" : \"1x\"\n\
        },\n\
        {\n\
            \"idiom\" : \"ipad\",\n\
            \"size\" : \"20x20\",\n\
            \"filename\" : \"Icon-40.png\",\n\
            \"scale\" : \"2x\"\n\
        },\n\
        {\n\
            \"size\" : \"29x29\",\n\
            \"idiom\" : \"ipad\",\n\
            \"filename\" : \"Icon-29.png\",\n\
            \"scale\" : \"1x\"\n\
        },\n\
        {\n\
            \"size\" : \"29x29\",\n\
            \"idiom\" : \"ipad\",\n\
            \"filename\" : \"Icon-58.png\",\n\
            \"scale\" : \"2x\"\n\
        },\n\
        {\n\
            \"size\" : \"40x40\",\n\
            \"idiom\" : \"ipad\",\n\
            \"filename\" : \"Icon-40.png\",\n\
            \"scale\" : \"1x\"\n\
        },\n\
        {\n\
            \"size\" : \"40x40\",\n\
            \"idiom\" : \"ipad\",\n\
            \"filename\" : \"Icon-80.png\",\n\
            \"scale\" : \"2x\"\n\
        },\n\
        {\n\
            \"size\" : \"76x76\",\n\
            \"idiom\" : \"ipad\",\n\
            \"filename\" : \"Icon-76.png\",\n\
            \"scale\" : \"1x\"\n\
        },\n\
        {\n\
            \"size\" : \"76x76\",\n\
            \"idiom\" : \"ipad\",\n\
            \"filename\" : \"Icon-152.png\",\n\
            \"scale\" : \"2x\"\n\
        },\n\
        {\n\
            \"size\" : \"83.5x83.5\",\n\
            \"idiom\" : \"ipad\",\n\
            \"filename\" : \"Icon-167.png\",\n\
            \"scale\" : \"2x\"\n\
        },\n\
        {\n\
            \"size\" : \"1024x1024\",\n\
            \"idiom\" : \"ios-marketing\",\n\
            \"filename\" : \"Icon-1024.png\",\n\
            \"scale\" : \"1x\"\n\
        }\n\
    ],\n\
    \"info\" : {\n\
        \"version\" : 1,\n\
        \"author\" : \"xcode\"\n\
    }\n\
}"

#define ALL_ANDROID_FOLDER                                                 \
    @[                                                                     \
        @"mipmap-hdpi", @"mipmap-mdpi", @"mipmap-xhdpi", @"mipmap-xxhdpi", \
        @"mipmap-xxxhdpi"                                                  \
    ]
#define ALL_ANDROID_SIZE @[ @(72), @(48), @(96), @(144), @(512) ]

BOOL CGImageWriteToFile(CGImageRef image, NSString *path) {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination =
        CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
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

void saveIOSImg(CGImageRef imageRef, CGImageRef subscriptImgRef, int size,
                NSString *name, NSString *folderPath) {
    printf("saveIOSImg: %d %s\n", size,
           [folderPath stringByAppendingPathComponent:name].UTF8String);
    // get src size
    size_t w = 0, h = 0;
    w = CGImageGetWidth(imageRef);
    h = CGImageGetHeight(imageRef);

    NSSize desSize = NSMakeSize(size, size);

    NSString *desPath = [folderPath stringByAppendingPathComponent:name];
    [[NSFileManager defaultManager] removeItemAtPath:desPath error:nil];

    // create des bit map
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(
        NULL, desSize.width, desSize.height, 8, desSize.width * 8, colorSpace,
        kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);

    CGColorSpaceRelease(colorSpace);

    if (destContext == NULL) {
        printf("failed to create the output bitmap context! %s \n",
               NSStringFromSize(desSize).UTF8String);
    }

    CGRect destTile = CGRectMake(0.f, 0.f, desSize.width, desSize.height);
    CGContextDrawImage(destContext, destTile, imageRef);
    if (subscriptImgRef) {
        CGContextDrawImage(destContext, destTile, subscriptImgRef);
    }

    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    CGImageWriteToFile(destImage, desPath);
    CGImageRelease(destImage);
}

void saveAndroidImg(CGImageRef imageRef, CGImageRef subscriptImgRef, int size,
                    NSString *name, NSString *folderPath) {
    printf("saveAndroidImg: %d %s\n", size,
           [folderPath stringByAppendingPathComponent:name].UTF8String);
    // get src size
    size_t w = 0, h = 0;
    w = CGImageGetWidth(imageRef);
    h = CGImageGetHeight(imageRef);

    NSSize desSize = NSMakeSize(size, size);

    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    NSString *desPath = [folderPath stringByAppendingPathComponent:name];
    [[NSFileManager defaultManager] removeItemAtPath:desPath error:nil];

    // create des bit map
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(
        NULL, desSize.width, desSize.height, 8, desSize.width * 8, colorSpace,
        kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);

    CGColorSpaceRelease(colorSpace);

    if (destContext == NULL) {
        printf("failed to create the output bitmap context! %s \n",
               NSStringFromSize(desSize).UTF8String);
    }

    CGRect destTile = CGRectMake(0.f, 0.f, desSize.width, desSize.height);
    CGContextDrawImage(destContext, destTile, imageRef);
    if (subscriptImgRef) {
        CGContextDrawImage(destContext, destTile, subscriptImgRef);
    }

    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    CGImageWriteToFile(destImage, desPath);
    CGImageRelease(destImage);
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        // insert code here...
        if (2 <= argc) {
            NSString *filePath = [NSString stringWithUTF8String:argv[1]];
            NSString *subscriptPath = @"";
            if (2 < argc) {
                subscriptPath = [NSString stringWithUTF8String:argv[2]];
            }

            printf("get iconFilePath: %s\n", filePath.UTF8String);
            printf("get subscriptPath: %s\n", subscriptPath.UTF8String);

            NSFileManager *mgr = [NSFileManager defaultManager];

            CGImageRef srcImgRef = NULL;
            CGImageRef subscriptImgRef = NULL;
            if ([mgr fileExistsAtPath:filePath]) {
                // get cgimage
                NSData *imageData =
                    [[NSData alloc] initWithContentsOfFile:filePath];
                CGImageSourceRef imageSource = CGImageSourceCreateWithData(
                    (__bridge CFDataRef)imageData, NULL);

                srcImgRef =
                    CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);

                if ([mgr fileExistsAtPath:subscriptPath]) {
                    // get cgimage
                    NSData *imageData =
                        [[NSData alloc] initWithContentsOfFile:subscriptPath];
                    CGImageSourceRef imageSource = CGImageSourceCreateWithData(
                        (__bridge CFDataRef)imageData, NULL);

                    subscriptImgRef =
                        CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
                }
            }

            if (!srcImgRef) {
                printf("image file is not supported: %s", filePath.UTF8String);
                exit(-1);
            }

            printf("\n");
            printf("working on iOS icons ...\n");

            NSString *folderPath = [filePath stringByDeletingPathExtension];

            [mgr removeItemAtPath:folderPath error:nil];

            [mgr createDirectoryAtPath:folderPath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];

            [mgr createDirectoryAtPath:
                     [folderPath stringByAppendingPathComponent:IMAGE_ASSETS]
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];

            [mgr createDirectoryAtPath:
                     [[folderPath stringByAppendingPathComponent:IMAGE_ASSETS]
                         stringByAppendingPathComponent:ICON_ASSETS]
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];

            [mgr createDirectoryAtPath:
                     [[folderPath stringByAppendingPathComponent:IMAGE_ASSETS]
                         stringByAppendingPathComponent:LAUNCH_ASSETS]
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];

            [[ICON_JSON dataUsingEncoding:NSUTF8StringEncoding]
                writeToFile:[[[folderPath
                                stringByAppendingPathComponent:IMAGE_ASSETS]
                                stringByAppendingPathComponent:ICON_ASSETS]
                                stringByAppendingPathComponent:JSON_NAME]
                 atomically:YES];

            NSError *err = nil;
            id obj = [NSJSONSerialization
                JSONObjectWithData:[ICON_JSON
                                       dataUsingEncoding:NSUTF8StringEncoding]
                           options:NSJSONReadingMutableLeaves
                             error:&err];
            //            NSLog(@"%@ %@", err, obj);

            NSArray *images = obj[@"images"];

            for (NSDictionary *obj in images) {
                NSString *size = obj[@"size"];
                NSString *scale = obj[@"scale"];
                NSString *left = [size componentsSeparatedByString:@"x"][0];
                NSString *right =
                    [scale stringByTrimmingCharactersInSet:
                               [NSCharacterSet
                                   characterSetWithCharactersInString:@"x"]];

                float s = 0;
                float l = left.floatValue;
                float r = right.length ? right.floatValue : 1;
                s = l * r;

                saveIOSImg(
                    srcImgRef, subscriptImgRef, (int)floorf(s),
                    obj[@"filename"],
                    [[folderPath stringByAppendingPathComponent:IMAGE_ASSETS]
                        stringByAppendingPathComponent:ICON_ASSETS]);
            }

            printf("\n");
            printf("working on Android icons ...\n");
            for (int i = 0; i < ALL_ANDROID_FOLDER.count; i++) {
                saveAndroidImg(
                    srcImgRef, subscriptImgRef, [ALL_ANDROID_SIZE[i] intValue],
                    @"ic_launcher.png",
                    [folderPath
                        stringByAppendingPathComponent:ALL_ANDROID_FOLDER[i]]);
            }

            CGImageRelease(srcImgRef);
        } else {
            printf("**************************************\n");
            printf("use: \"icontool [icon-file-path]\" to generate icons.\n");
            printf(
                "use: \"icontool [icon-file-path] [subscript-file-path]\" to "
                "generate icons with subscripts.\n");
            printf("**************************************\n");
        }
    }
    return 0;
}
