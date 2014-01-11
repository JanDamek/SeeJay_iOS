//
//  AppDelegate.h
//  SeeJay Radio
//
//  Created by Tomas Vanek on 2/21/13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "comPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, comPlayerDelegate>{
    NSTimer* timer;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) comPlayer *player;

@property (strong, nonatomic) NSString *lastMeta;
@property (strong, nonatomic) NSString *prevMeta;

@property (strong, nonatomic) NSMutableArray *archive;
@property (strong, nonatomic) NSIndexPath *selected_archive;

@property int sleepInterval;

-(NSString*)sleepIntervalToString;
-(void)sleepButton;

-(void)setNewMeta:(NSString*)meta;

-(void)loadArchive;


@end
