Portable Application Template
=============================
Copyright (c) 2007 Karl Loncarek (for the template)

Latest version of this template could be downloaded at:
http://www.loncarek.de/downloads/PortableApplicationTemplate.zip

ABOUT Portable Application Template
===================================
This template is intended to help developers or interested users to easily
create launchers for applications to make them portable. Those applications
could be open source or shareware or even commercial applications. The two
latter ones may be interesting for personal use. Thus almost every
application could be run from e.g. USB drive no matter what drive letter is
used, i.e. without leaving any information or traces on the host PC.
 
HOW TO ADAPT THE TEMPLATE TO YOUR NEEDS
=======================================
The key problem of "normal" applications is that they leave traces on the
computer that they are running on. Those traces could be registry keys,
directories with files, or setting files (e.g. .INI files) themselves.
This template is a NSIS source. It uses the same technique as all the
applications that could be found on http://portableapps.com .

First of all you have to trace what changes are done on your system when
installing an application. Personally I use the freeware version of Total
Uninstall, but you can use any other tracing software you like.
You could also use Sysinternals Filemon or Regmon application for this task.

Then list the changed/created folders, files, registry keys in the constants
REGKEYS, SETTINGSFILES, SETTINGSDIRS. Separate multiple entries with "||".

When you set USEREGKEYSFILE to "TRUE" (default) an existing file "Registry.reg"
within the data directory will override the settings done in REGKEYS. In this
case the parent registry keys within "Registry.reg" will be processed
recursively (all subkeys of the parent keys are saved automatically). Child
registry keys are ignored for processing. The file "Registry.reg" has to be of
windows regedit format. You could create it with regedit.exe itself or with any
other application that saves monitored registry keys in that format (e.g. Total
Uninstall). The launcher itself creates files in regedit format. Not only the
registry keys are used but also the saved settings which then will be the
actual portable registry settings. Just take care that the parent registry keys
within "Registry.reg" are directly followed by their child registry keys.

Folders or files written to the users profile directory are automatically
redirected if the constant REDIRECTUSERPROFILE is set to true. So there is no
need to add them in the above lists.
Beware of applications that launch other applications. Those applications
started by your portable program will also use the changed user profile folder.
In such a case it is recommended to comment out REDIRECTUSERPROFILE or set it
to something different than "TRUE". Then automatic redirection is disabled.
If the application to launch does not create those files on the first start
then they have to be copied manually into the "UserProfile" directory. The
"UserProfile" could be found within your data directory depending on your
directory structure (see below).

You could hand over some additional default command line parameters to your
application to launch. Simply set them within EXEPARMS. Those settings will be
overridden by command line parameters given in an INI file. The highest
priority have command line parameters given to the launcher when running it.
All other settings within the INI or defined in EXEPARMS will then be ignored.

On some applications additional changes in e.g. configuration files have to be
done, mainly regarding path settings. You have to check if you could use
relative paths (the easiest thing as you don't have to do anything else) or if
you have to change a drive letter each time you start the launcher. This has
to be configured manually and should be done only by intermediate/advanced
users who have some knowledge on NSIS.

If you want to create a launcher for a commercial/shareware application you
have first to take care whether the license of that application allows it. This
is in your responsibility. Do not create a package which contains the
commercial files as this would be illegal in most cases. Since version 1.9 this
template integrates some functions that help you in that task. You can simply
share the EXE created from this source. All the application and data
directories are created automatically. Even if your portable application folder
is empty (or at least does not contain the EXE) you will be prompted for a
folder that holds your locally installed application and copies all the files
below it. Existing settings will be copied when the launcher runs for the
first time. You should not uninstall the local application before that.

If you want to share your sources with your launcher simple set the constant
INSTALLSOURCES to "TRUE". Then those files will be packed into the launcher.
The launcher then acts as launcher and installer! The source files will then be
copied automatically into the appropriate folders. An existing "readme.txt"
will be copied also to the sources. If it does not exist a warning will occur
when compiling. Do not worry about this warning, it's more a kind of an
information. Also an existing "Registry.reg" will be installed into the data
directory.

Beware also of settings which are only possible with administrator rights.
It might happen that you don't have adminstrator rights on the host computer.
In such a case the application might not run. But you have the possibility to
check whether the local user has administrator rights (necessary when e.g.
writing to the HKLM registry key). Simply set ADMINREQUIRED to "TRUE". If not
required comment it out or set it to something different than "TRUE".

With GTKVERSION you could set the version number of the GTK installation your
portable application requires. With USEJAVAVERSION you could do the same for
JAVA. Java and/or GTK could also be installed into a common files folder which
allows multiple applications to use the same or several JAVA/GTK versions.
See below at the directory structure on mor information.

For your reference:
List of possible root keys for the registry value (use short version as much
as possible to save space. The list is taken from the NSIS help)
 HKCC or HKEY_CURRENT_CONFIG
 HKCR or HKEY_CLASSES_ROOT
 HKCU or HKEY_CURRENT_USER
 HKDD or HKEY_DYN_DATA
 HKLM or HKEY_LOCAL_MACHINE
 HKPD or HKEY_PERFORMANCE_DATA
 HKU or HKEY_USERS
 SHCTX or SHELL_CONTEXT

LICENSE OF TEMPLATE
===================
           Copyright© 2006-2007 Karl Loncarek <karl [at] loncarek [dot] de>
           All rights reserved.

           Redistribution and use in source and binary forms, with or without
           modification, are permitted provided that the following conditions
           are met:

             1. Redistributions of source code must retain the above copyright
                notice, this list of conditions and the following disclaimer.
             2. Redistributions in binary form must reproduce the above
                copyright notice, this list of conditions and the following
                disclaimer in the documentation and/or other materials
                provided with the distribution.

           THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
           "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
           LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
           FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
           COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
           INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
           (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
           SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
           HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
           STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
           ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
           OF THE POSSIBILITY OF SUCH DAMAGE.

REQUIREMENTS
============
In order to compile this script with NSIS you need the following Plugins:
- NewAdvSplash
- Registry
- FindProc
- Dialogs

INSTALLATION / DIRECTORY STRUCTURE
==================================
This template uses the same directory structure as John T. Haller did with most
of the packages at http://www.portableapps.com to keep some kind of uniformity.

Below <NAME> is used for your applications name.
 
By default the program expects one of these directory structures:

+-\CommonFiles\ (optional)
| +-\GTK\
| | +-\<GTK_VERSION>\ (optional, files/directories of GTK installation (bin, lib, ...)
| +-\JAVA\
|   +-\<JRE_VERSION>\ (optional, files/directories of JRE installation (bin, lib, ...)
+-\ <--- Directory with <NAME>Portable.exe
  +-\App\
  | +-\<NAME>\ <--- All files and directories of a local installation
  | +-\GTK\ (optional, files/directories of GTK installation (bin, lib, ...)
  | +-\JAVA\ (optional, files/directories of JRE installation (bin, lib, ...)
  +-\Data\ (optional, will be created automatically when needed)
  | +-\Registry\ (optional, will be created automatically when needed)
  | +-\Settings\ (optional, will be created automatically when needed)
  | +-\UserProfile\ (optional, will be created automatically when needed)
  +-\Other\ (optional) <--- contains additional information
    +-\<NAME>Sources\ (optional)
    +-\<NAME>PortableSources\ (optional) <--- contains source of launcher

OR

+-\ <--- Directory with Portable<NAME>.exe
  +-\CommonFiles\ (optional)
  | +-\GTK\
  | | +-\<GTK_VERSION>\ (optional, files/directories of GTK installation (bin, lib, ...)
  | +-\JAVA\
  |   +-\<JRE_VERSION>\ (optional, files/directories of JRE installation (bin, lib, ...)
  +-\<NAME>Portable\
    +-\App\
    | +-\<NAME>\ <--- All files and directories of a local installation
    | +-\GTK\ (optional, files/directories of GTK installation (bin, lib, ...)
    | +-\JAVA\ (optional, files/directories of JRE installation (bin, lib, ...)
    +-\Data\ (optional, will be created automatically when needed)
    | +-\Registry\ (optional, will be created automatically when needed)
    | +-\Settings\ (optional, will be created automatically when needed)
    | +-\UserProfile\ (optional, will be created automatically when needed)
    +-\Other\ (optional) <--- contains additional information
      +-\<NAME>Sources\ (optional)
      +-\<NAME>PortableSources\ (optional) <--- contains source of launcher

OR

+-\ <--- Directory with Portable<NAME>.exe
  +-\PortableApps\
    +-\CommonFiles\ (optional)
    | +-\GTK\
    | | +-\<GTK_VERSION>\ (optional, files/directories of GTK installation (bin, lib, ...)
    | +-\JAVA\
    |   +-\<JRE_VERSION>\ (optional, files/directories of JRE installation (bin, lib, ...)
    +-\<NAME>Portable\
      +-\App\
      | +-\<NAME>\ <--- All files and directories of a local installation
      | +-\GTK\ (optional, files/directories of GTK installation (bin, lib, ...)
      | +-\JAVA\ (optional, files/directories of JRE installation (bin, lib, ...)
      +-\Data\ (optional, will be created automatically when needed)
      | +-\Registry\ (optional, will be created automatically when needed)
      | +-\Settings\ (optional, will be created automatically when needed)
      | +-\UserProfile\ (optional, will be created automatically when needed)
      +-\Other\ (optional) <--- contains additional information
        +-\<NAME>Sources\ (optional)
        +-\<NAME>PortableSources\ (optional) <--- contains source of launcher

Which directory will be scanned for the JAVA/GTK version that will be used
(highest priority first):
A. "App\JAVA" or "App\GTK"
B. "CommonFiles\JAVA\<JRE_VERSION>" or "CommonFiles\GTK\<GTK_VERSION>"
C. "CommonFiles\JAVA" or "CommonFiles\GTK"
D. on the host computer installed JAVA or GTK

Remarks: When the above A and B do not exist C will be used regardless of the
installed version. It is highly recommended to use B as far as possible if you
want to share it with other portable applications. If your application does not
require a special GTK/JAVA version it is recommended to use C with the newest
available version of GTK/JAVA. <JRE_VERSION> should be only the version number
e.g. "1.6.0_01", otherwise it won't be found. A message will appear when the
hosts JAVA/GTK will be used.

It can be used in other directory configurations by including the
<NAME>Portable.INI in the same directory as the launcher <NAME>Portable.EXE.
Details for the configuration settings in the INI files could be found below.
The INI file may also be placed in the subdirectories "Portable<NAME>",
"PortableApps\<NAME>Portable", "Apps\<NAME>Portable", or
"Data\<NAME>Portable". Those directories are relative to the location of the
<NAME>Portable.EXE file. All paths given in the INI-file should be relative
to the location of <NAME>Portable.EXE.

.INI FILE CONFIGURATION OPTIONS
===============================
The launcher will look for an .INI file within it's directory. If you are
happy with the default options, you won't need it. The INI file is formatted
as follows (Below <NAME> is used for your applications name.):

[<NAME>Portable]
ProgramExecutable=<NAME>.exe
ProgramParameters=
ProgramDirectory=App\<NAME>
DataDirectory=Data
SplashScreen=enabled
ExtractSources=TRUE
JAVAVersion=1.6.0_01

Required entries are ProgramDirectory and DataDirectory. If others are
missing or empty the default values will be used.
All paths provided should be RELATIVE to the "<NAME>Portable.exe".

ProgramExecutable:
	Allows to launch a different EXE file of your application
ProgramParameters:
	Additonal parameters that should be used when launching the application.
	This setting overrides te defaults.
ProgramDirectory:
	The path to the EXE file of your application that should be launched. But
	this is only the path, thus must not contain a filename.
DataDirectory:
	The path where all settings should be stored (registry keys and the
	above subdirectories)
SplashScreen:
	Controls whether the splash screen is showed upon start of the launcher
	if one is defined by default. Anything but "enabled" disables it.
ExtractSources:
	Controls whether the launcher acts also as installer, i.e. will install
	sources and readme.txt (or other files) if they do not exist yet.
	Anything else than TRUE will not install/extract any files
GTKVersion:
	Tells the launcher which version of GTk should be used. See above for
	version handling.
JAVAVersion:
	Tells the launcher which version of JAVA should be used. Well in fact
	it's the JRE version. See above for version handling.

CURRENT LIMITATIONS
===================
WRITE ACCESS REQUIRED - The data directory must be writeable on your drive
(e.g. USB drive) as all the settings and configurations are saved there.

HISTORY
=======
1.0 -	First release: Based on Quickport NSIS template developed by Deuce
	added capability to backup multiple files/registry keys
1.1 -	INI files and some default directory structures are supported now.
1.2 -	added sleep time when deleting registry keys; adopted new directory
	structure as recently used by John (AppPortable instead of PortableApp)
1.3 -	fixed a bug
1.4 -	added handling for second launch; some bugfixes
1.5 -	complete rewrite for easier understanding of the source; original
	files/directories are now renamed instead of copied; error message when
	backup files/folders exist; Readme now included at end of the script
1.6 -	no need to define any folder/file within SETTINGSFILES or
	SETTINGSDIRS that is normally stored within the users profile folder.
	Those folders/files will now be stored on the portable drive
	automatically (i.e. redirected)!
1.7 -	added creation of other (maybe missing) data folders; made user profile
	redirection switchable, documentation updates
1.8 -	added check whether user has local administrator rights; removed
	"Unused WordFunc" warning during compile time; optimized compiling when
	commenting out some constants was forgotten ( to get smallest EXE you
	should really comment out); bugfixes
1.9 -	when no directories are found a default directory structure is created;
	when no EXE is found you are asked to select a folder from which to
	copy the files; added possibility to integrate the sources if you want
	to distribute only the exe, e.g. when creating commercial/shareware
	applications launchers -> launcher is an installer at the same time;
	added switch for INI file to disable that behaviour;
	optimzed source code
2.0 -	registry keys are now stored in one single file even with multiple
	registry keys (not compatible to previous versions); Overrides setting
	of REGKEYS 	if USEREGKEYSFILE is "TRUE" and reads registry keys
	to process from file "Registry.reg"; Added "Registry.reg" to source
	installation; Added default command line parameters; removed one
	possible directroy structure (which did not make sense); added GTK and
	JAVA (or better JRE) support, adjustable via INI; automatic detection
	of a "CommonFiles" directory; some code cleanup
