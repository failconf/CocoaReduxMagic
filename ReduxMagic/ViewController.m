#import "ViewController.h"
#import "Reducer.h" 

@implementation ViewController

+ (void)initialize {
    [STORE setReducer:[Reducer new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [STORE subscribe:self];
}

- (void)viewWillDisappear {
    [STORE unsubscribe:self];
    [super viewWillDisappear];
}

- (void)newState:(id)state {
    NSLog(@"New State %@", state);
    self.titleField.stringValue = state[@"counter"];
}

- (IBAction)doAddItem:(id)sender {
    [STORE dispatch:@"INCREMENT" payload:@1];
}

//- (void)setRepresentedObject:(id)representedObject {
//    [super setRepresentedObject:representedObject];
//
//    // Update the view, if already loaded.
//}

@end
