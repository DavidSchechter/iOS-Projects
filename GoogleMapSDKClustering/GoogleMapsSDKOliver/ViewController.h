//
//  ViewController.h
//  GoogleMapsSDKOliver
//
//  Created by David Schechter on 2/7/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ResturantInfo.h"

#define kGOOGLE_API_KEY @"AIzaSyBDWGkz_E0cM18VFZTa5UETSiZYdEMXK34"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ViewController : UIViewController <GMSMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CLLocationManager *locationManager;
    NSMutableArray *markersArray;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    
    bool firstTime;
    
    NSMutableArray *cardsArray;
    bool tableisOpen;
    
    GMSMapView *allAnnotationsMapView;
    NSMutableArray *allMarkersArray;
    
    NSMutableArray *allMarkersInfo;
    NSMutableArray *clusterdMarkersInfo;
    NSMutableArray *clusterdMarkersSubMarkers;
    
    int currentNumberOfItemsForTable;
    
    bool zoomedInByClickingMarker;
    bool zoomedByCode;
    
    NSMutableArray *zoomInMarkersArray;
    NSMutableArray *zoomInMarkersInfoArray;

    
}

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableFields;

@end

