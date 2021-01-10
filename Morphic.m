//
//  Morphic.m
//  PlistExplorer
//
//  Created by Karsten Kusche on 13.01.10.
//  Copyright 2010 Briksoftware.com. All rights reserved.
//

#import "Morphic.h"
#import "PlistExplorer.h"
#import "CrackedUnarchiver.h"
#import "PlistLogger.h"

@implementation Morphic
{
	NSMutableDictionary* data;
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		data = [NSMutableDictionary dictionary];
	}
	return self;
}

- (id)initWithCoder:(NSKeyedUnarchiver*)unarchiver
{
	self = [self init];
	NSDictionary* blob = [[(CrackedUnarchiver*)unarchiver cracker] blobOfUnarchiver:unarchiver];

	for (NSString* key in blob.allKeys)
	{
		id obj = [blob objectForKey:key];
		// if the value is a property-list compatible object, it's something like a number. If it's not compatible, it needs to be decoded seperately
		CFTypeID typeID = CFGetTypeID((__bridge CFTypeRef)(obj));
		// test if the object is a CFKeyedArchiverUID
		if (typeID == 0x29)
		{
			obj = [unarchiver decodeObjectForKey:key];
			if (obj == nil)
			{
				// nil wouldn't be shown, so use a string @"nil"
				obj = @"nil";
			}
		}
		[data setObject: obj forKey:key];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone	// needed for some kinds of Core Data "layout" files
{
    return [self class];	// not sure if this is the right thing to return, but it avoids crashes
}

- (void)logYourselfLevel:(NSInteger)level using:(PlistLogger*)logger
{
	if ([logger tryLogObject:self] == NO) {
		// already printed once before
		[logger logStringOfObject:@"(recursion)" level:level];
	}
	else
	{
		// the information about the object
		[logger logStringOfObject:self.className level:level];

		// the information about the object's properties
		NSArray *keys = [data allKeys];
		keys = [keys sortedArrayUsingSelector:@selector(compare:)];

		for (NSString* key in keys)
		{
			id object = [data objectForKey:key];
			[logger logKey:key level:level];
			[logger logValue:object level:level];
		}
	}
}
@end
