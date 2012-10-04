//
//  RecentViewController.m
//  TopPlaces
//
//  Created by Heaven Chen on 10/4/12.
//  Copyright (c) 2012 Heaven Chen. All rights reserved.
//

#import "RecentViewController.h"
#import "PictureViewController.h"
#import "FlickrFetcher.h"

@interface RecentViewController ()

@end

@implementation RecentViewController
//@synthesize recentPhotos=_recentPhotos;

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

}

- (void) viewWillAppear:(BOOL)animated
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *recents = [[defaults objectForKey:@"TopPlacesRecents"] mutableCopy];
  if (!recents) recents = [NSMutableArray arrayWithCapacity:20];
  self.photos = recents;
  NSLog(@"recent photos are %@", self.photos);
  [self.tableView reloadData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

@end
