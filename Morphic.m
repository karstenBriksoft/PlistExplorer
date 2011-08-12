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

@implementation Morphic

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
	NSArray* keys = [[(CrackedUnarchiver*)unarchiver cracker] keysOfUnarchiver:unarchiver];

	for (NSString* key in keys) 
	{
		id obj = [unarchiver decodeObjectForKey:key];
		if (obj == nil)
		{
			// nil wouldn't be shown, so use a string @"nil"
			obj = @"nil";
		}
		[data setObject: obj forKey:key];
	}
	return self;
}

- (void)logYourselfLevel:(NSInteger)level recordingVisitedObjects:(NSMutableSet*)visitedObjects
{
	if ([visitedObjects containsObject:self]) {
		// already printed once before
		printf("%s\n",[[NSString stringWithFormat:@"%@%@",[self gapForLevel:level],@"(recursion)"] UTF8String]);
	}
	else
	{
		[visitedObjects addObject:self];

		// the information about the object
		printf("%s\n",[[NSString stringWithFormat:@"%@%@",[self gapForLevel:level],[self className]] UTF8String]);
		
		// the information about the object's properties
		NSArray *keys = [data allKeys];
		keys = [keys sortedArrayUsingComparator:^(id obj1, id obj2) {
			return [(NSString*)obj1 compare:obj2];
		}];

		for (NSString* key in keys)
		{
			id object = [data objectForKey:key];
			[key logYourselfLevel:level+1 recordingVisitedObjects:visitedObjects];
			[object logYourselfLevel:level+3 recordingVisitedObjects:visitedObjects];
		}
	}
}
@end
