//
//  CustomViewController.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 17/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "CustomViewController.h"
#import <TOMSSuggestionBar/TOMSSuggestionBar.h>

@interface CustomViewController () <TOMSSuggestionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation CustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TOMSSuggestionBar *suggestionBar = [[TOMSSuggestionBar alloc] initWithNumberOfSuggestionFields:3];
    [suggestionBar subscribeTextInputView:self.textField];
    
    suggestionBar.delegate = self;
    [suggestionBar showArrayWith:@[@"23123123123ndlkajkljsadkl lkjd lkjslkada kld klasjlkjkl",
                                  @"45654645645656 lkjd lkjslkada kld klasjlkjkl",
                                  @"876876876876868 lkjd lkjslkada kld klasjlkjkl"]];
}

#pragma mark - TOMSSuggestionDelegate

- (void)suggestionBar:(TOMSSuggestionBar *)suggestionBar
  didSelectSuggestion:(NSString *)suggestion {
    NSString *replacement = [suggestion stringByAppendingString:@" "];
    self.textField.text = suggestion;
}

- (void)suggestionBar:(TOMSSuggestionBar *)suggestionBar
        textDidChange:(NSString *)text {
    
}

#pragma mark - TOMSSuggestionDataSource

- (NSString *)suggestionBar:(TOMSSuggestionBar *)suggestionBar
    relevantContextForInput:(NSString *)textInput
              caretLocation:(NSInteger)caretLocation
{
    NSRange lastWordRange = [textInput rangeOfString:@" "
                                             options:NSBackwardsSearch];
    
    NSString *relevantContext;
    if (lastWordRange.location == NSNotFound) {
        relevantContext = textInput;
    } else {
        relevantContext = [textInput substringFromIndex:lastWordRange.location + 1];
    }
    
    return relevantContext;
}

- (NSPredicate *)suggestionBar:(TOMSSuggestionBar *)suggestionBar
           predicateForContext:(NSString *)context
                 attributeName:(NSString *)attributeName
{
    return [NSPredicate predicateWithFormat:@"%K LIKE[cd] %@", attributeName, [NSString stringWithFormat:@"*%@*", context]];
}

- (NSArray *)suggestionBar:(TOMSSuggestionBar *)suggestionBar sortDescriptorsForAttributeName:(NSString *)attributeName
{
    return @[[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES]];
}

@end
