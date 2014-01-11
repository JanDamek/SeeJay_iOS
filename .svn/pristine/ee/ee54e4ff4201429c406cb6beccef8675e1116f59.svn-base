//
//  ContactViewController.m
//  SeeJay Radio
//
//  Created by Tomas Vanek on 3/25/13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@property (nonatomic) BOOL volej;

@end

@implementation ContactViewController

@synthesize tabbar = _tabbar;
@synthesize volej = _volej;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)zavolej:(id)sender
{
    self.volej = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Volat studio"
                                                   message: @"Opravdu vytočit 224 225 225 ?"
                                                  delegate: self
                                         cancelButtonTitle:@"Ne"
                                         otherButtonTitles:@"Ano",nil];
    
    
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //        NSLog(@"user pressed Button Indexed 0");
        // Any action can be performed here
    }
    else
    {
        if (self.volej){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+420224225225"]];
        } else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:+420777733733"]];
        }
    }
}



-(IBAction)SMS:(id)sender
{
    self.volej = NO;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"SMS do studia"
                                                   message: @"Opravdu zaslat SMS do studia 777 733 733 ?"
                                                  delegate: self
                                         cancelButtonTitle:@"Ne"
                                         otherButtonTitles:@"Ano",nil];
    [alert show];
}


-(IBAction)email:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:studio@seejay.cz"]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
