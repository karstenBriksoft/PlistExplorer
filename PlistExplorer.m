//
//  PlistExplorer.m
//  PlistExplorer
//
//  Created by Karsten Kusche on 13.01.10.
//  Copyright 2010 Briksoftware.com. All rights reserved.
//

#import "PlistExplorer.h"
#import "Morphic.h"
#import "CrackedUnarchiver.h"
#import "objc/objc-class.h"

@interface NSKeyedUnarchiver (PlistExplorer)

- (id)_blobForCurrentObject; // returns the current blob object
- (void)setClass:(Class)arg1 forClassName:(NSString*)name;
- (void)reset;

@end

@implementation NSObject (PlistExplorer)

- (void)logYourself
{
	[self logYourselfLevel:1];
}

- (NSString*)logString
{
	return [self description];
}

- (void)logYourselfLevel:(NSInteger)level
{
	printf("%s\n",[[NSString stringWithFormat:@"%@%@",[self gapForLevel:level],[self logString]] UTF8String]);
}

- (NSString*)gapForLevel:(NSInteger)level
{
	NSMutableString* gap = [NSMutableString stringWithCapacity:level*2];
	int i;
	for (i = 0; i< level; i++)
	{
		[gap appendString:@"  "]; 
	}
	return gap;
}

@end

@implementation NSArray (PlistExplorer)

- (void)logYourselfLevel:(NSInteger)level
{
	for (id obj in self)
	{
		[obj logYourselfLevel: level + 1];
	}
}

@end

@implementation NSDictionary (PlistExplorer)

- (void)logYourselfLevel:(NSInteger)level
{
	for (NSString* key in [self allKeys])
	{
		id obj = [self objectForKey:key];
		[key logYourselfLevel: level + 1];
		[obj logYourselfLevel: level + 3];
	}
}

@end


@implementation NSData (PlistExplorer)

- (NSString*)logString
{
	// description of NSData is a bit too long, just write something usefull
	return [NSString stringWithFormat: @"NSData with: %i Bytes",[self length]];
}

@end

@implementation PlistExplorer

- (NSKeyedUnarchiver *) newUnarchiver 
{
	CrackedUnarchiver* unarchiver = [[CrackedUnarchiver alloc] initForReadingWithData:data];
	[unarchiver setCracker:self];
	return unarchiver;
}

- (NSString*)getClassNameFromException:(NSException*)exception
{
	// parse the exception's reason for the name of the class that it wanted to unarchive

	NSString* reason = [exception reason];
	NSScanner* scanner = [NSScanner scannerWithString:reason];
	NSString* prefix;
	[scanner scanString:@"*** -[CrackedUnarchiver decodeObjectForKey:]: cannot decode object of class (" intoString:&prefix];
	NSString* name;
	[scanner scanUpToString:@")" intoString:&name];
	return name;
}

- (NSArray*)keysOfUnarchiver:(NSKeyedUnarchiver*)unarchiver
{
	NSDictionary* blob = [unarchiver _blobForCurrentObject];
	// blob has the keys of all objects + a @"$class" key
	return [blob allKeys];
}


- (void) addMorphicNamed: (NSString *) className  
{
	Class newClass = objc_allocateClassPair([Morphic class], [className UTF8String],0);
	objc_registerClassPair(newClass);
}

- (id)crackUnarchiver:(NSKeyedUnarchiver*)unarchiver
{
	// return the unarchived object

	NSArray* keys = [self keysOfUnarchiver: unarchiver];
	for (NSString* key in keys)
	{
		// there should be only one key in keys. At least only the first object is returned.
		BOOL error = YES;
		while (error)
		{
			// try until it is cracked
			@try 
			{
				error = NO;
				return [unarchiver decodeObjectForKey:key];
				
			}
			@catch (NSException* exception)
			{
				if ([[exception name] isEqual:NSInvalidUnarchiveOperationException])
				{
					// too bad the exception doesn't have the class's name in its info dictionary.
					// actually this could probably be swizzled into appkit..
					NSString* className = [self getClassNameFromException: exception];
					[self addMorphicNamed: className];
					unarchiver = [self newUnarchiver];
				}
				else 
				{
					NSLog(@"unhandled exception: %@",exception);
					exit(1);
				}
				error = YES;
			}
		}
	}
	//	NSLog(@"dict: %@",dict);
	return nil;
}

- (NSDictionary*)crackFile:(NSString*)aFile
{
	file = aFile;
	data = [NSData dataWithContentsOfFile:file];
	NSKeyedUnarchiver* unarchiver = [self newUnarchiver];

	return [self crackUnarchiver: unarchiver];
}
@end
