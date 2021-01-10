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
#import "PlistLogger.h"
#import "PlistStringLogger.h"

int main(int argc, char* argv[])
{
	@autoreleasepool
	{
		Class loggerClass = [PlistStringLogger class];
		NSArray* args = [[NSProcessInfo processInfo] arguments];
		NSArray* paths = [args subarrayWithRange:NSMakeRange(1, args.count - 1)];
		if (paths.count == 0)
		{
			printf("usage: %s <filename>\n",argv[0]);
			return EX_USAGE;
		}
		for (NSString* path in paths)
		{
			PlistExplorer* explorer = [[PlistExplorer alloc] init];
			PlistLogger* logger = [[loggerClass alloc] init];
			id res = [explorer crackFile:path];
			[res logYourselfUsing:logger];
		}
	}
	return EX_OK;
}
