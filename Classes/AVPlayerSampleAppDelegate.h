//
//  AVPlayerSampleAppDelegate.h
//  AVPlayerSample
//
//  Created by Fabio Rodella on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayerSampleViewController;

@interface AVPlayerSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AVPlayerSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AVPlayerSampleViewController *viewController;

@end

