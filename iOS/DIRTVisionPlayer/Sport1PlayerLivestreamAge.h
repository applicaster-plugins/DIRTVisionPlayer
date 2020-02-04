//
//  Sport1PlayerLivestreamAge.h
//  Sport1Player
//
//  Created by Oliver Stowell on 30/08/2019.
//  Copyright © 2019 Applicaster Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DIRTVisionPlayerAdapter.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kFSKKey = @"fsk";
static NSString *const kFSK16 = @"FSK16";

@protocol Sport1HTTPClient;

@interface Sport1PlayerLivestreamPin : NSObject

@property (nonatomic, weak) DIRTVisionPlayerAdapter *currentPlayerAdapter;

-(instancetype)initWithConfigurationJSON:(NSDictionary*)configurationJSON currentPlayerAdapter:(DIRTVisionPlayerAdapter* _Nullable)currentPlayerAdapter httpClient:(id<Sport1HTTPClient>)httpClient;
-(void)updateLivestreamAgeDataWithCompletion:(void (^)(BOOL success))completionHandler;
-(BOOL)shouldDisplayPin;

@end

NS_ASSUME_NONNULL_END
