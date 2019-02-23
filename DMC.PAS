{****************************************************************************

						Dos Menu System Compiler v 1.0

 ****************************************************************************}
{$M 65521,0,400000}
{$N-}{$E+}
USES
	DosApp;
CONST
	Version  = 1.0;
	MaxOpts	= 50;

{***** Token Types *****}
TYPE	TokenType	= ARRAY [0..1000] OF Char;
CONST	StringToken		= 0;
		LabelToken		= 1;
		UnknownToken	= 2;
		EndOfFileToken = 3;

{***** Menu Type *****}
TYPE
	MenuType			= RECORD
								LabelName	: String;
								NumOpts 		: Integer;
								OptionText	: ARRAY [1..MaxOpts] OF String[56];
                                                                								User			: ARRAY [1..MaxOpts] OF String[8];
								ActionString: ARRAY [1..MaxOpts] OF String[128];
								ActionType	: ARRAY [1..MaxOpts] OF Integer;
								Description	: ARRAY [1..MaxOpts,1..11] OF String[56];
						  END;

{***** Global Variables *****}
VAR
	MenuFile 		: String;
	CompiledFile	: String;
	DMSFile 			: File OF Byte;
	DMCFile 			: File OF MenuType;
	DMSErrorMsg : String;

{***** Make Ver Str *****}
FUNCTION MakeVerStr(a:Real):String;
VAR
	s	:	String;
BEGIN
	Str(a:2:1,s);
	MakeVerStr:=s;
END;

{***** Write Help *****}
PROCEDURE WriteHelp;
BEGIN
	WriteLn;
	WriteLn('Dos Menu System Compiler v '+MakeVerStr(Version)+'  -  By Mattias Gustavsson ');
	WriteLn;
	WriteLn('  SYNTAX: ');
	WriteLn('     dmc file.dms file.dmc');
	WriteLn;
	Halt(0);
END;

{***** UStr *****}
FUNCTION UStr(s:String):String;
VAR
	i	:	Integer;
BEGIN
	FOR i:=1 TO Length(s) DO
		s[i]:=UpCase(s[i]);
	UStr:=s;
END;

{***** DMS Error *****}
PROCEDURE DMSError(FileName:String);
BEGIN
	WriteLn('Error in '+FileName);
	WriteLn(DMSErrorMsg);
	Halt(0);
END;

{***** Open DMS *****}
PROCEDURE OpenDMS(FileName:String);
BEGIN
	DMSErrorMsg:='Couldn''t open file';
	Assign(DMSFile,FileName);
	Reset(DMSFile);
	IF IOResult<>0 THEN BEGIN
		DMSError(FileName);
		Exit;
	END;
	DMSErrorMsg:='';
END;

{***** Create DMC *****}
PROCEDURE CreateDMC(FileName:String);
BEGIN
	DMSErrorMsg:='Couldn''t create file';
	Assign(DMCFile,FileName);
	Rewrite(DMCFile);
	IF IOResult<>0 THEN BEGIN
		DMSError(FileName);
		Exit;
	END;
	DMSErrorMsg:='';
END;

{***** Read Token *****}
PROCEDURE ReadToken(VAR Token:TokenType; VAR TokType:Integer);
VAR
	Char:Byte;

	{*** Read Char ***}
	PROCEDURE ReadChar(VAR Char:Byte);
	BEGIN
		IF EOF(DMSFile) THEN BEGIN
			Token[0]:=Chr(0);
			TokType:=EndOfFileToken;
			Exit;
		END;
		Read(DMSFile,Char);
		IF IOResult<>0 THEN BEGIN
			Token[0]:=Chr(0);
			TokType:=UnknownToken;
			DMSError(MenuFile);
			Halt(0);
		END;
	END;
BEGIN
	TokType:=UnknownToken;
	ReadChar(Char);
	IF TokType=EndOfFileToken THEN Exit;
	{*** Bypass Comments ***}
	IF Char=Ord('{') THEN BEGIN
		REPEAT
			ReadChar(Char);
			IF TokType=EndOfFileToken THEN Exit;
		UNTIL Char=Ord('}');
		ReadToken(Token,TokType);
	END ELSE
	{*** Bypass Whitespace ***}
	IF (Char<33) OR (Char>122) THEN
		ReadToken(Token,TokType)
	ELSE
	{*** Read String ***}
	IF Char=Ord('"') THEN BEGIN
		TokType:=StringToken;
		Token[0]:=Chr(0);
		ReadChar(Char);
		IF TokType=EndOfFileToken THEN Exit;
		WHILE Char<>Ord('"') DO BEGIN
			Inc(Token[0]);
			Token[Ord(Token[0])]:=Chr(Char);
			ReadChar(Char);
			IF TokType=EndOfFileToken THEN Exit;
		END;
	END ELSE
	{*** Read Label ***}
	IF Char=Ord('[') THEN BEGIN
		TokType:=LabelToken;
		Token[0]:=Chr(0);
		ReadChar(Char);
		IF TokType=EndOfFileToken THEN Exit;
		WHILE Char<>Ord(']') DO BEGIN
			IF (Char>32) AND (Char<123) THEN BEGIN
				Inc(Token[0]);
				Token[Ord(Token[0])]:=Chr(Char);
			END;
			ReadChar(Char);
			IF TokType=EndOfFileToken THEN Exit;
		END;
	END ELSE
	{*** Unknown Token ***}
	BEGIN
		Token[0]:=Chr(0);
		TokType:=UnknownToken;
	END;
END;

{*** TokenStr ***}
FUNCTION TokenStr(VAR Token:TokenType; Index,Count:Integer):String;
VAR
	i		: Integer;
	Result: String;
BEGIN
	IF Ord(Token[0])<Index+Count THEN
		Count:=Ord(Token[0])-(Index-1);
	Result:='';
	FOR i:=Index TO Index+Count-1 DO
		Result:=Result+Token[i];
	TokenStr:=Result;
END;

{*** TokenCmp ***}
FUNCTION TokenCmp(VAR Token:TokenType; CmpString:String):Boolean;
VAR
	i		: Integer;
	Result: Boolean;
BEGIN
	Result:=True;
	IF Ord(Token[0])=Length(CmpString) THEN BEGIN
		FOR i:=1 TO Length(CmpString) DO
			IF UpCase(Token[i])<>UpCase(CmpString[i]) THEN BEGIN
				Result:=False;
				Break;
			END;
	END ELSE
		Result:=False;
	TokenCmp:=Result;
END;

{***** Find Label *****}
PROCEDURE FindLabel(LabelString:String);
VAR
	Token	  : TokenType;
	TokType : Integer;
BEGIN
	DMSErrorMsg:='Couldn''t find label: '+LabelString+'!';
	Reset(DMSFile);
	REPEAT
		ReadToken(Token,TokType);
		IF TokType=EndOfFileToken THEN
			DMSError(MenuFile);
	UNTIL (TokType=LabelToken) AND (TokenCmp(Token,LabelString+'!'));
	DMSErrorMsg:='';
END;

{***** Get Description *****}
PROCEDURE GetDescription(VAR Menu:MenuType; Option:Integer; VAR Token:TokenType);
VAR
	row,
	i	: Integer;
BEGIN
	i:=1;row:=0;
	WHILE (i<=Ord(Token[0])) AND (row<11) DO BEGIN
		Inc(row);
		Menu.Description[Option,row]:='';
		WHILE (Token[i]<>Chr(13)) AND (i<=Ord(Token[0])) AND
				(Length(Menu.Description[Option,row])<=56) DO
		BEGIN
			IF Token[i]>=Chr(32) THEN
				Menu.Description[Option,row]:=Menu.Description[Option,row]+Token[i];
			Inc(i);
		END;
		IF Token[i]=Chr(13) THEN
			Inc(i);
	END;

END;

{***** Read DMS *****}
PROCEDURE ReadDMS(VAR Menu:MenuType; LabelString:String);
VAR
	i,j		  : Integer;
	DescriptionLabel : ARRAY [1..MaxOpts] OF String[30];
	Token	  : TokenType;
	TokType : Integer;
BEGIN
	Menu.LabelName:=LabelString;
	Menu.NumOpts:=0;
	FindLabel(LabelString);
	{*** Load Options ***}
	ReadToken(Token,TokType);
	WHILE TokType=StringToken DO BEGIN
		Inc(Menu.NumOpts);
		{*** Option Text ***}
		Menu.OptionText[Menu.NumOpts]:=TokenStr(Token,1,60);
		{*** Description ***}
		DMSErrorMsg:='Couldn''t read description token';
		ReadToken(Token,TokType);
		IF TokType=StringToken THEN BEGIN
			GetDescription(Menu,Menu.NumOpts,Token);
			DescriptionLabel[Menu.NumOpts]:='None';
		END ELSE BEGIN
			DescriptionLabel[Menu.NumOpts]:=TokenStr(Token,1,128);
			IF UStr(DescriptionLabel[Menu.NumOpts])='NONE' THEN
				FOR i:=1 TO 11 DO
					Menu.Description[Menu.NumOpts,i]:='';
		END;
		DMSErrorMsg:='';
		{*** Action ***}
		DMSErrorMsg:='Couldn''t read action token';
		ReadToken(Token,TokType);
		Menu.ActionString[Menu.NumOpts]:=TokenStr(Token,1,128);
		Menu.ActionType[Menu.NumOpts]:=TokType;
		ReadToken(Token,TokType);
		DMSErrorMsg:='';
	END;
	{*** Load Descriptions ***}
	FOR i:=1 TO Menu.NumOpts DO
		IF UStr(DescriptionLabel[i])<>'NONE' THEN BEGIN
			FOR j:=1 TO 11 DO
				Menu.Description[i,j]:='';
			FindLabel(DescriptionLabel[i]);
			DMSErrorMsg:='Couldn''t read description string';
			ReadToken(Token,TokType);
			GetDescription(Menu,i,Token);
			DMSErrorMsg:='';
		END;
END;

{***** Clear Menu *****}
PROCEDURE ClearMenu(VAR Menu:MenuType);
VAR
	i,j,k : Integer;
BEGIN
	WITH Menu DO BEGIN
		FOR i:=0 TO 255 DO
			LabelName[i]:=Chr(0);
		NumOpts:=0;
		FOR i:=1 TO MaxOpts DO BEGIN
			FOR j:=0 TO 60 DO
				OptionText[i,j]:=Chr(0);
			FOR j:=0 TO 128 DO
				ActionString[i,j]:=Chr(0);
			ActionType[i]:=0;
			FOR j:=1 TO 11 DO
				FOR k:=0 TO 56 DO
					Description[i,j,k]:=Chr(0);
		END;
	END;
END;

{***** Write DMC *****}
PROCEDURE WriteDMC(VAR Menu:MenuType);
BEGIN
	DMSErrorMsg:='Couldn''t write '+Menu.LabelName+'!';
	Write(DMCFile,Menu);
	IF IOResult<>0 THEN
		DMSError(MenuFile);
END;

{***** Compile *****}
PROCEDURE Compile(LabelString:String);
VAR
	Menu	: MenuType;
	i		: Integer;
BEGIN
	WriteLn('Compiling: ',LabelString);
	ClearMenu(Menu);
	ReadDMS(Menu,LabelString);
	WriteDMC(Menu);
	FOR i:=1 TO	Menu.NumOpts DO
		IF (Menu.ActionType[i]=LabelToken)
		AND (UStr(Menu.ActionString[i])<>'NONE')
		AND (UStr(Menu.ActionString[i])<>'EXIT') THEN
			Compile(Menu.ActionString[i]);
END;
BEGIN
	IF SwitchSet('/?') OR (ParamTexts<>3) THEN
		WriteHelp;
	MenuFile:=ParamText(1);
	CompiledFile:=ParamText(2);
	OpenDMS(MenuFile);
	CreateDMC(CompiledFile);
	Compile('Main');
	Close(DMCFile);
	Close(DMSFile);
END.