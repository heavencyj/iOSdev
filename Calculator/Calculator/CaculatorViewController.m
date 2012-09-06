//
//  CaculatorViewController.m
//  Caculator
//
//  Created by Heaven Chen on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CaculatorViewController.h"
#import "CaculatorBrain.h"

@interface CaculatorViewController() 
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL hasDot;
@property (nonatomic) BOOL isVariable;
@property (nonatomic, strong) CaculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariables;
@end

@implementation CaculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize variables = _variables;
@synthesize userIsInTheMiddleOfEnteringANumber = 
_userIsInTheMiddleOfEnteringANumber;
@synthesize hasDot = _hasDot;
@synthesize brain = _brain;
@synthesize testVariables = _testVariables;
@synthesize isVariable = _isVariable;

-(CaculatorBrain *)brain 
{
  if (!_brain) _brain = [[CaculatorBrain alloc] init];
  return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
  NSString *digit = sender.currentTitle;
  if (self.userIsInTheMiddleOfEnteringANumber) {
    self.display.text = [self.display.text 
                         stringByAppendingString:digit];
  } else {
    if ([digit doubleValue]) {
      self.userIsInTheMiddleOfEnteringANumber = YES;
    }
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
  if (!self.isVariable)
    [self.brain pushToProgram:[NSNumber numberWithDouble:[self.display.text doubleValue]]];
  // Show all the input in history label
  self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
  // Clear out the flags
  self.userIsInTheMiddleOfEnteringANumber = NO;
  self.hasDot = NO;
  self.isVariable = NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
  if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
  [self.brain pushToProgram:sender.currentTitle];
  double result = [[self.brain class] runProgram:self.brain.program usingVariableVaules:self.testVariables];
  self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
  NSString *resultString = [NSString stringWithFormat:@"%g",result];
  self.display.text = resultString;  
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
      double result = [[self.brain class] runProgram:self.brain.program usingVariableVaules:self.testVariables];
      NSString *resultString = [NSString stringWithFormat:@"%g",result];
      self.display.text = resultString;
      self.userIsInTheMiddleOfEnteringANumber = NO;
    }
  }
  else {
    [self.brain popFromProgram];
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
  }
}

- (IBAction)testPressed:(UIButton *)sender {
  if ([[sender currentTitle] isEqualToString:@"test1"]) {
    self.testVariables = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"x",@"2.5",@"y", nil];
  } else if ([[sender currentTitle] isEqualToString:@"test2"]){
    self.testVariables = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"x", @"0",@"z", nil];
  } else if ([[sender currentTitle] isEqualToString:@"test3"]) {
    self.testVariables = [NSDictionary dictionaryWithObjectsAndKeys:@"-2",@"y",@"-5.5",@"z", @"3", @"x", nil];
  }
  self.variables.text = @"";
  for (NSString *variable in self.testVariables) {
    self.variables.text = [[[[self.variables.text stringByAppendingString:variable] stringByAppendingString:@" = "] stringByAppendingString:[self.testVariables objectForKey:variable]] stringByAppendingString:@"  "];
  }
  double result = [[self.brain class] runProgram:self.brain.program usingVariableVaules:self.testVariables];
  NSString *resultString = [NSString stringWithFormat:@"%g",result];
  self.display.text = resultString;  
}

- (IBAction)variablePressed:(UIButton *)sender {
  self.display.text = [self.testVariables valueForKey:[sender currentTitle]];
  [self.brain pushToProgram:[sender currentTitle]];
  self.isVariable = YES;
  [self enterPressed];
}

- (void)viewDidUnload {
  [self setVariables:nil];
  [super viewDidUnload];
}
@end