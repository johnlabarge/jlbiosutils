//
//  DynamicProperties.m
//  headstand2
//
//  Created by John La Barge on 11/26/11.
//  Copyright (c) 2011 Smarty Pants Solutions LLC. All rights reserved.
//

#import "DynamicProperties.h"
#import <objc/runtime.h>


static NSString* PropertyNameFromSetter(NSString *setterName)
{
    setterName = [setterName substringFromIndex:3];                // Remove "set"
    NSString *firstChar = [[setterName substringToIndex:1] lowercaseString];
    NSString *tail = [setterName substringFromIndex:1];
    tail = [tail substringToIndex:[tail length] - 1];        // Remove ":"
    return [firstChar stringByAppendingString:tail];        // Convert first char to lowercase.
}


static id DynamicGetter(id self, SEL _cmd)
{
    DynamicProperties *dyno = (DynamicProperties *)self; 
    return [dyno.properties objectForKey:NSStringFromSelector(_cmd)];
}


static void DynamicSetter(id self, SEL _cmd, id value)
{
    NSString *key = PropertyNameFromSetter(NSStringFromSelector(_cmd));
    DynamicProperties * dyno = (DynamicProperties *) self;
    
    if (value == nil)
    {
        [dyno.properties removeObjectForKey:key];
    }
    else
    {
        [dyno.properties setObject:value forKey:key];
    }
}


@implementation DynamicProperties
@synthesize properties;

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selStr = NSStringFromSelector(sel);
    // Only handle selectors beginning with "set", ending with a colon and with no intermediate colons.
    // Also, to simplify PropertyNameFromSetter, we requre a length of at least 5 (2 + "set").
    if ([selStr hasPrefix:@"set"] &&
        [selStr hasSuffix:@":"] &&
        [selStr rangeOfString:@":" options:0 range:NSMakeRange(0, [selStr length] - 1)].location == NSNotFound &&
        [selStr length] >= 6)
    {
        NSLog(@"Generating dynamic accessor -%@ for property \"%@\"", selStr, PropertyNameFromSetter(selStr));
        return class_addMethod(self, sel, (IMP)DynamicSetter, @encode(id(*)(id, SEL, id)));
    }
    else if ([selStr rangeOfString:@":"].location == NSNotFound) 
    {
    
        NSLog(@"Generating dynamic accessor -%@", selStr);
        return class_addMethod(self, sel, (IMP)DynamicGetter, @encode(id(*)(id, SEL)));

    }
    else
    {
        return [super resolveInstanceMethod:sel];
    }
}

-(id)initWithFile:(NSString *)file 
{
    BOOL fileExists =  [
                        [NSFileManager defaultManager] 
                        fileExistsAtPath:file
                        ];
    
    if (fileExists) {
        NSData * data = [NSData dataWithContentsOfFile:file]; 
        return [self initWithData:data]; 

    } else { 
        NSLog(@"Error: no such file:%@, initializing empty dictionary.", file);
        self.properties = [[NSMutableDictionary alloc] init];
    }
    return self;
    
}

-(id)initWithData:(NSData *)data
{
    self.properties = [NSJSONSerialization 
                 JSONObjectWithData:data
                 options:NSJSONReadingMutableContainers
                       error:nil];   
    return self;
}

-init {
    self.properties = [[NSMutableDictionary alloc]init];
    return self;
}

-(BOOL) storeToFile:(NSString *)file { 
    NSData * dataToWrite = [NSJSONSerialization dataWithJSONObject:self.properties 
                                                           options:NSJSONWritingPrettyPrinted 
                                                             error:nil]; 
    return [dataToWrite writeToFile:file atomically:YES]; 

}
/** an idea I'm toying with but not quite ready to complete 
 - (void)observeValueForKeyPath:(NSString *)keyPath

                      ofObject:(id)object

                        change:(NSDictionary *)change

                       context:(void *)context

{
    NSString *selectorName = [NSString stringWithFormat:@"set%@:",keyPath]; 
    SEL setter = NSSelectorFromString(selectorName); 
    NSMethodSignature * setterSig = [NSMutableArray
                                    instanceMethodSignatureForSelector:setter];
    NSInvocation * setterInvocation = [NSInvocation
                                invocationWithMethodSignature:setterSig];
    
    NSObject * arg = [[change objectForKey:NSKeyValueChangeNewKey] copy]; 
    [setterInvocation setTarget:self]; 
    [setterInvocation setSelector:setter]; 
    [setterInvocation setArgument:&arg atIndex:2]; 
    [setterInvocation invoke]; 
    [self changed];

}
*/

@end
