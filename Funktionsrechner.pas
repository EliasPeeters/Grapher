unit Funktionsrechner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, StrUtils, Math, Vcl.StdCtrls,
  Vcl.ExtCtrls;

function BerechneY(X: Extended; Funktion: string): Extended;


implementation




function UnerlaubteZeichen(Funktion: String): boolean;
var
AktuellesZeichen: String;
I: Integer;
Nichts: Extended;
begin
  for I := 1 to Funktion.Length do
  begin
    AktuellesZeichen:= Copy(Funktion, I, 1);
    if AktuellesZeichen = '1' then Nichts:= 1
    else if AktuellesZeichen = '2' then Nichts:= 1
    else if AktuellesZeichen = '3' then Nichts:= 1
     else if AktuellesZeichen = '4' then Nichts:= 1
     else if AktuellesZeichen = '5' then Nichts:= 1
     else if AktuellesZeichen = '6' then Nichts:= 1
     else if AktuellesZeichen = '7' then Nichts:= 1
     else if AktuellesZeichen = '8' then Nichts:= 1
     else if AktuellesZeichen = '9' then Nichts:= 1
     else if AktuellesZeichen = '0' then Nichts:= 1
     else if AktuellesZeichen = 'x' then Nichts:= 1
     else if AktuellesZeichen = 's' then Nichts:= 1
     else if AktuellesZeichen = 'c' then Nichts:= 1
     else if AktuellesZeichen = 't' then Nichts:= 1
     else if AktuellesZeichen = '^' then Nichts:= 1
     else if AktuellesZeichen = '+' then Nichts:= 1
     else if AktuellesZeichen = '-' then Nichts:= 1
     else if AktuellesZeichen = '*' then Nichts:= 1
     else if AktuellesZeichen = '/' then Nichts:= 1
     else if AktuellesZeichen = '(' then Nichts:= 1
     else if AktuellesZeichen = ')' then Nichts:= 1
     else
     begin
      ShowMessage('Ich habe dich durchschaut');
      Abort;
     end;
  end;
  result:= true;
end;

function ReverseString(const AValue: string): string;
var
  Len: Integer;
  Src: Integer;
begin
  Len := Length(AValue);
  SetLength(Result, Len);
  for Src := 1 to Len do
    Result[Src] := AValue[Len - Src + 1];
end;

function XAnzahlInEinemString(Str: String): Extended;
var
AktuelleStelle, I, AktuelleStellePos: Integer;
Anzahl: Extended;
begin
  AktuelleStelle:= 0;
  for I := 0 to Str.Length do
  begin
    AktuelleStellePos:= PosEx('x', Str, AktuelleStelle);
    if 0 = PosEx('x', Str, AktuelleStelle) then
    begin
      result:= Anzahl;
    end;
    Anzahl:= Anzahl+1;
    AktuelleStelle:= AktuelleStellePos;
  end;

end;

function LinkerOperant(Funktion: String; OperatorStelle: Integer): String;
begin

end;



function XInDerFunktionErsetzen(Funktion: String; Y: Extended):String;
var
  AktuelleStelle:               Integer;
  I :                            Integer;
  AktuelleStellePos:            Integer;
  VorherigeStelle:              String;
  ReplaceStringwithMultiplier:  String;
  StringSchnitt1:               String;
  StringSchnitt2:               String;
begin
  AktuelleStelle:= 1;
  AktuelleStellePos:= 0;
  VorherigeStelle:= '';
  StringSchnitt1:= '';
  StringSchnitt2:= '';
  for I := 0 to Funktion.Length do
  begin
    if  0 <> PosEx('x', Funktion, AktuelleStelle) then
    begin
      AktuelleStellePos:= PosEx('x', Funktion, AktuelleStelle);
      VorherigeStelle:= Copy(Funktion, AktuelleStellePos-1, 1);
      if
      (VorherigeStelle = '0') or
      (VorherigeStelle = '1') or
      (VorherigeStelle = '2') or
      (VorherigeStelle = '3') or
      (VorherigeStelle = '4') or
      (VorherigeStelle = '5') or
      (VorherigeStelle = '6') or
      (VorherigeStelle = '7') or
      (VorherigeStelle = '8') or
      (VorherigeStelle = '9')
      then
      begin
        ReplaceStringwithMultiplier:= '*' + FloatToStrF(Y, ffFixed, 8, 10);
        StringSchnitt1:= Copy(Funktion, 1 , AktuelleStellePos-1);
        StringSchnitt2:= Copy(Funktion, AktuelleStellePos+1 , Funktion.Length);
        Funktion:= StringSchnitt1 + ReplaceStringwithMultiplier + StringSchnitt2;
      end
      else
      begin
        StringSchnitt1:= Copy(Funktion, 1 , AktuelleStellePos-1);
        StringSchnitt2:= Copy(Funktion, AktuelleStellePos+1 , Funktion.Length);
        Funktion:= StringSchnitt1 + FloatToStrF(Y, ffFixed, 8, 10) + StringSchnitt2;
      end;
      AktuelleStelle:= AktuelleStellePos;
      VorherigeStelle:= '';
    end;
  end;
  result:= Funktion;
end;

function StrichrechnungFinden(Funktion: String; Y: Extended): String;
var
NaechstesPlusZeichen:              Integer;
NaechstesMinusZeichen:            Integer;
LetztesPlusZeichen:                Integer;
FaktorEins:                       String;
FaktorZwei:                       String;
AktuelleStelle:                   Integer;
I, II, III, IV:                   Integer;
LetzterVerwendeterOperator:       Integer;
UebernaechsterOperator:           Array [0..3] of Integer;
RichtigerUebernaechsterOperator:  Integer;
Ergebnis:                         Extended;
OriginalFunktionEins:             String;
OriginalFunktionZwei:             String;
LetzterOperator:                  Array[0..3] of Integer;
RichtigerLetzterOperator:         Integer;
FunktionBisAktuellerOperator:     String;
FunktionBisAktuellerOperatorReverse: String;
NegativerFaktor:                  Boolean;
Zwischenergebnis:                 String;

begin
  LetzterVerwendeterOperator:= 0;
  AktuelleStelle:= 1;
  RichtigerUebernaechsterOperator:= 1000;
  LetztesPlusZeichen:= 1;
  RichtigerLetzterOperator:= 0;
  NaechstesPlusZeichen:= 0;
  NaechstesMinusZeichen:= 0;
  FaktorEins:= '';
  FaktorZwei:= '';
  I:= 0;
  II:= 0;
  III:= 0;
  IV:= 0;
  Ergebnis:= 0;
  OriginalFunktionEins:= '';
  OriginalFunktionZwei:= '';
  RichtigerLetzterOperator:= 0;
  FunktionBisAktuellerOperator:= '';
  FunktionBisAktuellerOperatorReverse:= '';


  for I := 0 to Funktion.Length do
  begin
    NaechstesPlusZeichen:= PosEx('+', Funktion, AktuelleStelle);
    NaechstesMinusZeichen:= PosEx('-', Funktion, AktuelleStelle);
    if NaechstesMinusZeichen= 1 then
    begin
      NaechstesMinusZeichen:= PosEx('-', Funktion, AktuelleStelle+1);
    end;


    if ((NaechstesPlusZeichen < NaechstesMinusZeichen) and (NaechstesPlusZeichen <> 0)) or
       ((NaechstesPlusZeichen > 0) and (NaechstesMinusZeichen = 0))then
    begin

      FunktionBisAktuellerOperator:= Copy(Funktion, 0, NaechstesPlusZeichen-1);
      FunktionBisAktuellerOperatorReverse:= ReverseString(FunktionBisAktuellerOperator);

      LetzterOperator[0]:= PosEx('+', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[1]:= PosEx('-', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[2]:= PosEx('*', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[3]:= PosEx('/', FunktionBisAktuellerOperatorReverse, 1);

      for IV := 0 to 3 do
      begin
        if LetzterOperator[IV] <> 0 then
        begin
          LetzterOperator[IV]:= FunktionBisAktuellerOperator.Length - LetzterOperator[IV]+1;
        end;
      end;

      for III := 0 to 3 do
      begin
        if (LetzterOperator[III] > RichtigerLetzterOperator) and (LetzterOperator[III] <> 0)  then
        begin
          RichtigerLetzterOperator := LetzterOperator[III];
        end;
      end;



      UebernaechsterOperator[0]:= PosEx('+', Funktion, NaechstesPlusZeichen+1);
      UebernaechsterOperator[1]:= PosEx('-', Funktion, NaechstesPlusZeichen+1);
      UebernaechsterOperator[2]:= PosEx('*', Funktion, NaechstesPlusZeichen+1);
      UebernaechsterOperator[3]:= PosEx('/', Funktion, NaechstesPlusZeichen+1);

      for II := 0 to 3 do
      begin
        if (UebernaechsterOperator[II] < RichtigerUebernaechsterOperator) and (UebernaechsterOperator[II] <> 0)  then
        begin
          RichtigerUebernaechsterOperator := UebernaechsterOperator[II];
        end;
      end;

      FaktorEins:= Copy(Funktion, RichtigerLetzterOperator+1, NaechstesPlusZeichen-RichtigerLetzterOperator-1);
      FaktorZwei:= Copy(Funktion, NaechstesPlusZeichen+1, RichtigerUebernaechsterOperator-1-NaechstesPlusZeichen);
      Ergebnis:= StrToFloat(FaktorEins) + StrToFloat(FaktorZwei);
      OriginalFunktionEins:= Copy(Funktion, 0, RichtigerLetzterOperator);
      OriginalFunktionZwei:= Copy(Funktion, RichtigerUebernaechsterOperator, Funktion.Length);
      Funktion:= OriginalFunktionEins + FloatToStrF(Ergebnis, ffFixed, 8, 10) + OriginalFunktionZwei;
      LetztesPlusZeichen:= NaechstesPlusZeichen;
      RichtigerUebernaechsterOperator:= 1000;
      RichtigerLetzterOperator:= 0;
      AktuelleStelle:= NaechstesPlusZeichen;

    end
    else if (NaechstesMinusZeichen < NaechstesPlusZeichen) and (NaechstesMinusZeichen <> 0) or
            ((NaechstesMinusZeichen > 0) and (NaechstesPlusZeichen = 0)) then

    begin

      FunktionBisAktuellerOperator:= Copy(Funktion, 0, NaechstesMinusZeichen-1);
      FunktionBisAktuellerOperatorReverse:= ReverseString(FunktionBisAktuellerOperator);

      LetzterOperator[0]:= PosEx('+', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[1]:= PosEx('-', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[2]:= PosEx('*', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[3]:= PosEx('/', FunktionBisAktuellerOperatorReverse, 1);

      for IV := 0 to 3 do
      begin
        if LetzterOperator[IV] <> 0 then
        begin
          LetzterOperator[IV]:= FunktionBisAktuellerOperator.Length - LetzterOperator[IV]+1;
        end;
      end;

      for III := 0 to 3 do
      begin
        if (LetzterOperator[III] > RichtigerLetzterOperator) and (LetzterOperator[III] <> 0)  then
        begin
          RichtigerLetzterOperator := LetzterOperator[III];
        end;
      end;



      if  (LetzterOperator[1] = RichtigerLetzterOperator) and
          ((Copy(FunktionBisAktuellerOperator, RichtigerLetzterOperator-1, 1) = '+') or
          (Copy(FunktionBisAktuellerOperator, RichtigerLetzterOperator-1, 1) = '-') or
          (Copy(FunktionBisAktuellerOperator, RichtigerLetzterOperator-1, 1) = '*') or
          (Copy(FunktionBisAktuellerOperator, RichtigerLetzterOperator-1, 1) = '/'))
          then
      begin
        Delete(FunktionBisAktuellerOperator,RichtigerLetzterOperator, 1);
        Delete(Funktion,RichtigerLetzterOperator, 1);
        FunktionBisAktuellerOperatorReverse:= ReverseString(FunktionBisAktuellerOperator);
            LetzterOperator[0]:= PosEx('-', FunktionBisAktuellerOperatorReverse, 1);
            LetzterOperator[1]:= PosEx('+', FunktionBisAktuellerOperatorReverse, 1);
            LetzterOperator[2]:= PosEx('*', FunktionBisAktuellerOperatorReverse, 1);
            LetzterOperator[3]:= PosEx('/', FunktionBisAktuellerOperatorReverse, 1);

        for IV := 0 to 3 do
        begin
          if LetzterOperator[IV] <> 0 then
          begin
            LetzterOperator[IV]:= FunktionBisAktuellerOperator.Length - LetzterOperator[IV]+1;
          end;
        end;

        RichtigerLetzterOperator:= 0;
        for III := 0 to 3 do
        begin
          if (LetzterOperator[III] > RichtigerLetzterOperator) and (LetzterOperator[III] <> 0)  then
          begin
            RichtigerLetzterOperator := LetzterOperator[III];
          end;
        end;
        NegativerFaktor:= true;
        //if RichtigerLetzterOperator = 1 then RichtigerLetzterOperator:= 0;
      end;

      if (NaechstesMinusZeichen = RichtigerLetzterOperator+1) and (PosEx('-', Funktion, NaechstesMinusZeichen+1)= 0) and (PosEx('+', Funktion, NaechstesMinusZeichen+1)= 0) then
      begin
        break;
      end;

       if (NaechstesMinusZeichen = RichtigerLetzterOperator+1) and ((PosEx('-', Funktion, NaechstesMinusZeichen+1)<> 0) or (PosEx('+', Funktion, NaechstesMinusZeichen+1)<> 0)) then
      begin
        Delete(Funktion, NaechstesMinusZeichen, 1);
        NaechstesMinusZeichen:= PosEx('-', Funktion, NaechstesMinusZeichen+1);
        NegativerFaktor:= true;
      end;


      UebernaechsterOperator[0]:= PosEx('+', Funktion, NaechstesMinusZeichen+1);
      UebernaechsterOperator[1]:= PosEx('-', Funktion, NaechstesMinusZeichen+1);
      UebernaechsterOperator[2]:= PosEx('*', Funktion, NaechstesMinusZeichen+1);
      UebernaechsterOperator[3]:= PosEx('/', Funktion, NaechstesMinusZeichen+1);

      for II := 0 to 3 do
      begin
        if (UebernaechsterOperator[II] < RichtigerUebernaechsterOperator) and (UebernaechsterOperator[II] <> 0)  then
        begin
          RichtigerUebernaechsterOperator := UebernaechsterOperator[II];
        end;
      end;

      FaktorEins:= Copy(Funktion, RichtigerLetzterOperator+1, NaechstesMinusZeichen-RichtigerLetzterOperator-1);
      FaktorZwei:= Copy(Funktion, NaechstesMinusZeichen+1, RichtigerUebernaechsterOperator-1-NaechstesMinusZeichen);
      if NegativerFaktor then
      begin
        Ergebnis:= StrToFloat(FaktorEins) + StrToFloat(FaktorZwei);
        if PosEx('-', FloatToStr(Ergebnis), 1) = 0 then
        begin
        Zwischenergebnis:= '-' + FloatToStr(Ergebnis);
        Ergebnis:= StrToFloat(Zwischenergebnis);
        end;

      end
      else
      begin
        Ergebnis:= StrToFloat(FaktorEins) - StrToFloat(FaktorZwei);
      end;
      OriginalFunktionEins:= Copy(Funktion, 0, RichtigerLetzterOperator);
      OriginalFunktionZwei:= Copy(Funktion, RichtigerUebernaechsterOperator, Funktion.Length);
      Funktion:= OriginalFunktionEins + FloatToStrF(Ergebnis, ffFixed, 8, 10) + OriginalFunktionZwei;
      LetztesPlusZeichen:= NaechstesPlusZeichen;
      RichtigerUebernaechsterOperator:= 1000;
      RichtigerLetzterOperator:= 0;
      AktuelleStelle:= NaechstesMinusZeichen;
    end;
  end;

  result:= Funktion;

end;
{
function HochFinden(Funktion: String; Y: Extended): String;
var
I, II: Extended;
NaechstesHochZeichen: Extended;
AktuelleStelle: Extended;
LetzterOperator: Array [0..3] of Extended;
FunktionBisAktuellerOperator: String;
FunktionBisAktuellerOperatorReverse: String;
RichtigerLetzterOperator: Extended;
begin
  AktuelleStelle:= 1;
  for I := 0 to Funktion.Length do
  begin
    NaechstesHochZeichen:= PosEx('^', Funktion, AktuelleStelle);
    if NaechstesHochZeichen <> 0 then
    begin
      FunktionBisAktuellerOperator:= Copy(Funktion, 0, NaechstesHochZeichen-1);
      FunktionBisAktuellerOperatorReverse:= ReverseString(FunktionBisAktuellerOperator);

      LetzterOperator[0]:= PosEx('+', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[1]:= PosEx('-', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[2]:= PosEx('*', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[3]:= PosEx('/', FunktionBisAktuellerOperatorReverse, 1);

      for II := 0 to 3 do
      begin
        if (LetzterOperator[II] > RichtigerLetzterOperator) and (LetzterOperator[II] <> 0)  then
        begin
          RichtigerLetzterOperator := LetzterOperator[II];
        end;
      end
    end;
  end;

end;
}

function HochFinden(Funktion: String; Y: Extended): String;
var
NaechstesHochZeichen:              Integer;
FaktorEins:                       String;
FaktorZwei:                       String;
AktuelleStelle:                   Integer;
I, II, III, IV:                   Integer;
LetzterVerwendeterOperator:       Integer;
UebernaechsterOperator:           Array [0..3] of Integer;
RichtigerUebernaechsterOperator:  Integer;
Ergebnis:                         Extended;
OriginalFunktionEins:             String;
OriginalFunktionZwei:             String;
LetzterOperator:                  Array[0..3] of Integer;
RichtigerLetzterOperator:         Integer;
FunktionBisAktuellerOperator:     String;
FunktionBisAktuellerOperatorReverse: String;
NegativerFaktor:                  Boolean;
Zwischenergebnis:                 String;

begin
  LetzterVerwendeterOperator:= 0;
  AktuelleStelle:= 1;
  RichtigerUebernaechsterOperator:= 1000;
  RichtigerLetzterOperator:= 0;
  NaechstesHochZeichen:= 0;
  FaktorEins:= '';
  FaktorZwei:= '';
  I:= 0;
  II:= 0;
  III:= 0;
  IV:= 0;
  Ergebnis:= 0;
  OriginalFunktionEins:= '';
  OriginalFunktionZwei:= '';
  RichtigerLetzterOperator:= 0;
  FunktionBisAktuellerOperator:= '';
  FunktionBisAktuellerOperatorReverse:= '';
  NegativerFaktor:= false;

  for I := 0 to Funktion.Length do
  begin
    NaechstesHochZeichen:= PosEx('^', Funktion, AktuelleStelle);
    if NaechstesHochZeichen <> 0 then
    begin
      FunktionBisAktuellerOperator:= Copy(Funktion, 0, NaechstesHochZeichen-1);
      FunktionBisAktuellerOperatorReverse:= ReverseString(FunktionBisAktuellerOperator);

      LetzterOperator[0]:= PosEx('-', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[1]:= PosEx('+', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[2]:= PosEx('*', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[3]:= PosEx('/', FunktionBisAktuellerOperatorReverse, 1);


      for IV := 0 to 3 do
      begin
        if LetzterOperator[IV] <> 0 then
        begin
          LetzterOperator[IV]:= FunktionBisAktuellerOperator.Length - LetzterOperator[IV]+1;
        end;
      end;

      for III := 0 to 3 do
      begin
        if (LetzterOperator[III] > RichtigerLetzterOperator) and (LetzterOperator[III] <> 0)  then
        begin
          RichtigerLetzterOperator := LetzterOperator[III];

        end;
      end;

      if  (LetzterOperator[0] = RichtigerLetzterOperator) and
          ((Copy(FunktionBisAktuellerOperator, RichtigerLetzterOperator-1, 1) = '+') or
          (Copy(FunktionBisAktuellerOperator, RichtigerLetzterOperator-1, 1) = '-') or
          (Copy(FunktionBisAktuellerOperator, RichtigerLetzterOperator-1, 1) = '*') or
          (Copy(FunktionBisAktuellerOperator, RichtigerLetzterOperator-1, 1) = '/'))
          then
      begin
        Delete(FunktionBisAktuellerOperator,RichtigerLetzterOperator, 1);
        Delete(Funktion,RichtigerLetzterOperator, 1);
        FunktionBisAktuellerOperatorReverse:= ReverseString(FunktionBisAktuellerOperator);
            LetzterOperator[0]:= PosEx('-', FunktionBisAktuellerOperatorReverse, 1);
            LetzterOperator[1]:= PosEx('+', FunktionBisAktuellerOperatorReverse, 1);
            LetzterOperator[2]:= PosEx('*', FunktionBisAktuellerOperatorReverse, 1);
            LetzterOperator[3]:= PosEx('/', FunktionBisAktuellerOperatorReverse, 1);

        for IV := 0 to 3 do
        begin
          if LetzterOperator[IV] <> 0 then
          begin
            LetzterOperator[IV]:= FunktionBisAktuellerOperator.Length - LetzterOperator[IV]+1;
          end;
        end;

        RichtigerLetzterOperator:= 0;
      for III := 0 to 3 do
        begin
          if (LetzterOperator[III] > RichtigerLetzterOperator) and (LetzterOperator[III] <> 0)  then
          begin
            RichtigerLetzterOperator := LetzterOperator[III];
          end;
        end;
        NegativerFaktor:= true;
        //if RichtigerLetzterOperator = 1 then RichtigerLetzterOperator:= 0;
      end;


      UebernaechsterOperator[0]:= PosEx('+', Funktion, NaechstesHochZeichen+1);
      UebernaechsterOperator[1]:= PosEx('-', Funktion, NaechstesHochZeichen+1);
      UebernaechsterOperator[2]:= PosEx('*', Funktion, NaechstesHochZeichen+1);
      UebernaechsterOperator[3]:= PosEx('/', Funktion, NaechstesHochZeichen+1);

      for II := 0 to 3 do
      begin
        if (UebernaechsterOperator[II] < RichtigerUebernaechsterOperator) and (UebernaechsterOperator[II] <> 0)  then
        begin
          RichtigerUebernaechsterOperator := UebernaechsterOperator[II];
        end;
      end;


      NaechstesHochZeichen:= PosEx('^', Funktion, AktuelleStelle);
      FaktorEins:= Copy(Funktion, RichtigerLetzterOperator+1, NaechstesHochZeichen-RichtigerLetzterOperator-1);
      FaktorZwei:= Copy(Funktion, NaechstesHochZeichen+1, RichtigerUebernaechsterOperator-1-NaechstesHochZeichen);
      Ergebnis:= power(StrToFloat(FaktorEins), StrToFloat(FaktorZwei));
      if (NegativerFaktor) and (StrToInt(FaktorZwei) mod 2 = 1) then
      begin
        Zwischenergebnis:= '-' + FloatToStrF(Ergebnis, ffFixed, 8, 10);
        Ergebnis:= StrToFloat(Zwischenergebnis);
      end;
      OriginalFunktionEins:= Copy(Funktion, 0, RichtigerLetzterOperator);
      OriginalFunktionZwei:= Copy(Funktion, RichtigerUebernaechsterOperator, Funktion.Length);
      Funktion:= OriginalFunktionEins + FloatToStrF(Ergebnis, ffFixed, 8, 10) + OriginalFunktionZwei;
      RichtigerUebernaechsterOperator:= 1000;
      RichtigerLetzterOperator:= 0;
      AktuelleStelle:= NaechstesHochZeichen;

    end
  end;

  result:= Funktion;

end;


function SinusKosinusTangens(Funktion: String; Y: Extended): String;
var
NaechstesS: Integer;
NaechstesC: Integer;
NaechstesT: Integer;
KlammerAuf, KlammerZu: Integer;
Klammerinhalt: String;
Ergebnis: Extended;
AktuelleStelle: Integer;
OriginalFunktionEins: String;
OriginalFunktionZwei: String;
begin
  AktuelleStelle:= 1;
  NaechstesS:= PosEx('s', Funktion, AktuelleStelle);
  NaechstesC:= PosEx('c', Funktion, AktuelleStelle);
  NaechstesT:= PosEx('t', Funktion, AktuelleStelle);

  if  ((NaechstesS < NaechstesC) and (NaechstesS < NaechstesT) and (NaechstesS <> 0)) or
      ((NaechstesS <> 0) and (NaechstesC = 0) and (NaechstesT = 0))then
  begin

    KlammerAuf:= PosEx('(', Funktion, AktuelleStelle);
    KlammerZu:= PosEx(')', Funktion, AktuelleStelle);
    Klammerinhalt:= Copy(Funktion, KlammerAuf+1, KlammerZu-Klammerauf-1);

    try
      Ergebnis:= Sin(StrToFloat(Klammerinhalt));
    Except
      ShowMessage('Nix Gut');
      Abort;
    end;

    OriginalFunktionEins:= Copy(Funktion,0,NaechstesS-1);
    OriginalFunktionZwei:= Copy(Funktion, KlammerZu+1, Funktion.Length);
    Funktion:= OriginalFunktionEins + FloatToStrF(Ergebnis, ffFixed, 8, 10) + OriginalFunktionZwei;
    AktuelleStelle:= NaechstesS;
  end

  else if  ((NaechstesC < NaechstesS) and (NaechstesC < NaechstesT) and (NaechstesC <> 0)) or
      ((NaechstesC <> 0) and (NaechstesS = 0) and (NaechstesT = 0))then
  begin

    KlammerAuf:= PosEx('(', Funktion, AktuelleStelle);
    KlammerZu:= PosEx(')', Funktion, AktuelleStelle);
    Klammerinhalt:= Copy(Funktion, KlammerAuf+1, KlammerZu-Klammerauf-1);

    try
      Ergebnis:= Cos(StrToFloat(Klammerinhalt));
    Except
      ShowMessage('Nix Gut');
      Abort;
    end;

    OriginalFunktionEins:= Copy(Funktion,0,NaechstesS-1);
    OriginalFunktionZwei:= Copy(Funktion, KlammerZu+1, Funktion.Length);
    Funktion:= OriginalFunktionEins + FloatToStrF(Ergebnis, ffFixed, 8, 10) + OriginalFunktionZwei;
    AktuelleStelle:= NaechstesS;
  end

  else if  ((NaechstesT < NaechstesS) and (NaechstesT < NaechstesC) and (NaechstesT <> 0)) or
      ((NaechstesT <> 0) and (NaechstesS = 0) and (NaechstesC = 0))then
  begin

    KlammerAuf:= PosEx('(', Funktion, AktuelleStelle);
    KlammerZu:= PosEx(')', Funktion, AktuelleStelle);
    Klammerinhalt:= Copy(Funktion, KlammerAuf+1, KlammerZu-Klammerauf-1);

    try
      Ergebnis:= Tan(StrToFloat(Klammerinhalt));
    Except
      ShowMessage('Nix Gut');
      Abort;
    end;

    OriginalFunktionEins:= Copy(Funktion,0,NaechstesS-1);
    OriginalFunktionZwei:= Copy(Funktion, KlammerZu+1, Funktion.Length);
    Funktion:= OriginalFunktionEins + FloatToStrF(Ergebnis, ffFixed, 8, 10) + OriginalFunktionZwei;
    AktuelleStelle:= NaechstesS;
  end;

  result:= Funktion;


end;


function PunktrechnungFinden(Funktion: String; Y: Extended): String;
var
NaechstesMalZeichen:              Integer;
NaechstesGeteiltZeichen:          Integer;
LetztesMalZeichen:                Integer;
FaktorEins:                       String;
FaktorZwei:                       String;
AktuelleStelle:                   Integer;
I, II, III, IV:                   Integer;
LetzterVerwendeterOperator:       Integer;
UebernaechsterOperator:           Array [0..3] of Integer;
RichtigerUebernaechsterOperator:  Integer;
Ergebnis:                         Extended;
OriginalFunktionEins:             String;
OriginalFunktionZwei:             String;
LetzterOperator:                  Array[0..3] of Integer;
RichtigerLetzterOperator:         Integer;
FunktionBisAktuellerOperator:     String;
FunktionBisAktuellerOperatorReverse: String;
MinusVorFaktor:                   Boolean;
NegativerFaktor:                  Boolean;

begin
  LetzterVerwendeterOperator:= 0;
  AktuelleStelle:= 1;
  RichtigerUebernaechsterOperator:= 1000;
  LetztesMalZeichen:= 1;
  RichtigerLetzterOperator:= 0;
  NaechstesMalZeichen:= 0;
  NaechstesGeteiltZeichen:= 0;
  FaktorEins:= '';
  FaktorZwei:= '';
  I:= 0;
  II:= 0;
  III:= 0;
  IV:= 0;
  Ergebnis:= 0;
  OriginalFunktionEins:= '';
  OriginalFunktionZwei:= '';
  RichtigerLetzterOperator:= 0;
  FunktionBisAktuellerOperator:= '';
  FunktionBisAktuellerOperatorReverse:= '';


  for I := 0 to Funktion.Length do
  begin
    NaechstesMalZeichen:= PosEx('*', Funktion, AktuelleStelle);
    NaechstesGeteiltZeichen:= PosEx('/', Funktion, AktuelleStelle);
    MinusvorFaktor:= false;

    if ((NaechstesMalZeichen < NaechstesGeteiltZeichen) and (NaechstesMalZeichen <> 0)) or
       ((NaechstesMalZeichen > 0) and (NaechstesGeteiltZeichen = 0)) then
    begin

      FunktionBisAktuellerOperator:= Copy(Funktion, 0, NaechstesMalZeichen-1);
      FunktionBisAktuellerOperatorReverse:= ReverseString(FunktionBisAktuellerOperator);

      if PosEx('-', Funktion, NaechstesMalZeichen) = NaechstesMalZeichen+1  then
      begin
        MinusVorFaktor:= true;;
      end;

      LetzterOperator[0]:= PosEx('+', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[1]:= PosEx('-', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[2]:= PosEx('*', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[3]:= PosEx('/', FunktionBisAktuellerOperatorReverse, 1);

      for IV := 0 to 3 do
      begin
        if LetzterOperator[IV] <> 0 then
        begin
          LetzterOperator[IV]:= FunktionBisAktuellerOperator.Length - LetzterOperator[IV]+1;
        end;
      end;

      for III := 0 to 3 do
      begin
        if (LetzterOperator[III] > RichtigerLetzterOperator) and (LetzterOperator[III] <> 0)  then
        begin
          RichtigerLetzterOperator := LetzterOperator[III];
        end;
      end;



      UebernaechsterOperator[0]:= PosEx('+', Funktion, NaechstesMalZeichen+1);
      if MinusVorFaktor then
      begin
        UebernaechsterOperator[1]:= PosEx('-', Funktion, NaechstesMalZeichen+2);
      end

      else
      begin
        UebernaechsterOperator[1]:= PosEx('-', Funktion, NaechstesMalZeichen+1);
      end;

      UebernaechsterOperator[2]:= PosEx('*', Funktion, NaechstesMalZeichen+1);
      UebernaechsterOperator[3]:= PosEx('/', Funktion, NaechstesMalZeichen+1);

      for II := 0 to 3 do
      begin
        if (UebernaechsterOperator[II] < RichtigerUebernaechsterOperator) and (UebernaechsterOperator[II] <> 0)  then
        begin
          RichtigerUebernaechsterOperator := UebernaechsterOperator[II];
        end;
      end;




      FaktorEins:= Copy(Funktion, RichtigerLetzterOperator+1, NaechstesMalZeichen-RichtigerLetzterOperator-1);
      FaktorZwei:= Copy(Funktion, NaechstesMalZeichen+1, RichtigerUebernaechsterOperator-1-NaechstesMalZeichen);
      if MinusVorFaktor then
      begin
        Ergebnis:= StrToFloat(FaktorEins) *  StrToFloat(FaktorZwei);
      end

      else
      begin
        Ergebnis:= StrToFloat(FaktorEins)*StrToFloat(FaktorZwei);
      end;

      OriginalFunktionEins:= Copy(Funktion, 0, RichtigerLetzterOperator);
      OriginalFunktionZwei:= Copy(Funktion, RichtigerUebernaechsterOperator, Funktion.Length);
      Funktion:= OriginalFunktionEins +  FloatToStrF(Ergebnis, ffFixed, 8, 10)  + OriginalFunktionZwei;
      LetztesMalZeichen:= NaechstesMalZeichen;
      RichtigerUebernaechsterOperator:= 1000;
      RichtigerLetzterOperator:= 0;
      AktuelleStelle:= NaechstesMalZeichen;

    end
    else if  ((NaechstesGeteiltZeichen < NaechstesMalZeichen) and (NaechstesGeteiltZeichen <> 0)) or ((NaechstesGeteiltZeichen > 0) and (NaechstesMalZeichen = 0)) then

    begin

      FunktionBisAktuellerOperator:= Copy(Funktion, 0, NaechstesGeteiltZeichen-1);
      FunktionBisAktuellerOperatorReverse:= ReverseString(FunktionBisAktuellerOperator);

      LetzterOperator[0]:= PosEx('+', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[1]:= PosEx('-', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[2]:= PosEx('*', FunktionBisAktuellerOperatorReverse, 1);
      LetzterOperator[3]:= PosEx('/', FunktionBisAktuellerOperatorReverse, 1);

      for IV := 0 to 3 do
      begin
        if LetzterOperator[IV] <> 0 then
        begin
          LetzterOperator[IV]:= FunktionBisAktuellerOperator.Length - LetzterOperator[IV]+1;
        end;
      end;

      for III := 0 to 3 do
      begin
        if (LetzterOperator[III] > RichtigerLetzterOperator) and (LetzterOperator[III] <> 0)  then
        begin
          RichtigerLetzterOperator := LetzterOperator[III];
        end;
      end;

      UebernaechsterOperator[0]:= PosEx('+', Funktion, NaechstesGeteiltZeichen+1);
      UebernaechsterOperator[1]:= PosEx('-', Funktion, NaechstesGeteiltZeichen+1);
      UebernaechsterOperator[2]:= PosEx('*', Funktion, NaechstesGeteiltZeichen+1);
      UebernaechsterOperator[3]:= PosEx('/', Funktion, NaechstesGeteiltZeichen+1);

      for II := 0 to 3 do
      begin
        if (UebernaechsterOperator[II] < RichtigerUebernaechsterOperator) and (UebernaechsterOperator[II] <> 0)  then
        begin
          RichtigerUebernaechsterOperator := UebernaechsterOperator[II];
        end;
      end;

      FaktorEins:= Copy(Funktion, RichtigerLetzterOperator+1, NaechstesGeteiltZeichen-RichtigerLetzterOperator-1);
      FaktorZwei:= Copy(Funktion, NaechstesGeteiltZeichen+1, RichtigerUebernaechsterOperator-1-NaechstesGeteiltZeichen);
      Ergebnis:= StrToFloat(FaktorEins) / StrToFloat(FaktorZwei);
      OriginalFunktionEins:= Copy(Funktion, 0, RichtigerLetzterOperator);
      OriginalFunktionZwei:= Copy(Funktion, RichtigerUebernaechsterOperator, Funktion.Length);
      Funktion:= OriginalFunktionEins + FloatToStrF(Ergebnis, ffFixed, 8, 10) + OriginalFunktionZwei;
      LetztesMalZeichen:= NaechstesMalZeichen;
      RichtigerUebernaechsterOperator:= 1000;
      RichtigerLetzterOperator:= 0;
      AktuelleStelle:= NaechstesGeteiltZeichen;
    end;
  end;

  result:= Funktion;

end;

function MinusUndPlus(Funktion: String): String;
var
I:                  Integer;
AktuelleStelle:     Integer;
PlusZeichen:        Integer;
begin
  AktuelleStelle:= 1;
  for I := 1 to Funktion.Length do
  begin
    PlusZeichen:= PosEx('+',Funktion, I);
    if Funktion[Pluszeichen+1] = '-' then
    begin
      Delete(Funktion, PlusZeichen, 1);
    end;

  end;
  result:= Funktion;
end;

function BerechneY(X: Extended; Funktion: string): Extended;
begin
  if UnerlaubteZeichen(Funktion) then
  begin
    Funktion:= XInDerFunktionErsetzen(Funktion, X);
    Funktion:= SinusKosinusTangens(Funktion, X);
    Funktion:= HochFinden(Funktion, X);
    Funktion:= PunktrechnungFinden(Funktion, X);
    Funktion:= MinusUndPlus(Funktion);
    Funktion:= StrichrechnungFinden(Funktion, X);
    result:= StrToFloat(Funktion);
  end;
end;


end.
