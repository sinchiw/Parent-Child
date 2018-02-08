//
//  ViewController.m
//  Child app
//
//  Created by Wilmer sinchi on 12/8/17.
//  Copyright © 2017 Wilmer sinchi. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [locationManager requestWhenInUseAuthorization];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
  
    if (currentLocation != nil) {
        _longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)locations:(id)sender
{
    NSDictionary *childDict = @{ @"username": self.names.text,
                                 @"current_latitude":self.latitude, @"current_longitude":self.longitude };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:childDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
      NSString *postLength = [NSString stringWithFormat:@"%lu", [jsonData  length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"https://turntotech.firebaseio.com/digitalleash/"];
    [urlString appendString:self.names.text ];
    [urlString appendString:@".json"];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PATCH"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"Request reply: %@", requestReply);
    }] resume];
}
@end
