//
//  ResturantInfo.m
//  GoogleMapsSDKOliver
//
//  Created by David Schechter on 2/9/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

/*custom object to hold the relevant ifromation for a resturant*/

#import "ResturantInfo.h"

@implementation ResturantInfo

@synthesize name,address;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.name=@"";
        self.address=@"";
    }
    return self;
}




@end
