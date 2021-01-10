//
//  PlistLogger.h
//  PlistExporer
//
//  Created by Karsten Kusche on 10.01.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlistLogger : NSObject

- (void)logStringOfObject:(id)object level:(NSInteger)level;
- (BOOL)tryLogObject:(id)object;
- (void)logKey:(id)object level:(NSInteger)level;
- (void)logValue:(id)object level:(NSInteger)level;
- (void)logArray:(NSArray*)array level:(NSInteger)level;

@end

@interface NSObject (PlistLogger)
- (void)logYourselfUsing:(PlistLogger*)logger;
- (NSString*)logString;
- (void)logYourselfLevel:(NSInteger)level using:(PlistLogger*)logger;
@end

NS_ASSUME_NONNULL_END
