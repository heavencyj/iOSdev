//
//  GraphViewController.m
//  Calculator
//
//  Created by Heaven Chen on 9/12/12.
//
//

#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController () 
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController
@synthesize graphView = _graphView;

-(void)setGraphView:(GraphView *)graphView {
  _graphView = graphView;
  [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
  UITapGestureRecognizer* tripleTapRecoginizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTapping:)];
  tripleTapRecoginizer.numberOfTapsRequired = 3;
  [self.graphView addGestureRecognizer:tripleTapRecoginizer];
  [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
