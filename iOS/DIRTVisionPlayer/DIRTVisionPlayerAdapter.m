//
//  Sport1PlayerAdapter.m
//  Sport1Player
//
//  Created by Oliver Stowell on 28/08/2019.
//  Copyright © 2019 Applicaster Ltd. All rights reserved.
//

@import PluginPresenter;
@import ZappPlugins;
#import "DIRTVisionPlayerAdapter.h"
#import <JWPlayer_iOS_SDK/JWPlayerController.h>
#import "Sport1PlayerLivestreamAge.h"
#import "JWPlayerViewController+Public.h"
#import "Sport1PlayerViewController.h"
#import "Sport1PlayerHelper.h"

static NSString *const kPlayableItemsKey = @"playable_items";
static NSString *const kPluginName = @"pin_validation_plugin_id";

@interface DIRTVisionPlayerAdapter ()
@property (nonatomic, strong) Sport1PlayerLivestreamPin *livestreamPinValidation;
@property (nonatomic, strong) ZPPlayerConfiguration *playerConfiguration;
@property (nonatomic, strong) Sport1PlayerHelper *playerHelper;
@end

@implementation DIRTVisionPlayerAdapter

+ (id<ZPPlayerProtocol>)pluggablePlayerInitWithPlayableItems:(NSArray<id<ZPPlayable>> *)items configurationJSON:(NSDictionary *)configurationJSON {
    NSString *playerKey = configurationJSON[@"playerKey"];

    if (![playerKey isNotEmptyOrWhiteSpaces]) {
        return nil;
    }

    [JWPlayerController setPlayerKey:playerKey];

    DIRTVisionPlayerAdapter *instance = [DIRTVisionPlayerAdapter new];
    instance.configurationJSON = configurationJSON;
    instance.playerViewController = [Sport1PlayerViewController new];
    instance.playerViewController.configurationJSON = configurationJSON;
    instance.currentPlayableItem = items.firstObject;
    instance.currentPlayableItems = items;
    instance.pluginManager = [ZPPluginManager class];
    id<Sport1HTTPClient> httpClient = [[Sport1HTTPClientImplementation alloc] initWithConfigurationJSON:configurationJSON];
    instance.playerHelper = [[Sport1PlayerHelper alloc] initWithHTTPClient:httpClient];
    instance.livestreamPinValidation = [[Sport1PlayerLivestreamPin alloc] initWithConfigurationJSON:configurationJSON
                                                                               currentPlayerAdapter:instance httpClient:httpClient];

    return instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ZPPlayerProtocol overrides

- (void)presentPlayerFullScreen:(UIViewController *)rootViewController configuration:(ZPPlayerConfiguration *)configuration {
    [self presentPlayerFullScreen:rootViewController configuration:configuration completion:nil];
}

- (void)presentPlayerFullScreen:(UIViewController *)rootViewController configuration:(ZPPlayerConfiguration *)configuration completion:(void (^)(void))completion {
    self.playerConfiguration = configuration;
    [self sendScreenViewAnalyticsFor:self.currentPlayableItem];
    if ([self.currentPlayableItem isFree] == NO) {
        NSObject<ZPLoginProviderUserDataProtocol> *loginPlugin = [[ZAAppConnector sharedInstance].pluginsDelegate.loginPluginsManager createWithUserData];
        NSDictionary *extensions = [NSDictionary dictionaryWithObject:self.currentPlayableItems forKey:kPlayableItemsKey];

        if ([loginPlugin respondsToSelector:@selector(isUserComplyWithPolicies:)]) {
            [self handleUserComply:[loginPlugin isUserComplyWithPolicies:extensions]
                       loginPlugin:loginPlugin
                rootViewController:rootViewController
                        completion:completion];
        } else if ([loginPlugin respondsToSelector:@selector(isUserComplyWithPolicies:completion:)]) {
            __block typeof(self) blockSelf = self;
            [loginPlugin isUserComplyWithPolicies:extensions completion:^(BOOL isUserComply) {
               [blockSelf handleUserComply:isUserComply
                               loginPlugin:loginPlugin
                        rootViewController:rootViewController
                                completion:completion];
           }];
        }
    }
}

#pragma mark - ZPPlayerProtocol overrides - Helpers

- (void)handleUserComply:(BOOL)isUserComply
             loginPlugin:(NSObject<ZPLoginProviderUserDataProtocol> *)plugin
      rootViewController:(UIViewController *)rootViewController
              completion:(void (^)(void))completion {
    if (!isUserComply) {
        NSDictionary *playableItems = [NSDictionary dictionaryWithObject:[self currentPlayableItems] forKey:kPlayableItemsKey];
        [plugin login:playableItems completion:^(enum ZPLoginOperationStatus status) {
            
        }];
    }
}

#pragma mark - Analytics

- (void)sendScreenViewAnalyticsFor:(NSObject <ZPPlayable>*)current {
    if (current.isLive) {
        [[[ZAAppConnector sharedInstance] analyticsDelegate] trackScreenViewWithScreenTitle:@"Livestream"
                                                                                 parameters:[[NSDictionary alloc] init]];
    } else {
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:current, @"playable", nil];
        [[[ZAAppConnector sharedInstance] analyticsDelegate] trackScreenViewWithScreenTitle:@"Spiele Video"
                                                                                 parameters:parameters];
    }
}

@end
