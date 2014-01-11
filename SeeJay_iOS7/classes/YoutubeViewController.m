//
//  YoutubeViewController.m
//  SeeJay Radio
//
//  Created by Tomas Vanek on 2/21/13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

#import "YoutubeViewController.h"

@implementation YoutubeViewController

@synthesize youtube = _youtube;
@synthesize progres = _progres;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.youtube setDelegate:self];
	[self.youtube loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.youtube.com/seejayradio"]]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.progres setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)btnZpet:(id)sender{
    [self.youtube goBack];
}

-(IBAction)btnDopredu:(id)sender{
    [self.youtube goForward];
}

-(IBAction)btnStop:(id)sender{
    [self.youtube stopLoading];
}

-(IBAction)btnReload:(id)sender{
    [self.youtube reload];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progres setHidden:NO];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.progres setHidden:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progres setHidden:YES];
}

@end
