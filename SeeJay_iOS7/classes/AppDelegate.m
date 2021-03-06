//
//  AppDelegate.m
//  SeeJay Radio
//
//  Created by Tomas Vanek on 2/21/13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

#import "AppDelegate.h"
#import "XMLReader.h"

@implementation AppDelegate

@synthesize player=_player, lastMeta, prevMeta, sleepInterval, archive = _archive;

static NSString * streamURL = @"http://mp3stream.abradio.cz:8000/seejay64.mp3.m3u";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    _player = [[comPlayer alloc]initWithURL:streamURL];
    [_player stop];
    _player.delegate = self;
    
//    UIStoryboard *st;
//    
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
//        // Load resources for iOS 6.1 or earlier
//        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
//            //move to your iphone4s storyboard
//            st = [UIStoryboard storyboardWithName:@"Storyboard_iPhone6" bundle:[NSBundle mainBundle]];
//        }else{
//            st = [UIStoryboard storyboardWithName:@"Storyboard_iPad6" bundle:[NSBundle mainBundle]];
//        }
//    } else {
//        // Load resources for iOS 7 or later
//        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
//            //move to your iphone4s storyboard
//            st = [UIStoryboard storyboardWithName:@"Storyboard_iPhone7" bundle:[NSBundle mainBundle]];
//        }else{
//            st = [UIStoryboard storyboardWithName:@"Storyboard_iPad7" bundle:[NSBundle mainBundle]];
//        }
//    }
//    
//    UIViewController *co = [st instantiateInitialViewController];
//    self.window.rootViewController = co;
    
    return YES;
}

-(void)stopPlaying:(comPlayer *)player{
    prevMeta = @"";
    lastMeta = @"";
}

-(NSString *)sleepIntervalToString{
    return [NSString stringWithFormat:@"%d min",sleepInterval];
}

-(void)zastavPlayer{
    if (sleepInterval<1){
        [timer invalidate];
        
        [_player stop];
        sleepInterval=0;
    }else
        sleepInterval-=1;
}

-(void)sleepButton{
    [timer invalidate];
    
    if (_player.player.rate!=0){
        sleepInterval+=15;
        if (sleepInterval>60){
            sleepInterval = 0;
        }
        
        if (sleepInterval>0)
            timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(zastavPlayer) userInfo:nil repeats:YES];
    }else sleepInterval=0;
}

-(void)metaData:(comPlayer *)player meta:(NSString *)meta{
    [self setNewMeta:meta];
}

-(void)setNewMeta:(NSString *)meta{
    if ([lastMeta compare:meta]!=NSOrderedSame){
        prevMeta = lastMeta;
        lastMeta = meta;
    }
}

-(void)loadArchive{
    NSData *podcast_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.seejay.cz/xmlarchiv.php"]];
    NSDictionary *podcast = [XMLReader dictionaryForXMLData:podcast_data error:nil];
    NSObject *rss = [podcast valueForKey:@"rss"];
    NSArray *channel = [rss valueForKey:@"channel"];
    
    if (_archive){
        [_archive removeAllObjects];
    } else
        _archive = [[NSMutableArray alloc]init];
    
    if ([channel isKindOfClass:[NSArray class]]){
        for (NSDictionary *ch in channel) {
            NSMutableDictionary *i = [[NSMutableDictionary alloc]init];
            NSString *tit = [[ch valueForKey:@"title"] valueForKey:@"text"];
            tit = [tit stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [i setValue:tit forKey:@"title"];
            
            NSMutableArray *items = [[NSMutableArray alloc]init];
            [i setValue:items forKey:@"items"];
            
            for (NSDictionary *it in [ch objectForKey:@"item"]) {
                NSString *title = [[it valueForKey:@"title"] valueForKey:@"text"];
                title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                NSArray *sec_tit = [title componentsSeparatedByString:@"|"];
                
                NSString *buf = [sec_tit objectAtIndex:0];
                buf = [buf stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                buf = [buf stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                buf = [buf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSMutableDictionary *porad = nil;
                for (porad in items) {
                    if ([[porad valueForKey:@"title"] isEqualToString:buf]){
                        break;
                    }
                }
                
                NSMutableArray *po_it;
                if (!porad){
                    porad = [[NSMutableDictionary alloc]init];
                    
                    [porad setValue:buf forKey:@"title"];
                    
                    buf = [[it valueForKey:@"description"]valueForKey:@"text"];
                    buf = [buf stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    buf = [buf stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    buf = [buf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [porad setValue:buf forKey:@"description"];
                    
                    po_it = [[NSMutableArray alloc]init];
                    [porad setValue:po_it forKey:@"items"];
                    [items addObject:porad];
                }else{
                    po_it = [porad objectForKey:@"items"];
                }
                
                NSMutableDictionary *po_de = [[NSMutableDictionary alloc]init];
                
                buf = [sec_tit objectAtIndex:1];
                buf = [buf stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                buf = [buf stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                buf = [buf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [po_de setValue:buf forKey:@"title"];
                
                buf = [[it valueForKey:@"description"] valueForKey:@"text"];
                buf = [buf stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                buf = [buf stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                buf = [buf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [po_de setValue:buf forKey:@"description"];
                
                buf = [[it valueForKey:@"enclosure"] valueForKey:@"url"];
                buf = [buf stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                buf = [buf stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                buf = [buf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [po_de setValue:buf forKey:@"link"];
                
                buf = [[it valueForKey:@"enclosure"] valueForKey:@"length"];
                buf = [buf stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                buf = [buf stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                buf = [buf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [po_de setValue:buf forKey:@"size"];
                
                [po_it addObject:po_de];
            }
            
            [_archive addObject:i];
        }
    }
    
    //    items = [[channel valueForKey:@"item"] copy];
}


@end
