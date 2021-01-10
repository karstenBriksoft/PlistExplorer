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


@implementation PlistExplorer

- (NSKeyedUnarchiver *) newUnarchiverWithData: (NSData*)data
{
	NSError* error = nil;
	CrackedUnarchiver* unarchiver = [[CrackedUnarchiver alloc] initForReadingFromData:data error:&error];
	if (error != nil)
	{
		NSLog(@"error reading data: %@",error);
	}
	else
	{
		unarchiver.cracker = self;
		unarchiver.decodingFailurePolicy = NSDecodingFailurePolicyRaiseException;
		unarchiver.requiresSecureCoding = NO;
	}
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

- (NSDictionary*)blobOfUnarchiver:(NSKeyedUnarchiver*)unarchiver
{
	NSDictionary* blob = [unarchiver _blobForCurrentObject];
	// blob has the keys of all objects + a @"$class" key
	return blob;
}


- (void) addMorphicNamed: (NSString *) className  
{
	Class newClass = objc_allocateClassPair([Morphic class], [className UTF8String],0);
	objc_registerClassPair(newClass);
}

- (id)crackUnarchiver:(NSKeyedUnarchiver*)unarchiver withData:(NSData*)data
{
	// return the unarchived object

	NSDictionary* blob = [self blobOfUnarchiver: unarchiver];
	for (NSString* key in blob.allKeys)
	{
		// there should be only one key in keys. At least only the first object is returned.
		BOOL error;
		do
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
					unarchiver = [self newUnarchiverWithData:data];
				}
				else 
				{
					NSLog(@"unhandled exception: %@",exception);
					exit(1);
				}
				error = YES;
			}
		} while (error == YES);
	}
	//	NSLog(@"dict: %@",dict);
	return nil;
}

- (NSDictionary*)crackFile:(NSString*)file
{
	NSData* data = [NSData dataWithContentsOfFile:file];
	NSKeyedUnarchiver* unarchiver = [self newUnarchiverWithData:data];

	return [self crackUnarchiver: unarchiver withData: data];
}
@end
