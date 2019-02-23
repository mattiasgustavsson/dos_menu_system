{****************************************************************************

					Dos Menu System - File Reading Routines

 ****************************************************************************}

{**** Get Extension *****}
FUNCTION GetExtension(FileName:String):String;
VAR
	Pos	: Integer;
BEGIN
	Pos:=1;
	WHILE FileName[Pos]<>'.' DO
		Inc(Pos);
	GetExtension:=Ustr(Copy(FileName,Pos+1,Min(Length(FileName)-Pos,3)));
END;

{***** Get Drive *****}
FUNCTION GetDrive(FileName:String):String;
VAR
	i,j:Integer;
BEGIN
	IF FileName[2]=':' THEN
		GetDrive:=Copy(FileName,1,2)
	ELSE
		GetDrive:='';
END;

{***** Get Path *****}
FUNCTION GetPath(FileName:String):String;
VAR
	i,j:Integer;
BEGIN
	i:=Length(FileName);
	WHILE FileName[i]<>'\' DO
		Dec(i);
	IF FileName[2]=':' THEN BEGIN
		j:=3;
		i:=i-2;
	END ELSE
		j:=1;
	IF i=1 THEN
		GetPath:=Copy(FileName,j,i)
	ELSE
		GetPath:=Copy(FileName,j,i-1);
END;

{***** Get Prog *****}
FUNCTION GetProg(FileName:String):String;
VAR
	i:Integer;
BEGIN
	i:=Length(FileName);
	WHILE FileName[i]<>'\' DO
		Dec(i);
	GetProg:=Copy(FileName,i+1,Length(FileName)-i);
END;

VAR
	DMSErrorMsg : String;

{***** DMS Error *****}
PROCEDURE DMSError(FileName:String);
BEGIN
	WriteLn('Error in '+FileName);
	WriteLn(DMSErrorMsg);
	Halt(0);
END;


{***** Read DMS *****}
PROCEDURE ReadDMS(LabelString:String);
BEGIN
	Reset(DMSFile);
	DMSErrorMsg:='Couldn''t find label: '+LabelString+'!';
	REPEAT
		IF EOF(DMSFile) THEN
			DMSError(MenuFile);
		Read(DMSFile,Menu);
	UNTIL UStr(Menu.LabelName)=UStr(LabelString);
END;

{***** AddLabel *****}
PROCEDURE AddLabel(LabelString:String);
VAR
	i,j	: Integer;
BEGIN
	Menu.LabelName:=LabelString;
	Menu.NumOpts:=1;
	Menu.OptionText[1]:='Empty option';
	Menu.ActionString[1]:='NONE';
	Menu.ActionType[1]:=LabelToken;
	FOR j:=1 TO 11 DO
		Menu.Description[1,j]:='';
	Menu.Description[1,1]:='Delete this option and enter your own ones.';
	FOR i:=2 TO MaxOpts DO BEGIN
		Menu.OptionText[i]:='';
		Menu.ActionString[i]:='';
		Menu.ActionType[i]:=0;
		FOR j:=1 TO 11 DO
			Menu.Description[i,j]:='';
	END;
	Seek(DMSFile,FileSize(DMSFile));
	Write(DMSFile,Menu);
	ReadDMS(MenuLabel);
END;

{***** Open DMS *****}
PROCEDURE OpenDMS(FileName:String);
BEGIN
	Assign(DMSFile,FileName);
	Reset(DMSFile);
	IF IOResult<>0 THEN BEGIN
		Rewrite(DMSFile);
		AddLabel('Main');
	END;
END;

{***** Set Default Color Definitions *****}
PROCEDURE DefaultColors;
BEGIN
	BarCol0:=Black;
	BarCol1:=Red;
	BarCol2:=LightRed;
	TitleCol0:=Green;
	TitleCol1:=LightGreen;
	TitleCol2:=White;
	MenuCol0:=Green;
	MenuCol1:=LightGreen;
	MenuCol2:=White;
	DescCol0:=Green;
	DescCol1:=LightGreen;
	DescCol2:=White;
	CursCol0:=Cyan;
	CursCol1:=White;
END;

{***** Read Colors *****}
PROCEDURE ReadColors;
VAR
	Fi	: File OF Byte;
BEGIN
	DefaultColors;
	Assign(Fi,ColFile);
	Reset(Fi);
	IF IOResult<>0 THEN
		Exit;
	Read(Fi,BarCol0);
	Read(Fi,BarCol1);
	Read(Fi,BarCol2);
	Read(Fi,TitleCol0);
	Read(Fi,TitleCol1);
	Read(Fi,TitleCol2);
	Read(Fi,MenuCol0);
	Read(Fi,MenuCol1);
	Read(Fi,MenuCol2);
	Read(Fi,DescCol0);
	Read(Fi,DescCol1);
	Read(Fi,DescCol2);
	Read(Fi,CursCol0);
	Read(Fi,CursCol1);
	Close(Fi);
END;

{***** Set Default Window Definitions *****}
PROCEDURE DefaultWindows;
BEGIN
	TitleTopLeft:='É';
	TitleTop:='Í';
	TitleTopRight:='»';
	TitleLeft:='º';
	TitleRight:='º';
	TitleBottomLeft:='È';
	TitleBottom:='Í';
	TitleBottomRight:='¼';

	MenuTopLeft:='É';
	MenuTop:='Í';
	MenuTopRight:='»';
	MenuLeft:='º';
	MenuRight:='º';
	MenuLeftSplit:='Ì';
	MenuSplit:='Í';
	MenuRightSplit:='¹';
	MenuBottomLeft:='È';
	MenuBottom:='Í';
	MenuBottomRight:='¼';

	DescTopLeft:='É';
	DescTop:='Í';
	DescTopRight:='»';
	DescLeft:='º';
	DescRight:='º';
	DescLeftSplit:='Ì';
	DescSplit:='Í';
	DescRightSplit:='¹';
	DescBottomLeft:='È';
	DescBottom:='Í';
	DescBottomRight:='¼';

	BarChar1:='°';
	BarChar2:='±';
	BarChar3:='²';
	BarChar4:='Û';
END;

{***** Read Windows *****}
PROCEDURE ReadWindows;
VAR
	Fi	: File OF Char;
BEGIN
	DefaultWindows;
	Assign(Fi,WinFile);
	Reset(Fi);
	IF IOResult<>0 THEN
		Exit;
	Read(Fi,TitleTopLeft);
	Read(Fi,TitleTop);
	Read(Fi,TitleTopRight);
	Read(Fi,TitleLeft);
	Read(Fi,TitleRight);
	Read(Fi,TitleBottomLeft);
	Read(Fi,TitleBottom);
	Read(Fi,TitleBottomRight);

	Read(Fi,MenuTopLeft);
	Read(Fi,MenuTop);
	Read(Fi,MenuTopRight);
	Read(Fi,MenuLeft);
	Read(Fi,MenuRight);
	Read(Fi,MenuLeftSplit);
	Read(Fi,MenuSplit);
	Read(Fi,MenuRightSplit);
	Read(Fi,MenuBottomLeft);
	Read(Fi,MenuBottom);
	Read(Fi,MenuBottomRight);

	Read(Fi,DescTopLeft);
	Read(Fi,DescTop);
	Read(Fi,DescTopRight);
	Read(Fi,DescLeft);
	Read(Fi,DescRight);
	Read(Fi,DescLeftSplit);
	Read(Fi,DescSplit);
	Read(Fi,DescRightSplit);
	Read(Fi,DescBottomLeft);
	Read(Fi,DescBottom);
	Read(Fi,DescBottomRight);

	Read(Fi,BarChar1);
	Read(Fi,BarChar2);
	Read(Fi,BarChar3);
	Read(Fi,BarChar4);
	Close(Fi);
END;

{*** Read Directory ***}
FUNCTION ReadDirectory(VAR FileList:DirectoryType; Path:String):Integer;
VAR
	Files		: Integer;
	DirInfo	: SearchRec;

	{*** Read files ***}
	PROCEDURE ReadFiles(UsrPath:String);
	BEGIN
		FindFirst(Path+UsrPath,Anyfile,DirInfo);
		WHILE DosError=0 DO BEGIN
			IF (DirInfo.Attr AND Directory)=0 THEN BEGIN
				FileList[Files]:=DirInfo;
				Inc(Files);
			END;
			FindNext(DirInfo);
		END;
	END;

	{*** Read Directories ***}
	PROCEDURE ReadDirs;
	BEGIN
		FindFirst(Path+'*.*',Anyfile,DirInfo);
		WHILE DosError=0 DO BEGIN
			IF ((DirInfo.Attr AND Directory)=Directory) AND (DirInfo.Name<>'.') THEN BEGIN
				FileList[Files]:=DirInfo;
				FileList[Files].Name:=FileList[Files].Name+'\';
				Inc(Files);
			END;
			FindNext(DirInfo);
		END;
	END;

BEGIN
	Files:=1;
	ReadDirs;
	ReadFiles('*.BAT');
	ReadFiles('*.DMS');
	ReadFiles('*.COM');
	ReadFiles('*.EXE');
	ReadFiles('*.ZIP');
	ReadDirectory:=Files-1;
END;
