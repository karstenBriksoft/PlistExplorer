//
//  PlistLogger.m
//  PlistExporer
//
//  Created by Karsten Kusche on 10.01.21.
//

#import "PlistLogger.h"

@implementation NSString (PlistLogger)

- (NSString*)logString
{
	return self;
}

@end

@implementation NSObject (PlistLogger)

- (void)logYourselfUsing:(PlistLogger*)logger
{
	[self logYourselfLevel:0 using: logger];
}

- (NSString*)logString
{
	return [self description];
}

- (void)logYourselfLevel:(NSInteger)level using:(PlistLogger*)logger
{
	[logger logStringOfObject:self level:level];
}

@end

@implementation NSArray (PlistLogger)

- (void)logYourselfLevel:(NSInteger)level using:(PlistLogger*)logger
{
	[logger logArray: self level: level];
}

@end

@implementation NSDictionary (PlistLogger)

- (void)logYourselfLevel:(NSInteger)level using:(PlistLogger*)logger
{
	// the information about the object's properties
	NSArray *keys = [self allKeys];
	keys = [keys sortedArrayUsingSelector:@selector(compare:)];

	for (NSString* key in keys)
	{
		id obj = [self objectForKey:key];
		[logger logKey:key level:level];
		[logger logValue:obj level:level];
	}
}

@end


@implementation NSData (PlistLogger)

- (NSString*)logString
{
	// description of NSData is a bit too long, just write something usefull
	return [NSString stringWithFormat: @"NSData with: %tu Bytes",[self length]];
}

@end

@interface PlistLogger ()

@property (retain) NSMutableSet* visitedObjects;

@end

@implementation PlistLogger

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		// visited objects are used only for Morphics
		_visitedObjects = [NSMutableSet new];
	}
	return self;
}

- (void)logStringOfObject:(id)object level:(NSInteger)level
{
	
}

- (BOOL)tryLogObject:(id)object
{
	if ([_visitedObjects containsObject:object]) return NO;
	[_visitedObjects addObject:object];
	return YES;
}

- (void)logKey:(id)object level:(NSInteger)level
{
	[object logYourselfLevel:level + 1 using:self];
}

- (void)logValue:(id)object level:(NSInteger)level
{
	[object logYourselfLevel:level + 3 using:self];
}

- (void)logArray:(NSArray *)array level:(NSInteger)level
{
	for (id obj in array)
	{
		[obj logYourselfLevel:level+1 using:self];
	}
}
@end
