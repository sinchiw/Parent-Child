//
//  ViewController.m
//  Parent
//
//  Created by Wilmer sinchi on 12/4/17.
//  Copyright © 2017 Wilmer sinchi. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
@class Reachability;



@interface ViewController ()

@end

@implementation ViewController{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
   
-(void) viewWillAppear:(BOOL)animated
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        NSLog(@"connection unavailable");
    }
    else
    {
        //connection available
        NSLog(@"connection available");
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //add the follwoing code in the viewdidload ti initate the cllocationmanger object
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [locationManager requestWhenInUseAuthorization];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
//    {
//        NSURL *scriptUrl = [NSURL URLWithString:@"http://apps.wegenerlabs.com/hi.html"];
//        NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
//        if (data)
//            NSLog(@"Device is connected to the internet");
//        else
//            NSLog(@"Device is not connected to the internet");
//    }
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}
- (IBAction)userdetetail:(id)sender {
    
    
    NSDictionary *userDetails = @{ @"username": self.user.text, @"latitude": self.latitudeLabel.text, @"longitude": self.longitudeLabel.text, @"radius": self.radius.text };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDetails
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [jsonData  length]];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"https://turntotech.firebaseio.com/digitalleash/"];
    [urlString appendString:self.user.text ];
    [urlString appendString:@".json"];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
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

- (IBAction)updateLocation:(id)sender {
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"https://turntotech.firebaseio.com/digitalleash/"];
    
    
    self.user.text = [self.user.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([self.user.text isEqualToString:@""]){
         [urlString appendString:@"InvalidUser" ];
    }else
        [urlString appendString:self.user.text ];
    [urlString appendString:@".json"];
    [request setURL:[NSURL URLWithString:urlString]];
    
  
//    NSURLSessionDataTask *dataTask = [urlString dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSLog(@"Response: %@",response);
//        NSLog(@"Data: %@",data);
//        NSLog(@"Error: %@",error);
//    }];
//    [dataTask resume];
//
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
      
       
        NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dictionary == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid User" message:@"Please put valid user name..." preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSLog(@"You pressed button OK");
                }];

                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
        else{
            NSLog(@"%@",dictionary);
            double parentLat = [[dictionary valueForKey:@"latitude"] doubleValue];
            double parentLon = [[dictionary valueForKey:@"longitude"] doubleValue];
            CLLocation *parentLoc = [[CLLocation alloc] initWithLatitude:parentLat longitude:parentLon];
            
            double childLat = [[dictionary valueForKey:@"current_latitude"] doubleValue];
            double childLon = [[dictionary valueForKey:@"current_longitude"] doubleValue];
            CLLocation *childLoc = [[CLLocation alloc] initWithLatitude:childLat longitude:childLon];
            
            double actualCalculatedRadius = [parentLoc distanceFromLocation:childLoc];
            double givenRadius = [[dictionary valueForKey:@"radius"] doubleValue];
            
            if (actualCalculatedRadius <= givenRadius){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"Success"];
                    [self presentViewController:currentViewController animated:YES completion:nil];
                });
                
                
                
                
            }
            else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"Failure"];
                    [self presentViewController:currentViewController animated:YES completion:nil];
                });
                
                
            }
            
            NSLog(@"Distance in meters = %f",actualCalculatedRadius);
        }
        
        

    }] resume];
}





- (IBAction)updates:(id)sender {
    {
        NSDictionary *parentDict = @{ @"username": self.user.text, @"latitude": self.latitudeLabel.text, @"longitude": self.longitudeLabel.text, @"radius": self.radius.text };
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parentDict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString *postLength = [NSString stringWithFormat:@"%lu", [jsonData  length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"https://turntotech.firebaseio.com/digitalleash/"];
        [urlString appendString:self.user.text   ];
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
    
    
}

@end
