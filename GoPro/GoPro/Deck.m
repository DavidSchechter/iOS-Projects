//
//  Deck.m
//  GoPro
//
//  Created by Schechter, David on 8/10/16.
//  Copyright © 2016 DavidSchechter. All rights reserved.
//

#import "Deck.h"

@interface Deck ()
{
    NSMutableArray* deckOfCards;
    int capacity;
}
@end

@implementation Deck


- (instancetype)initWithCapacity:(int)n
{
    self = [super init];
    if (self) {
        deckOfCards = [[NSMutableArray alloc] initWithCapacity:n];
        capacity = n;
    }
    return self;
}

- (instancetype)initWithNCards:(int)n
{
    self = [super init];
    if (self) {
        deckOfCards = [[NSMutableArray alloc] initWithCapacity:n];
        capacity = n;
        [self createNCardAndAddToDeck:n];
    }
    return self;
}

- (void)createNCardAndAddToDeck:(int)n
{
    for (int i =0;i<n;i++)
    {
        Card* tmpCard = [[Card alloc] initWithIndex:i];
        [deckOfCards addObject:tmpCard];
    }
}

- (Card*)removeTopCard
{
    Card* result = nil;
    if ([deckOfCards count]>0)
    {
        result = [deckOfCards firstObject];
        [deckOfCards removeObject:result];
    }
    return result;
}

- (Boolean)addCardToTopOfDeck:(Card*)card
{
    if ([deckOfCards count]==capacity)
    {
        return false;
    }
    else
    {
        [deckOfCards insertObject:card atIndex:0];
        return true;
    }
}

- (Boolean)addCardToBottomOfDeck:(Card*)card
{
    if ([deckOfCards count]==capacity)
    {
        return false;
    }
    else
    {
        [deckOfCards addObject:card];
        return true;
    }
}

- (Card*)cardAtIndex:(int)i
{
    Card* result = nil;
    if (i>=0 && i<[deckOfCards count])
    {
        result = [deckOfCards objectAtIndex:i];
    }
    return result;
}

- (int)count
{
    return deckOfCards.count;
}

@end
