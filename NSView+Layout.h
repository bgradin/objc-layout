#import <Cocoa/Cocoa.h>

@interface NSView(Layout)
- (void)invalidateLayout;
- (NSSize)measure:(NSSize)sizeAvailable;
- (NSSize)arrange:(NSSize)sizeFinal;
@property (nonatomic, readonly, assign) NSSize desiredSize;
@end

@implementation NSView(Layout)

- (NSSize)desiredSize
{
    return self.bounds.size;
}

- (void)invalidateLayout
{
    if (self.superview != nil)
        [self.superview invalidateLayout];
    
    self.needsDisplay = YES;
}

- (NSSize)measure:(NSSize)sizeAvailable
{
    for (NSView *view in self.subviews)
         [view measure:sizeAvailable];
    
    return sizeAvailable;
}

- (NSSize)arrange:(NSSize)sizeFinal
{
    for (NSView *view in self.subviews)
        [view arrange:sizeFinal];

    return sizeFinal;
}

@end
