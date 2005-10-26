//
//  qtplay.c
//  qtplay
//
//  Copyright (c) 2002, Rainbow Flight.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  *  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  *  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//  *  Neither the name of Rainbow Flight nor the names of its contributors may be
//  used to endorse or promote products derived from this software without specific
//  prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//
//  Created by Sarah Childers on Thu Aug 22 2002.
//
//  Released version 1.0 on Sat Sep 7 2002.
//  - Plays any audio file supported by Quicktime, including CDs, AIFF, MIDI, and MP3.
//  - Playlist features such as loop, shuffle, and random.
//  - Special flag for simply playing a CD, for lazy people.
//  - Verbose and quiet flags for different levels of feedback.
//
//  Modified by Matt Slot (MJS) on Tue Sep 10 2002.
//  - Use UpTime() to generate a better random seed.
//
//  Modified by Sarah Childers on Wed Sept 18 2002.
//  - Automatic recognition of CDs.
//  - Ability to read stdin.
//
//  Modified by Sarah Childers on Fri Sep 27 2002. Released version 1.1.
//  - Converted Cocoa calls to Carbon/System calls.
//  - Added support for signals: SIGINT (stop song).
//  - Added support for Aliases.
//  cc -Wall -Wmost -Wcast-qual -O3 -framework Quicktime -framework Carbon -o qtplay qtplay.c
//
//  Modified by Carsten Klapp on Sun Nov 17 2002.
//  - Work around possible qt bug where white boxes show on screen even though all non-audio tracks have already been deleted.
//
//  Modified by Sarah Childers on Sun Dec 15 2002.
//  - Work around a bug in Mac OS X 10.0.x where the filesystem ID and signature bytes were erroneously swapped.
//  - CD detection based on filesystem ID only (instead of on ID and signature).
//  - Added "update time" flag for changing processor usage.
//
//  Modified by Sarah Childers on Wed Dec 18 2002.
//  - Possibly improved error handling while playing.
//  - Added support for playing sound resource files (using Sound Manager).
//
//  Modified by Sarah Childers on Thurs Dec 19 2002.
//  - Fixed bug where if a directory was specified, the filename of files was the whole path instead of relative path. (Bug in Carbon v1.1. Correct in Cocoa v1.0.)
//  - Added support for signals: SIGTSTP (pause song) and SIGCONT (continue song). (Bug: glitches/skipping on 'continue' in v1.1.)
//
//  Modified by Sarah Childers on Sunday Dec 22 2002.
//  - Added "volume" flag.
//  - Fixed bug where if "qtplay" was run without specifying filenames, "./" was prepended to the filenames. (Bug: crashed if type 'qtplay ""'.)
//  cc -prebind -no-cpp-precomp -O3 -framework Quicktime -framework Carbon -o qtplay qtplay.c

#import <Carbon/Carbon.h>
#import <QuickTime/Movies.h>

#include <sys/time.h>
#include <unistd.h>

typedef char BOOL;

// global flags:
BOOL gRecursive = FALSE;
BOOL gVerbose = FALSE;
BOOL gQuiet = FALSE;
BOOL gShuffle = FALSE;
BOOL gRandom = FALSE;
BOOL gLoop = FALSE;
BOOL gCD = FALSE;
int  gSleepTime = 100000;
short gVolume = 0x0100;

// global signal flags:
BOOL gStop = FALSE;
BOOL gPause = FALSE;
BOOL gCont = FALSE;
BOOL gIsPaused = FALSE;

// function prototypes:
void printHelp();
void processSignal(int sigraised);
CFMutableArrayRef getfiles (int count, const char * array[]);
void addContents(CFURLRef path, CFMutableArrayRef files);
void playfile(CFURLRef pathname);
void playfile_quicktime(Movie qtMovie, CFURLRef pathname);
void playfile_sndmanager(int max, CFURLRef pathname);
void removeTracks(Movie movie);

void myprint( const char * string, ... ) { if (!gQuiet) printf(string); };
void myprintv( const char * string, ... ) { if (!gQuiet && gVerbose) printf(string); };
void myprinturl( CFURLRef path )
{
	if (!gQuiet)
	{
		CFStringRef str = CFURLCopyFileSystemPath(path, kCFURLPOSIXPathStyle);
		//myprint("%s\n", CFStringGetCStringPtr(str,CFStringGetSystemEncoding()));
		CFShow(str);//???
		CFRelease(str);
	}
};

/*****************************************/

int main (int argc, const char * argv[])
{
	int filenum = 1; // 0 = path to app; 1 = path to file; ...

	while (filenum < argc && argv[filenum][0] == '-' && argv[filenum][1] != '\0')
	{
		switch (argv[filenum][1])
		{
			case 'l':
				gLoop = TRUE;
				break;
			case 'q':
				gQuiet = TRUE;
				gVerbose = FALSE;
				break;
			case 'r':
				gRecursive = TRUE;
				break;
			case 't':
				if (filenum+1 < argc)
				{
					float seconds;
					if (sscanf(argv[filenum+1],"%f",&seconds) > 0)
					{
						gSleepTime = (int)(seconds * 1000000.0);
						filenum++;
						break;
					}
				}
				// else print help and exit:
				printHelp();
				return 0;
			case 'v':
				gQuiet = FALSE;
				gVerbose = TRUE;
				break;
			case 'V':
				if (filenum+1 < argc)
				{
					float percent;
					if (sscanf(argv[filenum+1],"%f",&percent) > 0)
					{
						if (percent > 100.0) percent = 100.0;
						if (percent <= 0 ) percent = 0;
						gVolume = (short)(percent * .01 * 256); // 100% --> 0x0100
						filenum++;
						break;
					}
				}
				// else print help and exit:
				printHelp();
				return 0;
			case 'z':
				gShuffle = TRUE;
				gRandom = FALSE;
				break;
			case 'Z':
				gShuffle = FALSE;
				gRandom = TRUE;
				break;
			case 'c':
				if (argv[filenum][2] == 'd')
				{
					gCD = TRUE;
					break;
				}
			default:
				// print help and exit:
				printHelp();
				return 0;
		}
		filenum++;
	}
	
	myprint("Welcome to Quicktime Player by Sarah Childers\n");
	myprintv("Initializing.\n");

	// seed random number generator:
	if (gRandom || gShuffle)
		srandom(clock() ^ AbsoluteToNanoseconds(UpTime()).lo); // -- MJS

	// set up signal callbacks:
	signal(SIGINT, &processSignal);
	signal(SIGTSTP, &processSignal);
	signal(SIGCONT, &processSignal);
	
	{
		CFMutableArrayRef files;

		// create list of files
		myprintv("Creating file list.\n");
		
		if (gCD)
		{
			// contents of CDs (passed by global variable):
			files = getfiles(0, NULL);
		}
		else if (filenum == argc)
		{
			// contents of working directory, if no files specified:
			const char * array[] = {""};
			files = getfiles(1, array);
		}
		else
		{
			// specified files:
			files = getfiles(argc-filenum, &argv[filenum]);
		}
		
		myprintv("%d files in play list.\n", CFArrayGetCount(files));
	
		// play list of files
		myprintv("Playing file list.\n");

		if( CFArrayGetCount(files) > 0 )
		{

			EnterMovies();
			do
			{
				filenum = 0;
				while (filenum < CFArrayGetCount(files))
				{
					if (gRandom || gShuffle)
					{
						// swap array[i] with array[random]
						int new = filenum + ( random() % (CFArrayGetCount(files)-filenum) );
						CFURLRef temp = CFArrayGetValueAtIndex(files, filenum);
						CFArraySetValueAtIndex(files, filenum, CFArrayGetValueAtIndex(files, new));
						CFArraySetValueAtIndex(files, new, temp);
					}
					
					playfile( CFArrayGetValueAtIndex(files, filenum) );

					if (!gRandom)
						filenum++;
				}
			}
			while (gLoop);
			ExitMovies();
		}
	}
	
    return 0;
}

void printHelp()
{
	printf("usage: qtplay [OPTION] [file(s) | -]\n");
	printf("       qtplay [OPTION] -cd\n");
	printf("\n");
	printf(" -l      loop\n");
	printf(" -q      quiet\n");
	printf(" -r      recursive\n");
	printf(" -v      verbose\n");
	printf(" -z      shuffle play\n");
	printf(" -Z      random play\n");
	printf("\n");
	printf(" -t val  update time (in seconds; default = .1)\n");
	printf(" -V val  volume (in percent; default = 100)\n");
	printf("\n");
	printf(" -       read standard input\n");
	printf(" -cd     plays all CDs\n");
}

void processSignal(int sigraised)
{
	static time_t mytime = 0;
	
	myprint("\n"); // so ^C on its own line...
	if (sigraised == SIGINT) // interupt: ^C
	{
		gStop = TRUE;
		if (clock() - mytime <= (int)GetDblTime())
		{
			myprintv("User terminated program.\n");
			exit(0); // no error: we want to exit if press ^C^C
		}
		mytime = clock();
	}
	else if (sigraised == SIGTSTP) // keyboard suspend: ^Z
	{
		gPause = TRUE;
	}
	else if (sigraised == SIGCONT) // continue: fg, bg
	{
		gCont = TRUE;
	}
}

CFMutableArrayRef getfiles (int count, const char * array[])
{
	CFMutableArrayRef files = CFArrayCreateMutable(NULL, 0, NULL); // note: we must retain/release files ourselves!
	int filenum =  0;
	OSErr theErr = noErr;

	while ( filenum < count || gCD )
	{
		CFURLRef path = NULL;
		BOOL isStdin = FALSE;
		
		if (gCD)
		{
			// set path to contents of CDs:
			
			#define kAudioCDFilesystemID 19016
			FSVolumeInfo info;
			HFSUniStr255 volumeName;
			long systemVersion;

			theErr = FSGetVolumeInfo(kFSInvalidVolumeRefNum, filenum+1, NULL, kFSVolInfoFSInfo, &info, &volumeName, NULL);
			if (theErr != noErr)
			{
				if (theErr != nsvErr)
					myprint("Error getting information for volume %d. Error %d returned.\n", count, theErr);
				else
					// we are at the end of the "list of volumes"... so exit loop
					break;
			}

			// bug fix from Apple web site example code:
			// Work around a bug in Mac OS X 10.0.x where the filesystem ID and signature bytes were erroneously swapped. This was fixed in Mac OS X 10.1 (r. 2653443).
			if (Gestalt(gestaltSystemVersion, &systemVersion) != noErr)
				systemVersion = 0;
			if ((systemVersion >= 0x00001000 && systemVersion < 0x00001010 && info.signature == kAudioCDFilesystemID)
				|| info.filesystemID == kAudioCDFilesystemID)
			{
				// volume is an Audio CD, "replace" path with volume name:
				CFURLRef baseurl = CFURLCreateWithFileSystemPath(NULL, CFSTR("/Volumes"), kCFURLPOSIXPathStyle, TRUE);
				CFStringRef substr = CFStringCreateWithCharacters(NULL, volumeName.unicode, volumeName.length);

				myprintv("Found a CD: /Volumes/%s\n", CFStringGetCStringPtr(substr,CFStringGetSystemEncoding()));
				path = CFURLCreateCopyAppendingPathComponent(NULL, baseurl, substr, FALSE);

				CFRelease(substr);
				CFRelease(baseurl);
			}
			else
			{
				// volume is not an Audio CD, goto next volume:
				filenum++;
				continue;
			}
		}
		else
		{
			// set path:
			{
				CFStringRef pathstr = CFStringCreateWithCString(NULL, array[filenum], CFStringGetSystemEncoding());
				path = CFURLCreateWithFileSystemPath(NULL, pathstr, kCFURLPOSIXPathStyle, FALSE);
				CFRelease(pathstr);
			}
			
			if ( (path != NULL) && CFEqual(CFURLGetString(path), CFSTR("-")) )
			{
				// "replace" path with next line of standard in:
				size_t length;
				char * chars = fgetln(stdin, &length);
				isStdin = TRUE;

				if (chars == NULL)
				{
					// end of stdin, goto next file:
					filenum++;
					continue;
				}

				if (length > 1 && chars[length-1] == '\n')
					length--;

				{
					CFStringRef pathstr = CFStringCreateWithBytes(NULL, chars, length, CFStringGetSystemEncoding(), FALSE);
					CFRelease(path); // "replace" path
					path = CFURLCreateWithFileSystemPath(NULL, pathstr, kCFURLPOSIXPathStyle, FALSE);
					CFRelease(pathstr);
				}
			}
		}

		// get file information (about path)
		{
			FSRef fsRef;

			if ( path == NULL )
			{
				addContents(path, files);
			}
			else if ( CFURLGetFSRef(path, &fsRef) )
			{
				BOOL isDir;
				BOOL wasAlias;
				theErr = FSResolveAliasFileWithMountFlags(&fsRef, TRUE, &isDir, &wasAlias, kResolveAliasFileNoUI);
				
				if (theErr == noErr)
				{
					if (wasAlias)
					{
						CFRelease(path); // "replace" path
						path = CFURLCreateFromFSRef(NULL, &fsRef);
					}
					
					// if a directory, add contents, else add file
					if (isDir)
						addContents(path, files);
					else
						CFArrayInsertValueAtIndex(files, CFArrayGetCount(files), path);
				}
				else
				{
					myprint("Error getting info about file. Error %d returned:\n", theErr);
					myprinturl(path);
				}
			}
			else
			{
				myprint("Error. File does not exist:\n");
				myprinturl(path);
			}
		}
		
		if (!isStdin)
			filenum++;
	}

	return files;
}

void addContents(CFURLRef path, CFMutableArrayRef files)
{
	OSErr theErr;
	FSRef fsRef;

	// get fsRef:
	if ( path == NULL )
	{
		// "replace" path with working directory
		CFURLRef temp;
		temp = CFURLCreateWithFileSystemPath(NULL, CFSTR("."), kCFURLPOSIXPathStyle, TRUE);
		CFURLGetFSRef(temp, &fsRef);
		CFRelease(temp);
	}
	else if ( !CFURLGetFSRef(path, &fsRef) )
	{
		myprint("Error. Directory does not exist:\n");
		myprinturl(path);
		return;
	}
	
	{
		FSIterator iterator;
		ItemCount actualNumFiles;
		FSRef contentFSRef;
		HFSUniStr255 contentName;
		
		theErr = FSOpenIterator(&fsRef, kFSIterateFlat, &iterator);
		if (theErr != noErr)
			myprint("Error opening iterator.\n");
		
		while (theErr == noErr)
		{
			theErr = FSGetCatalogInfoBulk(iterator, 1, &actualNumFiles, NULL, kFSCatInfoNone, NULL, &contentFSRef, NULL, &contentName);
	
			if (theErr != errFSNoMoreItems && theErr != noErr)
			{
				myprint("Error getting contents of directory. Error %d returned:\n", theErr);
				myprinturl(path);
			}
			else if (actualNumFiles > 0)
			{
				// if not invisible:
				if ( (contentName.unicode[0]) != (UniChar)('.') )
				{
					BOOL isDir;
					BOOL wasAlias;
					theErr = FSResolveAliasFileWithMountFlags(&contentFSRef, TRUE, &isDir, &wasAlias, kResolveAliasFileNoUI);
					
					if(theErr == noErr)
					{
						CFURLRef pathurl;

						if (wasAlias)
							pathurl = CFURLCreateFromFSRef(NULL, &contentFSRef);
						else
						{
							// in order to keep printf of pathname nice, do not recreate from FSRef:
							CFStringRef substr = CFStringCreateWithCharacters(NULL, contentName.unicode, contentName.length);

							if ( path != NULL )
							{
								pathurl = CFURLCreateCopyAppendingPathComponent(NULL, path, substr, isDir);
							}
							else
							{
								pathurl = CFURLCreateWithFileSystemPath(NULL, substr, kCFURLPOSIXPathStyle, isDir);
							}
							
							CFRelease(substr);
						}
						
						// if a directory and recursive, add contents, else add file
						if (!isDir)
							CFArrayInsertValueAtIndex(files, CFArrayGetCount(files), pathurl);
						else if (gRecursive)
							addContents(pathurl, files);
					}
					else
					{
						myprint("Error getting info about contents of directory. Error %d returned:\n", theErr);
						myprinturl(path);
					}
				}
			}
		}
		theErr = FSCloseIterator(iterator);
		if (theErr != noErr)
			myprint("Error closing iterator.\n");
	}
	return;
}

void playfile(CFURLRef pathname)
{
	if (!pathname)
	{
		myprint("Error. Play file passed NULL.\n");
		return;
	}

	myprintv("\n");
	myprinturl(pathname);
	
	{
		OSErr theErr = noErr;
		Movie qtMovie = NULL;
		
		// initialize movie
		myprintv("Initializing file.\n");
		
		{
			FSRef fsRef;
			FSSpec fsSpec;
			short refNum;

			if ( !CFURLGetFSRef(pathname, &fsRef) )
			{
				myprint("Error opening movie file. File does not exist:\n");
				myprinturl(pathname);
				return;
			}

			theErr = FSGetCatalogInfo(&fsRef, kFSCatInfoNone, NULL, NULL, &fsSpec, NULL);
			if (theErr != noErr)
			{
				myprint("Error opening movie file. Can't get file specifier. Error %d returned.\n", theErr);
				return;
			}

			// first, try opening file as a quicktime file:
			theErr = OpenMovieFile(&fsSpec, &refNum, fsRdPerm);
			if (theErr != noErr)
			{
				myprint("Error opening movie file. Error %d returned.\n", theErr);
				return;
			}
			theErr = NewMovieFromFile(&qtMovie, refNum, NULL, NULL, newMovieActive & newMovieDontAskUnresolvedDataRefs, NULL);
			CloseMovieFile(refNum);
			
			if (theErr != noErr)
			{
				// if not quicktime file, then try opening file as a sound resource file (switch to sound manager):
				if (theErr == noMovieFound)
				{
					int refNum;
					int max;
					
					// initialize sound resource
					myprintv("Not a Quicktime file. Switching to sound manager.\n");

					refNum = FSpOpenResFile(&fsSpec,fsRdPerm);
					if (refNum < 0)
					{
						myprint("Error opening sound resource file. Error %d returned.\n", ResError());
						return;
					}

					UseResFile(refNum);
					theErr = ResError();
					if (theErr != noErr)
					{
						myprint("Error opening sound resource file. Can't use resource file. Error %d returned.\n", theErr);
						CloseResFile(refNum);
						return;
					}

					max = Count1Resources('snd ');
					theErr = ResError();
					if (theErr != noErr)
					{
						myprint("Error opening sound resource file. Can't count number of resources. Error %d returned.\n", theErr);
						CloseResFile(refNum);
						return;
					}

					if (max <= 0)
					{
						myprint("Error opening file. Not a Quicktime file. No sound resources.\n");
					}
					else
					{
						// if resource file exists, play sound resources:
						if (max > 1)
						{
							myprintv("%d sound resources in file.\n", max);
						}
						playfile_sndmanager(max, pathname);
					}

					CloseResFile(refNum);
					
					return;
				}

				myprint("Error opening movie file. Can't create new movie from file. Error %d returned.\n", theErr);
				return;
			}
		}

		// remove tracks which are not sound tracks:
		removeTracks(qtMovie);
		if (GetMovieTrackCount(qtMovie) <= 0)
		{
			myprint("Error opening movie file. No sound tracks.\n");
		}
		else
		{
			// if movie file exists, play quicktime movie:
			playfile_quicktime(qtMovie, pathname);
		}
	}
}

void playfile_quicktime(Movie qtMovie, CFURLRef pathname)
{
	int theErr;

	// set volume:
	SetMovieVolume(qtMovie, gVolume);
	
	// so start at beginning:
	GoToBeginningOfMovie(qtMovie);
	// so beginning of movie not cut off:
	usleep(100000);

	// play movie
	myprintv("Playing movie file.\n");

	StartMovie(qtMovie);

	// if file type is not movie, then stop:
	theErr = GetMoviesError();
	if (theErr != noErr)
	{
		myprint("Error starting movie file. Error %d returned.\n", theErr);
	}

	while( (theErr == noErr) && !IsMovieDone(qtMovie) )
	{
		// so less processor intensive:
		usleep(gSleepTime);

		// if we recieved a "stop" signal, then stop:
		if (gStop == TRUE)
		{
			gStop = FALSE;
			myprintv("User cancelled movie file.\n");
			StopMovie(qtMovie);
			theErr = userCanceledErr;
		}
		// if we recieved a "suspend" signal, then pause
		else if (gPause == TRUE)
		{
			gPause = FALSE;
			myprintv("User paused movie file.\n");
			if (gIsPaused == FALSE)
			{
				gIsPaused = TRUE;
				StopMovie(qtMovie);
				kill(getpid(),SIGSTOP); // suspend process
			}
		}
		// if we recieved a "continue" signal, then resume where we left off
		else if (gCont == TRUE)
		{
			gCont = FALSE;
			myprinturl(pathname);
			myprintv("User continued movie file.\n");
			if (gIsPaused == TRUE)
			{
				gIsPaused = FALSE;
				StartMovie(qtMovie);
			}
		}
		else
		{
			// so update movie:
			MoviesTask(qtMovie, 0);

			// if error, then stop:
			theErr = GetMoviesError();
			if (theErr != noErr)
			{
				myprint("Error playing movie file. Error %d returned.\n", theErr);
			}
		}
	}

	// deallocate movie
	myprintv("Movie file done.\n");

	DisposeMovie(qtMovie);
	return;
}

void playfile_sndmanager(int max, CFURLRef pathname)
{
	int index;
	int theErr;

	SndChannelPtr pchan = NULL;

	// allocate sound channel
	theErr = SndNewChannel(&pchan, 0, 0, NULL);
	if (theErr != noErr)
	{
		myprint("Error creating sound channel. Error %d returned.\n", theErr);
		return;
	}

	// set volume:
	{
		SndCommand snd;
		snd.cmd = volumeCmd;
		snd.param2 = gVolume | (gVolume << 16); // sets gVolume to left and right channels
		theErr = SndDoImmediate(pchan, &snd);
		if (theErr != noErr)
		{
			myprint("Error setting volume. Error %d returned.\n", theErr);
		}
	}

	// play sound resource:
	for (index=1; index<=max; index++)
	{
		SndListHandle sndHandle;
		SCStatus theStatus;

		// play sound resource number x
		myprintv("Playing sound resource file: resource number %d.\n", index);

		// getting sound resource number x
		sndHandle = (SndListHandle)(Get1IndResource('snd ',index));
		theErr = ResError();
		if (theErr != noErr)
		{
			myprint("Error opening sound resource file. Can't get resource number %d. Error %d returned.\n", index, theErr);
			break;
		}

		theErr = SndPlay(pchan, sndHandle, TRUE);
		if (theErr != noErr)
		{
			myprint("Error playing sound resource file. Can't play resource number %d. Error %d returned.\n", index, theErr);
		}

		theErr = SndChannelStatus (pchan, sizeof(SCStatus), &theStatus);
		if (theErr != noErr)
		{
			myprint("Error playing sound resource file. Can't get status of resource number %d. Error %d returned.\n", index, theErr);
		}
		
		while ( (theErr == noErr) && (theStatus.scChannelBusy == TRUE) )
		{
			// so less processor intensive:
			usleep(gSleepTime);

			// if we recieved a "stop" signal, then stop:
			if (gStop == TRUE)
			{
				myprintv("User cancelled sound resource file.\n");
				{
					SndCommand snd;
					snd.cmd = flushCmd;
					theErr = SndDoImmediate(pchan, &snd);
					snd.cmd = quietCmd;
					theErr = SndDoImmediate(pchan, &snd);
				}
				theErr = userCanceledErr;
			}
			// if we recieved a "suspend" signal, then pause
			else if (gPause == TRUE)
			{
				gPause = FALSE;
				myprintv("User paused sound resource file.\n");
				if (gIsPaused == FALSE)
				{
					gIsPaused = TRUE;
					{
						SndCommand snd;
						snd.cmd = pauseCmd;
						theErr = SndDoImmediate(pchan, &snd);
					}
					kill(getpid(),SIGSTOP); // suspend process
				}
			}
			// if we recieved a "continue" signal, then resume where we left off
			else if (gCont == TRUE)
			{
				gCont = FALSE;
				myprinturl(pathname);
				myprintv("User continued sound resource file.\n");
				if (gIsPaused == TRUE)
				{
					gIsPaused = FALSE;
					{
						SndCommand snd;
						snd.cmd = resumeCmd;
						theErr = SndDoImmediate(pchan, &snd);
					}
				}
			}
			else
			{
				theErr = SndChannelStatus (pchan, sizeof(SCStatus), &theStatus);
				if (theErr != noErr)
				{
					myprint("Error playing sound resource file. Can't get status of resource number %d. Error %d returned.\n", index, theErr);
				}
			}
		}
		if (gStop == TRUE)
		{
			gStop = FALSE;
			index = max;
		}
	}

	// deallocate sound channel
	myprintv("Sound resource file done.\n");

	theErr = SndDisposeChannel (pchan, FALSE);
	if (theErr != noErr)
	{
		myprint("Error disposing sound channel. Error %d returned.\n", theErr);
	}

	return;
}

void removeTracks(Movie movie)
{
	long index;
	Track track;
	OSType mediaType;
	
	// remove all tracks except sound
	for (index = GetMovieTrackCount(movie); index > 0; index--)
	{
		track = GetMovieIndTrack(movie, index);
		GetMediaHandlerDescription(GetTrackMedia(track), &mediaType, NULL, NULL);
		if (mediaType != SoundMediaType && mediaType != MusicMediaType)
		{
			DisposeMovieTrack(track);
		}
	}

	// bug fix by Carsten Klapp:
	// work around possible qt bug where white boxes show on screen even though all non-audio tracks have already been deleted
	{
		Rect boxRect;
		EmptyRect(&boxRect);
		SetMovieBox(movie, &boxRect);
	}
}
