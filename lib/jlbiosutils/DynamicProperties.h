//
//  DynamicProperties.h
//  headstand2
//
//  Created by John La Barge on 11/26/11.
//  Copyright (c) 2011 Smarty Pants LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

static void DynamicSetter(id self, SEL _cmd, id value);
static id DynamicGetter(id self, SEL _cmd);
static NSString* PropertyNameFromSetter(NSString *setterName);

@interface DynamicProperties : NSObject { 
 
    NSMutableDictionary* properties; 
    
}
-(id)initWithData:(NSData *)data;
-(id)initWithFile:(NSString *)file;
-(id)init;

-(BOOL) storeToFile:(NSString *)file;


@property (nonatomic,retain) NSMutableDictionary * properties; 

@end
