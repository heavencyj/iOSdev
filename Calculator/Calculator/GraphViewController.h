//
//  GraphViewController.h
//  Calculator
//
//  Created by Heaven Chen on 9/12/12.
//
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter>

-(void)setGraphViewDataSource:(id<GraphViewDataSource>)dataSource;
-(void)drawGraph;
@end
