//
//  CaculatorBrain.m
//  Caculator
//
//  Created by Heaven Chen on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CaculatorBrain.h"

@interface  CaculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
+(BOOL)isOperation:(NSString *)string;
@property (nonatomic) BOOL hasHighOrder;
@end

@implementation CaculatorBrain
@synthesize programStack = _programStack;
@synthesize hasHighOrder = _hasHighOrder;

- (NSMutableArray *)programStack
{
  if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
  return _programStack;
}

- (id)program
{
  return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
  NSMutableArray *stack;
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
  }
  NSString *result=[self descriptionOfTopOfStack:stack];
  while ([stack lastObject]) {
    result = [[result stringByAppendingString:@", "] stringByAppendingString:[self descriptionOfTopOfStack:stack]];
  }
  return result;
}

- (void)pushToProgram:(id)operand
{
    [self.programStack addObject:operand];
}

-(void)clear
{
  [self.programStack removeAllObjects];
}

+(BOOL)isOperation:(NSString *)string {
  NSSet *operationSet = [[NSSet alloc] initWithObjects:@"sqrt", @"sin",@"cos",@"log", @"+", @"-",@"*",@"/",@"π",@"e",@"enter", nil];
  return [operationSet containsObject:string];
    
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
  // Need an extra parameter to pass in the boolean to deal with
  // parenthesis
  return [self descriptionOfTopOfStack:stack needParenthesis:NO];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack needParenthesis:(BOOL)need
{
  
  NSString *result=@"";
  id topOfStack = [stack lastObject];
  if (topOfStack) [stack removeLastObject];
  
  if ([topOfStack isKindOfClass:[NSNumber class]])
  {
    result = [topOfStack stringValue];
  }
  else if ([topOfStack isKindOfClass:[NSString class]]) {
    if (![self isOperation:topOfStack]) result = topOfStack;
    else {
      NSString *operation = topOfStack;
      // Check number of operands to determine the display
      if ([self numberOfOperands:operation] == 1) {
        result = [[[operation stringByAppendingString:@"("] stringByAppendingString:[self descriptionOfTopOfStack:stack needParenthesis:NO]] stringByAppendingString:@")"];
      } else if ([self numberOfOperands:operation] == 2) { 
        // Parenthesis needed when there is a high order operation
        if ([operation isEqualToString:@"*"] ||[operation isEqualToString:@"/"] ) {
          NSString *op2 = [self descriptionOfTopOfStack:stack needParenthesis:YES];
          result = [[[self descriptionOfTopOfStack:stack needParenthesis:YES] stringByAppendingString:operation] stringByAppendingString:op2];
        } else if (need){
          // Low order operation need () when inside high order operation
          NSString *op2 = [self descriptionOfTopOfStack:stack needParenthesis:NO];
          result = [[[[@"(" stringByAppendingString:[self descriptionOfTopOfStack:stack needParenthesis:NO]] stringByAppendingString:operation] stringByAppendingString:op2] stringByAppendingString:@")"];
        } else {
          // Low order and low order, no need for ()
          NSString *op2 = [self descriptionOfTopOfStack:stack needParenthesis:NO];
         result = [[[self descriptionOfTopOfStack:stack needParenthesis:NO] stringByAppendingString:operation] stringByAppendingString:op2];
        }
      } else if ([self numberOfOperands:operation] == 0) {
        result = operation;
      } else if ([operation isEqualToString:@"enter"]) {
        result = [self descriptionOfProgram:stack];
      }
    }
  }  
  return result;
}


+ (double)numberOfOperands: (NSString *)operation {
  
  NSSet *singleOperandOperation = [[NSSet alloc] initWithObjects:@"sqrt", @"sin",@"cos",@"log", nil];
  NSSet *doubleOperandOperation = [[NSSet alloc] initWithObjects:@"+", @"-",@"*",@"/", nil];
  NSSet *noOperandOperation = [[NSSet alloc] initWithObjects:@"π",@"e", nil];
  if ([singleOperandOperation containsObject:operation]) return 1;
  else if ([doubleOperandOperation containsObject:operation]) return 2;
  else if ([noOperandOperation containsObject:operation]) return 0;
  else return -1;
}

+ (id)popOperandOffProgramStack:(NSMutableArray *)stack
{
  double result = 0;
  
  id topOfStack = [stack lastObject];
  if (topOfStack) [stack removeLastObject];
  else return @"Error: Not enough operand";
  
  if ([topOfStack isKindOfClass:[NSNumber class]])
  {
    result = [topOfStack doubleValue];
  }
  else if ([topOfStack isKindOfClass:[NSString class]])
  {
    NSString *operation = topOfStack;
    if ([operation isEqualToString:@"+"]) {
      id op1 = [self popOperandOffProgramStack:stack];
      if ([op1 isKindOfClass:[NSString class]]) return op1;
      id op2 = [self popOperandOffProgramStack:stack];
      if ([op2 isKindOfClass:[NSString class]]) return op2;
      result = [op1 doubleValue] + [op2 doubleValue];
    } else if ([@"*" isEqualToString:operation]) {
      id op1 = [self popOperandOffProgramStack:stack];
      if ([op1 isKindOfClass:[NSString class]]) return op1;
      id op2 = [self popOperandOffProgramStack:stack];
      if ([op2 isKindOfClass:[NSString class]]) return op2;
      result = [op1 doubleValue] * [op2 doubleValue];
    } else if ([operation isEqualToString:@"-"]) {
      id op1 = [self popOperandOffProgramStack:stack];
      if ([op1 isKindOfClass:[NSString class]]) return op1;
      id op2 = [self popOperandOffProgramStack:stack];
      if ([op2 isKindOfClass:[NSString class]]) return op2;
      result = [op2 doubleValue] - [op1 doubleValue];
    } else if ([operation isEqualToString:@"/"]) {
      id op1 = [self popOperandOffProgramStack:stack];
      if ([op1 isKindOfClass:[NSString class]]) return op1;
      id op2 = [self popOperandOffProgramStack:stack];
      if ([op2 isKindOfClass:[NSString class]]) return op2;
      if ([op1 doubleValue]) result = result = [op2 doubleValue] / [op1 doubleValue];
      else return @"Error: divisor = 0.";
    } else if ([operation isEqualToString:@"sin"]){
      id op1 = [self popOperandOffProgramStack:stack];
      if ([op1 isKindOfClass:[NSString class]]) return op1;
      result = sin([op1 doubleValue]);    
    } else if ([operation isEqualToString:@"cos"]){
      id op1 = [self popOperandOffProgramStack:stack];
      if ([op1 isKindOfClass:[NSString class]]) return op1;
      result = cos([op1 doubleValue]);    
    } else if ([operation isEqualToString:@"π"]){
      result = 3.14159;
    } else if ([operation isEqualToString:@"sqrt"]){
      id op1 = [self popOperandOffProgramStack:stack];
      if ([op1 isKindOfClass:[NSString class]]) return op1;
      if ([op1 doubleValue] >= 0) result =  sqrt([op1 doubleValue]);
      else return @"Error: sqrt operand < 0.";
    } else if ([operation isEqualToString:@"e"]){
      result = 2.71828;
    } else if ([operation isEqualToString:@"log"]){
      id op1 = [self popOperandOffProgramStack:stack];
      if ([op1 isKindOfClass:[NSString class]]) return op1;
      if ([op1 doubleValue] > 0) result =  log([op1 doubleValue]);
      else return @"Error: log operand < 0.";
    } else if ([operation isEqualToString:@"enter"]) {
      id current = [self runProgram:stack];
      if ([current isKindOfClass:[NSString class]]) return current;
      else result =[current doubleValue];
    }
  }
  return [NSNumber numberWithDouble:result];
}

+ (id)runProgram:(id)program
{
  NSMutableArray *stack;
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
  }
  return [self popOperandOffProgramStack:stack];
}

+ (id)runProgram:(id)program usingVariableVaules:(NSDictionary *)variableValues {
  NSMutableArray *stack;
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
  }
  for (int i=0; i < stack.count; i++) {
    NSString *variableValue = [variableValues objectForKey:[stack objectAtIndex:i]];
    if (variableValue)
      [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:[variableValue doubleValue]]];
  }
  return [self popOperandOffProgramStack:stack];

}

+ (NSSet *)variablesUsedInProgram:(id)program {
  
  NSMutableArray *stack;
  NSSet *variableSet = [[NSSet alloc] init];
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
  }
  for (id operand in stack) {
    if ([operand isKindOfClass:[NSString class]] && ![self isOperation:operand]) {
      variableSet = [variableSet setByAddingObject:operand];
    }
  }
  return variableSet;
}

-(void)popFromProgram 
{
  [self.programStack removeLastObject];
}

@end
