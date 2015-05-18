//
//  TweetTableViewDemoViewController.m
//  CCHS
//
//  Created by Connor Sendel on 5/12/15.
//  Copyright (c) 2015 Contripity. All rights reserved.
//

#import <TwitterKit/TwitterKit.h>
#import "TweetTableViewDemoViewController.h"

static NSString * const TweetTableReuseIdentifier = @"TweetCell";

@interface TweetTableViewDemoViewController () <TWTRTweetViewDelegate>

@property (nonatomic, strong) NSArray *tweets; // Hold all the loaded tweets

@end

@implementation TweetTableViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *tweetIDs = @[@"20", // @jack's first Tweet
                          @"510908133917487104" // our favorite Bike tweet
                          ];
    
    // Setup tableview
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension; // Explicitly set on iOS 8 if using automatic row height calculation
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[TWTRTweetTableViewCell class] forCellReuseIdentifier:TweetTableReuseIdentifier];
    
    // Load tweets
    __weak typeof(self) weakSelf = self;
    [[[Twitter sharedInstance] APIClient] loadTweetsWithIDs:tweetIDs completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            typeof(self) strongSelf = weakSelf;
            strongSelf.tweets = tweets;
            [strongSelf.tableView reloadData];
        } else {
            NSLog(@"Failed to load tweet: %@", [error localizedDescription]);
        }
    }];
}

# pragma mark - UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

- (TWTRTweetTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.tweets[indexPath.row];
    
    TWTRTweetTableViewCell *cell = (TWTRTweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TweetTableReuseIdentifier forIndexPath:indexPath];
                                                              
    [cell configureWithTweet:tweet];
    cell.tweetView.delegate = self;
    
    return cell;
}

// Calculate the height of each row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.tweets[indexPath.row];
    
    return [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.view.bounds)];
}

@end
