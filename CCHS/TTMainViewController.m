//
//  TTMainViewController.m
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/3/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import "TTMainViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "AppDelegate.h"
#import "TTDetailTweetView.h"
#import "TTWarningView.h"
#import "TTWebViewController.h"

static NSString * const TweetTableReuseIdentifier = @"TweetCell";

@interface TTMainViewController () <UITableViewDataSource, UITableViewDelegate, TWTRTweetViewDelegate, TTDetailTweetViewDelegate>
@property (nonatomic, strong) NSArray *tweets;
@end

@implementation TTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Style the nav bar title
    self.navigationItem.title = @"Timeline";
    
    // Setup tableview
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension; // Explicitly set on iOS 8 if using automatic row height calculation
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[TWTRTweetTableViewCell class] forCellReuseIdentifier:TweetTableReuseIdentifier];
    self.tableView.tableFooterView = [UIView new];
    
    // Create refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(downloadTweets)
                  forControlEvents:UIControlEventValueChanged];
    
    // Load saved tweets first
    if ([[[Twitter sharedInstance]session]authToken]) {
        [self loadSavedTweets];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if (guestSession != nil) {
            NSLog(@"dowloading tweets");
            [self downloadTweets];
        } else {
            NSLog(@"error: \(error.localizedDescription)");
        }

    }
     ];

}

- (void) showWarningViewWithTitle: (NSString *) title
{
    TTWarningView *warningView = [TTWarningView createNewWarningViewWithTitle:title];
    [warningView showOnView:self.navigationController.view];
}

#pragma mark TTLoginViewController delegate methods

- (void) loggedIn {
    [self downloadTweets];
}


#pragma mark Load Tweets

- (void) downloadTweets
{
    NSString *endPoint = @"https://api.twitter.com/1.1/lists/statuses.json";
    NSDictionary *params = @{@"slug": @"cherry-creek-admins", @"owner_id": @"312745292"};
    NSError *clientError;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                             URLRequestWithMethod:@"GET"
                             URL:endPoint
                             parameters:params
                             error:&clientError];

    __weak typeof(self) weakSelf = self;
    if (request) {
        NSLog(@"request successful");
        [[[Twitter sharedInstance] APIClient]
         sendTwitterRequest:request
         completion:^(NSURLResponse *response,
                      NSData *data,
                      NSError *connectionError) {
             if (data) {
                 NSError *jsonError;
                 NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:0
                                       error:&jsonError];
                 
                 NSMutableArray *IDs = [[NSMutableArray alloc] init];
                 for (id tweet in json){
                     if (tweet) {
                         NSLog(@"SWAg");
                         [IDs addObject:[tweet objectForKey:@"id_str"]];
                     }
                 }
                 [weakSelf loadTweetsWithIDs:IDs];
             }
             else {
                 NSLog(@"Connection Failed: %@", connectionError);
                 [self showWarningViewWithTitle:@"No internet connection"];
                 [weakSelf loadSavedTweets];
             }
         }];
    }
    else {
        NSLog(@"Client Error: %@", clientError);
        [self showWarningViewWithTitle:@"Error getting tweets from Twitter"];
        [weakSelf loadSavedTweets];
    }
}

- (void) loadTweetsWithIDs: (NSArray *) IDs
{
  
    
    for (NSObject* o in IDs) {
        NSLog(o);
    }
    __weak typeof(self) weakSelf = self;
    [[[Twitter sharedInstance] APIClient] loadTweetsWithIDs:IDs completion:^(NSArray *incomingTweets, NSError *error) {
        if (incomingTweets) {
            NSLog(@"%d", [incomingTweets count]);
            if ([weakSelf.refreshControl isRefreshing]) {
                [weakSelf.refreshControl endRefreshing];
            }
            typeof(self) strongSelf = weakSelf;
            strongSelf.tweets = incomingTweets;
            [strongSelf.tableView reloadData];
            //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //[appDelegate saveTweets:tweets];
            NSLog(@"Loaded to UIVIEW");
            for(UITableViewCell* o in strongSelf.tableView.visibleCells){
                NSLog(@"A");
                NSLog(o.textLabel.text);
            }
            
            NSLog(@"%d", strongSelf.tableView.visibleCells.count);
        } else {
            NSLog(@"Failed to load tweet: %@", [error localizedDescription]);
            [self showWarningViewWithTitle:@"Error displaying tweets"];
            [weakSelf loadSavedTweets];
        }
    }];
     
    
    
    
}

- (void) loadSavedTweets
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Tweets" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSError *fetchError = nil;
    NSArray *fetchResults = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if (fetchError) {
        NSLog(@"Error fetching request: %@, %@", fetchError, fetchError.localizedDescription);
    }else{
        if (fetchResults.count > 0) {
            NSManagedObject *tweet = fetchResults.firstObject;
            self.tweets = [tweet valueForKey:@"data"];
            [self.tableView reloadData];
        }
    }
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.tweets[indexPath.row];
    return [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.view.bounds)];
}

# pragma mark TweetViewDelegate methods

- (void)tweetView:(TWTRTweetView *)tweetView didSelectTweet:(TWTRTweet *)tweet{
    TTDetailTweetView *detailView = [TTDetailTweetView createNewDetailTweetViewWithTweet:tweet];
    detailView.delegate = self;
    [detailView loadViewAnimatedOnView:self.navigationController.view];
}

- (void)tweetView:(TWTRTweetView *)tweetView didTapURL:(NSURL *)url
{
    [self loadWebViewControllerWithURL:url];
}

- (void) loadWebViewControllerWithURL: (NSURL *) url
{
    TTWebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TTWebViewController"];
    webViewController.url = url;
    [self.navigationController pushViewController:webViewController animated:YES];
}

# pragma mark TTDetailTweetViewDelegate methods

- (void) didTapOnDetailTweetViewURL:(NSURL *)url
{
    [self loadWebViewControllerWithURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return NO;
}

@end
