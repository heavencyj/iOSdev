//
//  GraphViewController.m
//  Calculator
//
//  Created by Heaven Chen on 9/12/12.
//
//

#import "GraphViewController.h"

@interface GraphViewController () 
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet id<GraphViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@end

@implementation GraphViewController
@synthesize graphView = _graphView;
@synthesize dataSource = _dataSource;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
  if (_splitViewBarButtonItem != splitViewBarButtonItem) {
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
  }
}

// Set graph view and add guestures
-(void)setGraphView:(GraphView *)graphView {
  _graphView = graphView;
  self.graphView.dataSource = self.dataSource;
  // Add gestures
  [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
  UITapGestureRecognizer* tripleTapRecoginizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTapping:)];
  tripleTapRecoginizer.numberOfTapsRequired = 3;
  [self.graphView addGestureRecognizer:tripleTapRecoginizer];
  [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
}

// Set the graphview delegate to 
-(void)setGraphViewDataSource:(id<GraphViewDataSource>)dataSource {
  self.dataSource = dataSource;
  self.graphView.dataSource = self.dataSource;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [self.graphView resetOrigin];
}

-(void)drawGraph {
  [self.graphView setNeedsDisplay];
}

@end
