@echo off
color 71
echo -------------------------------------------------------
echo ProxyManager (for Imported Media and Nvidia GE footage)
echo -------------------------------------------------------
:: 		by DWLFS

:: DISCLAIMER #1! Use this script at your own discretion and responsibility. ALWAYS BACKUP!

:: This script copies files from recorded footage directory to AME watchfolder, 
:: moves files from recorded footage directory to target directory.
:: At next launch, this script will check if watchfolder is empty (because AME completed all proxy files generation),
:: and watchfolder\source folder containing the copies of the original will be deleted.

:: edited in Notepad++
:: // software implemented in example use case:
:: // Adobe Media Encoder, Nvidia GeForce Experience

echo.
echo.
echo.

:: -------------
:: --- SETUP ---
:: -------------

	:: This script assumes that:
	:: 1. You've created a watchfolder in Adobe Media Encoder application, watching for clips in 
	
	:: // For Imported Media: "%ImportedFootagePath%\%videoFormatFolder%\watchfolder"
	:: // For Nvidia GeForce Experience: "%RecordedFootagePath%\%gameFolderName%\watchfolder\"
	::
	:: // This script could hypothetically work with Handbrake CLI for bulk proxy generation, but it would require some tinkering in the engine room.
	:: 
	:: 2. //Selective processing feature (skippable if values of "customFileNaming=" or "gameAcronym=" are empty)
	::
	:: 			// Imported Media
	::	  A: You have used Total Commander bulk renaming function, so that every clip ready for proxy conversion in "%ImportedFootagePath%\%videoFormatFolder%"
	::    starts with %customFileNaming% followed by a custom system of enumeration, like "%customFileNaming% + 'multiple digit count'". 
	:: 	  Custom name can be modified, so it contains information like camera number, date etc, like Sony-%DATE%-%CAM%,
	::	  which could distinguish files from different projects and camera angles (camera A, camera B).
	::
	:: 			// Nvidia GeForce Experience
	::	  B: You have used Total Commander bulk renaming function, so that every clip ready for proxy conversion in "%RecordedFootagePath%\%gameFolderName%"
	::    starts with %gameAcronym% followed by a custom system of enumeration, like "%gameAcronym% + 'multiple digit count'". 
	::    Example: "D2R-001" or "RDR2-A-0001".
	::    Reasoning behind this functionality is that i found that the default clip NVIDIA GeForce Experience naming convention is impractical to navigate in NLE's.
	
	:: DISCLAIMER #2! Due to batch limitations (ASCII?), please limit yourself to using english alphabet letters when customizing this script.	

::
:: --- STEP 1: DEFINE PATHS
::

:: Here's where you should keep processing-ready camera footage in it's respective subfolders. Enter after "="
	set ImportedFootagePath=E:\Footage\! - to convert

:: Here's where you'll keep all the processed and editing-ready footage and it's subfolders. Enter after "="
	set ImportedReadyFootagePath=E:\Footage
	
:: Here's where you told Nvidia GeForce Experience to record your clips. Enter after "="
	set RecordedFootagePath=E:\Recording Gameplay\! - to convert

:: Here's where you'll keep all the processed editing-ready Nvidia GeForce Experience footage and it's subfolders. Enter after "="
	set RecordedReadyFootagePath=E:\Recording Gameplay

::
:: --- STEP 2: ENTER NAMING CONVENTION
::

::
:: A: Imported Media Formats
::
	:: ctrl+c ctrl+v four lines undeneath ":videoFormat" along with it to add more. 
	:: "videoFormatFolder" should be the name of the respective subfolder containing files to process.
	:: "customFileNaming" depends on the naming system you used. It distinguishes previously inspected and numbered clips instead of converting everything. 
	:: "fileExtensionIM" is a required field and it corresponds to video file extension unique to video format in the "videoFormatFolder".
	
	:: If "customFileNaming" is set to (for example) Sony, then the script will process any file that starts with "Sony" and has "fileExtensionIM*" extension.
	:: This script will process any file that starts with "customFileNamin" values as a prefix. 
	:: If you will leave it blank, the script will process all files with fileExtensionIM.
	
	echo Processing Imported Media
	
	:: Example use cases

		:Sony1080pMP4
		set videoFormatFolder=Sony1080pMP4
		set customFileNaming=Sony
		set fileExtensionIM=mp4
		call :proxyMachineIM

		
		:Gopro10-4kMP4
		set videoFormatFolder=Gopro10-4kMP4
		set customFileNaming=Gopro10
		set fileExtensionIM=mp4
		call :proxyMachineIM

		
::
:: B: Nvidia GeForce Experience
::
	:: ctrl+c ctrl+v four lines undeneath ":GameTitle" along with it to add more.
	::
	:: DISCLAIMER #3! - "gameFolderName" variable below is dictated by Nvidia Shadowplay's default recorded clips folder name of the game.
	::
	:: "gameAcronym" depends on the naming system you used. It distinguishes previously inspected and numbered clips instead of converting everything. 
	:: "fileExtensionNGE" is a required field and it corresponds to video file extension unique to video format in the "videoFormatFolder".
	:: This script will process any file that starts with "gameAcronym" value as a prefix.
	:: If you will leave it blank, the script will process all files with fileExtensionIM.

	echo Processing Nvidia GeForce Experience Media
	
	:: Example use cases

		:DarkSoulsIII
		set gameFolderName=Dark Souls III
		set gameAcronym=DS3
		set fileExtensionNGE=mp4
		call :proxyMachineNGE

		
		:RedDeadRedemption2
		set gameFolderName=Red Dead Redemption 2
		set gameAcronym=RDR2
		set fileExtensionNGE=mp4
		call :proxyMachineNGE

		
		:DiabloIIResurrected
		set gameFolderName=Diablo 2 Resurrected
		set fileExtensionNGE=mp4
		set gameAcronym=D2R
		call :proxyMachineNGE


	:: Below is where all the magic happens. No need to edit anything there unless you want to change directories.
	:: It is worth mentioning that once started, the process should not be interrupted.
	goto finish	
	
:: ----------------------
:: --- IM ENGINE ROOM ---
:: ----------------------
	
		:proxyMachineIM
			set ImportedRenamedClipsPath="%ImportedFootagePath%\%videoFormatFolder%\%customFileNaming%*.%fileExtensionIM%"
			set WatchfolderPathIM="%ImportedFootagePath%\%videoFormatFolder%\watchfolder"
			set FormatsReadyFootagePath="%ImportedReadyFootagePath%\%videoFormatFolder%"
			set IMediaInWatchfolderPath="%ImportedFootagePath%\%videoFormatFolder%\watchfolder\*.%fileExtensionIM%"
			
			echo =============================================================================
			echo %videoFormatFolder%.
			echo.
			echo The naming scheme is %customFileNaming%.
			echo Imported and numbered clips path are in %ImportedFootagePath%\%videoFormatFolder%\.
			echo Watchfolder path is %ImportedFootagePath%\%videoFormatFolder%\watchfolder.
			echo Destination folder of recorded footage is %FormatsReadyFootagePath%.
			goto checkIfFootagePresentIM
		
		:checkIfFootagePresentIM
			if not exist %ImportedRenamedClipsPath% (call :errorMsgIM)
			if exist %ImportedRenamedClipsPath% (call :proxyGeneratorIM)			
			if not exist %IMediaInWatchfolderPath% (call :cleanupIM)
			if exist %IMediaInWatchfolderPath% (call :nocleanupIM)			
			echo                                         ...%videoFormatFolder% done.
			echo =============================================================================
			echo.
			echo.
			echo.
			echo.
			echo.
			echo.
			exit /b		

			:proxyGeneratorIM
				:: proxy generator formula
				echo.
				echo Copying recorded clips to the watchfolder.
				if not exist %WatchfolderPathIM% (mkdir %WatchfolderPathIM%)
				copy %ImportedRenamedClipsPath% %WatchfolderPathIM%
						:: --- Copies files starting with %customFileNaming% prefix to the watchfolder, where Encoder will detect,
						:: --- and create proxy files in go-to editing path
				echo.		
				echo Moving original files to the destination folder.
				if not exist %FormatsReadyFootagePath% (mkdir %FormatsReadyFootagePath%)
				move /y %ImportedRenamedClipsPath% %FormatsReadyFootagePath%
						:: --- after copying is done, it moves original files to the "editing-ready" folder as go-to full res editing clips.
						:: --- Adobe Media Encoder will handle creating proxy files and moving them to proper path.
				echo.		

				exit /b
		
			:cleanupIM
				:: source cleanup formula
					:: --- Converted mp4 copies will be moved to "source" folder by Encoder, so if there is no m* files left to convert to proxies in the watchfolder,
					:: --- it will delete watchfolder entirely to conserve space, and then recreate it, but empty.
					:: --- This is done this way because Encoder has no way of choosing it's default "source" folder's name.
					:: --- By default it's the folder called "source" translated to your OS language, inside the "watchfolder".
					:: --- Because of this, depending on language used, batch might have problems interpreting non-English letters.
					echo Performing "watchfolder/source" folder cleanup via watchfolder removal when "watchfolder" is empty.
					rmdir %WatchfolderPathIM% /s /q
					mkdir %WatchfolderPathIM%
					exit /b
					
			:nocleanupIM
					echo Watchfolder not empty. Skipping Watchfolder cleanup.
					exit /b
					

			:errorMsgIM
				echo ---NO FOOTAGE FOUND
				exit /b
				
:: -----------------------
:: --- NGE ENGINE ROOM ---
:: -----------------------
	
		:proxyMachineNGE
			set RecordedNumberedClipsPath="%RecordedFootagePath%\%gameFolderName%\%gameAcronym%*.%fileExtensionNGE%"
			set WatchfolderPathNGE="%RecordedFootagePath%\%gameFolderName%\watchfolder"
			set GamesReadyFootagePath="%RecordedReadyFootagePath%\%gameFolderName%"
			set NGEMediaInWatchfolderPath="%RecordedFootagePath%\%gameFolderName%\watchfolder\*.%fileExtensionNGE%"
			
			echo -----------------------------------------------------------------------------
			echo %gameFolderName%.
			echo.
			echo The game's acronym is %gameAcronym%.
			echo Recorded and numbered clips path are in %RecordedFootagePath%\%gameFolderName%\.
			echo Watchfolder path is %RecordedFootagePath%\%gameFolderName%\watchfolder.
			echo Destination folder of recorded footage is %GamesReadyFootagePath%.
			goto checkIfFootagePresentNGE
		
		:checkIfFootagePresentNGE
			if not exist %RecordedNumberedClipsPath% (call :errorMsgNGE)
			if exist %RecordedNumberedClipsPath% (call :proxyGeneratorNGE)			
			if not exist %NGEMediaInWatchfolderPath% (call :cleanupNGE)
			if exist %NGEMediaInWatchfolderPath% (call :nocleanupNGE)	
			echo                                         ...%gameFolderName% done.
			echo -----------------------------------------------------------------------------
			echo.
			echo.
			echo.
			echo.
			echo.
			echo.
			exit /b		

			:proxyGeneratorNGE
				:: proxy generator formula
				echo.
				echo Copying recorded clips to the watchfolder.
				if not exist %WatchfolderPathNGE% (mkdir %WatchfolderPathNGE%)
				copy %RecordedNumberedClipsPath% %WatchfolderPathNGE%
						:: --- Copies files starting with %gameAcronym% prefix to the watchfolder, where Encoder will detect,
						:: --- and create proxy files in go-to editing path
				echo.		
				echo Moving original files to the destination folder.
				if not exist %GamesReadyFootagePath% (mkdir %GamesReadyFootagePath%)
				move /y %RecordedNumberedClipsPath% %GamesReadyFootagePath%
						:: --- after copying is done, it moves original files to the "editing-ready" folder as go-to full res editing clips.
						:: --- Adobe Media Encoder will handle creating proxy files and moving them to proper path.
				echo.		

				exit /b
		
			:cleanupNGE
				:: source cleanup formula
					echo Performing "watchfolder/source" folder cleanup via watchfolder removal when "watchfolder" is empty.
					rmdir %WatchfolderPathNGE% /s /q
					mkdir %WatchfolderPathNGE%
					exit /b
					
			:nocleanupNGE
					echo Watchfolder not empty. Skipping Watchfolder cleanup.
					exit /b
			

			:errorMsgNGE
				echo ---NO FOOTAGE FOUND
				exit /b


:finish
echo Proxy management complete.	
pause