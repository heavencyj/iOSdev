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
@synthesize midPoint = _midPoint;

- (void)setup
{
  self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
  NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
  CGFloat x = [pref floatForKey:@"originX"];
  CGFloat y = [pref floatForKey:@"originY"];
  CGFloat scale = [pref floatForKey:@"scale"];
  
  // if pref is not set
  if ( x == 0 && y==0 && scale==0) {
      CGPoint midPoint; //center in coordinate system
      midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
      midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
      self.midPoint = midPoint;
      self.origin = midPoint;
  }
  else {
    self.origin = CGPointMake(x, y);
    self.scale = scale;
  }
}

- (void)awakeFromNib
{
  [super awakeFromNib];
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
    [self saveDefultsOrigin:self.origin orScale:self.scale];
  }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
  
  if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
    
    CGPoint translation = [gesture translationInView:self];
    self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
    [self setNeedsDisplay];
    [gesture setTranslation:CGPointMake(0, 0) inView:self];
    [self saveDefultsOrigin:self.origin orScale:self.scale];
  }
}

- (void)tripleTapping:(UITapGestureRecognizer *)gesture {
  if (gesture.state == UIGestureRecognizerStateEnded) {
    self.origin = [gesture locationInView:self];
    [self saveDefultsOrigin:self.origin orScale:self.scale];
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

-(void)saveDefultsOrigin:(CGPoint)origin orScale:(CGFloat)scale {
  NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
  [pref setFloat:scale forKey:@"scale"];
  [pref setFloat:origin.x forKey:@"originX"];
  [pref setFloat:origin.y forKey:@"originY"];
  [pref synchronize];
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
    
    
    CGFloat xPixelsFromCartesianOrigin = pixel-self.origin.x; //Distance from center to edge of screen
    CGFloat x = xPixelsFromCartesianOrigin / [self scale];     //xValue in Units
    
    CGFloat y = [self.dataSource valueForExpressionAtX:x];  //Delegate calculates y-Value in units given x-Value in units
    //CGFloat y = 10;
    CGFloat yPixelsFromCartesianOrigin = y * [self scale];
    
    //If this is the first iteration through the loop, move to point to begin drawing.
    if (haveMovedToPoint == NO)
    {
      CGContextMoveToPoint(context, 0, self.origin.y-yPixelsFromCartesianOrigin);
      haveMovedToPoint = YES;
    }
    CGContextAddLineToPoint(context, pixel, self.origin.y-yPixelsFromCartesianOrigin);
  }
  
  CGContextStrokePath(context);
	UIGraphicsPopContext();
}

-(void)resetOrigin
{
  CGFloat distX = self.origin.x - self.midPoint.x;
  CGFloat distY = self.origin.y - self.midPoint.y;
  
  CGPoint newCenter; //center in coordinate system
  newCenter.x = self.bounds.origin.x + self.bounds.size.width/2;
  newCenter.y = self.bounds.origin.y + self.bounds.size.height/2;
  self.midPoint = newCenter;
  
  CGPoint newOrigin;
  newOrigin.x = newCenter.x + distX;
  newOrigin.y = newCenter.y + distY;
  
  self.origin = newOrigin;  
}
@end
