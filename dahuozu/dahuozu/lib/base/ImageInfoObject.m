//
//  ImageInfoObject.m
//  dahuozu
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ImageInfoObject.h"

@implementation ImageInfoObject
-(instancetype)initWithImageFileURL:(NSURL*)fileURL
{
    self = [self init];
    if (self)
    {
        CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)fileURL, NULL);
        NSDictionary *imageProperty = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, nil);
        NSLog(@"图片拍摄地点：%@",[imageProperty valueForKey:(NSString*)kCGImagePropertyIPTCCountryPrimaryLocationName]);
        CFRelease(source);
    }
    return self;
}
@end
