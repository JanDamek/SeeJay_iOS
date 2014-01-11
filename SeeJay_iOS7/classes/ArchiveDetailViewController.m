//
//  ArchiveDetailViewController.m
//  SeeJay Radio
//
//  Created by Jan Damek on 02.06.13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

#import "ArchiveDetailViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ArchiveDetailViewController()

@property (nonatomic) BOOL autoPlay;

@end

@implementation ArchiveDetailViewController

@synthesize autoPlay = _autoPlay;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    nf.GroupingSize = 3;
    nf.GroupingSeparator=@" ";
    nf.decimalSeparator = @",";
    nf.NumberStyle = NSNumberFormatterDecimalStyle;
    
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
    
    // Set the modal transition style of your choice
    playerVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // Present the movie player view controller
//    [self presentModalViewController:playerVC animated:YES];
    [self presentMoviePlayerViewControllerAnimated:playerVC];
    
    // Start playback
    [playerVC.moviePlayer prepareToPlay];
    [playerVC.moviePlayer play];
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
//        [self dismissModalViewControllerAnimated:YES];
        [self dismissMoviePlayerViewControllerAnimated];
    }
    
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (self.autoPlay)
        [d.player play];
}

@end
