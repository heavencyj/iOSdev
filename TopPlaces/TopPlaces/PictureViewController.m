//
//  PictureViewController.m
//  TopPlaces
//
//  Created by Heaven Chen on 10/4/12.
//  Copyright (c) 2012 Heaven Chen. All rights reserved.
//

#import "PictureViewController.h"
#import "FlickrFetcher.h"

@interface PictureViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PictureViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photo =_photo;

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.scrollView.delegate = self;
  NSData * imageData = [[NSData alloc] initWithContentsOfURL: [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge]];
  self.imageView.image = [UIImage imageWithData:imageData];
  self.scrollView.contentSize = self.imageView.image.size;
  self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (void)viewDidUnload
{
  [self setScrollView:nil];
  [self setImageView:nil];
  [super viewDidUnload];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
