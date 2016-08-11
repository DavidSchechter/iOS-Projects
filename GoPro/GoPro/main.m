//
//  main.m
//  GoPro
//
//  Created by Schechter, David on 8/9/16.
//  Copyright © 2016 DavidSchechter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeckController.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //Check if there wasn't a number of cards provided
        if(argc < 2) {
            printf("\nMissing number of cards varialbe to run program\n");
            return -1;
        }
        //Check if there too many arguments were provided
        else if(argc > 2) {
            printf("\nToo many varialbes provided. Program needs only one\n");
            return -1;
        }
        //Get the number of cards provided as an argument
        int numberOfCards = atoi(argv[1]);
        //Create an instance of the DeckController
        DeckController* controller = [DeckController new];
        //Calculate the of rounds need to re-shuffle a deck with the provided number of card
        int numberOfRounds = [controller calculateNumberOfRoundsNeededToReorderADeckOfSise:numberOfCards];
        
        // Print the result to standard output (console).
        printf("\nA deck with %d cards will take %d rounds to shuffle back into order.\n\n",
               numberOfCards, numberOfRounds);
    }
    return 0;
}
