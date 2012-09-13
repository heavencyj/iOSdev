//
//  CaculatorViewController.h
//  Caculator
//
//  Created by Heaven Chen on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *history;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)dotPressed:(UIButton *)sender;
- (IBAction)undoPressed:(UIButton *)sender;
- (IBAction)variablePressed:(UIButton *)sender;


@end
