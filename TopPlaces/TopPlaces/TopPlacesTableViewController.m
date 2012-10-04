//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by Heaven Chen on 10/2/12.
//  Copyright (c) 2012 Heaven Chen. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPlacePictureViewController.h"

@interface TopPlacesTableViewController ()
@property NSArray *topPlaces;
@end

@implementation TopPlacesTableViewController
@synthesize topPlaces = _topPlaces;

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
  self.topPlaces = [FlickrFetcher topPlaces];
  NSLog(@"content of array is %@", self.topPlaces);
  NSSortDescriptor *placeDescriptor =
  [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME
                              ascending:YES
                               selector:@selector(localizedCaseInsensitiveCompare:)];
  NSArray *descriptors = [NSArray arrayWithObjects:placeDescriptor, nil];
  self.topPlaces = [self.topPlaces sortedArrayUsingDescriptors:descriptors];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return self.topPlaces.count;
  //return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"topPlaces";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  NSString *title = [[self.topPlaces objectAtIndex:indexPath.row] valueForKey:FLICKR_PLACE_NAME];
  NSArray *location = [title componentsSeparatedByString:@", "];
  cell.textLabel.text = [location objectAtIndex:0];
  if (location.count == 3) {
    cell.detailTextLabel.text = [[[location objectAtIndex:1] stringByAppendingString:@", "]
                                 stringByAppendingString:[location objectAtIndex:2]];
  }
  else {
    cell.detailTextLabel.text = [location objectAtIndex:1];
  }
    
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
//     TopPlacePictureViewController *pictureViewController = [[TopPlacePictureViewController alloc] initWithNibName:@"" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:pictureViewController animated:YES];
     
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
  [segue.destinationViewController setPlace:[self.topPlaces objectAtIndex:indexPath.row]];
  [segue.destinationViewController setTitle:[[sender textLabel] text]];
}
@end
