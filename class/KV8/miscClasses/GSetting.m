//
//  GSetting.m
//

#import "GSetting.h"
#import "CamObj.h"

@interface GSetting()

-(id) initSingleton;

@end


@implementation GSetting
@synthesize bAddInfo,  bCurCamObjUpdated;
@synthesize nCurIndex, nCurIndex_playback, nsStrDocumentDir;
@synthesize arrCam, mLock1;
@synthesize arrEnableDisable, arrTimeZone, arrVResolution, arrVFileItem;

- (id) initSingleton
{
	if((self = [super init]))
	{
        self.nCurIndex=-1;
        self.nCurIndex_playback=-1;
        self.nsStrDocumentDir=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        self.arrCam=[[NSMutableArray alloc] init];       
        self.mLock1=[[NSLock alloc] init];
        self.arrEnableDisable=[[NSArray alloc] initWithObjects:
                                NSLocalizedString(@"Disable",nil),
                                NSLocalizedString(@"Enable",nil), nil];
        self.arrTimeZone=[[NSArray alloc] initWithObjects:
                          @"GMT-12:00",
                          @"GMT-11:00",
                          @"GMT-10:00",
                          @"GMT-09:30",
                          @"GMT-09:00",
                          @"GMT-08:00",
                          @"GMT-07:00",
                          @"GMT-06:00",
                          @"GMT-05:00",
                          @"GMT-04:30",
                          @"GMT-04:00",
                          @"GMT-03:30",
                          @"GMT-03:00",
                          @"GMT-02:00",
                          @"GMT-01:00",
                          @"GMT+00:00", //TIMEZONE0_INDEX=15
                          @"GMT+01:00",
                          @"GMT+02:00",
                          @"GMT+03:00",
                          @"GMT+03:30",
                          @"GMT+04:00",
                          @"GMT+04:30",
                          @"GMT+05:00",
                          @"GMT+05:30",
                          @"GMT+05:45",
                          @"GMT+06:00",
                          @"GMT+06:30",
                          @"GMT+07:00",
                          @"GMT+08:00",
                          @"GMT+08:45",
                          @"GMT+09:00",
                          @"GMT+09:30",
                          @"GMT+10:00",
                          @"GMT+10:30",
                          @"GMT+11:00",
                          @"GMT+11:30",
                          @"GMT+12:00",
                          @"GMT+12:45",
                          @"GMT+13:00",
                          @"GMT+14:00", nil];
        self.arrVResolution=[[NSArray alloc] initWithObjects: @"160X120", @"320X240", @"640X480", @"1280X720", nil];
        self.arrVFileItem=[[NSArray alloc] initWithObjects:
                           NSLocalizedString(@"Title",nil),
                           NSLocalizedString(@"Time",nil),
                           NSLocalizedString(@"Resolution",nil),
                           NSLocalizedString(@"Size",nil),
                           NSLocalizedString(@"Length",nil),
                           nil];
	}
	return self;
}

- (void) releaseAllObj
{
    [self.nsStrDocumentDir release];
    
    CamObj *camObj=nil;
    for(int i=0; i<self.arrCam.count; i++){
        camObj=[self.arrCam objectAtIndex:i];
        if(camObj!=nil) {
            camObj.m_delegateCam=nil;
//            [camObj stopSpeakAudio];
            [camObj stopConnect];
            [camObj stopAll];
            [camObj releaseObj];
            [camObj release];
            camObj=nil;
        }
    }
    [self.arrCam removeAllObjects];
	[self.arrCam release];
    [self.mLock1 release];
    [self.arrEnableDisable release];
    [self.arrTimeZone release];
    [self.arrVResolution release];
    [self.arrVFileItem release];
}

+ (GSetting *)instance
{
    static GSetting *curGSetting=nil;
    if(curGSetting!=nil) return curGSetting;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	// Allocates once with Grand Central Dispatch (GCD) routine.
	// It's thread safe.
	static dispatch_once_t safer;
	dispatch_once(&safer, ^(void)
				  {
					  curGSetting = [[GSetting alloc] initSingleton];
				  });
#else
	// Allocates once using the old approach, it's slower.
	// It's thread safe.
	@synchronized([GSetting class])
	{
		// The synchronized instruction will make sure,
		// that only one thread will access this point at a time.
		if(curGSetting == nil)
		{
			curGSetting = [[GSetting alloc] initSingleton];
		}
	}
#endif
	return curGSetting;
}

- (BOOL) isValidIndex
{
    if(nCurIndex<0 || nCurIndex >= [arrCam count]) return NO;
    else return YES;
}

- (NSInteger) getIndexByRowID:(NSUInteger)nRowID
{
    int nNum= (int)[arrCam count];
    if(nNum==0) return -1;
    
    CamObj *o=nil;
    int i=0;
    for(i=0; i<nNum; i++){
        o=[arrCam objectAtIndex:i];
        if(o.nRowID==nRowID) break;
    }
    if(i>=nNum) return -1;
    else return i;
}

- (NSInteger) getIndexByStrDID:(NSString *)nsDID
{
    int nNum= (int)[arrCam count];
    if(nNum==0 || nsDID==nil) return -1;
    
    CamObj *o=nil;
    int i=0;
    for(i=0; i<nNum; i++){
        o=[arrCam objectAtIndex:i];
        if([o.nsDID caseInsensitiveCompare:nsDID]==NSOrderedSame) break;
    }
    if(i>=nNum) return -1;
    else return i;
}

@end
