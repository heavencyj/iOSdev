//
//  GraphView.h
//  Calculator
//
//  Created by Heaven Chen on 9/13/12.
//
//

#import <UIKit/UIKit.h>

@class GraphView; // forward declaration

@protocol GraphViewDataSource
- (id)programForGraphView:(GraphView *)sender;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
// set this property to whatever object will provide this View's data
// usually a Controller using a GraphView in its View
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@end
