#import "Reducer.h"

@implementation Reducer

- (NSMutableDictionary *)reduce:(NSMutableDictionary *)state action:(id)action {
    id type = action[@"type"];
    
    if ([type isEqualToString:@"INCREMENT"]) {
        state[@"counter"] = @([state[@"counter"] integerValue] + 1);
    }
    
    return state;
}

@end
