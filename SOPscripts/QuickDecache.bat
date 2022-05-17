@echo off
color 78
echo ------------
echo QuickDecache
echo ------------
:: 		by DWLFS

echo.
:: edited in Notepad++
:: // software implemented in example use case:
:: // Adobe Premiere Pro (two versions 2018,2020), RX7, Audacity, Ableton Live, Adobe Audition
:: // Google Chrome, Documents/Temp folder, Firefox, Opera, OperaGX, Spotify

echo Deleting cache files from custom cache directory.
echo.
timeout 5
set customCachePath=E:\@ - Cache

	:: /q /s for silent "yes" and subdirectory files
	   del "%customCachePath%\2018\media cache" /q /s
	   del "%customCachePath%\2018\media cache files" /q /s
	   del "%customCachePath%\2018\peak files" /q /s
	   del "%customCachePath%\2018\Team Projects Cache" /q /s
	   del "%customCachePath%\2020\media cache" /q /s
	   del "%customCachePath%\2020\media cache files" /q /s
	   del "%customCachePath%\2020\peak files" /q /s
	   del "%customCachePath%\2020\Team Projects Cache" /q /s
	   del "%customCachePath%\rx7" /q /s
	   del "%customCachePath%\audacity" /q /s
   	   del "%customCachePath%\ableton" /q /s	
   	   del "%customCachePath%\audition" /q /s	

echo Deleting cache files from Documents and Program Files/Data.
echo.
timeout 5

:: liste any temp folder that regularly takes space.

:: local temp
		echo Deleting cache - local temp
		del "%LocalAppData%\Temp" /q /s
:: chrome
		echo Deleting cache - chrome
	    del "%LocalAppData%\Google\Chrome\User Data\Default\Cache" /q /s
:: firefox
		echo Deleting cache - firefox
	    del "%LocalAppData%\Mozilla\Firefox\Profiles\k841ldsr.default-release\cache2\entries" /q /s
:: opera
		echo Deleting cache - opera
	    del "%LocalAppData%\Opera Software\Opera Stable\Cache" /q /s
:: operaGX
		echo Deleting cache - operaGX
	    del "%LocalAppData%\Opera Software\Opera GX Stable\Cache" /q /s
:: spotify
		echo Deleting cache - spotify
	    del "%LocalAppData%\Packages\SpotifyAB.SpotifyMusic_zpdnekdrzrea0\LocalCache" /q /s

echo.	
timeout 5   

	   
	   
pause