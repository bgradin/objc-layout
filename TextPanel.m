#import "TextPanel.h"

@interface TextPanel()
{
    NSLayoutManager *m_layoutManager;
    NSSize m_sizeLastMeasure;
}
@property (nonatomic, assign) NSSize sizeLastMeasure;
@property (nonatomic, retain) NSLayoutManager *layoutManager;
@end

@implementation TextPanel
@synthesize sizeLastMeasure = m_sizeLastMeasure;
@synthesize layoutManager = m_layoutManager;

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self == nil)
        return nil;
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    self.layoutManager = layoutManager;
    [layoutManager release];
    
    return self;
}

- (NSString *)stringValue
{
    return [self.value string];
}

- (void)setStringValue:(NSString *)stringValue
{
    NSAttributedString *newString = [[NSAttributedString alloc] initWithString:stringValue];
    self.value = newString;
    [newString release];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self.value drawInRect:NSMakeRect(self.padding.left, self.padding.top, NSWidth(self.bounds) - self.padding.left - self.padding.right, NSHeight(self.bounds) - self.padding.top - self.padding.bottom)];
}

- (NSSize)measureCore:(NSSize)sizeAvailable
{
    NSSize textSize = [self.value boundingRectWithSize:sizeAvailable options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)].size;
    self.desiredSize = NSMakeSize(self.padding.left + textSize.width + self.padding.right, self.padding.top + textSize.height + self.padding.bottom);
    return self.desiredSize;
}

- (NSSize)arrangeCore:(NSSize)sizeFinal
{
    [self setFrameSize:sizeFinal];
    return sizeFinal;
}

@end
