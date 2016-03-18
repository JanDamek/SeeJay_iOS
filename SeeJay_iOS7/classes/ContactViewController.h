//
//  ContactViewController.h
//  SeeJay Radio
//
//  Created by Tomas Vanek on 3/25/13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ContactViewController : UIViewController<ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UITabBarItem *tabbar;

-(IBAction)zavolej:(id)sender;
-(IBAction)SMS:(id)sender;
-(IBAction)email:(id)sender;

@end
