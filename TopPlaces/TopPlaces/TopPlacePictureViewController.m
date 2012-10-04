//
//  TopPlacePictureViewController.m
//  TopPlaces
//
//  Created by Heaven Chen on 10/4/12.
//  Copyright (c) 2012 Heaven Chen. All rights reserved.
//

#import "TopPlacePictureViewController.h"
#import "FlickrFetcher.h"
#import "PictureViewController.h"

@interface TopPlacePictureViewController ()

@end

@implementation TopPlacePictureViewController
@synthesize photos = _photos;
@synthesize place = _place;

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

  self.photos = [FlickrFetcher photosInPlace:self.place maxResults:50];
  NSLog(@"photos are %@", self.photos);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"picture";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  NSString *title = [[self.photos objectAtIndex:indexPath.row] valueForKey:FLICKR_PHOTO_TITLE];
  NSString *subTitle = [[self.photos objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
  NSLog(@"subtitle is %@", subTitle);
  if ([title length] != 0)
    cell.textLabel.text = title;
  else if ([subTitle length] != 0)
    cell.textLabel.text = subTitle;
  else 
    cell.textLabel.text = @"Unknown";
  cell.detailTextLabel.text = subTitle;
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //add to recent list
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *recents = [[defaults objectForKey:@"TopPlacesRecents"] mutableCopy];
  if (!recents) recents = [NSMutableArray arrayWithCapacity:20];
  NSDictionary *recent = [self.photos objectAtIndex:indexPath.row];
  // Check for duplicates
  int duplicate = -1;
  for (NSDictionary *photo in recents) {
    if ([photo objectForKey:FLICKR_PHOTO_ID] == [recent objectForKey:FLICKR_PHOTO_ID]) 
      duplicate = [recents indexOfObject:photo];
  }
  if (duplicate > 0) [recents removeObjectAtIndex:duplicate];
  [recents insertObject:recent atIndex:0];
  NSLog(@"add recents %@", recents);
  [defaults setObject:recents forKey:@"TopPlacesRecents"];
  [defaults synchronize];
  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
  [segue.destinationViewController setPhoto:[self.photos objectAtIndex:indexPath.row]];
  [segue.destinationViewController setTitle:[[sender textLabel] text]];
}

@end
