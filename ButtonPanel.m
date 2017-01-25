#import "ButtonPanel.h"

@interface ButtonPanel()
{
    Padding m_padding;
    NSSize m_desiredSize;
    BOOL m_needsLayout;
}
@property (nonatomic, assign) BOOL needsLayout;
@end

@implementation ButtonPanel
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

- (void)setAutoresizingMask:(NSAutoresizingMaskOptions)autoresizingMask
{
    NSLog(@"Warning: tried to explicitly set autoresizingMask on instance of '%@'", NSStringFromClass([self class]));
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.needsLayout)
        [self arrange:[self measure:self.bounds.size]];
    
    [super drawRect:dirtyRect];
}

- (NSSize)measure:(NSSize)sizeAvailable
{
    return [self measureCore:sizeAvailable];
}

- (NSSize)measureCore:(NSSize)sizeAvailable
{
    [self sizeToFit];
    self.desiredSize = NSMakeSize(NSWidth(self.frame) + self.padding.left + self.padding.right, NSHeight(self.frame) + self.padding.top + self.padding.bottom);
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
    [self setFrameSize:self.desiredSize];
    return self.frame.size;
}

- (void)viewDidMoveToSuperview
{
    [self invalidateLayout];
}

- (void)invalidateLayout
{
    if (self.superview != nil && !self.needsLayout)
        [self.superview invalidateLayout];
    
    self.needsDisplay = YES;
    self.needsLayout = YES;
}

@end
