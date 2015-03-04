utf-8;134217984ate.h
//  CanNow
//
//  Created by David Schechter on 12/22/13.
//  Copyright (c) 2013 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSMutableArray *bannerImagesArray;

@end
