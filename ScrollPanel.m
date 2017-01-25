#import "ScrollPanel.h"
#import "NSView+Layout.h"

@interface ScrollPanel()
{
    NSSize m_desiredSize;
}
@property (nonatomic, assign) NSSize desiredSize;
@end

@implementation ScrollPanel

- (NSSize)measure:(NSSize)sizeAvailable
{
    self.desiredSize = sizeAvailable;
    return self.desiredSize;
}

- (NSSize)arrange:(NSSize)sizeFinal
{
    [self setFrameSize:self.desiredSize];
    return self.frame.size;
}

@end
