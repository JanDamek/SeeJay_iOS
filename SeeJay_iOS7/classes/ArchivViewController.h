//
//  ArchivViewController.h
//  SeeJay Radio
//
//  Created by Jan Damek on 22.05.13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "XMLReader.h"

@interface ArchivViewController : UITableViewController<ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;

@end
