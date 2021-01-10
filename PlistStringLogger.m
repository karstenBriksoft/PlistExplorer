//
//  PlistStringLogger.m
//  PlistExporer
//
//  Created by Karsten Kusche on 10.01.21.
//

#import "PlistStringLogger.h"

@implementation PlistStringLogger

- (void)logStringOfObject:(id)object level:(NSInteger)level
{
	for (NSInteger i = 0; i < level; i++)
	{
		printf("  ");
	}
	printf("%s\n",[object logString].UTF8String);
}

@end
