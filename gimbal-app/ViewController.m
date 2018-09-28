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
CLGeocoder *geocoder;
CLPlacemark *placemark;

- (void)viewDidLoad {
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
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
//    1.  Get most recent location (lastObject) - CHECK
//    2.  Update 3 fields: Latitude (check), Longitude (check), Address (check)
//    2.5 Fix bug where address pushes shit down (check)
//    3.  Perform check: if this latitude & longitude is (within) correct coordinates, & SECOND FLOOR!
//        call showAlert to tell the user that "You have reached the ROW DTLA! Congratulations!"
//    4.  Done.

    CLLocation *currentLocation = [locations lastObject];

    if (currentLocation != nil) {
        [self updateCoordinates:(CLLocation *)currentLocation];
        [self updateAddress:(CLLocation *)currentLocation];
    }
  
    // store in config (env)
    // (120ft * 125ft) => (36.576m * 38.1m) => 26.41m meters if half the diagonal
    // lat: 34.033402
    // long: -118.240309
}

- (void)updateCoordinates:(CLLocation *)location {
    _latitudeLabel.text = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
    _longitudeLabel.text = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
}

- (void)updateAddress:(CLLocation *)location {
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (error == nil && [placemarks count] > 0) {
                            placemark = [placemarks lastObject];
                            self->_addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@, %@ %@\n%@",
                                                         placemark.subThoroughfare, placemark.thoroughfare,
                                                         placemark.locality, placemark.administrativeArea,
                                                         placemark.postalCode,
                                                         placemark.country];
                        } else {
                            NSLog(@"Geocode Error: %@", error.debugDescription);
                        }
                   }];
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
