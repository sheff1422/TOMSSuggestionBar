//
//  TOMSSuggestionBarController.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSSuggestionBarController.h"
#import "TOMSSuggestionBarView.h"
#import "TOMSSuggestionBarCell.h"
#import "TOMSSuggestionBar.h"

@interface TOMSSuggestionBarController ()

@property (strong, nonatomic) NSArray *suggestionsArray;

@end

@implementation TOMSSuggestionBarController

#pragma mark - Initialization

- (instancetype)initWithSuggestionBarView:(TOMSSuggestionBarView *)suggestionBarView
{
    self = [super init];
    if (self) {
        self.suggestionsArray = @[];
        CGRect suggestionBarViewFrame = suggestionBarView.frame;
        self.collectionView = suggestionBarView;
        self.collectionView.frame = suggestionBarViewFrame;
    }
    return self;
}

#pragma mark - Suggesting

- (void)suggestableArrayDidChange:(NSArray *)suggestions {
    self.suggestionsArray = suggestions;
    [self.collectionView reloadData];
}

- (void)didSelectSuggestionAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text;
    if (indexPath.row + 1 <= self.suggestionsArray.count) {
        text = self.suggestionsArray[indexPath.row];
    }
    
    [self.suggestionBar.delegate suggestionBar:self.suggestionBar didSelectSuggestion:text];
}

#pragma mark - Bridged Getters

- (NSInteger)numberOfSuggestionFields
{
    return((TOMSSuggestionBarView *)self.collectionView).numberOfSuggestionFields;
}


#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfSuggestionFields = [self numberOfSuggestionFields];
    CGFloat width = (self.collectionView.frame.size.width - (numberOfSuggestionFields - 1) * kTOMSSuggestionCellPadding) / (CGFloat)numberOfSuggestionFields;
    CGFloat height = self.collectionView.frame.size.height;
    
    if (numberOfSuggestionFields % 2 == 0) {
        return CGSizeMake(floorf(width), height);
    } else {
        CGFloat maxWidth = floorf(width * 1.02532);
        if (indexPath.row == floorf(numberOfSuggestionFields / 2)) {
            return CGSizeMake(maxWidth, height);
        } else {
            width = (self.collectionView.frame.size.width - (numberOfSuggestionFields - 1) * kTOMSSuggestionCellPadding - maxWidth) / (CGFloat)(numberOfSuggestionFields - 1);
            return CGSizeMake(floorf(width), height);
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfSuggestionFields];
}


- (NSString *)cellIdentifierForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"kTOMSSuggestionBarCell";
    return [cellIdentifier stringByAppendingFormat:@"_%i", indexPath.row];
}

- (void)configureCell:(id)cell
         forIndexPath:(NSIndexPath *)indexPath
{
    TOMSSuggestionBarCell *suggestionBarCell = (TOMSSuggestionBarCell *)cell;
    
    suggestionBarCell.indexPath = indexPath;
    suggestionBarCell.suggestionBarController = self;
    
    NSString *text;
    if (indexPath.row + 1 <= self.suggestionsArray.count) {
        text = self.suggestionsArray[indexPath.row];
    }
    
    suggestionBarCell.textLabel.text = text;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self cellIdentifierForItemAtIndexPath:indexPath];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                           forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}
@end
