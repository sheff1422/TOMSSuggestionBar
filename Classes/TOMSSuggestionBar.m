//
//  TOMSSuggestionBar.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSSuggestionBar.h"
#import "TOMSSuggestionBarView.h"
#import "TOMSSuggestionBarController.h"

@interface TOMSSuggestionBar ()
@property (nonatomic, strong) TOMSSuggestionBarView *suggestionBarView;
@property (nonatomic, assign) NSRange relevantContextRange;
@end

@implementation TOMSSuggestionBar
@synthesize backgroundColor = _backgroundColor;

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.suggestionBarView = [[TOMSSuggestionBarView alloc] initWithFrame:[TOMSSuggestionBar suggestionBarFrame]
                                                     numberOfSuggestionFields:3];
        [self designatedInitialization];
    }
    return self;
}

- (instancetype)initWithNumberOfSuggestionFields:(NSInteger)numberOfSuggestionFields
{
    self = [super init];
    if (self) {
        numberOfSuggestionFields = MAX(1, numberOfSuggestionFields);
        self.suggestionBarView = [[TOMSSuggestionBarView alloc] initWithFrame:[TOMSSuggestionBar suggestionBarFrame]
                                                     numberOfSuggestionFields:numberOfSuggestionFields];
        [self designatedInitialization];
    }
    return self;
}

- (void)designatedInitialization
{
    self.suggestionBarView.backgroundColor = self.backgroundColor;
    self.suggestionBarView.suggestionBarController.suggestionBar = self;
    self.relevantContextRange = NSMakeRange(0, 0);
}

#pragma mark - Suggestion setup
- (void)showArrayWith:(NSArray *)suggestions {
    [self.suggestionBarView.suggestionBarController suggestableArrayDidChange:suggestions];
}
- (BOOL)subscribeTextInputView:(UIControl<UITextInput> *)textInputView
{
    if ([textInputView respondsToSelector:@selector(setInputAccessoryView:)]) {
        textInputView.autocorrectionType = UITextAutocorrectionTypeNo;
        textInputView.toms_suggestionBar = self;
        
        self.textInputView = textInputView;
        
        [self.textInputView performSelector:@selector(setInputAccessoryView:)
                                 withObject:self.suggestionBarView];
        
        [self.textInputView addTarget:self
                               action:@selector(textChanged:)
                     forControlEvents:UIControlEventEditingChanged];
        
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    [self.textInputView removeTarget:self
                              action:@selector(textChanged:)
                    forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Suggesting

- (void)textChanged:(UIControl<UITextInput> *)textInputView
{
    UITextRange *inputRange = [textInputView textRangeFromPosition:textInputView.beginningOfDocument
                                                        toPosition:textInputView.endOfDocument];
    NSString *inputText = [textInputView textInRange:inputRange];
    
    [self.delegate suggestionBar:self textDidChange:inputText];
}

#pragma mark - Bridget Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;    
    self.suggestionBarView.backgroundColor = self.backgroundColor;
}

#pragma mark - Default configuration

+ (CGRect)suggestionBarFrame
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGRectMake(0, 0, 320, 58);
    } else {
        return CGRectMake(0, 0, 320, 42);
    }
}

- (UIColor *)backgroundColor
{
    if (!_backgroundColor) {
        return [UIColor colorWithRed:210.0/255.0 green:213.0/255.0 blue: 219.0/255.0 alpha:1];
    }
    return _backgroundColor;
}

- (UIColor *)tileColor
{
    if (!_tileColor) {
        return [UIColor colorWithRed:174.0/255.0 green:179.0/255.0 blue: 190.0/255.0 alpha:1];
    }
    return _tileColor;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        return [UIColor whiteColor];
    }
    return _textColor;
}

- (UIFont *)font
{
    if (!_font) {
        return [UIFont systemFontOfSize:16];
    }
    return _font;
}

@end
