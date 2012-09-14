//
//  GraphView.m
//  Calculator
//
//  Created by Heaven Chen on 9/13/12.
//
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;
@synthesize origin = _origin;

- (void)setup
{
  self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
  CGPoint midPoint; //center in coordinate system
  midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
  midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
  self.origin = midPoint;
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

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
  if ((gesture.state == UIGestureRecognizerStateChanged) ||
      (gesture.state == UIGestureRecognizerStateEnded)) {
    self.scale *= gesture.scale; // adjust our scale
    gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
  }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
  
}
- (void)tripleTapping:(UITapGestureRecognizer *)gesture {
  if (gesture.state == UIGestureRecognizerStateEnded) {
    self.origin = [gesture locationInView:self];
  }
}

-(void)setOrigin:(CGPoint)origin
{
  if (origin.x != _origin.x || origin.y != _origin.y) {
    _origin.x = origin.x;
    _origin.y = origin.y;
    [self setNeedsDisplay];
  }
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  //Draw Axes
  CGRect axesRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
  [[UIColor whiteColor] set];
  [AxesDrawer drawAxesInRect:axesRect originAtPoint:self.origin scale:self.scale];
  
  
	UIGraphicsPushContext(context);
  
  //Set Drawing Options
  CGContextSetLineWidth(context, 2);
  [[UIColor whiteColor] setStroke];
  
  
  //Draw Graph
  
  BOOL haveMovedToPoint = NO;
  
  for (CGFloat pixel = 0; pixel < self.bounds.size.width; pixel++) { //Iterate over each pixel left to right, iOS coordinat system
    
    
    //CGFloat xPixelsFromCartesianOrigin = pixel-midPoint.x; //Distance from center to edge of screen
    //CGFloat x = xPixelsFromCartesianOrigin / [self scale];     //xValue in Units
    
    //CGFloat y = [self.dataSource valueForExpressionAtX:x];  //Delegate calculates y-Value in units given x-Value in units
    CGFloat y = 10;
    CGFloat yPixelsFromCartesianOrigin = y * [self scale];
    
    //If this is the first iteration through the loop, move to point to begin drawing.
    if (haveMovedToPoint == NO)
    {
      CGContextMoveToPoint(context, 0, (self.bounds.size.height/2)-yPixelsFromCartesianOrigin);
      haveMovedToPoint = YES;
    }
    CGContextAddLineToPoint(context, pixel, (self.bounds.size.height/2)-yPixelsFromCartesianOrigin);
  }
  
  CGContextStrokePath(context);
	UIGraphicsPopContext();
}

-(void)resetOrigin: (CGPoint)center
{
  CGFloat distX = self.origin.x - center.x;
  CGFloat distY = self.origin.y - center.y;
  
  CGPoint newCenter; //center in coordinate system
  newCenter.x = self.bounds.origin.x + self.bounds.size.width/2;
  newCenter.y = self.bounds.origin.y + self.bounds.size.height/2;

  CGPoint newOrigin;
  newOrigin.x = newCenter.x + distX;
  newOrigin.y = newCenter.y + distY;
  
  self.origin = newOrigin;
  
}
@end
