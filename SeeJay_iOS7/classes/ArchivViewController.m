//
//  ArchivViewController.m
//  SeeJay Radio
//
//  Created by Jan Damek on 22.05.13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

@import GoogleMobileAds;

#import "ArchivViewController.h"
#import "AppDelegate.h"
#import "ServiceTools.h"

@implementation ArchivViewController

@synthesize act;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GADBannerView *bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    [self.tableView setTableFooterView:bannerView];
    [ServiceTools GADInitialization:bannerView rootViewController:self];
    
    [self performSelectorInBackground:@selector(loadPodcast) withObject:nil];
}

-(void)loadPodcast{
    [act startAnimating];
    
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [d loadArchive];
    
    [self performSelectorInBackground:@selector(refreshTable) withObject:nil];
    
    [act stopAnimating];
}

-(void)refreshTable{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    return [d.archive count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    return [[d.archive objectAtIndex:section] valueForKey:@"title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSDictionary *i = [d.archive objectAtIndex:section];
    return [[i valueForKey:@"items" ] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,30)];
    [customView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    
    // create image object
    UIImage *myImage = [UIImage imageNamed:@"headline_640x30_px_retina.png"];
    
    // create the label objects
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.frame = CGRectMake(5,2,self.view.frame.size.width-5,25);
//
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSDictionary *sec =[d.archive objectAtIndex:section];
    NSString *title = [[sec valueForKey:@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    headerLabel.text = title;
//    headerLabel.text =  [[d.archive objectAtIndex:section] valueForKey:@"title"];
    headerLabel.textColor = [UIColor grayColor];
    
    // create the imageView with the image in it
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(0,0,self.view.frame.size.width,30);
    [imageView setContentMode:UIViewContentModeScaleToFill];
    
    [customView addSubview:imageView];
    [customView addSubview:headerLabel];
    
    return customView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellarchive";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSDictionary *a = [d.archive objectAtIndex:indexPath.section];
    a = [[a objectForKey:@"items"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [a valueForKey:@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Počet epizod: %ld",(long)[[a objectForKey:@"items"] count]];
    
    return cell;
}

#pragma mark - Table view delegate

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
     d.selected_archive = indexPath;
 }

@end
