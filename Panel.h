#import <Cocoa/Cocoa.h>
#import "NSView+Layout.h"

typedef struct {
    CGFloat left;
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
} Padding;

extern Padding PaddingDefault;
extern Padding PaddingNone;

@interface Panel : NSView
@property (nonatomic, assign) Padding padding;
- (id)initWithFrame:(NSRect)frameRect padding:(Padding)padding;
@end

@interface Panel(Protected)
@property (nonatomic, assign) NSSize desiredSize;
- (NSSize)measureCore:(NSSize)sizeAvailable;
- (NSSize)arrangeCore:(NSSize)sizeFinal;
@end
