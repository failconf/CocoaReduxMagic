#import <Cocoa/Cocoa.h>
#import "Store.h"

@interface ViewController : NSViewController <StoreSubscriber>

@property (weak) IBOutlet NSTextField *titleField;

@end

