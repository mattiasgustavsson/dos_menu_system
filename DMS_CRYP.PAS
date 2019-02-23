VAR
	Pos:Word;
{***** FORMLER *****}
CONST Formler = 2;
FUNCTION Formel1(val1,val2,val3,val4,val5:Byte):Byte;
BEGIN
	Formel1:=Byte(val1*val1+val2*3+val3*Pos+val4*4+val5*Val5*val5);
END;
FUNCTION Formel2(val1,val2,val3,val4,val5:Byte):Byte;
BEGIN
	Formel2:=Byte(val1+val2+val3+val4+Val5+Pos);
END;

{***** EnCrypt *****}
FUNCTION EnCrypt(b:Byte; code:String):Byte;
BEGIN
	CASE ((Ord(code[1]) MOD Formler)+1) OF
		 1 : EnCrypt:=Byte(b+Formel1(Ord(code[2]),Ord(code[3]),Ord(code[4]),Ord(code[5]),Ord(code[6])));
		 2 : EnCrypt:=Byte(b+Formel2(Ord(code[2]),Ord(code[3]),Ord(code[4]),Ord(code[5]),Ord(code[6])));
	END;
END;

{***** EnCryptString *****}
FUNCTION EnCryptString(s,code:String):String;
VAR
	i:Integer;
	Buf : String;
BEGIN
	code:=Copy(code+'      ',1,6);
	Buf:='';
	Pos:=0;
	FOR i:=1 TO Length(s) DO BEGIN
		Buf:=Buf+Chr(EnCrypt(Ord(s[Pos]),code));
		Inc(Pos);
	END;
	EnCryptString:=Buf;
END;