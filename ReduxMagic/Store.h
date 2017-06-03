#import <Foundation/Foundation.h>

@protocol StoreSubscriber <NSObject>

- (void)newState:(id)state;

@end

@protocol StoreReducer <NSObject>

- (id)reduce:(id)state action:(id)action;

@end

//

@interface Store : NSObject

@property id <StoreReducer> reducer;

+ (Store *)sharedStore;

- (void)dispatch:(NSString *)type payload:(id)payload;
- (void)dispatchAction:(id)action;

- (void)subscribe:(id <StoreSubscriber>)target;
- (void)unsubscribe:(id <StoreSubscriber>)target;

@end

#define STORE [Store sharedStore]
