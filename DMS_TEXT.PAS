{****************************************************************************

					Dos Menu System - Text Output Routines

 ****************************************************************************}

{***** Color Definitions *****}
VAR
	BarCol0,
	BarCol1,
	BarCol2,
	MenuCol0,
	MenuCol1,
	MenuCol2,
	TitleCol0,
	TitleCol1,
	TitleCol2,
	DescCol0,
	DescCol1,
	DescCol2,
	CursCol0,
	CursCol1	: Byte;

{***** Window Definitions *****}
VAR
	BarChar1,
	BarChar2,
	BarChar3,
	BarChar4,
	TitleTopLeft,
	TitleTop,
	TitleTopRight,
	TitleLeft,
	TitleRight,
	TitleBottomLeft,
	TitleBottom,
	TitleBottomRight,
	TitleSpace,
	MenuTopLeft,
	MenuTop,
	MenuTopRight,
	MenuLeft,
	MenuRight,
	MenuLeftSplit,
	MenuSplit,
	MenuRightSplit,
	MenuBottomLeft,
	MenuBottom,
	MenuBottomRight,
	MenuSpace,
	DescTopLeft,
	DescTop,
	DescTopRight,
	DescLeft,
	DescRight,
	DescLeftSplit,
	DescSplit,
	DescRightSplit,
	DescBottomLeft,
	DescBottom,
	DescBottomRight,
	DescSpace : Char;

{***** Get Key *****}
FUNCTION GetKey:Word;Assembler;
ASM
	{*** KeyPressed ***}
	mov	ah,1
	int	16h
	jz		@nokey
	{**** Read Key ***}
	mov	ah,8
	int	21h
	mov	ah,0
	cmp	al,0
	jne	@end
	{**** Read Scancode ***}
	mov	ah,8
	int	21h
	mov	ah,0ffh
	jmp	@end
@nokey:
	mov	ax,0
@end:
END;
FUNCTION GetAscii:Byte;Assembler;
ASM
		mov	ah,0
		int	16h
END;

{***** DrawBar *****}
PROCEDURE DrawBar;
VAR
	 x	:	Integer;
BEGIN
	FOR x:=1 TO 80 DO BEGIN
		PrintXYA(x, 1,BarChar1,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x, 2,BarChar1,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x, 3,BarChar2,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x, 4,BarChar2,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x, 5,BarChar3,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x, 6,BarChar3,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x, 7,BarChar4,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x, 8,BarChar4,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x, 9,BarChar1,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,10,BarChar1,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,11,BarChar2,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,12,BarChar2,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,13,BarChar3,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,14,BarChar3,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,15,BarChar4,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,16,BarChar4,BarCol2,BarCol1,BlinkOff);

		PrintXYA(x,34,BarChar4,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,35,BarChar4,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,36,BarChar3,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,37,BarChar3,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,38,BarChar2,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,39,BarChar2,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,40,BarChar1,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,41,BarChar1,BarCol2,BarCol1,BlinkOff);
		PrintXYA(x,42,BarChar4,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x,43,BarChar4,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x,44,BarChar3,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x,45,BarChar3,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x,46,BarChar2,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x,47,BarChar2,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x,48,BarChar1,BarCol1,BarCol0,BlinkOff);
		PrintXYA(x,49,BarChar1,BarCol1,BarCol0,BlinkOff);
	END;
	CentreA(50,'Cursor keys to highlight an option. ENTER/SPACE to select. Ctrl+X to exit.',LightGray,Black,BlinkOff);
END;

{***** DrawTitle *****}
PROCEDURE DrawTitle;
VAR
	 x,
	 y	:	Integer;
BEGIN
	FOR y:=2 TO 8 DO
		CASE y OF
		 2	:	BEGIN
					PrintXYA(12,2,TitleTopLeft,TitleCol1,TitleCol0,BlinkOff);
					FOR x:=13 TO 68 DO
						PrintXYA(x,2,TitleTop,TitleCol1,TitleCol0,BlinkOff);
					PrintXYA(69,2,TitleTopRight,TitleCol1,TitleCol0,BlinkOff);
				END;
		 8	:	BEGIN
					PrintXYA(12,8,TitleBottomLeft,TitleCol1,TitleCol0,BlinkOff);
					FOR x:=13 TO 68 DO
						PrintXYA(x,8,TitleBottom,TitleCol1,TitleCol0,BlinkOff);
					PrintXYA(69,8,TitleBottomRight,TitleCol1,TitleCol0,BlinkOff);
				END;
		ELSE 	BEGIN
					PrintXYA(12,y,TitleLeft,TitleCol1,TitleCol0,BlinkOff);
					FOR x:=13 TO 68 DO
						PrintXYA(x,y,TitleSpace,TitleCol2,TitleCol0,BlinkOff);
					PrintXYA(69,y,TitleLeft,TitleCol1,TitleCol0,BlinkOff);
				END;
		END;
	Centre(4,'Dos Menu System v '+MakeVerStr(Version));
	Centre(6,'By Mattias Gustavsson '+MakeStr(Year));
END;

{***** DrawMenuWindow *****}
PROCEDURE DrawMenuWindow;
VAR
	 x,
	 y	:	Integer;
BEGIN
	FOR y:=11 TO 30 DO
		CASE y OF
			11 :	BEGIN
						PrintXYA(9,11,MenuTopLeft,MenuCol1,MenuCol0,BlinkOff);
						FOR x:=10 TO 71 DO
							PrintXYA(x,11,MenuTop,MenuCol1,MenuCol0,BlinkOff);
						PrintXYA(72,11,MenuTopRight,MenuCol1,MenuCol0,BlinkOff);
					END;
			13 :	BEGIN
						PrintXYA(9,13,MenuLeftSplit,MenuCol1,MenuCol0,BlinkOff);
						FOR x:=10 TO 71 DO
							PrintXYA(x,13,MenuSplit,MenuCol1,MenuCol0,BlinkOff);
						PrintXYA(72,13,MenuRightSplit,MenuCol1,MenuCol0,BlinkOff);
					END;
			30 :	BEGIN
						PrintXYA(9,30,MenuBottomLeft,MenuCol1,MenuCol0,BlinkOff);
						FOR x:=10 TO 71 DO
							PrintXYA(x,30,MenuBottom,MenuCol1,MenuCol0,BlinkOff);
						PrintXYA(72,30,MenuBottomRight,MenuCol1,MenuCol0,BlinkOff);
					END;
		ELSE BEGIN
				PrintXYA(9,y,MenuLeft,MenuCol1,MenuCol0,BlinkOff);
				FOR x:=10 TO 71 DO
					PrintXYA(x,y,MenuSpace,MenuCol2,MenuCol0,BlinkOff);
				PrintXYA(72,y,MenuRight,MenuCol1,MenuCol0,BlinkOff);
			END;
		END;
	{*** Window Title ***}
	Centre(12,'Options');
	{*** Cursor ***}
	PrintXYA(11,21,'                                                            ',CursCol1,CursCol0,BlinkOff);
END;

{***** ClearMenuWindow *****}
PROCEDURE ClearMenuWindow;
VAR
	 y	:	Integer;
BEGIN
	FOR y:=14 TO 29 DO
		PrintXY(10,y,'                                                              ');
END;

{***** DrawDescriptionWindow *****}
PROCEDURE DrawDescriptionWindow;
VAR
	 x,
	 y	:	Integer;
BEGIN
	FOR y:=33 TO 47 DO
		CASE y OF
			33 :	BEGIN
						PrintXYA(11,33,DescTopLeft,DescCol1,DescCol0,BlinkOff);
						FOR x:=12 TO 69 DO
							PrintXYA(x,33,DescTop,DescCol1,DescCol0,BlinkOff);
						PrintXYA(70,33,DescTopRight,DescCol1,DescCol0,BlinkOff);
					END;
			35 :	BEGIN
						PrintXYA(11,35,DescLeftSplit,DescCol1,DescCol0,BlinkOff);
						FOR x:=12 TO 69 DO
							PrintXYA(x,35,DescSplit,DescCol1,DescCol0,BlinkOff);
						PrintXYA(70,35,DescRightSplit,DescCol1,DescCol0,BlinkOff);
					END;
			47 :	BEGIN
						PrintXYA(11,47,DescBottomLeft,DescCol1,DescCol0,BlinkOff);
						FOR x:=12 TO 69 DO
							PrintXYA(x,47,DescBottom,DescCol1,DescCol0,BlinkOff);
						PrintXYA(70,47,DescBottomRight,DescCol1,DescCol0,BlinkOff);
					END;
		ELSE BEGIN
				PrintXYA(11,y,DescLeft,DescCol1,DescCol0,BlinkOff);
				FOR x:=12 TO 69 DO
					PrintXYA(x,y,DescSpace,DescCol2,DescCol0,BlinkOff);
				PrintXYA(70,y,DescRight,DescCol1,DescCol0,BlinkOff);
			END;
		END;
END;

{***** ClearDescriptionWindow *****}
PROCEDURE ClearDescriptionWindow;
VAR
	 y	:	Integer;
BEGIN
  PrintXY(12,34,'                                                          ');
	FOR y:=36 TO 46 DO
	  PrintXY(12, y,'                                                          ');
END;

{***** Draw Options *****}
PROCEDURE DrawOptions(Option:Integer);
VAR
	i : Integer;
BEGIN
	ClearMenuWindow;
	Centre(34,Menu.OptionText[Option]);
	FOR i:=Option-7 TO Option+8 DO
		IF (i>=1) AND (i<=Menu.NumOpts) THEN
			Centre(21+i-Option,Menu.OptionText[i]);
END;

{***** Draw Description *****}
PROCEDURE DrawDescription(Option:Integer);
VAR
	i : Integer;
BEGIN
	ClearDescriptionWindow;
	Centre(34,Menu.OptionText[Option]);
	FOR i:=1 TO 11 DO
		Centre(35+i,Menu.Description[Option,i]);
END;

{***** Draw Loading *****}
PROCEDURE DrawLoading;
BEGIN
	ClearMenuWindow;
	ClearDescriptionWindow;
	Centre(41,'Loading...');
END;

{***** DrawScreen *****}
PROCEDURE DrawScreen;
BEGIN
	TextMode(Mode80x50);
	SetCursor(80,51);
	DrawBar;
	DrawTitle;
	DrawMenuWindow;
	DrawDescriptionWindow;
END;

{***** Draw Event Select *****}
PROCEDURE DrawEventSelect;
BEGIN
	ClearDescriptionWindow;
	Centre(34,'Add option - What should it do?');
	Centre(38,' F1 - Do nothing                              ');
	Centre(39,' F2 - Go to a previously defined menu label   ');
	Centre(40,' F3 - Go to a new menu label                  ');
	Centre(41,' F4 - Execute a file                          ');
	Centre(42,' F5 - Exit from the menu                      ');
	Centre(43,'ESC - Oops! I don''t want to add an option now');
END;

{***** Draw Text Select *****}
PROCEDURE DrawTextSelect;
BEGIN
	ClearDescriptionWindow;
	Centre(34,'Add option - What should it be called?');
	SetCursor(13,41);
	Centre(39,'Enter option text');
END;

{***** Draw Text Select Char *****}
PROCEDURE DrawTextSelectChar(Pos:Integer; Key:String);
BEGIN
	SetCursor(13+Pos,41);
	PrintXY(12+Pos,41,Key);
END;

{***** Draw Text Select Curs *****}
PROCEDURE DrawTextSelectCurs(Pos:Integer);
BEGIN
	SetCursor(13+Pos,41);
END;

{***** Draw Text Select Clear *****}
PROCEDURE DrawTextSelectClear;
BEGIN
	SetCursor(80,51);
END;

{***** Draw Select Oldlabel *****}
PROCEDURE DrawSelectOldlabel;
BEGIN
	ClearDescriptionWindow;
	Centre(34,'Add option - What submenu should be displayed?');
	Centre(40,'Choose one from the menu above');
END;

{***** Draw Old label Options *****}
PROCEDURE DrawOldlabelOptions(VAR OptionText:LabelListType; Option,NumOpts:Integer);
VAR
	i,j : Integer;
BEGIN
	ClearMenuWindow;
	FOR i:=Option-7 TO Option+8 DO
		IF (i>=1) AND (i<=NumOpts) THEN
			Centre(21+i-Option,OptionText[i]);
END;

{***** Draw New label Select *****}
PROCEDURE DrawNewlabelSelect;
BEGIN
	ClearDescriptionWindow;
	Centre(34,'New Label - What should it be called?');
	SetCursor(13,41);
	Centre(39,'Enter label text');
END;

{***** Draw New label Select Char *****}
PROCEDURE DrawNewlabelSelectChar(Pos:Integer; Key:String);
BEGIN
	SetCursor(13+Pos,41);
	PrintXY(12+Pos,41,Key);
END;

{***** Draw New label Select Curs *****}
PROCEDURE DrawNewlabelSelectCurs(Pos:Integer);
BEGIN
	SetCursor(13+Pos,41);
END;

{***** Draw Newlabel Select Clear *****}
PROCEDURE DrawNewlabelSelectClear;
BEGIN
	SetCursor(80,51);
END;

{***** Draw New label Select Again *****}
PROCEDURE DrawNewlabelSelectAgain;
BEGIN
	ClearDescriptionWindow;
	Centre(34,'New Label - What should it be called?');
	SetCursor(13,41);
	Centre(39,'Enter another label text');
	Centre(43,'That label already exists!');
END;

{***** Draw File Select *****}
PROCEDURE DrawFileSelect;
BEGIN
	ClearDescriptionWindow;
	Centre(34,'Add option - What file should be loaded?');
	Centre(40,'Choose one from the menu above');
END;

{***** Draw Drive Select *****}
PROCEDURE DrawDriveSelect;
BEGIN
	ClearDescriptionWindow;
	Centre(34,'Add option - What directory?');
	Centre(40,'Enter drive letter');
END;

{***** Draw Directory Options *****}
PROCEDURE DrawDirectoryOptions(VAR OptionText:DirectoryType; Option,NumOpts:Integer);
VAR
	i,j : Integer;
BEGIN
	ClearMenuWindow;
	FOR i:=Option-7 TO Option+8 DO
		IF (i>=1) AND (i<=NumOpts) THEN
			PrintXY(35,21+i-Option,OptionText[i].Name);
END;

{***** Draw Del Event Select *****}
PROCEDURE DrawDelEventSelect;
BEGIN
	ClearDescriptionWindow;
	Centre(34,'Delete option - or delete path?');
	Centre(38,' F1 - Delete menu option only                    ');
{	Centre(39,' F2 - Delete the file / menulabel                ');
	Centre(40,' F3 - Delete the directory                       ');
}	Centre(41,'ESC - Oops! I don''t want to delete an option now');
END;

{***** Draw Password Query *****}
PROCEDURE DrawPasswordQuery;
BEGIN
	ClearDescriptionWindow;
	Centre(34,'This option is protected by a password');
	Centre(38,'Enter Username: ________');
	Centre(40,'Enter Password: ______  ');
END;

{***** Draw Login User Char *****}
PROCEDURE DrawLoginUserChar(Pos:Integer; Key:String);
BEGIN
	SetCursor(45+Pos,38);
	PrintXY(44+Pos,38,Key);
END;

{***** Draw Login User Curs *****}
PROCEDURE DrawLoginUserCurs(Pos:Integer);
BEGIN
	SetCursor(45+Pos,38);
END;

{***** Draw Login User Clear *****}
PROCEDURE DrawLoginUserClear;
BEGIN
	SetCursor(80,51);
END;

{***** Draw Login Pass Char *****}
PROCEDURE DrawLoginPassChar(Pos:Integer; Key:String);
BEGIN
	SetCursor(45+Pos,40);
	PrintXY(44+Pos,40,Key);
END;

{***** Draw Login Pass Curs *****}
PROCEDURE DrawLoginPassCurs(Pos:Integer);
BEGIN
	SetCursor(45+Pos,40);
END;

{***** Draw Login User Clear *****}
PROCEDURE DrawLoginPassClear;
BEGIN
	SetCursor(80,51);
END;
