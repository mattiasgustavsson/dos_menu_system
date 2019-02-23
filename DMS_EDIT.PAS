{****************************************************************************

					Dos Menu System - Menu Edit Routines

 ****************************************************************************}

{***** AddOptionEventSelect *****}
FUNCTION AddOptionEventSelect:Integer;
VAR
	Key : Byte;
BEGIN
	DrawEventSelect;
	REPEAT
		Key:=GetKey AND $ff;
	UNTIL (Key>=59) AND (Key<=63) OR (Key=27);
	CASE Key OF
		59	: AddOptionEventSelect:=0;
		60	: AddOptionEventSelect:=1;
		61	: AddOptionEventSelect:=2;
		62	: AddOptionEventSelect:=3;
		63	: AddOptionEventSelect:=4;
		27	: AddOptionEventSelect:=5;
	END;
	DrawDescription(CurrentOption);
END;

{***** AddOptionTextSelect *****}
FUNCTION AddOptionTextSelect:String;
VAR
	Key		: Byte;
	Choice	: String;
BEGIN
	DrawTextSelect;
	Choice:='';
	REPEAT
		Key:=GetAscii;
		IF (Key>31) AND (Length(Choice)<56) THEN BEGIN
			Choice:=Choice+Chr(Key);
			DrawTextSelectChar(Length(Choice),Chr(Key));
		END;
		IF Key=8 THEN BEGIN
			DrawTextSelectChar(Length(Choice),' ');
			Choice:=Copy(Choice,1,Length(Choice)-1);
			DrawTextSelectCurs(Length(Choice));
		END;
	UNTIL Key=13;
	AddOptionTextSelect:=String(Choice);
	DrawTextSelectClear;
	DrawDescription(CurrentOption);
END;

{***** AddOptionOldlabel *****}
FUNCTION AddOptionOldlabel:String;
VAR
	List			: LabelListType;
	Option,
	Opts			: Integer;

	PROCEDURE ReadOptions;
	BEGIN
		Seek(DMSFile,0);
		Opts:=1;
		REPEAT
			Read(DMSFile,Menu);
			List[Opts]:=Menu.LabelName;
			Inc(Opts);
		UNTIL (EOF(DMSFile)) OR (Opts=1000);
		Dec(Opts);
	END;

	{***** Select Option *****}
	PROCEDURE SelectOption;
		{***** Cursor Up *****}
		PROCEDURE CursorUp;
		BEGIN
			IF Option>1 THEN
				Dec(Option)
			ELSE
				Option:=Opts;
			DrawOldlabelOptions(List,Option,Opts);
		END;

		{***** Cursor Down *****}
		PROCEDURE CursorDown;
		BEGIN
			IF Option<Opts THEN
				Inc(Option)
			ELSE
				Option:=1;
			DrawOldlabelOptions(List,Option,Opts);
		END;
	CONST
		Enter		= 13;
		Space		= 32;
		CursUp	= 72;
		CursDwn	= 80;
	VAR
		Key : Word;
		ActionFlag	: Boolean;
	BEGIN
		ActionFlag:=False;
		REPEAT
			{***** Read Keyboard *****}
			Key:=GetKey AND $ff;
			IF Key>0 THEN
				CASE Key OF
					{** Menu control **}
					Enter		: ActionFlag:=True;	{ ENTER	 }
					Space		: ActionFlag:=True;	{ SPACE	 }
					CursUp	: CursorUp;				{ CURSUP	 }
					CursDwn	: CursorDown;			{ CURSDWN }
				END;
		UNTIL ActionFlag;
	END;
BEGIN
	DrawSelectOldlabel;
	ReadOptions;
	Option:=1;
	DrawOldlabelOptions(List,Option,Opts);
	SelectOption;
	AddOptionOldLabel:=List[Option];
	ReadDMS(MenuLabel);
END;

{***** AddOptionNewlabel *****}
FUNCTION AddOptionNewlabel:String;
VAR
	Again		: Boolean;
	Key		: Byte;
	Choice	: String;
BEGIN
	DrawNewlabelSelect;
	REPEAT
		Choice:='';
		REPEAT
			Key:=GetAscii;
			IF (Key>31) AND (Length(Choice)<56) THEN BEGIN
				Choice:=Choice+Chr(Key);
				DrawNewlabelSelectChar(Length(Choice),Chr(Key));
			END;
			IF Key=8 THEN BEGIN
				DrawNewlabelSelectChar(Length(Choice),' ');
				Choice:=Copy(Choice,1,Length(Choice)-1);
				DrawNewlabelSelectCurs(Length(Choice));
			END;
		UNTIL Key=13;
		Seek(DMSFile,0);
		Again:=False;
		REPEAT
			Read(DMSFile,Menu);
			IF Menu.LabelName=Choice THEN BEGIN
				DrawNewlabelSelectAgain;
				Again:=True;
			END;
		UNTIL EOF(DMSFile);
	UNTIL Again=False;
	AddOptionNewlabel:=String(Choice);
	DrawNewlabelSelectClear;
	DrawDescription(CurrentOption);
	ReadDMS(MenuLabel);
END;

{***** AddOptionFileSelect *****}
FUNCTION AddOptionFileSelect:String;
VAR
	List : DirectoryType;
	Option,
	Opts		: Integer;

	{***** Select Option *****}
	PROCEDURE SelectOption;
		{***** Cursor Up *****}
		PROCEDURE CursorUp;
		BEGIN
			IF Option>1 THEN
				Dec(Option)
			ELSE
				Option:=Opts;
			DrawDirectoryOptions(List,Option,Opts);
		END;

		{***** Cursor Down *****}
		PROCEDURE CursorDown;
		BEGIN
			IF Option<Opts THEN
				Inc(Option)
			ELSE
				Option:=1;
			DrawDirectoryOptions(List,Option,Opts);
		END;
	CONST
		Enter		= 13;
		Space		= 32;
		CursUp	= 72;
		CursDwn	= 80;
	VAR
		Key : Word;
		ActionFlag	: Boolean;
	BEGIN
		ActionFlag:=False;
		REPEAT
			{***** Read Keyboard *****}
			Key:=GetKey AND $ff;
			IF Key>0 THEN
				CASE Key OF
					{** Menu control **}
					Enter		: ActionFlag:=True;	{ ENTER	 }
					Space		: ActionFlag:=True;	{ SPACE	 }
					CursUp	: CursorUp;				{ CURSUP	 }
					CursDwn	: CursorDown;			{ CURSDWN }
				END;
		UNTIL ActionFlag;
	END;

	{*** SelectFile ***}
	PROCEDURE SelectFile(VAR Choice:SearchRec; Path:String);
	BEGIN
		Opts:=ReadDirectory(List,Path);
		Option:=1;
		DrawDirectoryOptions(List,Option,Opts);
		SelectOption;
		Choice:=List[Option];
	END;
	{*** SelectDrive ***}
	FUNCTION SelectDrive:String;
	VAR
		Key	: Byte;
	BEGIN
		REPEAT
			Key:=GetKey;
		UNTIL Key<>0;
		SelectDrive:=Chr(Key);
	END;

	FUNCTION CutLastDir(Dir:String):String;
	VAR
		Pos	: Integer;
	BEGIN
		IF (Length(Dir)=3) AND (Dir[2]=':') OR (Dir='\') THEN
			Exit;
		Pos:=Length(Dir)-1;
		WHILE Dir[Pos]<>'\' DO
			Dec(Pos);
		CutLastDir:=Copy(Dir,1,Pos);
	END;

VAR
	CurrDir		: String;
	ChosenFile	: SearchRec;
BEGIN
	DrawDriveSelect;
	CurrDir:=SelectDrive;
	ChDir(CurrDir+':\');
	DrawFileSelect;
	GetDir(0,CurrDir);
	IF CurrDir[Length(CurrDir)]<>'\' THEN
		CurrDir:=CurrDir+'\';
	REPEAT
		SelectFile(ChosenFile,CurrDir);
		IF (ChosenFile.Attr AND Directory)=Directory THEN
			IF ChosenFile.Name<>'..\' THEN
				CurrDir:=CurrDir+ChosenFile.Name
			ELSE
				CurrDir:=CutLastDir(CurrDir);
	UNTIL (ChosenFile.Attr AND Directory)=0;
	AddOptionFileSelect:=CurrDir+ChosenFile.Name;
	ChDir(GetDrive(RunMenu)+GetPath(RunMenu));
END;

{***** DoAdd *****}
PROCEDURE DoAdd(Place:Integer; OptionText:String; ActionType:Integer;
					 ActionString,User:String);
VAR
	i,
	j	: Integer;
BEGIN
	ReadDMS(MenuLabel);
	FOR i:=Menu.NumOpts DOWNTO Place DO BEGIN
		Menu.OptionText[i+1]:=Menu.OptionText[i];
		Menu.ActionType[i+1]:=Menu.ActionType[i];
		Menu.ActionString[i+1]:=Menu.ActionString[i];
		Menu.User[i+1]:=Menu.User[i];
		FOR j:=1 TO 11 DO
			Menu.Description[i+1,j]:=Menu.Description[i,j];
	END;
	Inc(Menu.NumOpts);
	Menu.OptionText[Place]:=OptionText;
	Menu.ActionType[Place]:=ActionType;
	Menu.ActionString[Place]:=ActionString;
	Menu.User[Place]:=User;
	FOR j:=1 TO 11 DO
		Menu.Description[Place,j]:='';
	Seek(DMSFile,FilePos(DMSFile)-1);
	Write(DMSFile,Menu);
END;

{***** AddOption *****}
PROCEDURE AddOption;
CONST	StringToken		= 0;
		LabelToken		= 1;
		UnknownToken	= 2;
		EndOfFileToken = 3;
CONST
	Nothing	= 0;
	Oldmenu	= 1;
	Newmenu	= 2;
	Start		= 3;
	Exit		= 4;
	Cancel	= 5;
VAR
	StringChoice : String;
	Text	: String;
	Event	: Integer;
BEGIN
	{ Remember to make a check if the menus MaxOpts limit is passed }
	Event:=AddOptionEventSelect;
	IF Event=Nothing THEN BEGIN
		Text:=AddOptionTextSelect;
		DoAdd(CurrentOption,Text,LabelToken,'NONE','');
	END;
	IF Event=Oldmenu THEN BEGIN
		StringChoice:=AddOptionOldLabel;
		Text:=AddOptionTextSelect;
		DoAdd(CurrentOption,Text,LabelToken,StringChoice,'');
	END;
	IF Event=Newmenu THEN BEGIN
		StringChoice:=AddOptionNewLabel;
		AddLabel(StringChoice);
		Text:=AddOptionTextSelect;
		DoAdd(CurrentOption,Text,LabelToken,StringChoice,'');
	END;
	IF Event=Start THEN BEGIN
		StringChoice:=AddOptionFileSelect;
		Text:=AddOptionTextSelect;
		DoAdd(CurrentOption,Text,StringToken,StringChoice,'');
	END;
	IF Event=Exit THEN BEGIN
		Text:=AddOptionTextSelect;
		DoAdd(CurrentOption,Text,LabelToken,'EXIT','');
	END;
	ReadDMS(MenuLabel);
	DrawOptions(CurrentOption);
	DrawDescription(CurrentOption);
END;
{***** DelOptionEventSelect *****}
FUNCTION DelOptionEventSelect:Integer;
VAR
	Key : Byte;
BEGIN
	DrawDelEventSelect;
	REPEAT
		Key:=GetKey AND $ff;
	UNTIL (Key>=59) AND (Key<=63) OR (Key=27);
	CASE Key OF
		59	: DelOptionEventSelect:=0;
{		60	: DelOptionEventSelect:=1;
		61	: DelOptionEventSelect:=2;
}		27	: DelOptionEventSelect:=3;
	END;
END;

{***** DoDel *****}
PROCEDURE DoDel(Place:Integer);
VAR
	i,
	j	: Integer;
BEGIN
	ReadDMS(MenuLabel);
	FOR i:=Place TO Menu.NumOpts-1 DO BEGIN
		Menu.OptionText[i]:=Menu.OptionText[i+1];
		Menu.ActionType[i]:=Menu.ActionType[i+1];
		Menu.ActionString[i]:=Menu.ActionString[i+1];
		Menu.User[i]:=Menu.User[i+1];
		FOR j:=1 TO 11 DO
			Menu.Description[i,j]:=Menu.Description[i+1,j];
	END;
	Menu.OptionText[Menu.NumOpts]:='';
	Menu.ActionType[Menu.NumOpts]:=0;
	Menu.ActionString[Menu.NumOpts]:='';
	Menu.User[Menu.NumOpts]:='';
	FOR j:=1 TO 11 DO
		Menu.Description[Menu.NumOpts,j]:='';
	Dec(Menu.NumOpts);
	Seek(DMSFile,FilePos(DMSFile)-1);
	Write(DMSFile,Menu);
END;

{***** DelOption *****}
PROCEDURE DelOption;
CONST
	Option	= 0;
	TheFile  = 1;
	ThePath	= 2;
	Cancel	= 3;
VAR
	Event:Integer;
BEGIN
	Event:=DelOptionEventSelect;
	IF Event=Option THEN
		DoDel(CurrentOption);
	ReadDMS(MenuLabel);
	DrawOptions(CurrentOption);
	DrawDescription(CurrentOption);
END;

