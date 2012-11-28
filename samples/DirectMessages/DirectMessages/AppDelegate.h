//
//  AppDelegate.h
//  DirectMessages
//
//  Created by John La Barge on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Facebook.h"
#import "DataSet.h"
#import <UIKit/UIKit.h>
#import "SendMessageController.h"
#import "ViewMessageController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {
     
    Facebook *facebook;
    DataSet *apiData;
    NSMutableDictionary *userPermissions;
    SendMessageController *sendMessageController;
    ViewMessageController *viewMessageController;
}

@property (nonatomic, retain) IBOutlet UINavigationController * sendMessageController;
@property (nonatomic, retain) IBOutlet UINavigationController * viewMessageController; 

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) Facebook *facebook;

@property (nonatomic, retain) DataSet *apiData;

@property (nonatomic, retain) NSMutableDictionary *userPermissions;


@property (strong, nonatomic) UITabBarController *tabBarController;

@end
