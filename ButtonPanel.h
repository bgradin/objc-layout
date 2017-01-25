#import <Cocoa/Cocoa.h>
#import "Panel.h"

@interface ButtonPanel : NSButton
@property (nonatomic, assign) Padding padding;
- (id)initWithFrame:(NSRect)frameRect padding:(Padding)padding;
@end

@interface ButtonPanel(Protected)
@property (nonatomic, assign) NSSize desiredSize;
- (NSSize)measureCore:(NSSize)sizeAvailable;
- (NSSize)arrangeCore:(NSSize)sizeFinal;
@end
