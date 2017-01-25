#import <Cocoa/Cocoa.h>
#import "Panel.h"

@interface TextPanel : Panel
@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, copy) NSAttributedString *value;
@end
