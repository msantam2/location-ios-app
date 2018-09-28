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
//    1. Get most recent location (lastObject) - CHECK
//    2. Update 3 fields: Latitude (check), Longitude (check), Address
//    3. Perform check: if this latitude & longitude is (within) correct coordinates,
//        call showAlert to tell the user that "You have reached the ROW DTLA! Congratulations!"
//    4. Done.

    CLLocation *currentLocation = [locations lastObject];

    if (currentLocation != nil) {
      
        [self updateCoordinates:(CLLocation *)currentLocation];

        [geocoder reverseGeocodeLocation:currentLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
          if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self->_addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                         placemark.subThoroughfare, placemark.thoroughfare,
                                         placemark.postalCode, placemark.locality,
                                         placemark.administrativeArea,
                                         placemark.country];
          } else {
            NSLog(@"%@", error.debugDescription);
          }
        }];
    }
}

- (void)updateCoordinates:(CLLocation *)location {
    _latitudeLabel.text = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
    _longitudeLabel.text = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
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
