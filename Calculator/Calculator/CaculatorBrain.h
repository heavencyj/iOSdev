//
//  CaculatorBrain.h
//  Caculator
//
//  Created by Heaven Chen on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "math.h"

@interface CaculatorBrain : NSObject

-(void)pushToProgram:(id)operand;
-(void)popFromProgram;
-(double)performOperation:(NSString *)operation;
-(void)clear;
@property (nonatomic, readonly) id program;
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableVaules:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
@end
