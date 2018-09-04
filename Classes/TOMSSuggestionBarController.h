//
//  TOMSSuggestionBarController.h
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//


@class TOMSSuggestionBarView;
@class TOMSSuggestionBar;

@interface TOMSSuggestionBarController : UICollectionViewController

- (instancetype)initWithSuggestionBarView:(TOMSSuggestionBarView *)suggestionBarView;

- (void)suggestableArrayDidChange:(NSArray *)suggestions;

- (void)didSelectSuggestionAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) TOMSSuggestionBar *suggestionBar;

@end
