#import "Panel.h"

Padding PaddingDefault = { 4.0, 4.0, 4.0, 4.0 };
Padding PaddingNone = { 0.0, 0.0, 0.0, 0.0 };

@interface Panel()
{
    BOOL m_needsDisplay;
    Padding m_padding;
    NSSize m_desiredSize;
    BOOL m_needsLayout;
}
@property (nonatomic, assign) BOOL needsLayout;
@end

@implementation Panel
@synthesize needsLayout = m_needsLayout;
@synthesize padding = m_padding;

- (id)initWithFrame:(NSRect)frameRect padding:(Padding)padding
{
    self = [super initWithFrame:frameRect];
    if (self == nil)
        return nil;
    
    self.padding = padding;
    
    return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [self initWithFrame:frameRect padding:PaddingDefault];
    return self;
}

- (BOOL)needsDisplay
{
    return m_needsDisplay;
}

- (void)setNeedsDisplay:(BOOL)needsDisplay
{
    m_needsDisplay = needsDisplay;
}

- (BOOL)isFlipped
{
    return YES;
}

- (NSSize)desiredSize
{
    return m_desiredSize;
}

- (void)setDesiredSize:(NSSize)desiredSize
{
    m_desiredSize = desiredSize;
}

- (NSAutoresizingMaskOptions)autoresizingMask
{
    return NSViewWidthSizable | NSViewHeightSizable;
}

- (void)setAutoresizingMask:(NSAutoresizingMaskOptions)autoresizingMask
{
    NSLog(@"Warning: tried to explicitly set autoresizingMask on instance of '%@'", NSStringFromClass([self class]));
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.needsLayout)
        [self arrange:[self measure:self.bounds.size]];
}

- (void)invalidateLayout
{
    if (self.superview != nil && !self.needsLayout)
        [self.superview invalidateLayout];
    
    self.needsLayout = YES;
    self.needsDisplay = YES;
}

- (NSSize)measure:(NSSize)sizeAvailable
{
    return [self measureCore:sizeAvailable];
}

- (NSSize)measureCore:(NSSize)sizeAvailable
{
    for (NSView *view in self.subviews)
         [view measure:sizeAvailable];

    self.desiredSize = sizeAvailable;
    return self.desiredSize;
}

- (NSSize)arrange:(NSSize)sizeFinal
{
    NSSize arrangedSize = [self arrangeCore:sizeFinal];
    
    self.needsLayout = NO;
    
    return arrangedSize;
}

- (NSSize)arrangeCore:(NSSize)sizeFinal
{
    for (NSView *view in self.subviews)
        [view arrange:view.desiredSize];

    return sizeFinal;
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

@end
