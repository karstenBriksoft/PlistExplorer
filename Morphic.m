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

- (void)logYourselfLevel:(NSInteger)level
{
	// the information about the object
	printf("%s\n",[[NSString stringWithFormat:@"%@%@",[self gapForLevel:level],[self className]] UTF8String]);
	
	// the information about the object's properties
	for (NSString* key in [data allKeys])
	{
		id object = [data objectForKey:key];
		[key logYourselfLevel: level+1];
		[object logYourselfLevel: level+3];
	}
}
@end
