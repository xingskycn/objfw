ObjFW is a portable, lightweight framework for the Objective C language.
It enables you to write an application in Objective C that will run on
any platform supported by ObjFW without having to worry about
differences between operating systems or various frameworks that you
would otherwise need if you want to be portable.

See https://webkeks.org/objfw for more information.


Installation
============

  To install ObjFW, just run the following commands:

    $ ./configure
    $ make
    $ make install

  In case you checked out ObjFW from the Git repository, you need to run
  the following command first:

    $ ./autogen.sh


Building as a Mac OS X framework
================================

  It is also possible to build ObjFW as a Mac OS X framework. To do so,
  just execute xcodebuild -target ObjFW in the root directory of ObjFW
  or open the .xcodeproj in Xcode and choose Build -> Build from the
  menu. Copy the resulting ObjFW.framework to `/Library/Frameworks` and
  you are done.


Using the Mac OS X framework in Xcode
=====================================

  To use the Mac OS X framework in Xcode, you need to add the .framework
  to your project and add the following flags to "Other C Flags":

    -fconstant-string-class=OFConstantString -fno-constant-cfstrings

  Optionally, if you want to use blocks, you also need to add:

    -fblocks


Bugs and feature requests
=========================

  If you find any bugs or have feature requests, feel free to send a
  mail to js-spam@webkeks.org (remove -spam from the address!).
