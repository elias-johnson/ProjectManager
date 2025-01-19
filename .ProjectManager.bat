:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: NAME	       : Project Manager
::
:: DESCRIPTION : Simple CLI script for accessing and managing your projects.
:: VERSION     : 1.0.0
::
:: AUTHOR      : Elias Johnson
:: DATE        : 1-18-24
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal enabledelayedexpansion
@echo off

:: Create directory for projects if it does not already exist
if not exist "%Projects%" (mkdir Projects)
cd Projects

:: Main menu of the manager
:Project_Menu

	:: Display menu options
	cls
	echo  --------------
	echo   Project Menu
	echo  --------------
	echo.
	echo  (a) View All		
	echo  (n) New Project
	echo  (g) Github
	echo  (e) Exit
	echo.

	:: Prompt user for input
	set user_input=''
	set /p user_input=^>^>^>

	:: Execute user input
	if !user_input!==a (goto View_Projects) 
	if !user_input!==n (goto Create_Project) 
	if !user_input!==g (
		:: DEFAULT BROWSER + GITHUB LINK
		start chrome https://github.com/
		goto Project_Menu
	)
	if !user_input!==e (goto Exit) 
		
	:: Base case
	goto Project_Menu


:: Create new project
:Create_Project

:::::::::::::::::::::::
::
:: TODO: ensure that users cannot create a project with a name so that they cd out of Projects directory
::
:::::::::::::::::::::::

	cls
	echo  ----------------
	echo   Create Project
	echo  ----------------
	echo.

	:: Prompt user for input
	set project_name=''
	set /p project_name= Name of New Project: 
	
	:: Ensure valid project name
	if !project_name!==.. (
			echo Invalid Project Name.
			timeout /t 2 /nobreak >nul
			goto Create_Project
	)
	if !project_name!==. (
			echo Invalid Project Name.
			timeout /t 2 /nobreak >nul
			goto Create_Project
	)
	if !project_name!==b (
			echo Invalid Project Name.
			timeout /t 2 /nobreak >nul
			goto Create_Project
	)
	if !project_name!==d (
			echo Invalid Project Name.
			timeout /t 2 /nobreak >nul
			goto Create_Project
	) else (
		if not exist !project_name! (
			:: Create new project
			mkdir !project_name!
			cd !project_name!
			goto Project
		) else (
			echo Project With That Name Already Exists.
			timeout /t 2 /nobreak >nul
			goto Create_Project
		)
	)
		
	:: Base case
	goto Create_Project


:: View projects and select one for more details and options
:View_Projects

:::::::::::::::::::::::
::
:: TODO: ensure that users cannot delete a directory not inside the Projects directory
::
:::::::::::::::::::::::

	:: Display menu options
	cls
	echo  --------------------------------------------------
	echo   Select Project - Enter Name of Project to Select
	echo  --------------------------------------------------
	echo.
	for /D %%D in (*) do @echo      %%D
	echo.
	echo  (d) Delete Project
	echo  (b) Back
	echo.

	:: Prompt user for input
	set user_input=''
	set /p user_input=^>^>^>

	:: Execute user input
	if !user_input!==d (
		set /p delete=Name of project to delete: 
		if exist "!delete!" (
			set /p confirmation="Are You Sure? (y/n): "
			if "!confirmation!"=="y" (
				rmdir /S /Q "!delete!"
			)
		)
		goto View_Projects
	)
	if !user_input!==b (
		goto Project_Menu
	)
	if exist !user_input! (
		if not !user_input!==.. (
			if not !user_input!==. (
				cd !user_input!
				goto Project
			)
		)
	)	
		
	:: Base case
	goto View_Projects


:: View, edit, and run a project
:Project

	:: Display menu options
	cls
	echo  ---------
	echo   Project 
	echo  ---------
	echo.
	set /A num_files=0
	for %%F in (*) do (
		@echo      %%F
		set /A num_files+=1
	)
	echo.
	echo  File count: !num_files!
	echo.
	echo  (n) New file
	echo  (d) Delete file
	echo  (b) Back
	echo.
	
	:: Prompt user for input 
	set user_input=''
	set /p user_input=^>^>^>
	
	:: Execute user input
	if !user_input!==n (
		set /p new_file=Name of new file: 
		if !new_file!==n (
			echo Invalid file name.
			timeout /t 1 /nobreak >nul
			goto Project
		)
		if !new_file!==b (
			echo Invalid file name.
			timeout /t 1 /nobreak >nul
			goto Project
		)
		if !new_file!==.. (
			echo Invalid file name.
			timeout /t 1 /nobreak >nul
			goto Project
		)
		if !new_file!==. (
			echo Invalid file name.
			timeout /t 1 /nobreak >nul
			goto Project
		)
		echo.> !new_file!
		goto Project
	)
	if !user_input!==d (
		set /p delete=Name of file to delete: 
		if exist "!delete!" (
			set /p confirmation="Are you sure? (y/n): "
			if "!confirmation!"=="y" (
				del "!delete!"
			)
		)
		goto Project
	)
	if !user_input!==b (
		cd ..
		goto View_Projects
	)
	if exist !user_input! (
		!text_editor! !user_input!
	)
		
	:: Base case
	goto Project


:: Terminate the program
:Exit
	cls
	goto :eof