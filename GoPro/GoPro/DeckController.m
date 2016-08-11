//
//  DeckController.m
//  GoPro
//
//  Created by Schechter, David on 8/10/16.
//  Copyright © 2016 DavidSchechter. All rights reserved.
//

#import "DeckController.h"
#import "Deck.h"
#import "Card.h"

@implementation DeckController

- (int)calculateNumberOfRoundsNeededToReorderADeckOfSise:(int)n
{
    if (n<1)
    {
        return 0;
    }
    if (n==1)
    {
        return 1;
    }
    Deck *deckOfCards = [[Deck alloc] initWithNCards:n];
    
    int numberOfRounds = 0;
    
    @autoreleasepool {
        numberOfRounds = [self leasetCommonMultiple:[self calculateNumberOfRoundBackToOriginalPosition:[self shuffleCardsAlgorithm:deckOfCards]]];
    }

    return numberOfRounds;
}

/*!
 Shuffles the deck object accoring to the shuffiling algorithm
 
 @param deck
 The original deck object
 @result
 A new deck object after the shuffilng algorithm has being applied
 */
- (Deck*)shuffleCardsAlgorithm:(Deck*)deck
{
    //Create a new empty deck object
    Deck* tmpDeck = [[Deck alloc] initWithCapacity:deck.count];
    while(true)
    {
        //Remove one card from the top of the original deck object and add it to the top of the new deck object
        [tmpDeck addCardToTopOfDeck:[deck removeTopCard]];
        //If the original deck is empty - stop
        if (!deck.count)
        {
            break;
        }
        //Remove another card from the top of the original deck object
        Card* tmpCard = [deck removeTopCard];
        //If the original deck is not empty, add card to it's bottom
        if (deck.count)
        {
            [deck addCardToBottomOfDeck:tmpCard];
        }
        //If the original deck is empty, add the card to the top of the new deck object
        else
        {
            [tmpDeck addCardToTopOfDeck:tmpCard];
            break;
        }
    }
    return tmpDeck;
}

/*!
 Calculted to number of addtion shuffles need for each card to return to it's original position
 
 @param deck
 A deck object that the shuffling algorithm has been applied to
 @result
 An array with the same size as the deck object. Each place in the array is the number of rounds need to return the card object in the same location in deck object back to it's original position
 */
-(NSMutableArray*)calculateNumberOfRoundBackToOriginalPosition:(Deck*)deck
{
    //Create a new array with the same size of deck object
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:deck.count];
    //Fill each position with 1, for one round of the algorithm has been applied to each position in deck object
    for (int i=0;i<deck.count;i++)
    {
        [result addObject:@1];
    }
    //Start updating each position in the array
    for (int i=0;i<result.count;i++)
    {
        //Where should be start looking in the deck object
        int index = i;
        //Keep looking in the deck object until you find a card object with the same index as i
        while ([[deck cardAtIndex:index] index] != i)
        {
            //Update the index to look at next in the deck object
            index = [[deck cardAtIndex:index] index];
            //Update position i the the array with +1, as one more round is need to get to the original card
            result[i] = @([result[i] intValue] + 1);
        }
    }
    return result;
}

/*!
 Calculted the greatest common dividor between two number
 
 @param a
 A number
 @param b
 A number
 @result
 The greatest common dividor between m and n
 */
-(int)greatestCommonDivisorM:(int)a N:(int)b
{
        int c;
        while ( a != 0 ) {
            c = a; a = b%a; b = c;
        }
        return b;
}

/*!
 Calculted the least common multiple from an array of NSNumbers
 
 @param numbers
 An array of NSNumber
 @result
 The least common multiple for all the numbers in the array
 */
-(int)leasetCommonMultiple:(NSMutableArray*)numbers
{
    int res = 1;
    for (int i=0;i<numbers.count;i++)
    {
        int tmp = [numbers[i] intValue];
        res = res * tmp / [self greatestCommonDivisorM:res N:tmp];
    }
    return res;
}

@end
