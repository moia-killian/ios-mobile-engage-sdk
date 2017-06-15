#import "Kiwi.h"
#import "MobileEngage.h"
#import "MEConfigBuilder.h"
#import "MEConfig.h"

#define DB_PATH [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"EMSSQLiteQueueDB.db"]

SPEC_BEGIN(InboxIntegrationTests)

    beforeEach(^{
        [[NSFileManager defaultManager] removeItemAtPath:DB_PATH
                                                   error:nil];

        MEConfig *config = [MEConfig makeWithBuilder:^(MEConfigBuilder *builder) {
            [builder setCredentialsWithApplicationCode:@"14C19-A121F"
                                   applicationPassword:@"PaNkfOD90AVpYimMBuZopCpm8OWCrREu"];
        }];
        [MobileEngage setupWithConfig:config
                        launchOptions:nil];

        [MobileEngage appLoginWithContactFieldId:@123456789
                               contactFieldValue:@"contactFieldValue"];
    });

    describe(@"Notification Inbox", ^{

        it(@"fetchNotificationsWithResultBlock", ^{
            __block MENotificationInboxStatus *_inboxStatus;
            __block NSError *_error;

            [MobileEngage.inbox fetchNotificationsWithResultBlock:^(MENotificationInboxStatus *inboxStatus) {
                _inboxStatus = inboxStatus;
            }                                          errorBlock:^(NSError *error) {
                _error = error;
            }];

            [[_error shouldEventually] beNil];
            [[_inboxStatus shouldNotEventually] beNil];
        });

        it(@"resetBadgeCount", ^{
            MEConfig *config = [MEConfig makeWithBuilder:^(MEConfigBuilder *builder) {
                [builder setCredentialsWithApplicationCode:@"14C19-A121F"
                                       applicationPassword:@"PaNkfOD90AVpYimMBuZopCpm8OWCrREu"];
            }];
            [MobileEngage setupWithConfig:config
                            launchOptions:nil];

            [MobileEngage appLoginWithContactFieldId:@123456789
                                   contactFieldValue:@"contactFieldValue"];


            __block BOOL _success = NO;
            __block BOOL _error = YES;

            [MobileEngage.inbox resetBadgeCountWithSuccessBlock:^{
                _success = YES;
                _error = NO;
            }                                        errorBlock:^(NSError *error) {
            }];

            [[theValue(_success) shouldNotEventually] beYes];
            [[theValue(_error) shouldEventually] beNo];
        });

    });

SPEC_END