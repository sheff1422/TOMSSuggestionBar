//
//  TOMSSuggestionDelegate.h
//  Pods
//
//  Created by Tom König on 17/06/14.
//
//

#import <Foundation/Foundation.h>

@class TOMSSuggestionBar;

@protocol TOMSSuggestionDelegate <NSObject>

@optional

/**
 Gets called when a suggestion tile is tapped.
 
 @param suggestionBar The suggestionBar containing the tapped tile.
 @param suggestion The text on the tapped tile.
 @param associatedObject The instance fetched from CoreData that is represented by the tapped text.
 */
- (void)suggestionBar:(TOMSSuggestionBar *)suggestionBar
  didSelectSuggestion:(NSString *)suggestion;

/**
 Gets called when a text is changed.
 
 @param suggestionBar The suggestionBar containing the tapped tile.
 @param text The text filled in textfield.
 */
- (void)suggestionBar:(TOMSSuggestionBar *)suggestionBar
  textDidChange:(NSString *)text;

@end
