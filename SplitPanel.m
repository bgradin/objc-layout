#import <objc/runtime.h>
#import "NSView+Layout.h"
#import "SplitPanel.h"

@interface SplitPanel()
{
    NSSize m_desiredSize;
    BOOL m_needsLayout;
}
@property (nonatomic, assign) NSSize desiredSize;
@property (nonatomic, assign) BOOL needsLayout;
@end

@implementation SplitPanel
@synthesize desiredSize = m_desiredSize;
@synthesize needsLayout = m_needsLayout;

- (id<NSSplitViewDelegate>)delegate
{
    return self;
}

- (void)setDelegate:(id<NSSplitViewDelegate>)delegate
{
    NSLog(@"Warning: tried to explicitly set delegate on instance of '%@'", NSStringFromClass([self class]));
}

- (NSSize)measure:(NSSize)sizeAvailable
{
//    sizeAvailable = NSMakeSize(sizeAvailable.width, sizeAvailable.height - 50.0);
    
    NSUInteger subviewCount = self.subviews.count;
    CGFloat subviewWidth = self.vertical ? (sizeAvailable.width - self.dividerThickness - (2 * subviewCount)) / subviewCount : sizeAvailable.width;
    CGFloat subviewHeight = self.vertical ? sizeAvailable.height : (sizeAvailable.height - self.dividerThickness - (2 * subviewCount)) / subviewCount;
    NSSize subviewSize = NSMakeSize(subviewWidth, subviewHeight);
    
    for (NSView *view in self.subviews)
        [view measure:subviewSize];
    
    self.desiredSize = sizeAvailable;
    return self.desiredSize;
}

- (NSSize)arrange:(NSSize)sizeFinal
{
    [self setFrameSize:self.desiredSize];
    
    NSUInteger subviewCount = self.subviews.count;
    CGFloat subviewWidth = self.vertical ? (NSWidth(self.frame) - self.dividerThickness - (2 * subviewCount)) / subviewCount : NSWidth(self.frame);
    CGFloat subviewHeight = self.vertical ? NSHeight(self.frame) : (NSHeight(self.frame) - self.dividerThickness - (2 * subviewCount)) / subviewCount;
    NSSize subviewSize = NSMakeSize(subviewWidth, subviewHeight);

    for (NSView *view in self.subviews)
         [view arrange:subviewSize];
    
    self.needsLayout = NO;
    
    return sizeFinal;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.needsLayout)
        [self arrange:[self measure:self.frame.size]];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:0.0 yBy:NSHeight(self.frame)];
    [transform concat];
}

- (void)invalidateLayout
{
    if (self.superview != nil && !self.needsLayout)
        [self.superview invalidateLayout];
    
    self.needsLayout = YES;
    self.needsDisplay = YES;
}

- (void)viewDidMoveToSuperview
{
    if (self.needsLayout)
        [self.superview invalidateLayout];
    
    [self invalidateLayout];
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldSize
{
    [self invalidateLayout];
}

// NSSplitViewDelegate methods

- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex
{
    return NSZeroRect;
}

@end
