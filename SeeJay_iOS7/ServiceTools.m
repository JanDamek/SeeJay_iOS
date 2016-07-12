//
//  ServiceTools.m
//  Mazlusek
//
//  Created by Jan Damek on 08.07.16.
//  Copyright © 2016 Jan Damek. All rights reserved.
//

@import GoogleMobileAds;

#import "ServiceTools.h"

@implementation ServiceTools

+(void) GADInitialization:(GADBannerView*)bannerView rootViewController:(UIViewController*)rootViewController{
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    bannerView.adUnitID = @"ca-app-pub-9508528448741167/7712279856";
    bannerView.rootViewController = rootViewController;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"d94f56a29a7713c484d0cd4ae758cadb", @"213a4715eaba991fe83e5f35db3e3bc6" ];
    [bannerView loadRequest:request];
}

@end
