//
//  ArchivViewController.m
//  SeeJay Radio
//
//  Created by Jan Damek on 22.05.13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

#import "ArchivViewController.h"
#import "AppDelegate.h"

@implementation ArchivViewController

@synthesize act;

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
    
    //    NSLog(@"%@",podcast);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
//    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    detailLabel.backgroundColor = [UIColor clearColor];
//    detailLabel.textColor = [UIColor darkGrayColor];
//    detailLabel.text = @"Some detail text";
//    detailLabel.font = [UIFont systemFontOfSize:12];
//    detailLabel.frame = CGRectMake(70,33,230,25);
    
    // create the imageView with the image in it
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(0,0,self.view.frame.size.width,30);
    [imageView setContentMode:UIViewContentModeScaleToFill];
    
    [customView addSubview:imageView];
    [customView addSubview:headerLabel];
//    [customView addSubview:detailLabel];
    
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
//    cell.detailTextLabel.text = [a valueForKey:@"description"];
//    if ([cell.detailTextLabel.text isEqual:@""])
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Počet epizod: %ld",(long)[[a objectForKey:@"items"] count]];
    
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
     d.selected_archive = indexPath;
 }

@end
