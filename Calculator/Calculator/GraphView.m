//
//  GraphView.m
//  Calculator
//
//  Created by Heaven Chen on 9/13/12.
//
//

#import "GraphView.h"
#import "AxesDrawer.h"
#import "CaculatorBrain.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;

- (void)setup
{
  self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
  [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
  }
  return self;
}

#define DEFAULT_SCALE 10

- (CGFloat)scale
{
  if (!_scale) {
    return DEFAULT_SCALE; // don't allow zero scale
  } else {
    return _scale;
  }
}

- (void)setScale:(CGFloat)scale
{
  if (scale != _scale) {
    _scale = scale;
    [self setNeedsDisplay]; // any time our scale changes, call for redraw
  }
}

- (void)drawRect:(CGRect)rect
{
  CGPoint midPoint; // center of our bounds in our coordinate system
  midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
  midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
  
  [[UIColor whiteColor] set];
  [AxesDrawer drawAxesInRect:rect originAtPoint:midPoint scale:self.scale];
  
  // Draw the graph of program.
  CGPoint startPoint;
  startPoint.x = self.bounds.origin.x;
  startPoint.y = [[CaculatorBrain runProgram:self.dataSource usingVariableVaules:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat: startPoint.x], @"x", nil]] doubleValue];
}


@end
