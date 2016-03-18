//
//  PlayerViewController.h
//  SeeJay Radio
//
//  Created by Tomas Vanek on 2/21/13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "comPlayer.h"

@interface PlayerViewController : UIViewController <comPlayerDelegate,ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *startStopButton;
@property (strong, nonatomic) IBOutlet UILabel *dlouhyNazev;
@property (strong, nonatomic) IBOutlet UILabel *coHralo;
@property (strong, nonatomic) IBOutlet UILabel *sleepTime;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ani;

//novinka
@property (strong, nonatomic) IBOutlet UILabel *titleNovinka;
@property (strong, nonatomic) IBOutlet UILabel *descriptionNovinka;
@property (strong, nonatomic) IBOutlet UIImageView *imageNovinka;


-(IBAction)stopButton:(id)sender;
-(IBAction)setSleepButton:(id)sender;

-(IBAction)novinkaClick:(id)sender;

@end
