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
    // Do any additional setup after loading the view, typically from a nib.

    locationManager = [[CLLocationManager alloc] init];
}


- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];

    UIAlertController *startAlert = [UIAlertController alertControllerWithTitle:@"Tracking Your Location..."
                                                                        message:@"We will now alert you when you have reached the ROW DTLA. Stay tuned!"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
  
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Got It"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
  
    [startAlert addAction:defaultAction];
  
    [self presentViewController:startAlert animated:YES completion:nil];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);

    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Failed to Get Your Location"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];

    [errorAlert addAction:defaultAction];

    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    [locations lastObject]
//
//    NSLog(@"didUpdateToLocation: %@", newLocation);
//    CLLocation *currentLocation = newLocation;
//
//    if (currentLocation != nil) {
//        _longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        _latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//    }
}
@end
