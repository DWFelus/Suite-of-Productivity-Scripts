@echo off
setlocal enabledelayedexpansion
color 87
echo ---------
echo RightFoot
echo ---------
:: 		by DWLFS

echo.
:: edited in Notepad++
:: // optional, useful software implemented in example use case:
:: // AutoHotKey, Display Fusion, UAC Pass

:: ---EXAMPLE USE CASE:

:: ----------------------------------------------------------------------------------------------------------------
:: ---------------------------------------------------- SETUP  ----------------------------------------------------
:: ----------------------------------------------------------------------------------------------------------------
echo Setting up application pathing...
:: 
:: ---INITIALIZATION 
:: 
	:: Edit location of "RightFoot.bat"; when adding to "autostart" Windows Folder, cmd executes commands not relative to script's location.
	:: If Windows UAC prevents "RightFoot" from running at autostart, drag and drop "RightFoot.bat" into "UAC Pass" application,
	:: then copy the new shortcut to the "autostart" folder.

	set root="D:\Dev\Suite of Productivity Scripts"

::
:: --- BASIC SETTINGS
::
	:: 1. focus mode -> coding/editing; switches between workspace styles later.
		set focusMode=coding
	
	:: 2. timeframe file location; skip if unchanged.	
		set hoursPath=%root%\hours.cfg
	
	:: 3. edit path to directory containing your custom portable apps. If not in one directory, you can skip using "%portable%" variable later.
		set portable=D:\Programs\! - Portable
			
::			
:: --- OPTIONS
::
	:: Options for debugging and optional daily software.

	:: 1. start screen recording through a hotkey at the startup; stop at the end of tasks.	
		set recordStartup=yes	
	
	:: 2. override desktop switching and some ahk automated clicks.
		set overrideClicks=no
	
	:: 3. run JDownloader at startup.	
		set shouldStartJDownloader=no
		
	:: 4. take screenshot at startup and at the end of tasks
		set screenshots=yes
		
	:: 5. run display fusion in case it's not scheduled by task manager.
		set shouldRunDisplayFusion=no

::
:: --- PATHS OF TASKS AND THEIR LOAD TIMES
::
	:: First, the script will declare variables which will hold file and application locations,
	:: along with timers that estimate their individual load time.

	::
	:: SoP-scripts ("%root%\SOPscripts")
	::	
		set MusicalTimeProgrammer=start cmd /c "%root%\SOPscripts\MusicalTimeProgrammer.bat"
		set QuickDecache=start cmd /c "%root%\SOPscripts\QuickDecache.bat"
		set ProxyManager=start cmd /c "%root%\SOPscripts\ProxyManager.bat"		
	
	::
	:: APPS
	::	
		:: List of my apps and their load times; some apps won't start without admin privileges if RightFoot is used on autostart;
		:: In some cases UAC Pass was used to bypass this problem through it's "task schedule" operation. In most cases it is/was just copy/paste of the url. 
		:: Some apps have additional custom variables related to them that are relevant only to my system (example: additional delay for Premiere Pro).
		
		:: Every app has "loadTime*" variable underneath, which is acts as a timeout until application is fully loaded.
		:: "RightFoot.bat" opens apps through "start cmd /c" command and times out for "loadTime*", running an app through
		:: direct url might cause "RightFoot" script to hang-up until the executed process exits.
		
		:: 1.time for non-scripted apps to load at boot.
			set "loadTimeWindows=20"
			
		:: 2.time to cancel some backup and cleanup related tasks.
			set "timeToCancel=10"
			
		:: 3.time interval used to listen for focus mode end.
			set "timecheckInterval=10"
		
			:: A-J	
				set adobeReader= start cmd /c "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
				set "loadTimeAdobeReader=15"
				set anki= start cmd /c "C:\Program Files\Anki\anki.exe"
				set "loadTimeAnki=10"
				set encoder2020=start cmd /c "C:\Program Files\Adobe\Adobe Media Encoder 2020\Adobe Media Encoder.exe"
				set "loadTimeEncoder2020=90"
				set "delayEncoder=30"
				set encoder2018=start cmd /c "C:\Windows\System32\schtasks.exe /run /tn "UAC pass\Adobe Media Encoder 2018""
				set "loadTimeEncoder2018=90"
				set jdownloader=start cmd /c  "%LocalAppData%\JDownloader 2.0\JDownloader2Update.exe"
				set "loadTimeJDownloader=15"
				set desktopOK=start cmd /c "%portable%\DesktopOK.exe"
				set "loadTimeDesktopOK=3"
				set displayFusion=start cmd /c "C:\Program Files (x86)\DisplayFusion\DisplayFusion.exe"
				set "loadTimeDisplayFusion=10"
				set cmder=start cmd /c "C:\Windows\System32\schtasks.exe /run /tn "UAC pass\Cmder""
				set "loadTimeCmder=1"
				set gitbash=start cmd /c "%portable%\GitPortable\git-bash.exe"
				set "loadTimeGitBash=2"
				set GitHubDesktop=start cmd /c "%LocalAppData%\GitHubDesktop\GitHubDesktop.exe"
				set "loadTimeGitHubDesktop=10"

			
			:: J-T
				set notion=start cmd /c "%LocalAppData%\Programs\Notion\Notion.exe"
				set "loadTimeNotion=10"
				set rescueTime=start cmd /c "C:\Program Files (x86)\RescueTime\RescueTime.exe" 
				set "loadTimeRescueTime=3"
				set SimpleStickyNotes=start cmd /c "C:\Program Files (x86)\Simnet\Simple Sticky Notes\ssn.exe"
				set "loadTimeSimpleStickyNotes=5"
				set pomotroid=start cmd /c "%LocalAppData%\Programs\pomotroid\Pomotroid.exe"
				set "loadTimePomotroid=7"
				set "runTimeahkMovePomotroid=8"
				set TurnOffMonitor=start cmd /c "%portable%\GitPortable\Turn Off Monitor.exe"
			
			:: U-Z
				set visualStudio=start cmd /c "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
				set "loadTimeVisualStudio=25" 
	::
	:: CUSTOM PROJECTS, SCRIPTS, DOCUMENTS AND WORKSPACES ("%root%\projects" and other misc)
	::	
		set CsharpNotebook=start cmd /c "%root%\projects\CsharpNotebook.bat"
		set "loadTimeChrome=10"
		set FirefoxWorkspace=start cmd /c "%root%\projects\FirefoxWorkspace%.bat"
		set "loadTimeFirefox=10"
		set defaultProject2020=start cmd /c "%root%\projects\DefaultPremiereProject2020.bat"
		set "loadTimePremiere=90"
		set "delayPremiere=30"
		set defaultProject2018=start cmd /c "%root%\projects\DefaultPremiereProject2018.bat"
		set "loadTimePremiere=90"
		set "delayPremiere=30"
		set startWeeklySummary=start cmd /c "%root%\project\SmartGoals.bat"
		set "loadTimeStartWeeklySummary=10"
		set ProjectsCloudBackup=start cmd /c "%root%\projects\ProjectsCloudBackup.bat"

	::
	:: AHK script utilities
	::	
		:: extremely useful for automated desktop switching, clicking/moving windows, closing recurring prompts,
		:: activating apps, taking screenshots and starting screen capture.
			set "loadTimeAhkUtilities=5"
			
				:: ahk scripts pressing ctrl+win+left/right to switch Windows 10 virtual desktops.
				set ahkDesktopRight=start cmd /c "%root%\ahk\ahkRight.ahk"
				set ahkDesktopLeft=start cmd /c "%root%\ahk\ahkLeft.ahk"
				
				::(scripts custom to my system begin here)
				set ahkHideWindows=start cmd /c "%root%\ahk\custom\ahkHideWindows.ahk"
				set ahkUtility=start cmd /c "%root%\ahk\custom\ahkUtility.ahk"
				set ahkClickPremiere2020=start cmd /c "%root%\ahk\custom\ahkClickPremiere2020.ahk"
				set ahkMovePomotroid1=start cmd /c "%root%\ahk\custom\ahkMovePomotroid1.ahk"
				set ahkMovePomotroid2=start cmd /c "%root%\ahk\custom\ahkMovePomotroid2.ahk"
				set ahkScreenshot=start cmd /c "%root%\ahk\custom\ahkScreenshot.ahk"
				set ahkPressRec=start cmd /c "%root%\ahk\custom\ahkPressRec.ahk"
				goto continue
				
					:OverrideControls
						set ahkDesktopRight=navigation override
						set ahkDesktopLeft=navigation override
						set ahkHideWindows=navigation override
						set "loadTimeAhkUtilities=0"
						exit /b	
						
														::	":continue" to here
														:continue
	::
	:: DISPLAY FUSION monitor profiles
	::	
		:: Display Fusion is another extremely useful app; I've configured it so it resizes app windows on load or during runtime, 
		:: assigns them to certain virtual monitor splits or hides them to tray. Thanks to it's command-line support,
		:: it's possible to switch through monitor profiles with diffrent windows splits (depending on current context).
			set "loadTimeDfProfile=3"
				set dfStudying="C:\Program Files (x86)\DisplayFusion\DisplayFusionCommand.exe" -monitorloadprofile "Studying"
				set dfOpera="C:\Program Files (x86)\DisplayFusion\DisplayFusionCommand.exe" -monitorloadprofile "operaPremiere"
				set dfSingleScreen="C:\Program Files (x86)\DisplayFusion\DisplayFusionCommand.exe" -monitorloadprofile "SingleScreen"
			
echo Setting up pathing DONE.			
echo. 
echo.
echo.  

:: -----------------------------------------------------------------------------------------------------------------
:: ---------------------------------------------------- TIME AND DAY -----------------------------------------------
:: -----------------------------------------------------------------------------------------------------------------
echo Setting Time and Day...
::
:: --- Checking Day of Week
::
	set "_=mon tues wed thurs fri sat sun" 
	for /f %%# in ('WMIC Path Win32_LocalTime Get DayOfWeek^|Findstr [0-6]') do (set DOW=%%#)
	
::
:: --- Assigning value to DOW.
::
		IF %DOW%==1 (set day=monday)
		IF %DOW%==2 (set day=tuesday)
		IF %DOW%==3 (set day=wednesday)
		IF %DOW%==4 (set day=thursday)
		IF %DOW%==5 (set day=friday)
		IF %DOW%==6 (set day=saturday)
		IF %DOW%==0 (set day=sunday)

::
:: --- Setting time.
::
	set hour=%time:~0,2%
	echo Hour is %hour%.
	
::
:: --- Fetching day hourly schedule from "hours.cfg" file
::
		for /F "tokens=2 delims==" %%a in ('findstr /I "minimalWakeupTime=" %hoursPath%') do (set minimalWakeupTime=%%a)
		echo Minimal wake up time - %minimalWakeupTime%:00.
		for /F "tokens=2 delims==" %%a in ('findstr /I "morningTimeEnd=" %hoursPath%') do (set morningTimeEnd=%%a)
		echo Focus mode start - %morningTimeEnd%:00.
		for /F "tokens=2 delims==" %%a in ('findstr /I "focusEnd=" %hoursPath%') do (set focusEnd=%%a)
		echo Focus mode end - %focusEnd%:00.
		echo.


echo Setting up Time and Day DONE.			
echo. 
echo.
echo.  

:: -----------------------------------------------------------------------------------------------------------------
:: ---------------------------------------------------- STARTUP ----------------------------------------------------
:: -----------------------------------------------------------------------------------------------------------------
IF %recordStartup%==yes (call :RecStartup)
IF %screenshots%==yes (call :ahkScreenshot)

echo Windows Boot delay...
timeout %loadTimeWindows%

echo.
	:: delay for Windows to boot up. Useful when this script is used on "autostart".
	
::	
:: --- DAILIES
::
echo Running Daily Startup...
echo.
echo.
echo.

	:: those tasks/applications run regardless of day, week or current time.
			
			:: //
			:: // OVERRIDES and CONDITIONAL APPS
			:: //
				IF %shouldRunDisplayFusion%==yes (call :DisplayFusion)				
				IF %overrideClicks%==yes (call :OverrideControls)
				IF %shouldStartJDownloader%==yes (call :jdownloader)
		%TurnOffMonitor%				
		call :MusicalTimeProgrammer
		call :Notion
		call :ahkUtility		
		call :dfStudying
		call :RescueTime
		call :ProjectsCloudBackup
		call :startSimpleStickyNotes

echo Daily Startup DONE.
echo.
echo.
echo.

:: ----------------------------------------------------------------------------------------------
:: -------------------------------- DAY OF WEEK TASK LIST ---------------------------------------
:: ----------------------------------------------------------------------------------------------

echo Running Day of Week Tasks...
echo.
echo.
echo.
::
:: --- DEFINING TASKS
::
	:: If time is during off time go to OffHours, otherwise go to %day%.
		IF %hour% LSS %minimalWakeupTime% (GOTO OffHours)
		IF %hour% GEQ %focusEnd% (GOTO OffHours)
		echo Running Day of Week Tasks...
		echo.
		echo.
		echo.
		goto %day%
		
::	
:: --- OFF HOUR STARTUP ---
::
	:: if any of the conditions above are true, ignore day of week task list
	:: list any application that might run during off hours at a certain day.
		:OffHours
		echo Running Off Hours apps under specific conditions...
		echo.
		echo.
		echo.
		goto close

::
:: --- DAY OF WEEK TASKS
::
	:: These functions won't work on your system as they are fully customized, but they might serve as an idea
	:: how to modify this script for your own needs.

	:: List of functions:
	:: focusRoutine; runProxyManager; weeklySummary; startPomotroid
	:: ahkUtility ; ProjectsCloudBackup ; Encoder; QuickDecache; 

	:monday
		echo MONDAY
		echo ------
		echo.
		call :startPomotroid
		call :weeklySummary
		call :focusRoutine
		call :runProxyManager
		call :Encoder
		goto close

	   
	:tuesday
		echo TUESDAY
		echo -------
		echo.
		call :startPomotroid
		call :focusRoutine
		call :runProxyManager
		call :Encoder
		goto close

	   
	:wednesday
		echo WEDNESDAY
		echo ---------
		echo.
		call :startPomotroid
		call :focusRoutine
		call :runProxyManager
		call :Encoder
		goto close

		
	:thursday
		echo THURSDAY
		echo --------
		echo.
		call :startPomotroid
		call :focusRoutine
		call :runProxyManager
		call :Encoder
		goto close

	   
	:friday
		echo FRIDAY
		echo ------
		echo.
		call :startPomotroid
		call :focusRoutine
		call :runProxyManager
		call :Encoder
		goto close

	   
	:saturday
		echo SATURDAY
		echo --------
		echo.
		goto close

	   
	:sunday
		echo SUNDAY
		echo ------
		echo.
		call :QuickDecache
		goto close

:: --------------------------------------------------------------------------------------------
:: ------------------------------------- FUNCTIONS --------------------------------------------
:: --------------------------------------------------------------------------------------------

::
:: --- FOCUS MODE related
::	

	:focusRoutine
		echo Running Focus Routine...		
		echo Selecting focusMode...
		echo.
		:: :ahkRight goes to next virtual desktop (in this case desktop no.2) and runs further applications there.
		call :ahkRight
		:: decide if currently work is code or video oriented.
		IF %focusMode%==coding (call :focusModeCoding)
		IF %focusMode%==video (call :focusModeVideo)
		:: ahkLeft goes back to previous virtual (in this case desktop no.1).
		call :ahkLeft
		exit /b	

			:focusModeCoding
				echo FocusMode = coding
				echo.				
				call :dfStudying
				call :CmderStart
				call :GitbashStart				
				call :GithubDesktopStart					
				call :CsharpNotebookStart
				call :AnkiStart
				call :AdobeReaderStart
				call :FirefoxWorkspaceStart
				call :VisualStudioStart
				exit /b

			:focusModeVideo
				echo FocusMode = video
				echo.
				call :dfOpera
				echo Launching default project.
				%defaultProject2018%
				timeout %loadTimePremiere%
				echo.	
				call :dfStudying
				exit /b
							
::	
:: --- BACKUP, CACHE, UPDATE AND PROXY related
::	
	:runProxyManager
		echo Running Proxy Manager...
		echo.
		%ProxyManager%
		exit /b

	:QuickDecache
		echo Running Quick Decache...		
		call :timeToCancel
		echo.
		%QuickDecache%
		exit /b
	   			
	:ProjectsCloudBackup
		echo Backing up Projects to Cloud...
		call :timeToCancel
		echo.
		%ProjectsCloudBackup%
		exit /b
		
	:Encoder
		echo Selecting Encoders...
		IF %focusMode%==video (call :Encoder2018)
		call :Encoder2020
		exit /b

			:Encoder2018
				echo Running encoder 2018...
				echo.
				%encoder2018%
				timeout %loadTimeEncoder2018%
				exit /b

			:Encoder2020
				echo Running encoder 2020...
				echo.
				%encoder2020%			
				timeout %loadTimeEncoder2020%
				exit /b
::
:: --- APPS and misc SCRIPTS
::

	:weeklySummary
		echo Running weekly summary...
		%startWeeklySummary%
		timeout %loadTimeStartWeeklySummary%
		echo.
		exit /b

	:DisplayFusion
		echo Running Display Fusion...
		%displayFusion%
		timeout %loadTimeDisplayFusion%
		echo.
		exit /b
		
	:Notion
		echo Running Notion...
		start cmd /c %notion%
		timeout %loadTimeNotion%
		echo.
		exit /b
		
	:RescueTime
		echo Running Rescue Time...
		%rescueTime%
		timeout %loadTimeRescueTime%
		echo.
		exit /b

	:startPomotroid
		echo Running Pomotroid...
		call :ahkRight
		%ahkMovePomotroid1%
		timeout %runTimeahkMovePomotroid%
		%pomotroid%
		timeout %loadTimePomotroid%
		%ahkMovePomotroid2%
		timeout %runTimeahkMovePomotroid%
		echo.
		call :ahkLeft
		exit /b
		
	:MusicalTimeProgrammer
		echo Running MusicalTimeProgrammer...
		%MusicalTimeProgrammer%
		timeout %timeToCancel%%
		echo.
		exit /b
			
	:CmderStart
		echo Running Cmder...
		%cmder%					
		timeout %loadTimeCmder%
		echo.
		exit /b	

	:AdobeReaderStart
		echo Running Adobe Reader...
		%adobeReader%					
		timeout %loadTimeAdobeReader%
		echo.
		exit /b		

	:AnkiStart
		echo Running Anki...
		%anki%					
		timeout %loadTimeAnki%
		echo.
		exit /b				
	
	:jdownloader
		echo Running jdownloader...
		%jdownloader%
		timeout %loadTimeJDownloader%
		echo.
		exit /b

	:startSimpleStickyNotes
		echo Running SimpleStickyNotes...
		%SimpleStickyNotes%
		timeout %loadTimeSimpleStickyNotes%
		echo.
		exit /b
		
	:GitbashStart
		echo Running Gitbash...
		start cmd /c %gitbash%
		timeout %loadTimeGitBash%
		echo.
		exit /b	
	
	:GithubDesktopStart
		echo Running Github Desktop...
		%GitHubDesktop%
		timeout %loadTimeGitHubDesktop%
		echo.
		exit /b	
	
	:CsharpNotebookStart
		echo Running CsharpNotebook... 
		%CsharpNotebook%
		timeout %loadTimeChrome%
		echo.
		exit /b	

	:FirefoxWorkspaceStart
		echo Running Firefox Workspace... 
		%FirefoxWorkspace%
		timeout %loadTimeFirefox%
		echo.
		exit /b	

	:VisualStudioStart
		echo Running Visual Studio... 
		%visualStudio%
		timeout %loadTimeVisualStudio%
		echo.
		exit /b	
		
	:timeToCancel
		echo Time to cancel - %timeToCancel%
		timeout %timeToCancel%
		echo.
		exit /b


:: 
:: --- UTILITIES WITH TIMERS
::	
	::
	:: AHK 
	::
		:ahkRight
			echo Virtual Desktop Right
			echo.
			%ahkDesktopRight%
			timeout %loadTimeAhkUtilities%
			exit /b

		:ahkLeft
			echo Virtual Desktop Left
			echo.
			%ahkDesktopLeft%
			timeout %loadTimeAhkUtilities%
			exit /b

		:ahkHideWindows
			echo Hiding Windows...
			echo.
			%ahkHideWindows%
			timeout %loadTimeAhkUtilities%
			exit /b		
			
		:ahkUtility
			echo Running AHK Desktop Utility...
			%ahkUtility%
			timeout %loadTimeAhkUtilities%
			exit /b
			
	
		:RecStartup
			echo Pressing Record...
			echo.
			%ahkPressRec%
			timeout %loadTimeAhkUtilities%
			exit /b
			
		:ahkScreenshot
			echo Taking a screenshot...
			echo.
			%ahkScreenshot%	
			exit /b
			

	::						
	:: DISPLAY FUSION profiles	
	::
		:dfStudying
			echo DF profile - "Studying"
			echo.
			%dfStudying%
			timeout %loadTimeDfProfile%
			exit /b
			
		:dfOpera
			echo DF profile - "Opera"
			echo.
			%dfOpera%					
			timeout %loadTimeDfProfile%
			exit /b
			
		:dfSingleScreen
			echo DF profile - "SingleScreen"
			echo.
			%dfSingleScreen%
			timeout %loadTimeDfProfile%
			exit /b
						
:: -----------------
:: ------ END ------
:: -----------------

:close
	echo Running Day of Week DONE...
	echo.
	echo.
	echo.
	call :dfStudying
	call :ahkScreenshot
	call :ahkHideWindows
	IF %recordStartup%==yes (call :RecStartup)
	%TurnOffMonitor%	


:timecheckAfternoon
:: --- this loop checks time to end script after focus end.
	echo Waiting for focus end.
	timeout %timecheckInterval%
	echo.
	SET hour=%time:~0,2%
	echo RightFoot - Hour is %hour%.
	IF %hour% GEQ %focusEnd% (goto :end)
	goto timecheckAfternoon	

:end
	echo Script has reached it's end.
	timeout 60
	taskkill /f /im pomotroid.exe
	taskkill /f /im ConEmu64.exe
	taskkill /f /im ConEmuC.exe
	timeout 5
	taskkill /f /im cmd.exe