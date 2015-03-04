//
//  ViewController.m
//  GoogleMapsSDKOliver
//
//  Created by David Schechter on 2/7/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapView,tableFields;

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //initailize all data structures and flags
    
    markersArray = [[NSMutableArray alloc] init];
    allMarkersArray = [[NSMutableArray alloc] init];
    
    allMarkersInfo = [[NSMutableArray alloc] init];
    clusterdMarkersInfo = [[NSMutableArray alloc] init];
    clusterdMarkersSubMarkers = [[NSMutableArray alloc] init];
    
    zoomInMarkersArray = [[NSMutableArray alloc] init];
    zoomInMarkersInfoArray = [[NSMutableArray alloc] init];
    
    currentNumberOfItemsForTable=0;
    
    firstTime=YES;
    tableisOpen=false;
    
    zoomedInByClickingMarker=false;
    zoomedByCode=false;
    
    self.title = @"Google Maps in iOS";
    
    //Controls whether the My Location dot and accuracy circle is enabled.
    self.mapView.myLocationEnabled = YES;
    //Controls the type of map tiles that should be displayed.
    self.mapView.mapType = kGMSTypeNormal;
    //Shows the compass button on the map
    self.mapView.settings.compassButton = YES;
    //Shows the my location button on the map
    self.mapView.settings.myLocationButton = YES;
    //Sets the view controller to be the GMSMapView delegate
    self.mapView.delegate = self;
    
    allAnnotationsMapView=[[GMSMapView alloc] initWithFrame:self.mapView.frame];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    if ([locationManager respondsToSelector:(@selector(requestWhenInUseAuthorization))])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some parameters for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
}

#pragma mark CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.myLocationEnabled = YES;
        if (firstTime)
        {
            [locationManager startUpdatingLocation];
        }
    }
    else
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = 40.783435;
        coordinate.longitude = -73.966249;
        currentCentre=coordinate;
        GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coordinate zoom:13.0f];
        
        [self.mapView animateWithCameraUpdate:updatedCamera];
        
        [allAnnotationsMapView animateWithCameraUpdate:updatedCamera];

    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    if (firstTime)
//    {
    CLLocation *newLocation = locations[[locations count] -1];
    CLLocation *currentLocation = newLocation;
    //CLLocationCoordinate2D centre=[position coordinate];
    if ([currentLocation coordinate].latitude!=currentCentre.latitude || [currentLocation coordinate].longitude!=currentCentre.longitude)
    {
        currentCentre=[currentLocation coordinate];
        currenDist = 10;
        GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:currentLocation.coordinate zoom:13.0f];
        
        [self.mapView animateWithCameraUpdate:updatedCamera];
        
        [allAnnotationsMapView animateWithCameraUpdate:updatedCamera];
        
        [locationManager stopUpdatingLocation];
    }
    
//    }
}

#pragma mark Google Places API methods

/*method to query Google Place API*/

-(void) queryGooglePlaces: (NSString *) googleType
{
    
    
    // Build the url string we are going to sent to Google. NOTE: The kGOOGLE_API_KEY is a constant which should contain your own API key that you can obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
    
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL options:NSDataReadingUncached error:&error];
        if (error) {
            NSLog(@"the error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Data has loaded successfully.");
        }
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

/*method to pasrse the data from Google Place API*/

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData

                          options:kNilOptions
                          error:&error];

    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];

    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);

    //Plot the data in the places array onto the map with the plotPostions method.
    [self plotPositions:places];


}

/*method to create markers for all location returned by Google Place API*/

- (void)plotPositions:(NSArray *)data
{
//    //Remove any existing custom annotations but not the user location blue dot.
    if ([markersArray count]>0)
    {
        for (int i=0; i<markersArray.count;i++)
        {
            GMSMarker *marker=markersArray[i];
            marker.map=nil;
        }
    }
    if ([zoomInMarkersArray count]>0)
    {
        for (GMSMarker* marker in zoomInMarkersArray)
        {
            marker.map=nil;
        }
    }

    if ([data count]==0)
    {
        return;
    }


    //Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++)
    {

        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];

        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];


        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        ResturantInfo *tmpInfo=[[ResturantInfo alloc] init];
        tmpInfo.name=name;
        tmpInfo.address=vicinity;

        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];

        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;

        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];

        //Create a new annotiation.
        
        GMSMarker *marker=[self createMarker:@"1" forMap:allAnnotationsMapView andLocation:placeCoord];
        
        [allMarkersArray addObject:marker];
        [allMarkersInfo addObject:tmpInfo];
    }
    
    [self updateMarkers];
}

#pragma mark Clustering methods

/*method to check if a certian marker is inside a rectangle on the map*/

-(NSMutableArray*)checkForMarkerInRect:(CGRect)rect
{
    GMSProjection *projection = self.mapView.projection;
    
    CLLocationCoordinate2D southWestEdge = [projection coordinateForPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)];
    CLLocationCoordinate2D northEastEdge = [projection coordinateForPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)];
    
    NSMutableArray *markers = [NSMutableArray array];
    NSMutableArray *infos = [NSMutableArray array];
    
    for (int i=0;i<[allMarkersArray count];i++)
    {
        GMSMarker *marker=allMarkersArray[i];
        ResturantInfo *info=allMarkersInfo[i];
        if (marker.position.latitude>=southWestEdge.latitude && marker.position.latitude<=northEastEdge.latitude && marker.position.longitude<=northEastEdge.longitude && marker.position.longitude>=southWestEdge.longitude)
        {
            [markers addObject:marker];
            [infos addObject:info];
        }
    }
    
    return [NSMutableArray arrayWithObjects:markers,infos, nil];
}

/*method to cluster all the marker by a 100px X 100px square basis*/

-(void)updateMarkers
{
    double gridSize=100.0;
    CGRect visibleMapRect = self.mapView.frame;
    double startX = 0.0;
    double startY = 0.0;
    double endX = CGRectGetMaxX(visibleMapRect);
    double endY = CGRectGetMaxY(visibleMapRect);
    CGRect checkRect=CGRectMake(0, 0, gridSize, gridSize);
    while (startX<endX)
    {
        checkRect.origin.x=startX;
        while (startY<endY)
        {
            checkRect.origin.y=startY;
            NSMutableArray *markersAndInfoInVisableGrid=[self checkForMarkerInRect:checkRect];
            NSMutableArray *markersInVisableGrid=markersAndInfoInVisableGrid[0];
            NSMutableArray *infoInVisableGrid=markersAndInfoInVisableGrid[1];
            NSString *title=[NSString stringWithFormat:@"%lu",(unsigned long)[markersInVisableGrid count]];
            if ([markersInVisableGrid count]!=0)
            {
                CLLocationCoordinate2D placeCoord=[self.mapView.projection coordinateForPoint:CGPointMake(checkRect.origin.x+checkRect.size.width/2, checkRect.origin.y + checkRect.size.height/2)];
                GMSMarker* marker=[self createMarker:title forMap:self.mapView andLocation:placeCoord];
                [markersArray addObject:marker];
                [clusterdMarkersInfo addObject:infoInVisableGrid];
                [clusterdMarkersSubMarkers addObject:markersInVisableGrid];
            }
            startY+=gridSize;
        }
        startY=0;
        startX+=gridSize;
    }
    

}

/*method to create a marker for a map and a location on the map*/

-(GMSMarker*)createMarker:(NSString*)numberString forMap:(GMSMapView *)tmpMapView andLocation:(CLLocationCoordinate2D)placeCoord
{
    GMSMarker *marker = [GMSMarker markerWithPosition:placeCoord];
//    marker.title = name;
//    marker.snippet = vicinity;
    marker.map = tmpMapView;
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    marker.icon = [GMSMarker markerImageWithColor:randColor];
    
    //setup view
    double newSize = 30.0;
    UIView *circView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    CGPoint saveCenter = circView.center;
    CGRect newFrame = CGRectMake(circView.frame.origin.x, circView.frame.origin.y, newSize, newSize);
    circView.frame = newFrame;
    circView.layer.cornerRadius = newSize / 2.0;
    circView.center = saveCenter;
    circView.backgroundColor=[randColor colorWithAlphaComponent:1.0];
    
    //setup label
    NSString *tmpStr=numberString;
    UILabel *label;
    if ([tmpStr length]>1)
        label = [[UILabel alloc] initWithFrame:CGRectMake(circView.center.x-3, circView.center.y, 20, 10)];
    else
        label = [[UILabel alloc] initWithFrame:CGRectMake(circView.center.x, circView.center.y, 20, 10)];
    label.text = tmpStr;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.backgroundColor = [randColor colorWithAlphaComponent:1.0];
    [circView addSubview:label];
    
    //grab it
    UIGraphicsBeginImageContextWithOptions(circView.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [circView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //prepare options
    marker.icon = icon;
    
    return marker;
}

#pragma mark GMSMapViewDelegate methods

-(void)mapView:(GMSMapView *)tmpMapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    GMSVisibleRegion visibleRegion = self.mapView.projection.visibleRegion;
    
    CLLocationDistance verticalDistance = GMSGeometryDistance(visibleRegion.farLeft, visibleRegion.nearLeft);
    CLLocationDistance horizontalDistance = GMSGeometryDistance(visibleRegion.farLeft, visibleRegion.farRight);
    CLLocationDistance radiusForREgion=MAX(horizontalDistance, verticalDistance)*0.5;
    
    CGPoint point = tmpMapView.center;
    CLLocationCoordinate2D otherCentre = [tmpMapView.projection coordinateForPoint:point];
    
    currentCentre=otherCentre;
    
    
    currenDist=radiusForREgion;
    
    if (!zoomedInByClickingMarker)
    {
        [self queryGooglePlaces:@"restaurant"];
        firstTime=NO;
    }
    else
    {
        NSMutableArray *subMarkers=clusterdMarkersSubMarkers[currentNumberOfItemsForTable];
        for (GMSMarker* subMarker in subMarkers)
        {
            GMSMarker* tmpMarker=[self createMarker:@"1" forMap:self.mapView andLocation:subMarker.position];
            [zoomInMarkersArray addObject:tmpMarker];
        }
        zoomInMarkersInfoArray=clusterdMarkersInfo[currentNumberOfItemsForTable];
        
        zoomedByCode=false;

    }

    
}

-(BOOL) mapView:(GMSMapView *) mapView didTapMarker:(GMSMarker *)marker
{
    NSLog(@"try");
    CGFloat currentZoom = self.mapView.camera.zoom;
    if (zoomedInByClickingMarker)
    {
        for (int i;i<[zoomInMarkersArray count];i++)
        {
            GMSMarker *tmpMarker=zoomInMarkersArray[i];
            if (tmpMarker==marker)
            {
                currentNumberOfItemsForTable=i;
                i=(int)[zoomInMarkersArray count]+1;
            }
        }
    }
    else
    {
        for (int i;i<[markersArray count];i++)
        {
            GMSMarker *tmpMarker=markersArray[i];
            if (tmpMarker==marker)
            {
                currentNumberOfItemsForTable=i;
                i=(int)[markersArray count]+1;
            }
        }
    }
    if (currentZoom>14)
    {
        tableFields=[[UITableView alloc] initWithFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y+self.mapView.frame.size.height-300, self.mapView.frame.size.width, 300)];
        tableFields.dataSource=self;
        tableFields.delegate=self;
        tableisOpen=true;
        [self.view addSubview:tableFields];
        
    }
    else
    {
        marker.map=nil;
        zoomedInByClickingMarker=true;
        [self zoomAndDeclusterOnThisCoordinate:marker.position];
    }
    return YES;
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (tableisOpen)
    {
        [tableFields removeFromSuperview];
        tableisOpen=false;
    }
}

-(void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (tableisOpen)
    {
        [tableFields removeFromSuperview];
        tableisOpen=false;
    }
}

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if (tableisOpen)
    {
        [tableFields removeFromSuperview];
        tableisOpen=false;
    }
    if (zoomedInByClickingMarker && !zoomedByCode)
    {
        zoomedInByClickingMarker=false;
    }
}

/*method to only zoom in on 100px X 100px square the a marker represent and decluster only it*/

-(void)zoomAndDeclusterOnThisCoordinate:(CLLocationCoordinate2D)coordinate
{
    zoomedByCode=true;
    
    GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coordinate zoom:15.0f];
    
    [self.mapView animateWithCameraUpdate:updatedCamera];
}


#pragma mark UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    if (zoomedInByClickingMarker)
        return 1;
    else
        return [clusterdMarkersInfo[currentNumberOfItemsForTable] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"CardsRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    ResturantInfo *tmpInfo=clusterdMarkersInfo[currentNumberOfItemsForTable][indexPath.row];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,300,50)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,aView.frame.size.width-50,aView.frame.size.height/2 )];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, aView.frame.size.height/2 ,aView.frame.size.width-50,aView.frame.size.height/2 )];
    nameLabel.text=[NSString stringWithFormat:@"%@",tmpInfo.name];
    addressLabel.text=[NSString stringWithFormat:@"%@",tmpInfo.address];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    addressLabel.adjustsFontSizeToFitWidth = YES;
    [aView setBackgroundColor:[UIColor whiteColor]];
    [aView addSubview:nameLabel];
    [aView addSubview:addressLabel];
    [cell addSubview:aView];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
