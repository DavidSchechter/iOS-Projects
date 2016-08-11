//
//  Card.h
//  GoPro
//
//  Created by Schechter, David on 8/10/16.
//  Copyright © 2016 DavidSchechter. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @class Card
 @abstract This class represents the a card object in a deck object. Each card has an index for it's original location in the deck
 */
@interface Card : NSObject

/*!
 Initializes a card with an index
 
 @param index
 Original position of the card in a deck
 
 */
- (instancetype)initWithIndex:(int)index;

/*!
 Holds the original location of the card in a deck
 
 @property index
 Original position of the card in a deck
 */
@property (nonatomic,assign) int index;

@end
