/*
 *  PlistExplorerMain.c
 *  PlistExplorer
 *
 *  Created by Karsten Kusche on 13.01.10.
 *  Copyright 2010 Briksoftware.com. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import <sysexits.h>
#import "PlistExplorer.h"

int main(int argc, char* argv[])
{
	@autoreleasepool
	{
		NSString* path = nil;
		if (argc > 1)
		{
			path = [[NSString alloc] initWithUTF8String:argv[1]];
		}
		else
		{
			printf("usage: %s <filename>\n",argv[0]);
			return EX_USAGE;
		}
		PlistExplorer* explorer = [[PlistExplorer alloc] init];
		id res = [explorer crackFile:path];
		[res logYourself];
	}
	return EX_OK;
}