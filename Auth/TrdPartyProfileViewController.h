//
//  Copyright (c) 2015 LAS. All rights reserved.

#import <MaxLeap/MaxLeap.h>

@interface TrdPartyProfileViewController : UITableViewController <NSURLConnectionDelegate>

@property (nonatomic, copy) NSString *platform;

// UITableView header view properties
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *headerNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;

// UITableView row data properties
@property (nonatomic, strong) NSArray *rowTitleArray;
@property (nonatomic, strong) NSMutableArray *rowDataArray;
@property (nonatomic, strong) NSMutableData *imageData;

@end
