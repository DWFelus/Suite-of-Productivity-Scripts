@echo off
color 17
echo ----------------------
echo MusicalTimeProgrammer
echo ----------------------
:: 		by DWLFS

echo.
:: edited in Notepad++
:: // optional/useful software implemented in example use case:
:: // MusicBee (for automatically updating playlists)

:: ---DEFAULT USE CASE:

::
:: --- edit location of "hours.cfg" and; when adding to "autostart" Windows Folder, cmd executes commands not relative to script's location
:: 

	set hoursPath="D:\Dev\Suite of Productivity Scripts\hours.cfg"

::
:: --- Paths of playlists
::
	set SynthwavePath=start cmd /c "D:\Music\Playlists\Radio - Synthwave.xautopf"
	set ChillPath=start cmd /c "D:\Music\Playlists\Radio - Chill.xautopf"
	set Ambient=start cmd /c "D:\Music\Playlists\Radio - Ambient.xautopf"
	set FestivalPath=start cmd /c "D:\Music\Playlists\Radio - Festival.xautopf"
	set FullAlbumsPath=start cmd /c "D:\Music\Playlists\Radio - Full Albums.xautopf"
	set MorningPlaylist=start cmd /c "D:\Music\Playlists\Radio - Breakfast.xautopf"

::
:: --- Timers for later use
::
	set timecheckInterval=10
	set timeToCancel=10
	set loadTimeMusicBee=5
	
::
:: --- Checking Day of Week
::
	Set "_=mon tues wed thurs fri sat sun" 
	For /f %%# In ('WMIC Path Win32_LocalTime Get DayOfWeek^|Findstr [0-6]') Do (Set DOW=%%#)

::
:: --- Attaching functions to DOW values.
::
	IF %DOW%==1 (goto Monday)
	IF %DOW%==2 (goto Tuesday)
	IF %DOW%==3 (goto Wednesday)
	IF %DOW%==4 (goto Thursday)
	IF %DOW%==5 (goto Friday)
	IF %DOW%==6 (goto Saturday)
	IF %DOW%==0 (goto Sunday)
	
::	
:: --- Setting up variables and playlists for corresponding times of day.
::
	:Monday
		echo Monday
		set PlaylistFocus=Synthwave
		set PlaylistFocusEnd=FullAlbums
		set PlaylistOffhoursStartup=FullAlbums
		goto PlaylistsSetup
		
	:Tuesday
		echo Tuesday
		set PlaylistFocus=Chill
		set PlaylistFocusEnd=FullAlbums
		set PlaylistOffhoursStartup=FullAlbums
		goto PlaylistsSetup

	:Wednesday
		echo Wednesday
		set PlaylistFocus=Ambient
		set PlaylistFocusEnd=FullAlbums
		set PlaylistOffhoursStartup=FullAlbums
		goto PlaylistsSetup

	:Thursday
		echo Thursday
		set PlaylistFocus=Synthwave
		set PlaylistFocusEnd=FullAlbums
		set PlaylistOffhoursStartup=FullAlbums
		goto PlaylistsSetup

	:Friday
		echo Friday
		set PlaylistFocus=Chill
		set PlaylistFocusEnd=FullAlbums 
		set PlaylistOffhoursStartup=FullAlbums
		goto PlaylistsSetup

	:Saturday
		echo Saturday
		set PlaylistFocus=Festival
		set PlaylistFocusEnd=null
		set PlaylistOffhoursStartup=Festival
		goto PlaylistsSetup

	:Sunday
		echo Sunday
		set PlaylistFocus=Festival
		set PlaylistFocusEnd=null
		set PlaylistOffhoursStartup=Festival
		goto PlaylistsSetup

::
:: --- Defining variables for use in time-checking loops
::


:PlaylistsSetup	
	echo Focus playlist is %PlaylistFocus%.
	echo Focus end playlist is %PlaylistFocusEnd%.
	echo Playlist at offhours runtime is %PlaylistOffhoursStartup%.
	
	echo Setting up Playlists.
	timeout %timeToCancel%

	IF %PlaylistFocus%==Synthwave (set PlayPlaylist=%SynthwavePath%)
	IF %PlaylistFocus%==Chill (set PlayPlaylist=%ChillPath%)
	IF %PlaylistFocus%==Ambient (set PlayPlaylist=%Ambient%)
	IF %PlaylistFocus%==Festival (set PlayPlaylist=%FestivalPath%)
	
	IF %PlaylistFocusEnd%==FullAlbums (set PlayPlaylistFocusEnd=%FullAlbumsPath%)
	IF %PlaylistFocusEnd%==null (set PlayPlaylistFocusEnd="")
	
	IF %PlaylistOffhoursStartup%==FullAlbums (set PlayPlaylistOffhoursStartup=%FullAlbumsPath%)
	IF %PlaylistOffhoursStartup%==Festival (set PlayPlaylistOffhoursStartup=%FestivalPath%)

::
:: --- Checking intial time and deciding accordingly.
::
	set hour=%time:~0,2%
	echo Hour is %hour%.

::
:: --- Fetching day schedule
::
	for /F "tokens=2 delims==" %%a in ('findstr /I "focusEnd=" %hoursPath%') do (set focusEnd=%%a)

	for /F "tokens=2 delims==" %%a in ('findstr /I "morningTimeEnd=" %hoursPath%') do (set morningTimeEnd=%%a)

	for /F "tokens=2 delims==" %%a in ('findstr /I "minimalWakeupTime=" %hoursPath%') do (set minimalWakeupTime=%%a)
	
	echo Minimal wake up time is %minimalWakeupTime%.
	echo Morning time end/focus start is %morningTimeEnd%.
	echo Focus time end is %focusEnd%.
::
:: --- LOADING PLAYLISTS
::
		:initialTimeCheck
			:: If time is during off time...
				IF %hour% LSS %minimalWakeupTime% (GOTO closeOffHours)
				IF %hour% GEQ %focusEnd% (GOTO closeOffHours)
			:: ...otherwise proceed.
				goto MorningCheck

		:closeOffHours
			:: If time is during the off hours...
				echo Loading off hour playlist.
				%PlayPlaylistOffhoursStartup% 
				timeout %loadTimeMusicBee%
				goto close

		:MorningCheck
			:: If time is during morning time...
				IF %hour% GEQ %minimalWakeupTime% IF %hour% LSS %morningTimeEnd% (%MorningPlaylist% & echo Running morning playlist. & goto timecheckMorning)
			:: otherwise go to :FocusTime
				goto FocusTime

		:FocusTime
			:: If time is during focus time...
				echo Running Focus Time playlist.
				%PlayPlaylist%
				timeout %loadTimeMusicBee%
				call :timecheckAfternoon

::
:: --- LOOPS
::	
	:timecheckMorning
	:: --- this loops checks if it's time to play focus music
		echo Waiting to begin focus
		SET hour=%time:~0,2%
		timeout %timecheckInterval%
		echo Musical Time Programmer - Hour is %hour%.
		IF %hour% GEQ %morningTimeEnd% (%PlayPlaylist% & goto timecheckAfternoon)
		goto timecheckMorning


	:timecheckAfternoon
	:: --- this loop checks time to change playlist after focus end
		echo Waiting for focus end
		timeout %timecheckInterval%
		SET hour=%time:~0,2%
		echo Musical Time Programmer - Hour is %hour%.
		IF %hour% GEQ %focusEnd% (%PlayPlaylistFocusEnd% & goto close)
		goto timecheckAfternoon	
	
:close
echo Script has reached it's end.
pause