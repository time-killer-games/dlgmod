/*

 MIT License

 Copyright © 2020 Samuel Venable

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

*/

#import "subclass.h"
#import "widgetbuttons.h"
#import <Cocoa/Cocoa.h>
#import <sys/types.h>
#import <libproc.h>
#import <unistd.h>
#import <string.h>

void *owner = NULL;

const char *cocoa_bundle_path_from_pid(pid_t pid) {
  char buffer[PROC_PIDPATHINFO_MAXSIZE];
  if (proc_pidpath(pid, buffer, sizeof(buffer)) > 0) {
    NSString *result = [[NSString stringWithUTF8String:buffer] stringByAppendingString:@"\0"];
    while (![result hasSuffix:@".app"]) {
      result = [result stringByDeletingLastPathComponent];
      if ([result isEqualToString:@"/"]) { return ""; }
    }
    return [result UTF8String];
  }
  return "";
}

pid_t cocoa_ppid_from_pid(pid_t pid) {
  pid_t ppid;
  struct proc_bsdinfo proc_info;
  if (proc_pidinfo(pid, PROC_PIDTBSDINFO, 0, &proc_info, sizeof(proc_info)) > 0) {
    ppid = proc_info.pbi_ppid;
  }
  return ppid;
}

const char *cocoa_get_bundle_id_from_pid(pid_t pid) {
  NSString *path = [NSString stringWithUTF8String:cocoa_bundle_path_from_pid(pid)];
  if (![path isEqualToString:@""]) {
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return [[bundle bundleIdentifier] UTF8String];
  }
  return "";
}

const char *cocoa_get_bundle_id() {
  return cocoa_get_bundle_id_from_pid(getpid());
}

bool is_ppid_running_from_same_bundle() {
  pid_t pid = getppid();
  while (strcmp(cocoa_get_bundle_id(),
    cocoa_get_bundle_id_from_pid(pid)) != 0) {
    pid = cocoa_ppid_from_pid(pid);
    if (pid == cocoa_ppid_from_pid(pid)) {
      return false;
    }
  }
  return true;
}

void *cocoa_widget_get_owner() {
  return owner;
}

void cocoa_widget_set_owner(void *hwnd) {
  owner = hwnd;
}

int cocoa_show_message(const char *str, bool has_cancel, const char *icon, const char *title) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  NSString *myTitle = [NSString stringWithUTF8String:title];
  NSString *myStr = [NSString stringWithUTF8String:str];

  NSAlert *alert = [[NSAlert alloc] init];
  NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:icon]];
  [[alert window] setDieWhenParentProcessDies:YES];
  [alert setIcon:image];
  [alert setMessageText:myTitle];
  [alert setInformativeText:myStr];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_OK)]];
  if (has_cancel) [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_CANCEL)]];
  [alert setAlertStyle:1];

  NSModalResponse responseTag = [alert runModal];
  [image release];
  [alert release];

  if (responseTag == NSAlertFirstButtonReturn)
    return 1;

  return -1;
}

int cocoa_show_question(const char *str, bool has_cancel, const char *icon, const char *title) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  NSString *myTitle = [NSString stringWithUTF8String:title];
  NSString *myStr = [NSString stringWithUTF8String:str];

  NSAlert *alert = [[NSAlert alloc] init];
  NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:icon]];
  [[alert window] setDieWhenParentProcessDies:YES];
  [alert setIcon:image];
  [alert setMessageText:myTitle];
  [alert setInformativeText:myStr];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_YES)]];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_NO)]];
  if (has_cancel) [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_CANCEL)]];
  [alert setAlertStyle:1];

  NSModalResponse responseTag = [alert runModal];
  [image release];
  [alert release];

  if (responseTag == NSAlertFirstButtonReturn)
    return 1;

  if (responseTag == NSAlertSecondButtonReturn)
    return 0;

  return -1;
}

int cocoa_show_attempt(const char *str, const char *icon, const char *title) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  NSString *myStr = [NSString stringWithUTF8String:str];
  NSAlert *alert = [[NSAlert alloc] init];
  NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:icon]];
  [[alert window] setDieWhenParentProcessDies:YES];
  [alert setIcon:image];
  [alert setMessageText:@"Error"];

  if (![[NSString stringWithUTF8String:title] isEqualToString:@""])
    [alert setMessageText:[NSString stringWithUTF8String:title]];

  [alert setInformativeText:myStr];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_RETRY)]];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_CANCEL)]];
  [alert setAlertStyle:2];

  NSModalResponse responseTag = [alert runModal];
  [image release];
  [alert release];

  if (responseTag == NSAlertFirstButtonReturn)
    return 0;

  return -1;
}

int cocoa_show_error(const char *str, bool abort, const char *icon, const char *title) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  NSString *myStr = [NSString stringWithUTF8String:str];
  NSAlert *alert = [[NSAlert alloc] init];
  NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:icon]];
  [[alert window] setDieWhenParentProcessDies:YES];
  [alert setIcon:image];
  [alert setMessageText:@"Error"];

  if (![[NSString stringWithUTF8String:title] isEqualToString:@""])
    [alert setMessageText:[NSString stringWithUTF8String:title]];

  [alert setInformativeText:myStr];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_ABORT)]];
  if (!abort) [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_IGNORE)]];
  [alert setAlertStyle:2];

  NSModalResponse responseTag = [alert runModal];
  [image release];
  [alert release];

  if (responseTag == NSAlertFirstButtonReturn || abort)
    return 1;

  return -1;
}

const char *cocoa_input_box(const char *str, const char *def, const char *icon, const char *title) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  NSString *myTitle = [NSString stringWithUTF8String:title];
  NSString *myStr = [NSString stringWithUTF8String:str];
  NSString *myDef = [NSString stringWithUTF8String:def];

  NSAlert *alert = [[NSAlert alloc] init];
  NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:icon]];
  [[alert window] setDieWhenParentProcessDies:YES];
  [alert setIcon:image];
  [alert setMessageText:myTitle];
  [alert setInformativeText:myStr];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_OK)]];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_CANCEL)]];

  NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 22)];
  [[input cell] setWraps:NO];
  [[input cell] setScrollable:YES];
  [input setMaximumNumberOfLines:1];
  [input setStringValue:myDef];
  [alert setAccessoryView:input];
  NSView *myAccessoryView = [alert accessoryView];
  [[alert window] setInitialFirstResponder:myAccessoryView];

  NSModalResponse responseTag = [alert runModal];
  const char *result;

  if (responseTag == NSAlertFirstButtonReturn) {
    [input validateEditing];
    result = [[input stringValue] UTF8String];
  } else
    result = "";

  [input release];
  [image release];
  [alert release];

  return result;
}

const char *cocoa_password_box(const char *str, const char *def, const char *icon, const char *title) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  NSString *myTitle = [NSString stringWithUTF8String:title];
  NSString *myStr = [NSString stringWithUTF8String:str];
  NSString *myDef = [NSString stringWithUTF8String:def];

  NSAlert *alert = [[NSAlert alloc] init];
  NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:icon]];
  [[alert window] setDieWhenParentProcessDies:YES];
  [alert setIcon:image];
  [alert setMessageText:myTitle];
  [alert setInformativeText:myStr];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_OK)]];
  [alert addButtonWithTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_CANCEL)]];

  NSSecureTextField *input = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 22)];
  [[input cell] setWraps:NO];
  [[input cell] setScrollable:YES];
  [input setMaximumNumberOfLines:1];
  [input setStringValue:myDef];
  [alert setAccessoryView:input];
  NSView *myAccessoryView = [alert accessoryView];
  [[alert window] setInitialFirstResponder:myAccessoryView];

  NSModalResponse responseTag = [alert runModal];
  const char *result;

  if (responseTag == NSAlertFirstButtonReturn) {
    [input validateEditing];
    result = [[input stringValue] UTF8String];
  } else
    result = "";

  [input release];
  [image release];
  [alert release];

  return result;
}

const char *cocoa_get_open_filename(const char *filter, const char *fname, const char *dir, const char *title, bool mselect) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  NSOpenPanel *oFilePanel = [NSOpenPanel openPanel];
  [oFilePanel setDieWhenParentProcessDies:YES];
  [oFilePanel setMessage:[NSString stringWithUTF8String:title]];
  [oFilePanel setDirectoryURL:[NSURL fileURLWithPath:[NSString stringWithUTF8String:dir]]];
  [oFilePanel setCanChooseFiles:YES];
  [oFilePanel setCanChooseDirectories:NO];
  [oFilePanel setCanCreateDirectories:NO];
  [oFilePanel setResolvesAliases:YES];

  if (mselect)
    [oFilePanel setAllowsMultipleSelection:YES];
  else
    [oFilePanel setAllowsMultipleSelection:NO];

  NSView *openView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 431, 21)];
  NSPopUpButton *openPop = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(104, 0, 255, 22)];
  NSString *openFilter = [NSString stringWithUTF8String:filter];
  bool openShowAccessory = true;
  bool openAllowAllFiles = false;

  if ([openFilter length] == 0 ||
    ([openFilter rangeOfString:@"|"].location != NSNotFound &&
     [openFilter rangeOfString:@"|"].location == 0))
    openShowAccessory = false;

  if ([openFilter length] == 0 ||
    [openFilter rangeOfString:@"|"].location == NSNotFound) {
    openFilter = [openFilter stringByAppendingString:@"|"];
    openAllowAllFiles = true;
  }

  int openIndex = 0;
  int openCount = 0, openLength = [openFilter length];
  NSRange openRange = NSMakeRange(0, openLength);

  while (openRange.location != NSNotFound) {
    openRange = [openFilter rangeOfString: @"|" options:0 range:openRange];

    if (openRange.location != NSNotFound) {
      openRange = NSMakeRange(openRange.location + openRange.length, openLength - (openRange.location + openRange.length));
      openCount += 1;
    }
  }

  NSString *openPattern = openFilter;
  openPattern = [openPattern stringByReplacingOccurrencesOfString:@"*." withString:@""];
  openPattern = [openPattern stringByReplacingOccurrencesOfString:@" " withString:@""];

  NSArray *openArray1 = [openFilter componentsSeparatedByString:@"|"];
  NSArray *openArray2 = [openPattern componentsSeparatedByString:@"|"];
  NSMutableArray *openPatternArray = [[NSMutableArray alloc] init];
  NSMutableArray *openDescrArray = [[NSMutableArray alloc] init];

  for (openIndex = 0; openIndex <= openCount; openIndex += 1) {
    if (openIndex % 2) {
      [openPatternArray addObject:[openArray2 objectAtIndex:openIndex]];
    } else {
      [openDescrArray addObject:[openArray1 objectAtIndex:openIndex]];
    }
  }

  NSString *selectedOpenPattern = [openPatternArray objectAtIndex:0];
  NSArray *openPatternItems = [selectedOpenPattern componentsSeparatedByString:@";"];
  [oFilePanel setAllowedFileTypes:openPatternItems];

  if ([openPatternItems containsObject:@"*"] || openAllowAllFiles || !openShowAccessory)
    [oFilePanel setAllowedFileTypes:nil];

  [openPop addItemsWithTitles:openDescrArray];
  [openPop selectItemWithTitle:[openDescrArray objectAtIndex:0]];
  [openView addSubview:openPop];
  [oFilePanel setAccessoryView:openView];

  if (!openShowAccessory)
    [oFilePanel setAccessoryView:nil];

  const char *theOpenResult = "";
  bool initOpenAccessory = false;
  int openPopIndex = 0;

  NSModalSession openSession = [NSApp beginModalSessionForWindow:oFilePanel];
  [oFilePanel center];

  for (;;) {
    if ([NSApp runModalSession:openSession] == NSModalResponseOK) {
      NSURL *theOpenURL;
      NSString *theOpenFile;
      int openURLSize = [[oFilePanel URLs] count];

      if (openURLSize > 1) {
        NSMutableArray *openFileArray = [[NSMutableArray alloc] init];

        for (int openURLIndex = 0; openURLIndex < openURLSize; openURLIndex += 1) {
          [openFileArray addObject:[[[oFilePanel URLs] objectAtIndex:openURLIndex] path]];
        }

        theOpenFile = [openFileArray componentsJoinedByString:@"\n"];
        [openFileArray release];
      } else
        theOpenFile = [[[oFilePanel URLs] objectAtIndex:0] path];

      theOpenResult = [theOpenFile UTF8String];
      break;
    }

    if ([NSApp runModalSession:openSession] == NSModalResponseCancel)
      break;

    if (![oFilePanel isAccessoryViewDisclosed] && !initOpenAccessory) {
      [oFilePanel setAccessoryViewDisclosed:YES];
      initOpenAccessory = true;
    }

    if (openShowAccessory) {
      if ([openPop indexOfSelectedItem] != openPopIndex) {
        selectedOpenPattern = [openPatternArray objectAtIndex:[openPop indexOfSelectedItem]];
        openPatternItems = [selectedOpenPattern componentsSeparatedByString:@";"];

        if ([openPatternItems containsObject:@"*"])
          [oFilePanel setAllowedFileTypes:nil];
        else
          [oFilePanel setAllowedFileTypes:openPatternItems];

        openPopIndex = [openPop indexOfSelectedItem];
      }
    }
  }

  [NSApp endModalSession:openSession];
  [oFilePanel close];

  [openPatternArray release];
  [openDescrArray release];
  [openPop release];
  [openView release];

  return theOpenResult;
}

const char *cocoa_get_save_filename(const char *filter, const char *fname, const char *dir, const char *title) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  NSSavePanel *sFilePanel = [NSSavePanel savePanel];
  [sFilePanel setDieWhenParentProcessDies:YES];
  [sFilePanel setMessage:[NSString stringWithUTF8String:title]];
  [sFilePanel setDirectoryURL:[NSURL fileURLWithPath:[NSString stringWithUTF8String:dir]]];
  [sFilePanel setNameFieldStringValue:[[[NSString stringWithUTF8String:fname] lastPathComponent] stringByDeletingPathExtension]];
  [sFilePanel setCanCreateDirectories:YES];

  NSView *saveView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 433, 21)];
  NSPopUpButton *savePop = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(105, 0, 255, 22)];
  NSString *saveFilter = [NSString stringWithUTF8String:filter];
  bool saveShowAccessory = true;
  bool saveAllowAllFiles = false;

  if ([saveFilter length] == 0 ||
    ([saveFilter rangeOfString:@"|"].location != NSNotFound &&
     [saveFilter rangeOfString:@"|"].location == 0))
    saveShowAccessory = false;

  if ([saveFilter length] == 0 ||
    [saveFilter rangeOfString:@"|"].location == NSNotFound) {
    saveFilter = [saveFilter stringByAppendingString:@"|"];
    saveAllowAllFiles = true;
  }

  int saveIndex = 0;
  int saveCount = 0, saveLength = [saveFilter length];
  NSRange saveRange = NSMakeRange(0, saveLength);

  while (saveRange.location != NSNotFound) {
    saveRange = [saveFilter rangeOfString: @"|" options:0 range:saveRange];

    if (saveRange.location != NSNotFound) {
      saveRange = NSMakeRange(saveRange.location + saveRange.length, saveLength - (saveRange.location + saveRange.length));
      saveCount += 1;
    }
  }

  NSString *savePattern = saveFilter;
  savePattern = [savePattern stringByReplacingOccurrencesOfString:@"*." withString:@""];
  savePattern = [savePattern stringByReplacingOccurrencesOfString:@" " withString:@""];

  NSArray *saveArray1 = [saveFilter componentsSeparatedByString:@"|"];
  NSArray *saveArray2 = [savePattern componentsSeparatedByString:@"|"];
  NSMutableArray *savePatternArray = [[NSMutableArray alloc] init];
  NSMutableArray *saveDescrArray = [[NSMutableArray alloc] init];

  for (saveIndex = 0; saveIndex <= saveCount; saveIndex += 1) {
    if (saveIndex % 2) {
      [savePatternArray addObject:[saveArray2 objectAtIndex:saveIndex]];
    } else {
      [saveDescrArray addObject:[saveArray1 objectAtIndex:saveIndex]];
    }
  }

  NSString *selectedSavePattern = [savePatternArray objectAtIndex:0];
  NSArray *savePatternItems = [selectedSavePattern componentsSeparatedByString:@";"];
  [sFilePanel setAllowedFileTypes:savePatternItems];

  [sFilePanel setAllowedFileTypes:savePatternItems];

  if ([savePatternItems containsObject:@"*"] || saveAllowAllFiles || !saveShowAccessory)
    [sFilePanel setAllowedFileTypes:nil];

  [savePop addItemsWithTitles:saveDescrArray];
  [savePop selectItemWithTitle:[saveDescrArray objectAtIndex:0]];
  [saveView addSubview:savePop];
  [sFilePanel setAccessoryView:saveView];

  if (!saveShowAccessory)
    [sFilePanel setAccessoryView:nil];

  const char *theSaveResult = "";
  int savePopIndex = 0;

  NSModalSession saveSession = [NSApp beginModalSessionForWindow:sFilePanel];
  [sFilePanel center];

  for (;;) {
    if ([NSApp runModalSession:saveSession] == NSModalResponseOK) {
      NSURL *theSaveURL = [sFilePanel URL];
      NSString *theSaveFile = [theSaveURL path];
      theSaveResult = [theSaveFile UTF8String];
      break;
    }

    if ([NSApp runModalSession:saveSession] == NSModalResponseCancel)
      break;

    if (saveShowAccessory) {
      if ([savePop indexOfSelectedItem] != savePopIndex) {
        selectedSavePattern = [savePatternArray objectAtIndex:[savePop indexOfSelectedItem]];
        savePatternItems = [selectedSavePattern componentsSeparatedByString:@";"];

        if ([savePatternItems containsObject:@"*"])
          [sFilePanel setAllowedFileTypes:nil];
        else
          [sFilePanel setAllowedFileTypes:savePatternItems];

        savePopIndex = [savePop indexOfSelectedItem];
      }
    }
  }

  [NSApp endModalSession:saveSession];
  [sFilePanel close];

  [savePatternArray release];
  [saveDescrArray release];
  [savePop release];
  [saveView release];

  return theSaveResult;
}

const char *cocoa_get_directory(const char *capt, const char *root) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  NSOpenPanel* dirPanel = [NSOpenPanel openPanel];
  [dirPanel setDieWhenParentProcessDies:YES];
  [dirPanel setMessage:[NSString stringWithUTF8String:capt]];
  [dirPanel setDirectoryURL:[NSURL fileURLWithPath:[NSString stringWithUTF8String:root]]];
  [dirPanel setCanChooseFiles:NO];
  [dirPanel setCanChooseDirectories:YES];
  [dirPanel setCanCreateDirectories:YES];
  [dirPanel setAllowsMultipleSelection:NO];
  [dirPanel setResolvesAliases:YES];
  const char *theFolderResult = "";

  NSModalSession dirSession = [NSApp beginModalSessionForWindow:dirPanel];
  [dirPanel center];
    
  for (;;) {
    if ([NSApp runModalSession:dirSession] == NSModalResponseOK) {
      NSURL *theFolderURL = [[dirPanel URLs] objectAtIndex:0];
      NSString *theFolderPath = [theFolderURL path];
      if (![theFolderPath hasSuffix:@"/"])
        theFolderPath = [theFolderPath stringByAppendingString:@"/"];
      theFolderResult = [theFolderPath UTF8String];
      break;
    }

    if ([NSApp runModalSession:dirSession] == NSModalResponseCancel)
      break;
  }
    
  [NSApp endModalSession:dirSession];
  [dirPanel close];
  
  return theFolderResult;
}

int cocoa_get_color(int defcol, const char *title) {
  [[NSApplication sharedApplication] setActivationPolicy:1];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  int redValue = defcol & 0xFF;
  int greenValue = (defcol >> 8) & 0xFF;
  int blueValue = (defcol >> 16) & 0xFF;

  NSInteger buttonWidth = 82, buttonHeight = 30, rightofButtons = 8;
  NSString *myColorTitle = [NSString stringWithUTF8String:title];
  NSColor *myDefCol = [NSColor colorWithCalibratedRed:redValue green:greenValue blue:blueValue alpha:1.0f];
  NSColorPanel *myColorPanel = [NSColorPanel sharedColorPanel];
  [myColorPanel setDieWhenParentProcessDies:YES];

  [myColorPanel setFrame:NSMakeRect(0, 0, 229, 399) display:YES animate:NO];
  if ([myColorTitle length] > 0) [myColorPanel setTitle:myColorTitle];
  NSSize myColorSize = [[myColorPanel contentView] frame].size;
  NSView *myViewView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, myColorSize.width, buttonHeight)];
  NSView *myButtonView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, myColorSize.width, buttonHeight)];
  NSButton *myOKButton = [[NSButton alloc] initWithFrame:NSMakeRect(myColorSize.width - buttonWidth - rightofButtons, 0, buttonWidth, buttonHeight)];
  NSButton *myCancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(myColorSize.width - (buttonWidth * 2) - rightofButtons, 0, buttonWidth, buttonHeight)];

  [myOKButton setTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_OK)]];
  [myOKButton setAlternateTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_OK)]];
  [myOKButton setBezelStyle:1];
  [myCancelButton setTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_CANCEL)]];
  [myCancelButton setAlternateTitle:[NSString stringWithUTF8String:cocoa_widget_get_button_name(BUTTON_CANCEL)]];
  [myCancelButton setBezelStyle:1];
  [myButtonView addSubview:myOKButton];
  [myButtonView addSubview:myCancelButton];
  [myOKButton setKeyEquivalent:@"\r"];
  [myOKButton setNeedsDisplay:YES];
  [myViewView addSubview:myButtonView];
  [myColorPanel setColor:myDefCol];
  NSView *oldView = [myColorPanel contentView];
  [oldView retain];
  [myColorPanel setContentView:0];
  NSView *colorView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, myColorSize.width, myColorSize.height)];
  NSView *parentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, myColorSize.width, myColorSize.height)];
  [colorView addSubview:oldView];
  [parentView addSubview:colorView];
  [parentView addSubview:myViewView];
  [myColorPanel setContentView:parentView];
  [[myColorPanel standardWindowButton:NSWindowCloseButton] setHidden:YES];
  [[myColorPanel standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
  [[myColorPanel standardWindowButton:NSWindowZoomButton] setHidden:YES];
  myColorPanel.styleMask &= ~NSWindowStyleMaskResizable;
  colorView.autoresizingMask =  NSViewMinYMargin;
  parentView.autoresizingMask = NSViewMaxYMargin;
  myViewView.autoresizingMask = NSViewWidthSizable | NSViewMinXMargin;
  myButtonView.autoresizingMask = NSViewMinXMargin;

  NSModalSession colorSession = [NSApp beginModalSessionForWindow:myColorPanel];
  [myColorPanel setFrame:NSMakeRect(0, 0, 229, 399 + buttonHeight) display:YES animate:NO];
  [myColorPanel center];

  CGFloat r, g, b, a;
  NSColor *myColor = myDefCol;
  int redIntValue, greenIntValue, blueIntValue;
  NSString *redHexValue, *greenHexValue, *blueHexValue;
  NSColor *convertedColor;

  int rescol = -1;
  bool colorOKPressed = false;

  for (;;) {
    if ([NSApp runModalSession:colorSession] != NSModalResponseContinue)
      break;
    
    if ([[myColorPanel standardWindowButton:NSWindowCloseButton] state] == NSControlStateValueOn) {
      [[myColorPanel standardWindowButton:NSWindowCloseButton] setState:NSControlStateValueOff];
      [NSApp endModalSession:colorSession];
    }

    if ([myOKButton state] == NSControlStateValueOn) {
      [NSApp endModalSession:colorSession];
      colorOKPressed = true;
      [myColorPanel close];
    }

    if ([myCancelButton state] == NSControlStateValueOn) {
      [NSApp endModalSession:colorSession];
      [myColorPanel close];
    }
  }

  if (colorOKPressed) {
    myColor = [myColorPanel color];
    convertedColor = [myColor colorUsingType:NSColorTypeComponentBased];

    if (convertedColor) {
      [convertedColor getRed:&r green:&g blue:&b alpha:&a];
      redIntValue = (int)(r * 255);
      greenIntValue = (int)(g * 255);
      blueIntValue = (int)(b * 255);

      rescol = (redIntValue & 0xFF) + ((greenIntValue & 0xFF) << 8) + ((blueIntValue & 0xFF) << 16);
      [myColorPanel close];
    }
  }

  [myColorPanel setContentView:oldView];

  [oldView release];
  [colorView release];
  [myOKButton release];
  [myCancelButton release];
  [myButtonView release];
  [myViewView release];
  [parentView release];

  return rescol;
}
