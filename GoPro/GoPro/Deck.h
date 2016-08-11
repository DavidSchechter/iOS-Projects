//
//  Deck.h
//  GoPro
//
//  Created by Schechter, David on 8/10/16.
//  Copyright © 2016 DavidSchechter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
/*!
 @class Deck
 @abstract This class represents the a deck object that holds multiple card objects. This object simulates real deck of card, where the top card is a postion 0 and the bottom card is at the last position in the object.
 */
@interface Deck : NSObject

/*!
 Initializes a deck object that can hold n card objects.
 
 @param n
 Number of cards objects that the deck object can hold
 */
- (instancetype)initWithCapacity:(int)n;
/*!
 Initializes a deck object that holds n card objects.
 
 @param n
 Number of cards objects in the deck object
 */
- (instancetype)initWithNCards:(int)n;

/*!
 Removes the first card object from the deck object
 
 @result
 The top card object in the deck of object. Will be nil if deck object is empty.
 */
- (Card*)removeTopCard;

/*!
 Adds a card object to the start of the deck object. Will not add the card if the deck is already full
 
 @param card
 A card object to add
 @result
 True if added the card. False if did not
 */
- (Boolean)addCardToTopOfDeck:(Card*)card;

/*!
 Adds a card object to the end of the deck object. Will not add the card if the deck is already full
 
 @param card
 A card object to add
 @result
 True if added the card. False if did not
 */
- (Boolean)addCardToBottomOfDeck:(Card*)card;

/*!
 Returns the card object located at a specific index in the deck object
 
 @param i
 Location in the deck object
 @result
 A card object at the requested location. Will be nil if out of bounds.
 */
- (Card*)cardAtIndex:(int)i;

/*!
 Number of card objects int the deck object
 
 @result
 Number of card objects int the deck object
 */

- (int)count;

@end
