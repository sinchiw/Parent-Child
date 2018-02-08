//
//  ViewController.h
//  Child app
//
//  Created by Wilmer sinchi on 12/8/17.
//  Copyright © 2017 Wilmer sinchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate>
- (IBAction)locations:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *names;
@property (weak, nonatomic) IBOutlet UILabel *User;
//- (IBAction)myUnwindAction:(UIStoryboardSegue*)unwindSegue;
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;
@end

