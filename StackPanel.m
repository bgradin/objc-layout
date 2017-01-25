#import "StackPanel.h"

@interface StackPanel()
{
    Orientation m_orientation;
    CGFloat m_spacing;
}
@end

@implementation StackPanel
@synthesize orientation = m_orientation;

- (NSSize)measureCore:(NSSize)sizeAvailable
{
    NSSize sizeMinusPadding = NSMakeSize(sizeAvailable.width - self.padding.right - self.padding.left, sizeAvailable.height - self.padding.top - self.padding.bottom);
    NSSize sizeRemaining = sizeMinusPadding;
    
    if (self.orientation == OrientationHorizontal)
    {
        for (NSView *view in self.subviews)
        {
            NSSize desiredSize = [view measure:NSMakeSize(sizeRemaining.width, sizeMinusPadding.height)];
            CGFloat remainingWidth = view == [self.subviews lastObject]
                ? sizeRemaining.width - desiredSize.width
                : sizeRemaining.width - desiredSize.width - self.spacing;
            sizeRemaining = NSMakeSize(remainingWidth, MIN(sizeRemaining.height, sizeMinusPadding.height - desiredSize.height));
        }
    }
    else
    {
        for (NSView *view in self.subviews)
        {
            NSSize desiredSize = [view measure:NSMakeSize(sizeMinusPadding.width, sizeRemaining.height)];
            CGFloat remainingHeight = view == [self.subviews lastObject]
                ? sizeRemaining.height - desiredSize.height
                : sizeRemaining.height - desiredSize.height - self.spacing;
            sizeRemaining = NSMakeSize(MIN(sizeRemaining.width, sizeMinusPadding.width - desiredSize.width), remainingHeight);
        }
    }
    
    self.desiredSize = self.orientation == OrientationHorizontal
        ? NSMakeSize(sizeAvailable.width, sizeAvailable.height - sizeRemaining.height)
        : NSMakeSize(sizeAvailable.width - sizeRemaining.width, sizeAvailable.height);
    return self.desiredSize;
}

- (NSSize)arrangeCore:(NSSize)sizeFinal
{
    [self setFrameSize:self.desiredSize];

    if (self.orientation == OrientationHorizontal)
    {
        CGFloat x = self.padding.left;
        for (NSView *view in self.subviews)
        {
            [view setFrameOrigin:NSMakePoint(x, self.padding.top)];
            [view arrange:view.desiredSize];
            x += view == [self.subviews lastObject]
                ? view.desiredSize.width
                : view.desiredSize.width + self.spacing;
        }
    }
    else
    {
        CGFloat y = self.padding.top;
        for (NSView *view in self.subviews)
        {
            [view setFrameOrigin:NSMakePoint(self.padding.left, y)];
            [view arrange:view.desiredSize];
            y += view == [self.subviews lastObject]
                ? view.desiredSize.height
                : view.desiredSize.height + self.spacing;
        }
    }

    return self.frame.size;
}

@end
