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
- (CGFloat)valueForExpressionAtX:(CGFloat)x;
@end

@interface GraphView : UIView
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)tripleTapping:(UITapGestureRecognizer *)gesture;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
// set this property to whatever object will provide this View's data
// usually a Controller using a GraphView in its View
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@end
