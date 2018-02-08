//
//  ViewController.h
//  Parent
//
//  Created by Wilmer sinchi on 12/4/17.
//  Copyright © 2017 Wilmer sinchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class Reachability;


@interface ViewController : UIViewController <CLLocationManagerDelegate, NSURLConnectionDataDelegate>
- (IBAction)updateLocation:(id)sender;
- (IBAction)updates:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
- (IBAction)userdetetail:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *radius;
@property (weak, nonatomic) IBOutlet UITextField *user;





@end

