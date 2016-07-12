//
//  PlayerViewController.m
//  SeeJay Radio
//
//  Created by Jan Damek on 2/21/13.
//  Copyright (c) 2013 SeeJayRadio. All rights reserved.
//

@import GoogleMobileAds;

#import "PlayerViewController.h"
#import "AppDelegate.h"
#import "XMLReader.h"
#import "ServiceTools.h"

@interface PlayerViewController ()

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic ,weak) NSString *link_url;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation PlayerViewController

@synthesize
    dlouhyNazev = _dlouhyNazev,
    startStopButton = _startStopButton,
    coHralo = _coHralo,
    sleepTime = _sleepTime,
    titleNovinka = _titleNovinka,
    descriptionNovinka = _descriptionNovinka,
    imageNovinka = _imageNovinka,
    ani = _ani,
    timer = _timer,
    link_url = _link_url;

static NSString *rssURL = @"http://seejay.cz/rss.php";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    d.player.delegate = self;
    self.link_url = @"";
    
    [self.ani setHidesWhenStopped:YES];
    [self.ani stopAnimating];
    
    [ServiceTools GADInitialization:_bannerView rootViewController:self];
}

-(void)updateTimer{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.sleepTime.text = [d sleepIntervalToString];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    d.player.delegate = self;
    
    self.dlouhyNazev.text = d.lastMeta;
    self.coHralo.text = d.prevMeta;
    
    self.sleepTime.text = [d sleepIntervalToString];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    self.link_url = @"";
    
    [self performSelectorInBackground:@selector(nactiNovinkaNaPozadi) withObject:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    d.player.delegate = d;
    
    [self.timer invalidate];
}

-(void)stopButton:(id)sender{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!d.player.isPlaying){
        [d.player play];
    }else{
        [d.player stop];
    }
}

-(void)preparePlay:(comPlayer *)player{
    self.dlouhyNazev.text = @"";
    [self.ani startAnimating];
}

-(void)stopPlaying:(comPlayer *)player{
    self.dlouhyNazev.text = @"";
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    d.prevMeta = @"";
    d.lastMeta = @"";
    
    [self.ani stopAnimating];
}

-(void)startPlaying:(comPlayer *)player{
    self.dlouhyNazev.text = @"";
    [self.ani stopAnimating];
}

-(void)startInteruptPlaying:(comPlayer *)player{
    self.dlouhyNazev.text = @"Načitání do mezipaměti";
    [self.ani startAnimating];
}

-(void)stopInteruptPlaying:(comPlayer *)player{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.dlouhyNazev.text = d.lastMeta;
    
    [self.ani stopAnimating];
}

-(void)metaData:(comPlayer *)player meta:(NSString *)meta{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [d setNewMeta:meta];
    
    self.coHralo.text = d.prevMeta;
    self.dlouhyNazev.text = d.lastMeta;
    
    self.sleepTime.text = [d sleepIntervalToString];
}

-(void)setSleepButton:(id)sender{
    AppDelegate *d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [d sleepButton];
    self.sleepTime.text = [d sleepIntervalToString];
}

-(void)nactiNovinkaNaPozadi{
    NSData *rssData = [NSData dataWithContentsOfURL:[NSURL URLWithString:rssURL]];
    NSDictionary *rss = [XMLReader dictionaryForXMLData:rssData error:nil];
    rss = [rss objectForKey:@"rss"];
    NSDictionary *chanels = [rss objectForKey:@"channel"];
    NSArray *item = [chanels objectForKey:@"item"];
    
    NSDictionary *toUse=nil;
    NSDictionary *oldItem = nil;
    NSString *pubDate = nil;
    
    if ([item isKindOfClass:NSArray.class])
    {
        for (NSDictionary *i in item) {
            if (!pubDate) {
                pubDate = [[i objectForKey:@"pubDate"] objectForKey:@"text"];
                pubDate = [pubDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                oldItem = i;
            }else{
                //jiz mam mohu porovnavat
                NSString *newPubDate = [[i objectForKey:@"pubDate"] objectForKey:@"text"];
                newPubDate = [newPubDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                if ([newPubDate compare:pubDate]==NSOrderedAscending){
                    toUse = i;
                }else{
                    toUse = oldItem;
                }
            }
        }
    }else
        toUse = (NSDictionary*)item;
    
    NSString *tit = [[toUse objectForKey:@"title"] objectForKey:@"text"];
    tit = [tit stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *dec = [[toUse objectForKey:@"description"] objectForKey:@"text"];
    dec = [dec stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *img = [[toUse objectForKey:@"enclosure"] objectForKey:@"url"];
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
    UIImage *image = [UIImage imageWithData:imgData];
    self.link_url = [[toUse objectForKey:@"link"] objectForKey:@"text"];
    
    self.link_url = [[toUse objectForKey:@"link"] objectForKey:@"text"];
    self.link_url = [self.link_url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    self.titleNovinka.text = tit;
    self.descriptionNovinka.text = dec;
    self.imageNovinka.image = image;
}

-(void)novinkaClick:(id)sender{
    if (self.link_url && ![self.link_url isEqualToString:@""]){
        //otevri prohlizec s url novinky
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.link_url stringByReplacingOccurrencesOfString:@"\n" withString:@""]]];
    }
}

@end
