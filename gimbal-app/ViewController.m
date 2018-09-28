//
//  ViewController.m
//  gimbal-app
//
//  Created by Matthew Santamaria on 9/26/18.
//  Copyright © 2018 Matthew Santamaria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
CLLocationManager *locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
}

- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];

    [self showAlert:@"Tracking Your Location..."
            message:@"We will now alert you when you have reached the ROW DTLA. Stay tuned!"
         actionText:@"Got It"];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);

    [self showAlert:@"Error"
            message:@"Failed to get your location. Please try again soon."
         actionText:@"OK"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
  // 1. Get most recent location (lastObject)
  // 2. Update 3 fields: Latitude, Longitude, Address
  // 3. Perform check: if this latitude & longitude is (within) correct coordinates,
  //    call showAlert to tell the user that "You have reached the ROW DTLA! Congratulations!"
  // 4. Done.
  
//    CLLocation *currentLocation = [locations lastObject];
//    NSLog(@"didUpdateLocations: %@", currentLocation);

    NSLog(@"We are in didUpdateLocations");

//    if (currentLocation != nil) {
//        _longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        _latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//    }
}

#pragma mark - Utility methods

- (void)showAlert:(NSString *)title message:(NSString *)message actionText:(NSString *)actionText {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:actionText
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];

    [self presentViewController:alert animated:YES completion:nil];
}
@end
