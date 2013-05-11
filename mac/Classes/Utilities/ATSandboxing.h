
#import <Foundation/Foundation.h>

NSString *ATRealHomeDirectory();

NSString *ATUserScriptsDirectory();

BOOL ATIsSandboxed();
BOOL ATAreSecurityScopedBookmarksSupported();
BOOL ATIsUserScriptsFolderSupported();


NSString *ATOSVersionString();
int ATVersionMake(int major, int minor, int revision);
int ATOSVersion();
BOOL ATOSVersionAtLeast(int major, int minor, int revision);
BOOL ATOSVersionLessThan(int major, int minor, int revision);


@interface NSString (ATSandboxing)

- (NSString *)stringByAbbreviatingTildeInPathUsingRealHomeDirectory;
- (NSString *)stringByExpandingTildeInPathUsingRealHomeDirectory;

@end
