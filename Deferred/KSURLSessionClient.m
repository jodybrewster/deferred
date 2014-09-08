#import "KSURLSessionClient.h"
#import "KSDeferred.h"

@interface KSURLSessionClient ()
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation KSURLSessionClient

- (instancetype)init {
    return [self initWithURLSession:[NSURLSession sharedSession]];
}

- (instancetype)initWithURLSession:(NSURLSession *)session {
    self = [super init];
    if (self) {
        self.session = session;
    }
    return self;
}

- (KSPromise *)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue {
    KSDeferred *deferred = [KSDeferred defer];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [deferred rejectWithError:error];
        } else {
            [deferred resolveWithValue:[KSNetworkResponse networkResponseWithURLResponse:response
                                                                                    data:data]];
        }
    }] resume];

    return deferred.promise;
}

@end