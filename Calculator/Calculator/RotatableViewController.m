//
//  RotatableViewController.m
//  Calculator
//
//  Created by Heaven Chen on 9/18/12.
//
//

#import "RotatableViewController.h"

@interface RotatableViewController ()

@end

@implementation RotatableViewController

- (void)awakeFromNib {
  [super awakeFromNib];
  self.splitViewController.delegate = self;
}

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
  return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
