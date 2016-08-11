//
//  DeckController.h
//  GoPro
//
//  Created by Schechter, David on 8/10/16.
//  Copyright © 2016 DavidSchechter. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @class DeckController
 @abstract This class implements a controller that work with the deck model object.
 */
@interface DeckController : NSObject

/*!
 Applies shuffling algorith to deck objects and calculates the number of additional shuffles need to get back to the original order
 
 @param n
 The number of cards objects in the deck object to calculate
 @result
 The calculated number of additional shuffles
 */
- (int)calculateNumberOfRoundsNeededToReorderADeckOfSise:(int)n;

@end
