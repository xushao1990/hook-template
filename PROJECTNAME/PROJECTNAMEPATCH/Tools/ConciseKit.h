#import <Foundation/Foundation.h>

//__attribute__((objc_runtime_name("d01e4b8d6289a132412")))

@interface ConciseKit : NSObject {}

+ (NSString *)homePath;
+ (NSString *)desktopPath;
+ (NSString *)documentPath;
+ (NSString *)appPath;
+ (NSString *)resourcePath;

+ (BOOL)swizzleMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)klass;
+ (BOOL)swizzleMethod:(SEL)originalSelector in:(Class)klass with:(SEL)anotherSelector in:(Class)anotherKlass;
+ (BOOL)swizzleClassMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)klass;
+ (BOOL)swizzleClassMethod:(SEL)originalSelector in:(Class)klass with:(SEL)anotherSelector in:(Class)anotherKlass;

+ (void)waitUntil:(BOOL (^)(void))condition;
+ (void)waitUntil:(BOOL (^)(void))condition timeOut:(NSTimeInterval)timeOut;
+ (void)waitUntil:(BOOL (^)(void))condition timeOut:(NSTimeInterval)timeOut interval:(NSTimeInterval)interval;

@end

@interface $ : ConciseKit {}
@end