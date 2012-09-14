//
//  GraphViewController.h
//  Calculator
//
//  Created by Heaven Chen on 9/12/12.
//
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController

-(void)setGraphViewDataSource:(id<GraphViewDataSource>)dataSource;
@end
