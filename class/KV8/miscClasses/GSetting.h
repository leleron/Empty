//
//  GSetting.h
//

#import <Foundation/Foundation.h>

#define TIMEZONE0_INDEX     15
#define isPad (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface GSetting : NSObject
{
    char bAddInfo;
    char bCurCamObjUpdated;
    
    int  nCurIndex;
    int  nCurIndex_playback;
    NSString *nsStrDocumentDir;
    NSMutableArray *arrCam;
    
    NSLock  *mLock1; //for h264 decode
}

@property(assign) char bAddInfo;
@property(assign) char bCurCamObjUpdated;
@property(assign) int  nCurIndex, nCurIndex_playback;
@property(nonatomic, retain) NSString *nsStrDocumentDir;
@property(nonatomic, retain) NSMutableArray *arrCam;
@property(nonatomic, retain) NSLock  *mLock1;

@property(nonatomic, retain) NSArray *arrEnableDisable;
@property(nonatomic, retain) NSArray *arrTimeZone;
@property(nonatomic, retain) NSArray *arrVResolution;
@property(nonatomic, retain) NSArray *arrVFileItem;

+ (GSetting *)instance;
- (void) releaseAllObj;
- (BOOL) isValidIndex;
- (NSInteger) getIndexByRowID:(NSUInteger)nRowID;
- (NSInteger) getIndexByStrDID:(NSString *)nsDID;

@end
