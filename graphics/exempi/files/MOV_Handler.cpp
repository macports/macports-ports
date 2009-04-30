// =================================================================================================
// ADOBE SYSTEMS INCORPORATED
// Copyright 2002-2008 Adobe Systems Incorporated
// All Rights Reserved
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in accordance with the terms
// of the Adobe license agreement accompanying it.
// =================================================================================================

#include "XMP_Environment.h"		// ! This must be the first include.
#if ! ( XMP_64 || XMP_UNIXBuild)	//	Closes at very bottom.

#if XMP_WinBuild
	#pragma warning ( disable : 4996 )	// '...' was declared deprecated
#endif

#include "MOV_Handler.hpp"
#include "QuickTime_Support.hpp"

#include "QuickTimeComponents.h"

#if XMP_WinBuild
	#include "QTML.h"
	#include "Movies.h"
#endif

#if XMP_MacBuild
	#include <Movies.h>
#endif

using namespace std;

static	OSType	kXMPUserDataType = 'XMP_';
static	long	kXMPUserDataTypeIndex = 1;

static bool CreatorAtom_SetProperties ( SXMPMeta& xmpObj, 
									    const MOV_MetaHandler::CreatorAtomStrings& creatorAtomStrings );

static bool CreatorAtom_Update ( SXMPMeta& xmpObj, UserData& movieUserData );

static bool CreatorAtom_ReadStrings ( MOV_MetaHandler::CreatorAtomStrings& creatorAtomStrings, 
								      UserData& movieUserData );

// =================================================================================================
/// \file MOV_Handler.cpp
/// \brief File format handler for MOV.
///
/// This header ...
///
// =================================================================================================

// =================================================================================================
// MOV_MetaHandlerCTor
// ===================

XMPFileHandler * MOV_MetaHandlerCTor ( XMPFiles * parent )
{
	return new MOV_MetaHandler ( parent );

}	// MOV_MetaHandlerCTor

// =================================================================================================
// MOV_CheckFormat
// ===============

bool MOV_CheckFormat ( XMP_FileFormat format,
					   XMP_StringPtr  filePath,
                       LFA_FileRef    fileRef,
                       XMPFiles *     parent )
{
	IgnoreParam(format); IgnoreParam(fileRef);
	
	XMP_Assert ( format == kXMP_MOVFile );
	XMP_Assert ( fileRef == 0 );
	
	bool inBackground = XMP_OptionIsSet ( parent->openFlags, kXMPFiles_OpenInBackground );

	if ( parent->format != kXMP_MOVFile ) return false;	// Check the first call hint, QT is promiscuous.
	if ( ! QuickTime_Support::sMainInitOK ) return false;
	
	if ( inBackground ) {
		if ( ! QuickTime_Support::ThreadInitialize() ) return false;
	}

	bool   isMov = false;
	OSErr  err = noErr;

	Handle qtDataRef = 0;
	OSType qtRefType;
	Movie  tempMovie = 0;
	short  flags;

	CFStringRef cfsPath = CFStringCreateWithCString ( 0, filePath, kCFStringEncodingUTF8 );
	if ( cfsPath == 0 ) return false;	// ? Throw?
		
	err = QTNewDataReferenceFromFullPathCFString ( cfsPath, kQTNativeDefaultPathStyle, 0, &qtDataRef, &qtRefType );
	if ( err != noErr ) goto EXIT;
	
	flags = newMovieDontResolveDataRefs | newMovieDontAskUnresolvedDataRefs;
	err = NewMovieFromDataRef ( &tempMovie, flags, 0, qtDataRef, qtRefType );
	if ( err != noErr ) goto EXIT;
	
	isMov = true;

EXIT:

	if ( tempMovie != 0 ) DisposeMovie ( tempMovie );
	if ( qtDataRef != 0 ) DisposeHandle ( qtDataRef );
	if ( cfsPath != 0 ) CFRelease ( cfsPath );

	if ( inBackground && (! isMov) ) QuickTime_Support::ThreadTerminate();
	return isMov;	

}	// MOV_CheckFormat

// =================================================================================================
// MOV_MetaHandler::MOV_MetaHandler
// ================================

MOV_MetaHandler::MOV_MetaHandler ( XMPFiles * _parent )
	: mQTInit(false), mMovieDataRef(0), mMovieDataHandler(0), mMovie(0), mMovieResourceID(0), mFilePermission(0)
{

	this->parent = _parent;
	this->handlerFlags = kMOV_HandlerFlags;
	this->stdCharForm  = kXMP_Char8Bit;

}	// MOV_MetaHandler::MOV_MetaHandler

// =================================================================================================
// MOV_MetaHandler::~MOV_MetaHandler
// =================================

MOV_MetaHandler::~MOV_MetaHandler()
{
	bool inBackground = XMP_OptionIsSet ( this->parent->openFlags, kXMPFiles_OpenInBackground );

	this->CloseMovie();
	if ( inBackground ) QuickTime_Support::ThreadTerminate();

}	// MOV_MetaHandler::~MOV_MetaHandler

// =================================================================================================
// MOV_MetaHandler::ProcessXMP
// ===========================

void MOV_MetaHandler::ProcessXMP()
{
	if ( (!this->containsXMP) || this->processedXMP ) return;

	if ( this->handlerFlags & kXMPFiles_CanReconcile ) {
		XMP_Throw ( "Reconciling file handlers must implement ProcessXMP", kXMPErr_InternalFailure );
	}

	SXMPUtils::RemoveProperties ( &this->xmpObj, 0, 0, kXMPUtil_DoAllProperties );
	this->xmpObj.ParseFromBuffer ( this->xmpPacket.c_str(), (XMP_StringLen)this->xmpPacket.size() );
	this->processedXMP = true;

	CreatorAtom_SetProperties ( this->xmpObj, mCreatorAtomStrings );

}

// =================================================================================================
// MOV_MetaHandler::UpdateFile
// ===========================

void MOV_MetaHandler::UpdateFile ( bool doSafeUpdate )
{
	if ( ! this->needsUpdate ) return;
	if ( doSafeUpdate ) XMP_Throw ( "MOV_MetaHandler::UpdateFile: Safe update not supported", kXMPErr_Unavailable );

	XMP_StringPtr packetStr = this->xmpPacket.c_str();
	XMP_StringLen packetLen = (XMP_StringLen)this->xmpPacket.size();

	if ( packetLen == 0 ) return;	// Bail if no XMP packet
	
	if ( this->OpenMovie ( (kDataHCanRead | kDataHCanWrite) ) ) {

		UserData movieUserData ( GetMovieUserData ( this->mMovie ) );
		if ( movieUserData != 0 ) {

			OSErr err;

			// Remove previous versions
			err = GetUserData ( movieUserData, 0, kXMPUserDataType, kXMPUserDataTypeIndex );
			if ( err == noErr ) {
				RemoveUserData(movieUserData, kXMPUserDataType, kXMPUserDataTypeIndex);
			}

			// Add the new one
			Handle XMPdata ( NewHandle(packetLen) );
			if ( XMPdata != 0 ) {
				HLock ( XMPdata );
				strncpy ( *XMPdata, packetStr, packetLen );	// AUDIT: Handle created above using packetLen.
				HUnlock ( XMPdata );
				err = AddUserData ( movieUserData, XMPdata, kXMPUserDataType );
				DisposeHandle ( XMPdata );
			}

			CreatorAtom_Update ( this->xmpObj, movieUserData );

		}

	}

	this->needsUpdate = false;

}	// MOV_MetaHandler::UpdateFile

// =================================================================================================
// MOV_MetaHandler::WriteFile
// ==========================

void MOV_MetaHandler::WriteFile ( LFA_FileRef         sourceRef,
								  const std::string & sourcePath )
{
	IgnoreParam(sourceRef); IgnoreParam(sourcePath);
	
	XMP_Throw ( "MOV_MetaHandler::WriteFile: Not supported", kXMPErr_Unavailable );

}	// MOV_MetaHandler::WriteFile

// =================================================================================================
// MOV_MetaHandler::OpenMovie
// ==========================

bool MOV_MetaHandler::OpenMovie ( long inPermission )
{
	// If the file is already opened with the correct permission, bail
	if ( (inPermission == this->mFilePermission) && (this->mMovie != 0) ) return true;

	// If already open, close to open with new permissions
	if ( (this->mMovieDataRef != 0) || (this->mMovieDataHandler != 0) || (this->mMovie != 0) ) this->CloseMovie();
	XMP_Assert ( (this->mMovieDataRef == 0) && (this->mMovieDataHandler == 0) && (this->mMovie == 0) );

	OSErr  err = noErr;
	OSType qtRefType;
	short  flags;

	CFStringRef cfsPath = CFStringCreateWithCString ( 0, this->parent->filePath.c_str(), kCFStringEncodingUTF8 );
	if ( cfsPath == 0 ) return false;	// ? Throw?
		
	err = QTNewDataReferenceFromFullPathCFString ( cfsPath, kQTNativeDefaultPathStyle, 0,
												   &this->mMovieDataRef, &qtRefType );
	if ( err != noErr ) goto FAILURE;
	
	this->mFilePermission = inPermission;
	err = OpenMovieStorage ( this->mMovieDataRef, qtRefType, this->mFilePermission, &this->mMovieDataHandler );
	if ( err != noErr ) goto FAILURE;
	
	flags = newMovieDontAskUnresolvedDataRefs;
	this->mMovieResourceID = 0;	// *** Is this the right input value?
	err = NewMovieFromDataRef ( &this->mMovie, flags, &this->mMovieResourceID, this->mMovieDataRef, qtRefType );
	if ( err != noErr ) goto FAILURE;

	if ( cfsPath != 0 ) CFRelease ( cfsPath );
	return true;

FAILURE:

	if ( this->mMovie != 0 ) DisposeMovie ( this->mMovie );
	if ( this->mMovieDataHandler != 0 ) CloseMovieStorage ( this->mMovieDataHandler );
	if ( this->mMovieDataRef != 0 ) DisposeHandle ( this->mMovieDataRef );
	
	this->mMovie = 0;
	this->mMovieDataHandler = 0;
	this->mMovieDataRef = 0;

	if ( cfsPath != 0 ) CFRelease ( cfsPath );	
	return false;

}	// MOV_MetaHandler::OpenMovie

// =================================================================================================
// MOV_MetaHandler::CloseMovie
// ===========================

void MOV_MetaHandler::CloseMovie()
{

	if ( this->mMovie != 0 ) {
		if ( HasMovieChanged ( this->mMovie ) ) {	// If the movie has been modified, write it to disk.
			(void) UpdateMovieInStorage ( this->mMovie, this->mMovieDataHandler );
		}
		DisposeMovie ( this->mMovie );
	}

	if ( this->mMovieDataHandler != 0 ) CloseMovieStorage ( this->mMovieDataHandler );
	if ( this->mMovieDataRef != 0 ) DisposeHandle ( this->mMovieDataRef );
	
	this->mMovie = 0;
	this->mMovieDataHandler = 0;
	this->mMovieDataRef = 0;

}	// MOV_MetaHandler::CloseMovie

// =================================================================================================
// GetAtomInfo
// ===========

struct AtomInfo {
	XMP_Int64 atomSize;
	XMP_Uns32 atomType;
	bool hasLargeSize;
};

enum {	// ! Do not rearrange, code depends on this order.
	kBadQT_NoError		= 0,	// No errors.
	kBadQT_SmallInner	= 1,	// An extra 1..7 bytes at the end of an inner span.
	kBadQT_LargeInner	= 2,	// More serious inner garbage, found as invalid atom length.
	kBadQT_SmallOuter	= 3,	// An extra 1..7 bytes at the end of the file.
	kBadQT_LargeOuter	= 4		// More serious EOF garbage, found as invalid atom length.
};
typedef XMP_Uns8 QTErrorMode;

static QTErrorMode GetAtomInfo ( const LFA_FileRef qtFile, XMP_Int64 spanSize, int nesting, AtomInfo * info )
{
	QTErrorMode status = kBadQT_NoError;
	XMP_Uns8 buffer [8];
	
	info->hasLargeSize = false;
	
	LFA_Read ( qtFile, buffer, 8, kLFA_RequireAll );	// Will throw if 8 bytes aren't available.
	info->atomSize = GetUns32BE ( &buffer[0] );	// ! Yes, the initial size is big endian UInt32.
	info->atomType = GetUns32BE ( &buffer[4] );
	
	if ( info->atomSize == 0 ) {	// Does the atom extend to EOF?

		if ( nesting != 0 ) return kBadQT_LargeInner;
		info->atomSize = spanSize;	// This outer atom goes to EOF.

	} else if ( info->atomSize == 1 ) {	// Does the atom have a 64-bit size?

		if ( spanSize < 16 ) {	// Is there room in the span for the 16 byte header?
			status = kBadQT_LargeInner;
			if ( nesting == 0 ) status += 2;	// Convert to "outer".
			return status;
		}

		LFA_Read ( qtFile, buffer, 8, kLFA_RequireAll );
		info->atomSize = (XMP_Int64) GetUns64BE ( &buffer[0] );
		info->hasLargeSize = true;

	}
	
	XMP_Assert ( status == kBadQT_NoError );
	return status;

}	// GetAtomInfo

// =================================================================================================
// CheckAtomList
// =============
//
// Check that a sequence of atoms fills a given span. The I/O position must be at the start of the
// span, it is left just past the span on success. Recursive checks are done for top level 'moov'
// atoms, and second level 'udta' atoms ('udta' inside 'moov').
//
// Checking continues for "small inner" errors. They will be reported if no other kinds of errors
// are found, otherwise the other error is reported. Checking is immediately aborted for any "large"
// error. The rationale is that QuickTime can apparently handle small inner errors. They might be
// arise from updates that shorten an atom by less than 8 bytes. Larger shrinkage should introduce a
// 'free' atom.

static QTErrorMode CheckAtomList ( const LFA_FileRef qtFile, XMP_Int64 spanSize, int nesting )
{
	QTErrorMode status = kBadQT_NoError;
	AtomInfo    info;
	
	const static XMP_Uns32 moovAtomType = 0x6D6F6F76;	// ! Don't use MakeUns32BE, already big endian.
	const static XMP_Uns32 udtaAtomType = 0x75647461;
	
	for ( ; spanSize >= 8; spanSize -= info.atomSize ) {
	
		QTErrorMode atomStatus = GetAtomInfo ( qtFile, spanSize, nesting, &info );
		if ( atomStatus != kBadQT_NoError ) return atomStatus;
		
		XMP_Int64 headerSize = 8;
		if ( info.hasLargeSize ) headerSize = 16;
		
		if ( (info.atomSize < headerSize) || (info.atomSize > spanSize) ) {
			status = kBadQT_LargeInner;
			if ( nesting == 0 ) status += 2;	// Convert to "outer".
			return status;
		}
		
		bool doChildren = false;
		if ( (nesting == 0) && (info.atomType == moovAtomType) ) doChildren = true;
		if ( (nesting == 1) && (info.atomType == udtaAtomType) ) doChildren = true;
		
		XMP_Int64 dataSize = info.atomSize - headerSize;
		
		if ( ! doChildren ) {
			LFA_Seek ( qtFile, dataSize, SEEK_CUR );
		} else {
			QTErrorMode innerStatus = CheckAtomList ( qtFile, dataSize, nesting+1 );
			if ( innerStatus > kBadQT_SmallInner ) return innerStatus;	// Quit for serious errors.
			if ( status == kBadQT_NoError ) status = innerStatus;	// Remember small inner errors.
		}
	
	}
	
	XMP_Assert ( status <= kBadQT_SmallInner );	// Else already returned.
	// ! Make sure inner kBadQT_SmallInner is propagated if this span is OK.
	
	if ( spanSize != 0 ) {
		LFA_Seek ( qtFile, spanSize, SEEK_CUR );	// ! Skip the trailing garbage of this span.
		status = kBadQT_SmallInner;
		if ( spanSize >= 8 ) status = kBadQT_LargeInner;
		if ( nesting == 0 ) status += 2;	// Convert to "outer".
	}
	
	return status;

}	// CheckAtomList

// =================================================================================================
// AttemptFileRepair
// =================

static void AttemptFileRepair ( LFA_FileRef qtFile, XMP_Int64 fileSpace, QTErrorMode status )
{
	
	switch ( status ) {
		case kBadQT_NoError    : return;	// Sanity check.
		case kBadQT_SmallInner : return;	// Ignore these, QT seems to be able to handle them.
		case kBadQT_LargeInner : XMP_Throw ( "Can't repair QuickTime file", kXMPErr_BadFileFormat );
		case kBadQT_SmallOuter : break;		// Truncate file below.
		case kBadQT_LargeOuter : break;		// Truncate file below.
		default                : XMP_Throw ( "Invalid QuickTime error mode", kXMPErr_InternalFailure );
	}

	AtomInfo info;
	XMP_Int64 headerSize;
	
	// Process the top level atoms until an error is found.
	
	LFA_Seek ( qtFile, 0, SEEK_SET );
	
	for ( ; fileSpace >= 8; fileSpace -= info.atomSize ) {
	
		QTErrorMode atomStatus = GetAtomInfo ( qtFile, fileSpace, 0, &info );
		
		headerSize = 8;	// ! Set this before checking atomStatus, used after the loop.
		if ( info.hasLargeSize ) headerSize = 16;
		
		if ( atomStatus != kBadQT_NoError ) break;
		if ( (info.atomSize < headerSize) || (info.atomSize > fileSpace) ) break;
		
		XMP_Int64 dataSize = info.atomSize - headerSize;
		LFA_Seek ( qtFile, dataSize, SEEK_CUR );
	
	}
	
	// Truncate the file. If fileSpace >= 8 then the loop exited early due to a bad atom, seek back
	// to the atom's start. Otherwise, the loop exited because no mmore atoms are possible, no seek.
	
	if ( fileSpace >= 8 ) LFA_Seek ( qtFile, -headerSize, SEEK_CUR );
	XMP_Int64 currPos = LFA_Tell ( qtFile );
	LFA_Truncate ( qtFile, currPos );

}	// AttemptFileRepair

// =================================================================================================
// CheckFileStructure
// ==================

static void CheckFileStructure ( XMPFileHandler * thiz, bool doRepair )
{
	XMPFiles * parent = thiz->parent;
	
	// Open the disk file so we can look inside and maybe repair.
	
	AutoFile localFile;	// ! Don't use parent->fileRef keep this usage private.
	XMP_Assert ( parent->fileRef == 0 );	// The file should not be open yet.
	
	char openMode = 'r';
	if ( doRepair ) openMode = 'w';
	localFile.fileRef = LFA_Open ( parent->filePath.c_str(), openMode );
	if ( localFile.fileRef == 0 ) XMP_Throw ( "Can't open QuickTime file for update checks", kXMPErr_ExternalFailure );
	XMP_Int64 fileSize = LFA_Measure ( localFile.fileRef );
	
	// Check the basic file structure and try to repair if asked.
	
	QTErrorMode status = CheckAtomList ( localFile.fileRef, fileSize, 0 );
	
	if ( status != kBadQT_NoError ) {
		if ( doRepair ) {
			AttemptFileRepair ( localFile.fileRef, fileSize, status );	// Will throw if the attempt fails.
		} else if ( status != kBadQT_SmallInner ) {
			XMP_Throw ( "Ill-formed QuickTime file", kXMPErr_BadFileFormat );
		} else {
			return;	// ! Ignore these, QT seems to be able to handle them.
			// *** Might want to throw for check-only, ignore when repairing.
		}
	}

}	// CheckFileStructure;


// =================================================================================================
// MOV_MetaHandler::CacheFileData
// ==============================

void MOV_MetaHandler::CacheFileData()
{

	// Pre-check files opened for update. We've found bugs in Apple's QT code that make slightly
	// ill-formed files unreadable.

	XMPFiles * parent = this->parent;
	
	const bool isUpdate = XMP_OptionIsSet ( parent->openFlags, kXMPFiles_OpenForUpdate );
	const bool doRepair = XMP_OptionIsSet ( parent->openFlags, kXMPFiles_OpenRepairFile );
	
	if ( isUpdate ) {
		CheckFileStructure ( this, doRepair );	// Will throw for failure.
	}
	
	// Continue with the usual caching of the file's metadata.
	
	this->containsXMP = false;
	
	if ( this->OpenMovie ( kDataHCanRead ) ) {

		UserData movieUserData ( GetMovieUserData ( this->mMovie ) );
		if ( movieUserData != 0 ) {

			Handle XMPdataHandle ( NewHandle(0) );
			if ( XMPdataHandle != 0 ) {
			
				OSErr err = GetUserData ( movieUserData, XMPdataHandle, kXMPUserDataType, kXMPUserDataTypeIndex );
				if (err != noErr) {	// userDataItemNotFound = -2026

					packetInfo.writeable = true;	// If no packet found, created packets will be writeable

				} else {

					// Convert handles data, to std::string raw
					this->xmpPacket.clear();
					size_t dataSize = GetHandleSize ( XMPdataHandle );
					HLock(XMPdataHandle);
					this->xmpPacket.assign ( (const char*)(*XMPdataHandle), dataSize );
					HUnlock ( XMPdataHandle );

					this->packetInfo.offset = kXMPFiles_UnknownOffset;
					this->packetInfo.length = (XMP_Int32)dataSize;
					this->containsXMP = true;

					CreatorAtom_ReadStrings ( mCreatorAtomStrings, movieUserData );

				}
	
				DisposeHandle ( XMPdataHandle );

			}

		}

	}

}	// MOV_MetaHandler::CacheFileData

// =================================================================================================
// =================================================================================================

// *** Could be pulled out, maybe refactored and partly shared with AVI and WAV.

#pragma pack(push,1)

//	[TODO] Can we switch to using just a full path here?
struct FSSpecLegacy
{
	short	vRefNum;
	long	parID;
	char	name[260]; // http://msdn.microsoft.com/library/default.asp?url=/library/en-us/fileio/fs/naming_a_file.asp  -- 260 is "old school", 32000 is "new school".
};

struct CR8R_CreatorAtom
{
	unsigned long		magicLu;

	long				atom_sizeL;			// Size of this structure.
	short				atom_vers_majorS;	// Major atom version.
	short				atom_vers_minorS;	// Minor atom version.

	// mac
	unsigned long		creator_codeLu;		// Application code on MacOS.
	unsigned long		creator_eventLu;	// Invocation appleEvent.

	// windows
	char				creator_extAC[16];	// Extension allowing registry search to app.
	char				creator_flagAC[16];	// Flag passed to app at invocation time.

	char				creator_nameAC[32];	// Name of the creator application.
};

typedef CR8R_CreatorAtom** CR8R_CreatorAtomHandle;

typedef enum
{
	Embed_ExportTypeMovie = 0,
	Embed_ExportTypeStill,
	Embed_ExportTypeAudio,
	Embed_ExportTypeCustom
}
Embed_ExportType;


struct Embed_ProjectLinkAtom
{
	// header data
	unsigned long		magicLu;
	long				atom_sizeL;
	short				atom_vers_apiS;
	short				atom_vers_codeS;

	// the link data
	unsigned long		exportType;		// See enum. The type of export that generated the file

	//	[TODO] Can we switch to using just a full path here?
	FSSpecLegacy		fullPath;		// Full path of the project file
};

#pragma pack(pop)

// -------------------------------------------------------------------------------------------------

#define kCreatorTool		"CreatorTool"
#define AdobeCreatorAtomVersion_Major 1
#define AdobeCreatorAtomVersion_Minor 0
#define AdobeCreatorAtom_Magic 0xBEEFCAFE

#define myCreatorAtom	MakeFourCC ( 'C','r','8','r' )

static void CreatorAtom_Initialize ( CR8R_CreatorAtom& creatorAtom )
{
	memset ( &creatorAtom, 0, sizeof(CR8R_CreatorAtom) );
	creatorAtom.magicLu				= AdobeCreatorAtom_Magic;
	creatorAtom.atom_vers_majorS	= AdobeCreatorAtomVersion_Major;
	creatorAtom.atom_vers_minorS	= AdobeCreatorAtomVersion_Minor;
	creatorAtom.atom_sizeL			= sizeof(CR8R_CreatorAtom);
}

// -------------------------------------------------------------------------------------------------

#define PR_PROJECT_LINK_ATOM_VERS_API 1
#define PR_PROJECT_LINK_ATOM_VERS_CODE 0
#define PR_PROJECT_LINK_ATOM_TYPE 'PrmL'
#define PR_PROJECT_LINK_MAGIC 0x600DF00D // GoodFood 

#define myProjectLink	MakeFourCC ( 'P','r','m','L')

// -------------------------------------------------------------------------------------------------

static void CreatorAtom_MakeValid ( CR8R_CreatorAtom * creator_atomP )
{
	// If already valid, no conversion is needed.
	if ( creator_atomP->magicLu == AdobeCreatorAtom_Magic ) return;

	Flip4 ( &creator_atomP->magicLu );
	Flip2 ( &creator_atomP->atom_vers_majorS );
	Flip2 ( &creator_atomP->atom_vers_minorS );

	Flip4 ( &creator_atomP->atom_sizeL );
	Flip4 ( &creator_atomP->creator_codeLu );
	Flip4 ( &creator_atomP->creator_eventLu );

	XMP_Assert ( creator_atomP->magicLu == AdobeCreatorAtom_Magic );
}

// -------------------------------------------------------------------------------------------------

static void CreatorAtom_ToBE ( CR8R_CreatorAtom * creator_atomP )
{
	creator_atomP->atom_vers_majorS = MakeUns16BE ( creator_atomP->atom_vers_majorS );
	creator_atomP->atom_vers_minorS = MakeUns16BE ( creator_atomP->atom_vers_minorS );

	creator_atomP->magicLu			= MakeUns32BE ( creator_atomP->magicLu );
	creator_atomP->atom_sizeL		= MakeUns32BE ( creator_atomP->atom_sizeL );
	creator_atomP->creator_codeLu	= MakeUns32BE ( creator_atomP->creator_codeLu );
	creator_atomP->creator_eventLu	= MakeUns32BE ( creator_atomP->creator_eventLu );
}

// -------------------------------------------------------------------------------------------------

static void ProjectLinkAtom_MakeValid ( Embed_ProjectLinkAtom * link_atomP )
{
	// If already valid, no conversion is needed.
	if ( link_atomP->magicLu == PR_PROJECT_LINK_MAGIC ) return;

	// do the header
	Flip4 ( &link_atomP->magicLu );
	Flip4 ( &link_atomP->atom_sizeL );
	Flip2 ( &link_atomP->atom_vers_apiS );
	Flip2 ( &link_atomP->atom_vers_codeS );

	// do the FSSpec data
	Flip2 ( &link_atomP->fullPath.vRefNum );
	Flip4 ( &link_atomP->fullPath.parID );

	XMP_Assert ( link_atomP->magicLu == PR_PROJECT_LINK_MAGIC );
}

// -------------------------------------------------------------------------------------------------

static void ProjectLinkAtom_Initialize ( Embed_ProjectLinkAtom& epla, Embed_ExportType type,
										 const std::string& projectPathString)
{

	memset ( &epla, 0, sizeof(Embed_ProjectLinkAtom) );

	epla.magicLu = PR_PROJECT_LINK_MAGIC;
	epla.atom_sizeL = epla.atom_vers_apiS = PR_PROJECT_LINK_ATOM_VERS_API;
	epla.atom_vers_codeS = PR_PROJECT_LINK_ATOM_VERS_CODE;
	epla.atom_sizeL = sizeof(Embed_ProjectLinkAtom);
	epla.exportType = type;
	epla.fullPath.vRefNum = 0;
	epla.fullPath.parID = 0;

	strncpy ( epla.fullPath.name, projectPathString.c_str(),
			  min ( projectPathString.length(), sizeof(epla.fullPath.name) ) );

}

// -------------------------------------------------------------------------------------------------

static bool Mov_ReadProjectLinkAtom ( UserData& movieUserData, Embed_ProjectLinkAtom* epla )
{
	Handle PrmLdataHandle ( NewHandle(0) );
	if ( PrmLdataHandle == 0 ) return false;

	OSErr err = GetUserData ( movieUserData, PrmLdataHandle, 'PrmL', 1 );
	if ( err != noErr ) return false;

	// Convert handles data, to std::string raw
	//					std::string PrmLPacket;
	//					PrmLPacket.clear();
	size_t dataSize = GetHandleSize ( PrmLdataHandle );
	HLock ( PrmLdataHandle );

	bool ok = (dataSize == sizeof(Embed_ProjectLinkAtom));
	if ( ok ) {
		memcpy ( epla, (*PrmLdataHandle), dataSize );
		ProjectLinkAtom_MakeValid ( epla );
	}
	
	HUnlock ( PrmLdataHandle );
	DisposeHandle ( PrmLdataHandle );

	return ok;

}

// -------------------------------------------------------------------------------------------------

static bool Mov_ReadCreatorAtom ( UserData& movieUserData, CR8R_CreatorAtom* creatorAtom )
{
	Handle PrmLdataHandle ( NewHandle(0) );
	if ( PrmLdataHandle == 0 ) return false;

	OSErr err = GetUserData ( movieUserData, PrmLdataHandle, 'Cr8r', 1 );
	if ( err != noErr ) return false;

	// Convert handles data, to std::string raw
	//					std::string PrmLPacket;
	//					PrmLPacket.clear();
	size_t dataSize = GetHandleSize ( PrmLdataHandle );
	HLock ( PrmLdataHandle );
	
	bool ok = (sizeof(CR8R_CreatorAtom) == dataSize);
	if ( ok ) {
		memcpy ( creatorAtom, (*PrmLdataHandle), dataSize );
		CreatorAtom_MakeValid ( creatorAtom );
	}

	HUnlock ( PrmLdataHandle );
	DisposeHandle ( PrmLdataHandle );

	return ok;

}

// -------------------------------------------------------------------------------------------------

static bool Mov_WriteCreatorAtom ( UserData& movieUserData, CR8R_CreatorAtom& creatorAtom, bool mustExist )
{
	Handle PrmLdataHandle ( NewHandle(sizeof(CR8R_CreatorAtom)) );
	if ( PrmLdataHandle == 0 ) return false;

	OSErr err = GetUserData ( movieUserData, PrmLdataHandle, 'Cr8r', 1);
	if ( err == noErr ) {
		while ( ! RemoveUserData ( movieUserData, 'Cr8r', 1 ) ) {};
	} else {
		if ( mustExist ) return false;
	}
	
	// Convert handles data, to std::string raw
	//					std::string PrmLPacket;
	//					PrmLPacket.clear();
	size_t dataSize = GetHandleSize ( PrmLdataHandle );
	HLock ( PrmLdataHandle );
	memcpy ( (*PrmLdataHandle), &creatorAtom, sizeof(CR8R_CreatorAtom) );
	CreatorAtom_ToBE ( (CR8R_CreatorAtom*)(*PrmLdataHandle) );
	HUnlock ( PrmLdataHandle );

	OSErr movieErr = AddUserData ( movieUserData, PrmLdataHandle, 'Cr8r');

	DisposeHandle ( PrmLdataHandle );

	return movieErr==0;
}

// -------------------------------------------------------------------------------------------------

#define DoAssignBufferedString(str,buffer)	AssignBufferedString ( str, buffer, sizeof(buffer) )

static inline void AssignBufferedString ( std::string & str, const char * buffer, size_t maxLen )
{
	size_t len;
	for ( len = 0; (len < maxLen) && (buffer[len] != 0); ++len ) { /* empty body */ }
	str.assign ( buffer, len );
}

// -------------------------------------------------------------------------------------------------

static bool CreatorAtom_ReadStrings ( MOV_MetaHandler::CreatorAtomStrings& creatorAtomStrings, 
							   		  UserData& movieUserData )
{
	Embed_ProjectLinkAtom epla;
	bool ok = Mov_ReadProjectLinkAtom ( movieUserData, &epla );

	if ( ok ) {

		std::string projectPathString = epla.fullPath.name;

		if ( ! projectPathString.empty() ) {

			if ( projectPathString[0] == '/' ) {
				creatorAtomStrings.posixProjectPath = projectPathString;
			} else if ( projectPathString.substr(0,4) == std::string("\\\\?\\") ) {
				creatorAtomStrings.uncProjectPath = projectPathString;
			}

			switch ( epla.exportType ) {
				case Embed_ExportTypeMovie	: creatorAtomStrings.projectRefType = "movie"; break;
				case Embed_ExportTypeStill	: creatorAtomStrings.projectRefType = "still"; break;
				case Embed_ExportTypeAudio  : creatorAtomStrings.projectRefType = "audio"; break;
				case Embed_ExportTypeCustom : creatorAtomStrings.projectRefType = "custom"; break;
			}

		}

	}

	CR8R_CreatorAtom creatorAtom;
	ok = Mov_ReadCreatorAtom ( movieUserData, &creatorAtom );

	if ( ok ) {

		char buffer[256];

		sprintf ( buffer, "%d", creatorAtom.creator_codeLu );
		creatorAtomStrings.applicationCode = buffer;

		sprintf ( buffer, "%d", creatorAtom.creator_eventLu );
		creatorAtomStrings.invocationAppleEvent = buffer;

		DoAssignBufferedString ( creatorAtomStrings.extension, creatorAtom.creator_extAC );
		DoAssignBufferedString ( creatorAtomStrings.invocationFlags, creatorAtom.creator_flagAC );
		DoAssignBufferedString ( creatorAtomStrings.creatorTool, creatorAtom.creator_nameAC );

	}

	return ok;

}

// -------------------------------------------------------------------------------------------------

static bool CreatorAtom_SetProperties ( SXMPMeta& xmpObj, 
									    const MOV_MetaHandler::CreatorAtomStrings& creatorAtomStrings )
{
	if ( ! creatorAtomStrings.posixProjectPath.empty() ) {
		xmpObj.SetStructField ( kXMP_NS_CreatorAtom, "macAtom",
								kXMP_NS_CreatorAtom, "posixProjectPath", creatorAtomStrings.posixProjectPath, 0 );
	}

	if ( ! creatorAtomStrings.uncProjectPath.empty() ) {
		xmpObj.SetStructField ( kXMP_NS_CreatorAtom, "windowsAtom",
								kXMP_NS_CreatorAtom, "uncProjectPath", creatorAtomStrings.uncProjectPath, 0 );
	}

	if ( ! creatorAtomStrings.projectRefType.empty() ) {
		xmpObj.SetStructField ( kXMP_NS_DM, "projectRef", kXMP_NS_DM, "type", creatorAtomStrings.projectRefType.c_str());
	}

	if ( ! creatorAtomStrings.applicationCode.empty() ) {
		xmpObj.SetStructField ( kXMP_NS_CreatorAtom, "macAtom",
								kXMP_NS_CreatorAtom, "applicationCode", creatorAtomStrings.applicationCode, 0 );
	}

	if ( ! creatorAtomStrings.invocationAppleEvent.empty() ) {
		xmpObj.SetStructField ( kXMP_NS_CreatorAtom, "macAtom",
								kXMP_NS_CreatorAtom, "invocationAppleEvent", creatorAtomStrings.invocationAppleEvent, 0 );
	}

	if ( ! creatorAtomStrings.extension.empty() ) {
		xmpObj.SetStructField ( kXMP_NS_CreatorAtom, "windowsAtom",
								kXMP_NS_CreatorAtom, "extension", creatorAtomStrings.extension, 0 );
	}

	if ( ! creatorAtomStrings.invocationFlags.empty() ) {
		xmpObj.SetStructField ( kXMP_NS_CreatorAtom, "windowsAtom",
								kXMP_NS_CreatorAtom, "invocationFlags", creatorAtomStrings.invocationFlags, 0 );
	}

	if ( ! creatorAtomStrings.creatorTool.empty() ) {
		xmpObj.SetProperty ( kXMP_NS_XMP, "CreatorTool", creatorAtomStrings.creatorTool, 0 );
	}

	return ok;

}

// -------------------------------------------------------------------------------------------------

#define EnsureFinalNul(buffer) buffer [ sizeof(buffer) - 1 ] = 0

static bool CreatorAtom_Update ( SXMPMeta& xmpObj, 
							     UserData& movieUserData )
{

	// Get Creator Atom XMP values.
	bool found = false;
	std::string posixPathString, uncPathString;
	if ( xmpObj.GetStructField ( kXMP_NS_CreatorAtom, "macAtom", kXMP_NS_CreatorAtom, "posixProjectPath", &posixPathString, 0 ) ) found = true;
	if ( xmpObj.GetStructField ( kXMP_NS_CreatorAtom, "windowsAtom", kXMP_NS_CreatorAtom, "uncProjectPath", &uncPathString, 0 ) ) found = true;

	std::string applicationCodeString, invocationAppleEventString, extensionString, invocationFlagsString, creatorToolString;
	if ( xmpObj.GetStructField ( kXMP_NS_CreatorAtom, "macAtom", kXMP_NS_CreatorAtom, "applicationCode", &applicationCodeString, 0 ) ) found = true;
	if ( xmpObj.GetStructField ( kXMP_NS_CreatorAtom, "macAtom", kXMP_NS_CreatorAtom, "invocationAppleEvent", &invocationAppleEventString, 0 ) ) found = true;
	if ( xmpObj.GetStructField ( kXMP_NS_CreatorAtom, "windowsAtom", kXMP_NS_CreatorAtom, "extension", &extensionString, 0 ) ) found = true;
	if ( xmpObj.GetStructField ( kXMP_NS_CreatorAtom, "windowsAtom", kXMP_NS_CreatorAtom, "invocationFlags", &invocationFlagsString, 0 ) ) found = true;
	if ( xmpObj.GetProperty ( kXMP_NS_XMP, "CreatorTool", &creatorToolString, 0 ) ) found = true;

	// If no Creator Atom information found, don't write anything.
	if ( ! found ) return false;

	// Read Legacy Creator Atom.
	unsigned long creatorAtomSize = 0;
	CR8R_CreatorAtom creatorAtomLegacy;
	CreatorAtom_Initialize ( creatorAtomLegacy );
	bool ok = Mov_ReadCreatorAtom ( movieUserData, &creatorAtomLegacy );

	// Generate new Creator Atom from XMP.
	CR8R_CreatorAtom creatorAtomViaXMP;
	CreatorAtom_Initialize ( creatorAtomViaXMP );

	if ( ! applicationCodeString.empty() ) {
		creatorAtomViaXMP.creator_codeLu = strtoul ( applicationCodeString.c_str(), 0, 0 );
	}
	if ( ! invocationAppleEventString.empty() ) {
		creatorAtomViaXMP.creator_eventLu = strtoul ( invocationAppleEventString.c_str(), 0, 0 );
	}
	if ( ! extensionString.empty() ) {
		strncpy ( creatorAtomViaXMP.creator_extAC, extensionString.c_str(), sizeof(creatorAtomViaXMP.creator_extAC) );
		EnsureFinalNul ( creatorAtomViaXMP.creator_extAC );
	}
	if ( ! invocationFlagsString.empty() ) {
		strncpy ( creatorAtomViaXMP.creator_flagAC, invocationFlagsString.c_str(), sizeof(creatorAtomViaXMP.creator_flagAC) );
		EnsureFinalNul ( creatorAtomViaXMP.creator_flagAC );
	}
	if ( ! creatorToolString.empty() ) {
		strncpy ( creatorAtomViaXMP.creator_nameAC, creatorToolString.c_str(), sizeof(creatorAtomViaXMP.creator_nameAC) );
		EnsureFinalNul ( creatorAtomViaXMP.creator_nameAC );
	}

	// Write Creator Atom.
	if ( ok ) {
		// If there's legacy, update if atom generated from XMP doesn't match legacy.
		if ( memcmp ( &creatorAtomViaXMP, &creatorAtomLegacy, sizeof(CR8R_CreatorAtom) ) != 0 ) {
			ok = Mov_WriteCreatorAtom ( movieUserData, creatorAtomViaXMP, true );
		}
	} else {
		// Write completely new atom from XMP.
		ok = Mov_WriteCreatorAtom ( movieUserData, creatorAtomViaXMP, false );
	}

	return ok;

}

// =================================================================================================

#endif	// XMP_64 || XMP_UNIXBuild
