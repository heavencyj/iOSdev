//
//  CaculatorViewController.m
//  Caculator
//
//  Created by Heaven Chen on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CaculatorViewController.h"
#import "CaculatorBrain.h"
#import "GraphView.h"
#import "GraphViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface CaculatorViewController() <GraphViewDataSource>
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL hasDot;
@property (nonatomic, strong) CaculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariables;
-(void) updateDisplay;
@end

@implementation CaculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = 
_userIsInTheMiddleOfEnteringANumber;
@synthesize hasDot = _hasDot;
@synthesize brain = _brain;
@synthesize testVariables = _testVariables;

-(CaculatorBrain *)brain 
{
  if (!_brain) _brain = [[CaculatorBrain alloc] init];
  return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
  NSString *digit = sender.currentTitle;
  if (self.userIsInTheMiddleOfEnteringANumber) {
    if ([self.display.text isEqualToString:@"0"]) 
      self.display.text = digit;
    else
      self.display.text = [self.display.text 
                         stringByAppendingString:digit];
  } else {
    self.userIsInTheMiddleOfEnteringANumber = YES;
    self.display.text = digit;
  }
}

- (IBAction)clearPressed:(UIButton *)sender {
  self.history.text = @"";
  self.display.text = @"0";
  self.userIsInTheMiddleOfEnteringANumber = NO;
  self.hasDot = NO;
  [self.brain clear];
  
}

- (IBAction)enterPressed 
{  
  if (self.userIsInTheMiddleOfEnteringANumber)
    [self.brain pushToProgram:[NSNumber numberWithDouble:[self.display.text doubleValue]]];
  // Show all the input in history label
  else [self.brain pushToProgram:@"enter"];
  self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
  // Clear out the flags
  self.userIsInTheMiddleOfEnteringANumber = NO;
  self.hasDot = NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
  if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
  [self.brain pushToProgram:sender.currentTitle];
  [self updateDisplay];
}

- (IBAction)dotPressed:(UIButton *)sender {
  if (!self.userIsInTheMiddleOfEnteringANumber) {
    self.display.text = sender.currentTitle;
    self.userIsInTheMiddleOfEnteringANumber = YES;
  }
  else if (!self.hasDot) {
    // Should not have more than one "." in an operand
    self.display.text = [self.display.text 
                         stringByAppendingString:sender.currentTitle];
  }
  self.hasDot = YES;
}

- (IBAction)undoPressed:(UIButton *)sender {
  if (self.userIsInTheMiddleOfEnteringANumber) {
    if ([self.display.text length] > 1)
      self.display.text = [self.display.text 
                           substringToIndex:[self.display.text length]-1];
    
    else {
      // If it's the last digit, display 0 instead of nothing
      [self updateDisplay];
      self.userIsInTheMiddleOfEnteringANumber = NO;
    }
  }
  else {
    [self.brain popFromProgram];
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
  }
}


- (IBAction)variablePressed:(UIButton *)sender {
  if (self.userIsInTheMiddleOfEnteringANumber) {
    [self.brain pushToProgram:self.display.text];
  }
  self.display.text = [self.testVariables valueForKey:[sender currentTitle]];
  [self.brain pushToProgram:[sender currentTitle]];
  [self updateDisplay];
  self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (GraphViewController *)splitViewGraphViewController {
  id gvc = [self.splitViewController.viewControllers lastObject];
  if (![gvc isKindOfClass:[GraphViewController class]]) {
    gvc = nil;
  }
  return gvc;
}

- (IBAction)graphPressed {
  
  GraphViewController *gvc = [self splitViewGraphViewController];
  if (gvc) {
    [gvc setGraphViewDataSource:self];
    self.title = [@"y = " stringByAppendingString:self.history.text];
    [gvc drawGraph];
  }
  else {
    [self performSegueWithIdentifier:@"graph" sender:self];
  }
  
  
}

-(void)updateDisplay
{
  id result = [CaculatorBrain runProgram:self.brain.program usingVariableVaules:self.testVariables];
  self.history.text = [CaculatorBrain descriptionOfProgram:self.brain.program];
  NSString *resultString = nil;
  if ([result isKindOfClass:[NSNumber class]])
    resultString = [NSString stringWithFormat:@"%g",[result doubleValue]];
  else if ([result isKindOfClass:[NSString class]])
    resultString = result;
  self.display.text = resultString;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"graph"]) {
    [segue.destinationViewController setGraphViewDataSource:self];
    [segue.destinationViewController setTitle:[@"y = " stringByAppendingString:self.history.text]];
  }
}

-(CGFloat)valueForExpressionAtX:(CGFloat)x {
  return [[CaculatorBrain runProgram:self.brain.program usingVariableVaules:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:x] forKey:@"x"]] doubleValue];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.splitViewController.delegate = self;
}

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
  return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
  barButtonItem.title = self.title;
  [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
  
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter {
  id detailVC = [self.splitViewController.viewControllers lastObject];
  if ([detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]){
      detailVC = nil;
  }
  return detailVC;
}

@end
