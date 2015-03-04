//
//  BguWhereIsItAppDelegate.h
//  BguWhereIsIt
//
//  Created by David Schechter on 07/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BguWhereIsItAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	IBOutlet UINavigationController *firstNavigationController;
	IBOutlet UINavigationController *secondNavigationController;
	IBOutlet UINavigationController *thirdNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *firstNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *secondNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *thirdNavigationController;

@end
