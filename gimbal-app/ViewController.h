//
//  ViewController.h
//  gimbal-app
//
//  Created by Matthew Santamaria on 9/26/18.
//  Copyright © 2018 Matthew Santamaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (IBAction)getCurrentLocation:(id)sender;
@end
