#import <Cocoa/Cocoa.h>
#import "Panel.h"

typedef enum {
    OrientationHorizontal,
    OrientationVertical
} Orientation;

@interface StackPanel : Panel
@property (nonatomic, assign) Orientation orientation;
@property (nonatomic, assign) CGFloat spacing;
@end
