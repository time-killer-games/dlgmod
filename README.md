# dlgmod

--------------------------------------------------------------------------------------

CLI version of DialogModule for macOS

`dlgmod --show-message string [icon] [title]`
`dlgmod --show-message-cancelable string [icon] [title]`
`dlgmod --show-question string [icon] [title]`
`dlgmod --show-question-cancelable string [icon] [title]`
`dlgmod --show-attempt string [icon] [title]`
`dlgmod --show-error string fatal [icon] [title]`
`dlgmod --get-string string default [icon] [title]`
`dlgmod --get-password string default [icon] [title]`
`dlgmod --get-integer string default [icon] [title]`
`dlgmod --get-passcode string default [icon] [title]`
`dlgmod --get-open-filename filter filename`
`dlgmod --get-open-filename-ext filter filename directory title`
`dlgmod --get-open-filenames filter filename`
`dlgmod --get-open-filenames-ext filter filename directory title`
`dlgmod --get-save-filename filter filename`
`dlgmod --get-save-filename-ext filter filename directory title`
`dlgmod --get-directory directory`
`dlgmod --get-directory-alt title directory`
`dlgmod --get-color color`
`dlgmod --get-color-ext color title`

--------------------------------------------------------------------------------------

Can be ran from the Terminal App directly, or from other apps programatically.

You may put the "dlgmod" executable in the "Resources" folder of an App Bundle.

You may then execute it from your main executable and read output, whether inside and outside the main thread.

If `dlgmod` is run from within an App Bundle, it will close when the main executable in the same bundle has closed.

For easy access to functions that handle this for you, and for more target platforms, check out DialogModule:

https://github.com/time-killer-games/DialogModule

--------------------------------------------------------------------------------------

# Install / Uninstall Instructions

--------------------------------------------------------------------------------------

Click the green download button above on the right hand side of this page. 

Safari should extract the zip file inside your "Downloads" automatically. 

With other internet browsers you will need to do that manually.

Then run this, in the Terminal App, one line at a time, to install:

--------------------------------------------------------------------------------------

`mkdir $HOME/Downloads/dlgmod-main/dlgmod\ \(x64\)`

`chmod 777 $HOME/Downloads/dlgmod-main/dlgmod\ \(x64\).sh`

`$HOME/Downloads/dlgmod-main/dlgmod\ \(x64\).sh`

`sudo mkdir /usr/local/bin`

`sudo cp -f $HOME/Downloads/dlgmod-main/dlgmod\ \(x64\)/dlgmod /usr/local/bin/dlgmod`

`rm -rf $HOME/Downloads/dlgmod-main`

`sudo chmod 777 /usr/local/bin/dlgmod`

--------------------------------------------------------------------------------------

To run a test program in the terminal, and see if it installed properly:

--------------------------------------------------------------------------------------

`dlgmod --show-message 'Hello World!'`

--------------------------------------------------------------------------------------

If nothing happens, installation failed, or there is a bug worth reporting.

Uninstall with this terminal command:

--------------------------------------------------------------------------------------

`rm /usr/local/bin/dlgmod`

--------------------------------------------------------------------------------------

