//
//  ViewController.m
//  gimbal-app
//
//  Created by Matthew Santamaria on 9/26/18.
//  Copyright © 2018 Matthew Santamaria. All rights reserved.
//

#import "ViewController.h"
#include "math.h"

@interface ViewController ()

@end

@implementation ViewController
CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;
CLLocation *center;
double farthestDistanceFromCenterWithinBoundary;


- (void)viewDidLoad {
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
}

- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [locationManager requestWhenInUseAuthorization];
    [self setupDestinationDetails];

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
    CLLocation *currentLocation = [locations lastObject];

    if (currentLocation != nil) {
        [self updateCoordinates:(CLLocation *)currentLocation];
        [self updateAddress:(CLLocation *)currentLocation];

        BOOL destinationReached = [self didReachDestination:(CLLocation *)currentLocation];
        if (destinationReached) {
            [self showAlert:@"Success!"
                    message:@"You have reached the ROW DTLA!"
                 actionText:@"Sweet"];

            [locationManager stopUpdatingLocation];
        }
    }
}

- (void)setupDestinationDetails {
    [self setupCenter];
    [self setupBoundary];
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

- (BOOL)didReachDestination:(CLLocation *)location {
    return [self isWithinBoundary:(CLLocation *)location]; // && [self onCorrectFloor:(CLLocation *)location];
}

- (BOOL)isWithinBoundary:(CLLocation *)location {
    CLLocationDistance distance = [location distanceFromLocation:(const CLLocation *)center];
    return distance <= farthestDistanceFromCenterWithinBoundary;
}

- (BOOL)onCorrectFloor:(CLLocation *)location {
    double destinationFloor = [self convertStrToDouble:(NSString *)[[[NSProcessInfo processInfo] environment] objectForKey:@"BUILDING_FLOOR"]];
  
    return location.floor.level == destinationFloor;
}

- (void)setupCenter {
    double centerLat = [self convertStrToDouble:(NSString *)[[[NSProcessInfo processInfo] environment] objectForKey:@"CENTER_COORD_LAT"]];
    double centerLong = [self convertStrToDouble:(NSString *)[[[NSProcessInfo processInfo] environment] objectForKey:@"CENTER_COORD_LONG"]];

    center = [[CLLocation alloc] initWithLatitude:centerLat longitude:centerLong];
}

- (void)setupBoundary {
    double width = [self convertStrToDouble:(NSString *)[[[NSProcessInfo processInfo] environment] objectForKey:@"BUILDING_2D_WIDTH_FEET"]];
    double height = [self convertStrToDouble:(NSString *)[[[NSProcessInfo processInfo] environment] objectForKey:@"BUILDING_2D_HEIGHT_FEET"]];

    double widthMeters = [self convertFeetToMeters:(double)width];
    double heightMeters = [self convertFeetToMeters:(double)height];
  
    double distanceFromCenter = [self findPythagoreanHypotenuse:(double)(widthMeters / 2.0)
                                                           legB:(double)(heightMeters / 2.0)];
    farthestDistanceFromCenterWithinBoundary = distanceFromCenter;
}

#pragma mark - Utility Methods

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

- (double)convertStrToDouble:(NSString *)str {
    return [str doubleValue];
}

- (double)convertFeetToMeters:(double)feet {
    return (feet * 0.3048);
}

- (double)findPythagoreanHypotenuse:(double)legA legB:(double)legB {
    return sqrt(pow(legA, 2) + pow(legB, 2));
}
@end
