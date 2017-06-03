#import "Store.h"

/*
 
 todo:
 - thread safe
 
 */

@implementation Store {
    NSMutableDictionary *state;
    NSMutableArray *history;
    NSMutableArray *subscribers;
    NSMutableArray *actionQueue;
    NSMutableArray *reducers;
    NSTimer *timer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        state = [NSMutableDictionary new];
        history = [NSMutableArray new];
        subscribers = [NSMutableArray new];
        actionQueue = [NSMutableArray new];
        
        // todo weak
        __weak Store *this = self;
        timer = [NSTimer scheduledTimerWithTimeInterval:1./20. target:this selector:@selector(performReducers:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc {
    [timer invalidate];
    timer = nil;
}

+ (Store *)sharedStore {
    static Store *store;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [Store new];
    });
    return store;
}

- (void)dispatch:(NSString *)type payload:(id)payload {
    NSAssert([type length] > 0, @"type required");
    // NSAssert(!!payload, @"payload required");
    if (payload) {
        [self dispatchAction:@{ @"type": type, @"payload": payload}];
    } else {
        [self dispatchAction:@{ @"type": type}];
    }
}

- (void)dispatchAction:(id)action {
    [actionQueue addObject:action];
}

- (void)performReducers:(id)obj {
    if (actionQueue.count > 0) {
        NSLog(@"Perform reducers %@", actionQueue);
    }
    BOOL didChange = NO;
    while (true) {
        id action = [actionQueue lastObject];
        if (!action) {
            break;
        }
        [actionQueue removeLastObject];
        
        [self.reducer reduce:state action:action];
        
        didChange = YES;
    }
    if (didChange) {
        for (id <StoreSubscriber>subscriber in subscribers) {
            [subscriber newState:state];
        }
    }
}

- (void)subscribe:(id <StoreSubscriber>)target {
    if (![subscribers containsObject:target]) {
        [subscribers addObject:target];
    }
}

- (void)unsubscribe:(id <StoreSubscriber>)target {
    [subscribers removeObject:target];
}

@end
