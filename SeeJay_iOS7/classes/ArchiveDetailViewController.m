//
//  ArchiveDetailViewController.m
//  SeeJay Radio
//
//  Created by Jan Damek on 02.06.13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

@import GoogleMobileAds;

#import "ArchiveDetailViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ServiceTools.h"

@interface ArchiveDetailViewController()

@property (nonatomic) BOOL autoPlay;

@end

@implementation ArchiveDetailViewController

@synthesize autoPlay = _autoPlay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GADBannerView *bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    [self.tableView setTableFooterView:bannerView];
    [ServiceTools GADInitialization:bannerView rootViewController:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    return [[[[[d.archive objectAtIndex:d.selected_archive.section] valueForKey:@"items"] objectAtIndex:d.selected_archive.row] valueForKey:@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"poradcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSDictionary *a = [[[[[d.archive objectAtIndex:d.selected_archive.section] valueForKey:@"items"] objectAtIndex:d.selected_archive.row] valueForKey:@"items"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [a valueForKey:@"title"];
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    // set to long number of decimals to accommodate whatever a user might enter
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:2];
    nf.groupingSize = 3;
    nf.groupingSeparator=@" ";
    nf.decimalSeparator = @",";
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    
    double f=[[a valueForKey:@"size"] floatValue]/1024;
    NSString *si = @"kB";
    if (f>10000) {
        f = f / 1024;
        si = @"MB";
    }
    
    NSString *s = [nf stringFromNumber:
                   [NSNumber numberWithDouble:f]
                   ];
    
    cell.detailTextLabel.text =[NSString stringWithFormat:@"Velikost: %@ %@", s, si];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.autoPlay = d.player.isPlaying;
    [d.player stop];
    
    NSDictionary *a = [[[[[d.archive objectAtIndex:d.selected_archive.section] valueForKey:@"items"] objectAtIndex:d.selected_archive.row] valueForKey:@"items"] objectAtIndex:indexPath.row];
    
    // Initialize the movie player view controller with a video URL string
    MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[a valueForKey:@"link"]]];
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:playerVC
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:playerVC.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerVC.moviePlayer];
    
    playerVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentMoviePlayerViewControllerAnimated:playerVC];
    
    // Start playback
    [playerVC.moviePlayer prepareToPlay];
    [playerVC.moviePlayer play];
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        [self dismissMoviePlayerViewControllerAnimated];
    }
    
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (self.autoPlay)
        [d.player play];
}

@end
