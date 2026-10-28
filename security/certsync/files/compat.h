#import <AvailabilityMacros.h>

/*
 * We provide forward-compatibility defines for build environments
 * back to 10.4.
 */

/* Define version constants for use on earlier systems */
#ifndef MAC_OS_X_VERSION_10_6
#  define MAC_OS_X_VERSION_10_6 1060
#endif /* !MAC_OS_X_VERSION_10_6 */

#ifndef MAC_OS_X_VERSION_10_5
#  define MAC_OS_X_VERSION_10_5 1050
#endif /* !MAC_OS_X_VERSION_10_5 */

/*
 * Weak Linking Note:
 *
 * Correctly linking against weak symbols relies on actually having
 * the symbol available at link time, such that dyld can create its two-level
 * weak reference.
 *
 * Since we have to support building on earlier systems where the symbols
 * are not available at all, we #define the functions to NULL (with appropriate
 * function typedefs), allowing the standard approach of checking for
 * symbol != NULL to succeed.
 */

/* Allow building with SDKs <= 10.4 */
#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_4
    /* SecTrustSettings constants were not available until 10.5 */
    enum {
        kSecTrustSettingsDomainUser = 0,
        kSecTrustSettingsDomainAdmin,
        kSecTrustSettingsDomainSystem
    };
    typedef uint32_t SecTrustSettingsDomain;

    enum {
       kSecTrustSettingsResultInvalid = 0,
       kSecTrustSettingsResultTrustRoot,
       kSecTrustSettingsResultTrustAsRoot,
       kSecTrustSettingsResultDeny,
       kSecTrustSettingsResultUnspecified
    };
    typedef uint32_t SecTrustSettingsResult;
    #define kSecTrustSettingsResult          CFSTR("kSecTrustSettingsResult")

    /* SecCertificateCopyCommonName() was added in 10.5 */
    extern OSStatus SecCertificateCopyCommonName (SecCertificateRef certificate, CFStringRef *commonName) __attribute__((weak_import));
    #define SecCertificateCopyCommonName ((OSStatus(*)(SecCertificateRef, CFStringRef *)) NULL) /* We can't safely weak-link what we don't have */

    /* SecTrustSettingsCopyCertificates() was added in 10.5 */
    extern OSStatus SecTrustSettingsCopyCertificates (SecTrustSettingsDomain domain, CFArrayRef *certArray) __attribute__((weak_import));
    #define SecTrustSettingsCopyCertificates ((OSStatus(*)(SecTrustSettingsDomain, CFArrayRef *)) NULL) /* We can't safely weak-link what we don't have */

    /* SecTrustSettingsCopyTrustSettings() was added in 10.5 */
    extern OSStatus SecTrustSettingsCopyTrustSettings (SecCertificateRef certRef, SecTrustSettingsDomain domain, CFArrayRef *trustSettings) __attribute__((weak_import));
    #define SecTrustSettingsCopyTrustSettings ((OSStatus(*)(SecCertificateRef, SecTrustSettingsDomain, CFArrayRef *)) NULL) /* We can't safely weak-link what we don't have */

    extern CFStringRef SecCopyErrorMessageString (OSStatus status, void *reserved) __attribute__((weak_import));
    #define SecCopyErrorMessageString ((CFStringRef(*)(OSStatus, void *)) NULL) /* We can't safely weak-link what we don't have */

    /* CFError was added in 10.5 */
    typedef CFTypeRef CFErrorRef;

    /* errSecNoTrustSettings was added in 10.5 */
    #define errSecNoTrustSettings -25263
#endif

/* Allow building with SDKs <= 10.5 */
#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5
    /* errSecSuccess was not defined until 10.6 */
    #define errSecSuccess noErr

    /* NSDataWritingAtomic was not defined until 10.6, but it has an identical
     * value as the now-deprecated NSDataWritingAtomic */
    #define NSDataWritingAtomic NSAtomicWrite

    /* SecCertificateCopySubjectSummary() was added in 10.6 */
    extern CFStringRef SecCertificateCopySubjectSummary (SecCertificateRef certificate) __attribute__((weak_import));
    #define SecCertificateCopySubjectSummary ((CFStringRef(*)(SecCertificateRef)) NULL) /* We can't safely weak-link what we don't have */

    /* SecPolicyCreateBasicX509() was added in 10.6 */
    extern SecPolicyRef SecPolicyCreateBasicX509 (void) __attribute__((weak_import));
    #define SecPolicyCreateBasicX509 ((SecPolicyRef(*)(void)) NULL) /* We can't safely weak-link what we don't have */
#endif

/* Allow building with SDKs <= 10.6 */
#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_6
    /* SecCertificateCopyShortDescription() was added in 10.7 */
    extern CFStringRef SecCertificateCopyShortDescription (CFAllocatorRef alloc, SecCertificateRef certificate, CFErrorRef *error) __attribute__((weak_import));
    #define SecCertificateCopyShortDescription ((CFStringRef(*)(CFAllocatorRef, SecCertificateRef, CFErrorRef *)) NULL) /* We can't safely weak-link what we don't have */

    /* SecItemExport() was added in 10.7 */
    typedef struct {
      uint32_t                  version;
      SecKeyImportExportFlags   flags;
      CFTypeRef                 passphrase;
      CFStringRef               alertTitle;
      CFStringRef               alertPrompt;
      SecAccessRef              accessRef;
      CFArrayRef                keyUsage;
      CFArrayRef                keyAttributes;
    } SecItemImportExportKeyParameters;

    extern OSStatus SecItemExport (
       CFTypeRef secItemOrArray,
       SecExternalFormat outputFormat,
       SecItemImportExportFlags flags,
       const SecItemImportExportKeyParameters *keyParams,
       CFDataRef *exportedData
    ) __attribute__((weak_import));
    #define SecItemExport ((OSStatus(*)(CFTypeRef, SecExternalFormat, SecItemImportExportFlags, const SecItemImportExportKeyParameters *, CFDataRef *)) NULL) /* We can't safely weak-link what we don't have */
#endif
