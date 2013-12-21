#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:(__bridge NSURL *)url options:nil];
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    CGSize size = track.naturalSize;
    
    NSDictionary *properties = @{
        (__bridge NSString *)kQLPreviewPropertyHeightKey: @(round(size.height / 2.0)),
        (__bridge NSString *)kQLPreviewPropertyWidthKey: @(round(size.width / 2.0)),
        (__bridge NSString *)kQLPreviewPropertyDisplayNameKey: @"Test"
    };
    
    NSLog(@"***** Sending to URLRep");
    NSLog(@"URLRep original size: %@", NSStringFromSize(NSSizeFromCGSize(size)));
    NSLog(@"URLRep with props: %@", properties);
    
//    CFStringRef keys[] = {kQLPreviewPropertyDisplayNameKey};
//    CFStringRef vals[] = {CFSTR("Test")};
//    CFDictionaryRef properties = CFDictionaryCreate(kCFAllocatorDefault, (const void**)keys, (const void**)vals, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    QLPreviewRequestSetURLRepresentation(preview, url, contentTypeUTI, (__bridge CFDictionaryRef)properties);
    
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
