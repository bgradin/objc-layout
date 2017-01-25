#import "LayoutIslandPanel.h"

@implementation LayoutIslandPanel

- (void)invalidateLayout
{
    self.needsLayout = YES;
}

@end
