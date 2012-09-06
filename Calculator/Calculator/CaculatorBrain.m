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

- (double)performOperation:(NSString *)operation
{
  [self.programStack addObject:operation];
  return [[self class] runProgram:self.program];
}

-(void)clear
{
  [self.programStack removeAllObjects];
}

+(BOOL)isOperation:(NSString *)string {
  NSSet *operationSet = [[NSSet alloc] initWithObjects:@"sqrt", @"sin",@"cos",@"log", @"+", @"-",@"*",@"/",@"π",@"e", nil];
  return [operationSet containsObject:string];
    
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
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
      if ([self numberOfOperands:operation] == 1) {
        result = [[[operation stringByAppendingString:@"("] stringByAppendingString:[self descriptionOfTopOfStack:stack needParenthesis:NO]] stringByAppendingString:@")"];
      } else if ([self numberOfOperands:operation] == 2) { 
        if ([operation isEqualToString:@"*"] ||[operation isEqualToString:@"/"] ) {
          NSString *op2 = [self descriptionOfTopOfStack:stack needParenthesis:YES];
          result = [[[self descriptionOfTopOfStack:stack needParenthesis:YES] stringByAppendingString:operation] stringByAppendingString:op2];
        } else if (need){
          NSString *op2 = [self descriptionOfTopOfStack:stack needParenthesis:NO];
          result = [[[[@"(" stringByAppendingString:[self descriptionOfTopOfStack:stack needParenthesis:NO]] stringByAppendingString:operation] stringByAppendingString:op2] stringByAppendingString:@")"];
        } else {
          NSString *op2 = [self descriptionOfTopOfStack:stack needParenthesis:NO];
         result = [[[self descriptionOfTopOfStack:stack needParenthesis:NO] stringByAppendingString:operation] stringByAppendingString:op2];
        }
      } else if ([self numberOfOperands:operation] == 0) {
        result = operation;
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

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
  double result = 0;
  
  id topOfStack = [stack lastObject];
  if (topOfStack) [stack removeLastObject];
  
  if ([topOfStack isKindOfClass:[NSNumber class]])
  {
    result = [topOfStack doubleValue];
  }
  else if ([topOfStack isKindOfClass:[NSString class]])
  {
    NSString *operation = topOfStack;
    if ([operation isEqualToString:@"+"]) {
      result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
    } else if ([@"*" isEqualToString:operation]) {
      result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
    } else if ([operation isEqualToString:@"-"]) {
      double subtrahend = [self popOperandOffProgramStack:stack];
      result = [self popOperandOffProgramStack:stack] - subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
      double divisor = [self popOperandOffProgramStack:stack];
      if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
    } else if ([operation isEqualToString:@"sin"]){
      result = sin([self popOperandOffProgramStack:stack]);    
    } else if ([operation isEqualToString:@"cos"]){
      result = cos([self popOperandOffProgramStack:stack]); 
    } else if ([operation isEqualToString:@"π"]){
      result = 3.14159;
    } else if ([operation isEqualToString:@"sqrt"]){
      double operand = [self popOperandOffProgramStack:stack];
      if (operand > 0) result =  sqrt(operand);
    } else if ([operation isEqualToString:@"e"]){
      result = 2.71828;
    } else if ([operation isEqualToString:@"log"]){
      double operand = [self popOperandOffProgramStack:stack];
      // log base e
      if (operand) result = log(operand);
    }    
  }  
  return result;
}

+ (double)runProgram:(id)program
{
  NSMutableArray *stack;
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
  }
  return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program usingVariableVaules:(NSDictionary *)variableValues {
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
