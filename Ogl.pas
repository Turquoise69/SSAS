unit Ogl;

interface
uses opengl,Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, math, Unit1, varcmplx;

  type
  TWave = record
    chID : array[0..3] of AnsiChar;
    fmt: array [0..3] of AnsiChar;          // Format
    sch1ID: array [0..3] of AnsiChar;       // subchunk 1 ID
    NChans: integer;                        // Number of Channels
    chSize: integer;                        // Chunk Size
    sch1S: integer;                         // SubChunk1Size
    AF: integer;                            // Audio Format
    SR: integer;                            // Sample Rate
    BR: integer;                            // Byte Rate
    BA: integer;                            // Block Align
    BpS: integer;                           // Bits Per Sample
    sch2S: integer;                         // SubChunk2Size
    sch2ID: array [0..3] of AnsiChar;       // subchunk 2 ID
    drn: double;                            // duration
    public
    function IsHeaderValid :Boolean;
    end;

    type
  tfunc = function (Const a, b, lambda, t, fz:single; downbrd, upbrd :real) :single;

type
 TglGraphics = class(TForm)
 public
  f: TFileStream;
  fDataValid: Boolean;
  buf: Array Of Byte;
  vPanel: TPanel;
  pps, dataOffset, startI, nBuffer, nBitsPerSample, nBytesPerSample, nSamples, TBSelStart, tbpos, glBB, glTB:integer;
  waveDesc: TWave;
  maxScale, A, B, lambda, fz: real;

  Constructor CreateNew (fileName :String); OverLoad;
  Constructor CreateNew (fileName :String; lenBuffer :Integer; counter:integer); OverLoad;
  Property DataValid :Boolean Read fDataValid;
  procedure glDraw(sel_start, sel_end: integer; state,startindex,tbpos:integer; vPanel:TPanel;shft_l, shft_b:integer);
  procedure glDrawMScale(mode, start_I: integer; vPanel:TPanel; X_on:boolean; Xmax, Xmin, Xpres:integer; Xstep:double; Y_on:boolean; Ymax, Ymin, Ypres:integer; Ystep:double; Seg_size: integer);
  procedure glDrawFFT(vPanel:TPanel; AmpMax, AmpMin, shft_l, shft_b, FreqRange: integer);
  procedure glDrawFFT_Full(vPanel:TPanel; winN, N, YMax, shft_l, shft_b:integer);
  procedure CharDraw(vPanel:TPanel; seg_size:integer; x,y:real; isHoriz,a,b,c,d,e,f,g:boolean);
  procedure ReadWaveHeader; // ������ ��������� �����
  procedure ReadSamples (startReadIndex :Integer; nReadSamples :Integer; startIBuf :Integer);
  function  GetSampleI (index :Integer) :Integer;
  Property SampleI [index :Integer] :Integer Read GetSampleI;
  function Calculations(nSamples: integer; vPanel:TPanel): integer;
  function PxToOgl(value, size: integer): real;
  procedure NumDraw(vPanel:TPanel; offset, number:real; axis:string; seg_size,shft_l,shft_b,Xpres,Ypres:integer);
  function sinWX (Const aa, bb, lambda, t, fi_noll :single) :real;
  function sinc (Const lambda, t :single; width: integer) :real;     // ������ ����������� ������
  function RectPulse (Const coef, shift, t :single) :real;
end;

const
 glLB=-1.0;                         // ����� ������� ���� gl
 glRB=1.0;                          // ������ �������
 PIndex=0;                         // Global const before every type

var
  glGraphics1: TglGraphics;

implementation
//{$R *.dfm}

// ����� ���������� ����� ����� ��������� �������
function DefCoeff(scale:real): real; overload;
begin                                   // Res ? (0..2)
 result:=((glRB-glLB)/(scale));
end;

function DefCoeff(scale, glRB, glLB: real) :real; overload;
begin                                   // Res ? (0..2)
 result:=((glRB-glLB)/(scale));
 end;

// ������� ���������� �������� ������ ���������� �������� ������������� � ���������� x2,
// � �������� �������� ���������� ��������� ������� �������, �.�.
// ������� � �������, ����� ���������� ����� 2-�� ��������� ������� > 10 ��������
function TglGraphics.Calculations(nSamples: integer; vPanel:TPanel): integer;
var
 i,cnt:integer;
begin
 i:=nSamples;
 repeat
 begin
  i:=i div 2;
  inc(cnt);
 end;
 until ((vPanel.Width*defcoeff(i))>=10);
 Result:=cnt;
end;

Constructor TglGraphics.CreateNew (fileName :String);
begin
 // TO DO: ����� ���������� ������ ������
 CreateNew (fileName, 1024*1024*10, 0);
end;

// ������� �������� ���������� ������� � ������������ ������� OpenGL
// value - ������� ��������, size - ����� ��� ������ ������
function TglGraphics.PxToOgl(value, size: integer): real;
begin
 Result:=(value/Size)*(1.0-(-1.0));
end;

// ��������� ��������� ���������� ����� �� ���� ��������������� ����������
//
//   __A__
//  |     |
// F|     |B
//  |__G__|
//  |     |
// E|     |C
//  |__D__|
//
// ����� vPanel - ������ ������ �������, seg_size - ������ ������ �������� ����������,
// x,y - ��������� ����� ��������� � ����������� OpenGL,
// isHoriz - True ���� ��� �������, False - �������
// A,B,C,D,E,F,G - "�����" ��� ��� ������ ��������
procedure TglGraphics.CharDraw(vPanel:TPanel; seg_size:integer; x,y:real; isHoriz,a,b,c,d,e,f,g: boolean);
var
oglX, oglY: real;
begin
 oglX:=PxToOgl(seg_size,vPanel.Width);    // ������� ������� �������� �� ��������
 oglY:=PxToOgl(seg_size,vPanel.Height);   // � ������� ��������� OpenGL

 // ���������������� ������ �� ��������� E,D,C,G,F,A,B
 // � ��������� �� ������ ��� ������� ������ � ����������� ��
 // ��������� (on, off)
 if E=True then glColor3f(0.0, 0.0, 0.0) else glColor3f(1.0, 1.0, 1.0);
 glVertex2f(x,y);
 if isHoriz=False then glVertex2f(x,y-oglY) else glVertex2f(x+oglX,y);

 if D=True then glColor3f(0.0, 0.0, 0.0) else glColor3f(1.0, 1.0, 1.0);
 if isHoriz=False then glVertex2f(x,y-oglY) else glVertex2f(x+oglX,y);
 if isHoriz=False then glVertex2f(x+oglX,y-oglY) else glVertex2f(x+oglX,y+oglY);

 if C=True then glColor3f(0.0, 0.0, 0.0) else glColor3f(1.0, 1.0, 1.0);
 if isHoriz=False then glVertex2f(x+oglX,y-oglY) else glVertex2f(x+oglX,y+oglY);
 if isHoriz=False then glVertex2f(x+oglX,y) else glVertex2f(x,y+oglY);

 if G=True then glColor3f(0.0, 0.0, 0.0) else glColor3f(1.0, 1.0, 1.0);
 if isHoriz=False then glVertex2f(x+oglX,y) else glVertex2f(x,y+oglY);
 glVertex2f(x,y);

 if F=True then glColor3f(0.0, 0.0, 0.0) else glColor3f(1.0, 1.0, 1.0);
 glVertex2f(x,y);
 if isHoriz=False then glVertex2f(x,y+oglY) else glVertex2f(x-oglX,y);

 if A=True then glColor3f(0.0, 0.0, 0.0) else glColor3f(1.0, 1.0, 1.0);
 if isHoriz=False then glVertex2f(x,y+oglY) else glVertex2f(x-oglX,y);
 if isHoriz=False then glVertex2f(x+oglX,y+oglY) else glVertex2f(x-oglX,y+oglY);

 if B=True then glColor3f(0.0, 0.0, 0.0) else glColor3f(1.0, 1.0, 1.0);
 if isHoriz=False then glVertex2f(x+oglX,y+oglY) else glVertex2f(x-oglX,y+oglY);
 if isHoriz=False then glVertex2f(x+oglX,y) else glVertex2f(x,y+oglY);
end;

// ��������� ����� (�����, �����, ����� ����������) �� ���������
procedure TglGraphics.NumDraw(vPanel:TPanel; offset,number:real; axis:string; seg_size,shft_l,shft_b,Xpres,Ypres:integer);
var
 chr:string;
 i: integer;
 k1,k2: real;
 state:boolean;
begin
 // ����������� ������������ ��� �������������� ���
 if axis='y' then state:=false else if axis='x' then state:=true;
 // ���������� �� ���� �������� ������ ����� �������
 // � ������� �������� � ������
 if axis='x' then
 chr:=FloatToStrF(number, ffFixed, length(inttostr(Trunc(number)))+Xpres, Xpres)
 else if axis='y' then
 chr:=FloatToStrF(number, ffFixed, length(inttostr(Trunc(number)))+Ypres, Ypres);

 for i:=1 to Length(chr) do    // ������������ ����������� ����� �� ������� �����
 begin
  glLineWidth(1);                  // ������� �������� - 1 px
  glBegin(GL_LINE_STRIP);          // ������ ���������� ���������, �� ������ ��������� 2 �����
  // ���������� ��������� ����� ������� ��������� �����
  if axis='y' then
  begin
   k1:=-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width)-glGraphics1.PxToOgl(5*i+(seg_size*(i)),vPanel.Width);  // 5px
   k2:=-1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)+offset;
  end
  else if axis='x' then
  begin
   k1:=-1.0+offset+glGraphics1.PxToOgl(shft_l,vPanel.Width);
   k2:=-1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)-glGraphics1.PxToOgl(5*i+(seg_size*(i)),vPanel.Height);
  end;

       if chr[Length(chr)-i+1]='0' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, true, true, true, true, true, true, false)
  else if chr[Length(chr)-i+1]='1' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, false, true, true, false, false, false, false)
  else if chr[Length(chr)-i+1]='2' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, true, true, false, true, true, false, true)
  else if chr[Length(chr)-i+1]='3' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, true, true, true, true, false, false, true)
  else if chr[Length(chr)-i+1]='4' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, false, true, true, false, false, true, true)
  else if chr[Length(chr)-i+1]='5' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, true, false, true, true, false, true, true)
  else if chr[Length(chr)-i+1]='6' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, true, false, true, true, true, true, true)
  else if chr[Length(chr)-i+1]='7' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, true, true, true, false, false, false, false)
  else if chr[Length(chr)-i+1]='8' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, true, true, true, true, true, true, true)
  else if chr[Length(chr)-i+1]='9' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, true, true, true, true, false, true, true)
  else if chr[Length(chr)-i+1]='-' then glGraphics1.CharDraw(vPanel, seg_size, k1, k2, state, false, false, false, false, false, false, true);
  glEnd;

  if (chr[Length(chr)-i+1]=',')  and (axis='x') then
  begin
   glpointsize(seg_size div 2);
   glColor3f(0.0, 0.0, 0.0);
   glBegin(GL_POINTS);
   glVertex2f(k1+PxToOgl(seg_size,vPanel.Width),k2+PxToOgl(seg_size div 2,vPanel.Height));
   glEnd;
  end
  else if (chr[Length(chr)-i+1]=',')  and (axis='y') then
  begin
   glpointsize(seg_size div 2);
   glColor3f(0.0, 0.0, 0.0);
   glBegin(GL_POINTS);
   glVertex2f(k1+PxToOgl(seg_size div 2,vPanel.Width),k2-PxToOgl(seg_size,vPanel.Height));
   glEnd;
  end;
 end;
end;

procedure TglGraphics.glDrawMScale(mode, start_I:integer; vPanel:TPanel; X_on:boolean; Xmax, Xmin, Xpres:integer; Xstep:double; Y_on:boolean; Ymax, Ymin, Ypres:integer; Ystep:double; Seg_size: integer);
var
 i, rangeX, rangeY, lenX, lenY,z,shft_l,shft_b:integer;
 amp_min, amp_max: real;
begin
 rangeX:=Xmax-Xmin;          // �������� ����� ���������� ���� X � Y
 rangeY:=Ymax-Ymin;          //
 lenX:=vPanel.Width;         //
 lenY:=vPanel.Height;        //
 // ���� �������� �� ������� ����� � ������ ������� ���������� Panel ��� ��������� �����
 shft_l:=((length(floattostr(SimpleRoundTo(Ymax*Ystep,-Ypres)))+(Ypres+7))*Seg_Size)+5*(length(floattostr(Ymax*Ystep))+(Ypres+1));
 shft_b:=((length(floattostr(SimpleRoundTo(Xmax*Xstep,-Xpres)))+(Xpres+4))*Seg_Size)+5*(length(floattostr(Xmax*Xstep))+(Xpres+1));

 glColor3f(0.0, 0.0, 0.0);                                                 //
 glBegin(GL_LINE_STRIP);                                                   //
 glVertex2f(-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width), -1.0);          //    ����� ��� Y
 glVertex2f(-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width), 1.0);           //
 glEnd;                                                                    //

 glColor3f(0.0, 0.0, 0.0);                                                //
 glBegin(GL_LINE_STRIP);                                                   //
 glVertex2f(-1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height));         //    ����� ��� X
 glVertex2f(1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height));          //
 glEnd;                                                                    //

 if defcoeff(rangeX)>4*Seg_size*glGraphics1.PxToOgl(Seg_size,lenX) then    // ����� �� ����� ����� ��������� �������� �������� � ���������� � ���
 begin
  for I := 1 to rangeX-1 do
  begin
   // ����������� �����
   NumDraw(vPanel, i*defcoeff(rangeX, 1.0, -1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width)), SimpleRoundTo(Xmin+i*Xstep,-Xpres), 'x', Seg_size, shft_l, shft_b, Xpres, Ypres);
   // ����������� ����� �� ������ ���
   if X_on=True then                                                        // ������������ ��� �
   begin
    glColor3f(0.8, 0.8, 0.8);
    glLineWidth(1);
    glBegin(GL_LINE_STRIP);
    glVertex2f((-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width)+i*defcoeff(rangeX, 1.0, -1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width))), -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height));
    glVertex2f((-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width)+i*defcoeff(rangeX, 1.0, -1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width))), 1.0);
    glEnd;
   end;
  end
 end
 else                                                                      // ������������ �������� ��� �����������, ��� ��� ����� ���������� ��������� �����
 begin
  z:=Ceil(rangeX/(vPanel.Width div (Seg_size*16)));           //
  for i:=1 to (rangeX div z) do
   NumDraw(vPanel, z*i*defcoeff(rangeX, 1.0, -1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width)), SimpleRoundTo(Xmin+z*i*Xstep,-Xpres), 'x', Seg_size, shft_l, shft_b, Xpres, Ypres);

  for I := 1 to (rangeX div z) do
  begin
   if X_on=True then                                             // ������������ ��� �
   begin
    glColor3f(0.8, 0.8, 0.8);
    glLineWidth(1);
    glBegin(GL_LINE_STRIP);
    glVertex2f((-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width)+z*i*defcoeff(rangeX, 1.0, -1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width))), -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height));
    glVertex2f((-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width)+z*i*defcoeff(rangeX, 1.0, -1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width))), 1.0);
    glEnd;
   end;
  end;
 end;
 // �� �� ��� ��� Y
 if defcoeff(rangeY)>4*Seg_size*glGraphics1.PxToOgl(Seg_size,lenY) then     // ���������� ������ �������
 begin
  for I := 1 to rangeY-1 do
  begin
   NumDraw(vPanel, i*defcoeff(rangeY,1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)), SimpleRoundTo(Ymin+i*Ystep,-Ypres), 'y', Seg_size, shft_l, shft_b, Xpres, Ypres);
   if Y_on=True then
   begin
    glColor3f(0.8, 0.8, 0.8);
    glLineWidth(1);
    glBegin(GL_LINE_STRIP);
    glVertex2f(-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width), -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)+i*defcoeff(rangeY,1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)));
    glVertex2f(1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)+i*defcoeff(rangeY,1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)));
    glEnd;
   end;
  end;
 end
 else
 begin
  z:=Ceil(rangeY/(vPanel.Height div (Seg_size*4)));
  for I := 1 to (rangeY div z) do
  begin
   NumDraw(vPanel, i*z*defcoeff((rangeY),1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)), SimpleRoundTo(Ymin+z*i*Ystep,-Ypres), 'y', Seg_size, shft_l, shft_b, Xpres, Ypres);
   if Y_on=True then
   begin
    glColor3f(0.8, 0.8, 0.8);
    glBegin(GL_LINE_STRIP);
    glVertex2f(-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width), -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)+i*z*defcoeff(rangeY,1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)));
    glVertex2f(1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)+i*z*defcoeff(rangeY,1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)));
    glEnd;
   end;
  end;
 end;

 if mode=-1 then         // �� ������ ������, ������ ���
 else if mode=0 then     // ���������� �������������
  glDrawFFT(vPanel, YMax, YMin, shft_l, shft_b, rangeX)
 else if mode=1 then     // ����� ������������� ������� ��� ���� ����������� �������������
  glDraw(0,0,1,0,glgraphics1.tbpos,vPanel,shft_l, shft_b)
 else if mode=2 then     // ����� ������������� ��������� �������
  glDraw(0,0,1,start_i,Unit1.Form1.TrackBar5.Position,vPanel,shft_l, shft_b)
 else if mode=3 then     // ����� ������������� �������������� �������
  glDraw(0,0,2,start_i,Unit1.Form1.TrackBar5.Position,vPanel,shft_l, shft_b)
 else if (mode=4) then   // ����� ������������� ���������� �������
  glDraw(0,0,3,start_i,Unit1.Form1.TrackBar5.Position,vPanel,shft_l, shft_b)
 else if (mode=5) then   // ����� ������������� �������������� ��������
  glDraw(0,0,4,start_i,Unit1.Form1.TrackBar5.Position,vPanel,shft_l, shft_b)
 else if (mode=6) then   // ����� ������������� ������� sin(x)/x
  glDraw(0,0,5,start_i,Unit1.Form1.TrackBar5.Position,vPanel,shft_l, shft_b)
 else if (mode=7) then   // ����� �������������
  glDrawFFT_Full(vPanel, start_i, trunc(Xmax), Ymax, shft_l, shft_b)
end;

procedure TglGraphics.glDrawFFT_Full(vPanel:TPanel; winN, N, YMax, shft_l, shft_b:integer);
var
 x1,x2,y1,y2,x:double;
 i,amp_max,amp_min:integer;
begin
 amp_min:=999;
 amp_max:=-999;

 for i := 0 to N-1 do
 begin
  if amp_max<CmxArrAmp[i] then amp_max:=Ceil(CmxArrAmp[i]);                   // ������� ������������ � ����������� ��������
  if amp_min>CmxArrAmp[i] then amp_min:=Trunc(CmxArrAmp[i]);                  // ���������
 end;

 for i := 0 to N-1 do
 begin
  x:=CmxArrAmp[i];
  x1:=-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width)+i*defcoeff(N, 1.0, -1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width));
  x2:=-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width)+(i+1)*defcoeff(N, 1.0, -1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width));
  y1:=-1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)+winN*defcoeff(Ymax, 1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height));
  y2:=-1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height)+(winN+1)*defcoeff(Ymax, 1.0, -1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height));

  if x<0 then glColor3f(-1/x, -1/x, -1/x) else  glColor3f(1/x, 1/x, 1/x);
  glRectf(x1, y1, x2, y2);
 end;
end;

// ��������� ��������� ������� �������
procedure TglGraphics.glDrawFFT(vPanel:TPanel; AmpMax, AmpMin, shft_l, shft_b, FreqRange: integer);
var
 i:integer;
 shft_l_ogl,shft_b_ogl:real;
begin
 shft_l_ogl:=glGraphics1.PxToOgl(shft_l,vPanel.Width);
 shft_b_ogl:=glGraphics1.PxToOgl(shft_b,vPanel.Height);
  for i:=1 to FreqRange-1 do                // �� �������� 0-�� �������, �.�. ��� ������ ����� ��������
 begin
  glColor3f(0.0, 0.0, 0.0);
  glBegin(GL_LINE_STRIP);
  glVertex2f((-1.0+shft_l_ogl+i*defcoeff(FreqRange, 1.0, -1.0+shft_l_ogl)),-1.0+shft_b_ogl);
  glVertex2f((-1.0+shft_l_ogl+i*defcoeff(FreqRange, 1.0, -1.0+shft_l_ogl)), -1.0+shft_b_ogl+(((AmpMax-Ampmin)+(AmpArr[i]))*defcoeff((AmpMax-Ampmin),1.0,-1.0+shft_b_ogl)));
  glEnd;
 end;
end;

Constructor TglGraphics.CreateNew(fileName :String;  lenBuffer:Integer; counter:integer);
var
i,x:integer;
begin
 Inherited CreateNew(Application);
 dataOffset :=44;
 //endI:=lenBuffer;
 startI:=0;
 nBuffer := lenBuffer;
 f:= TFileStream.Create(fileName, fmOpenReadWrite, fmOpenReadWrite);
 ReadWaveHeader;
 if DataValid then
 begin
  // ��������� �����
  SetLength(buf, nBuffer);
  nBitsPerSample :=waveDesc.BpS;                                  // ���������� ����� �� ������
  nBytesPerSample :=nBitsPerSample Div 8;                         // ���������� ������ �� ������
  nSamples := waveDesc.sch2S div waveDesc.BA;
  maxScale:=nSamples/3;
  SetLength(Unit1.TempBuf, NSamples-1);
  Unit1.TempBufCmx:=VarArrayCreate([0, NSamples-1], varVariant);
  ReadSamples(0,nBuffer,startI);

  i:=0;
  while i<Nsamples-1 do
  begin
   f.Seek(44+i, soFromBeginning);
   f.Read(x, 1);
   Unit1.TempBuf[i]:=x;
   Unit1.TempBufCmx[i]:=VarComplexCreate((x/128)-1, 0);       // -1..1
   inc(i);
  end;
 end;
end;

function TglGraphics.sinWX (Const aa, bb, lambda, t, fi_noll :single) :real;
begin
 Result :=(glGraphics1.a+glGraphics1.b*cos(((4*pi)/glGraphics1.lambda)*t+glGraphics1.fz));
end;

function TglGraphics.sinc(Const lambda, t :single; width: integer) :real;
begin
 if t=width/2 then
  Result := 2
 else
  Result := 1+(sin(2*pi*lambda*(t-width/2)))/(t-width/2)*(0.53836-0.46164*cos(2*pi*(t-width/2)/width-1));
end;

function TglGraphics.RectPulse (Const coef, shift, t :single) :real;
begin
 if (t>=0) and (t<shift) then
 Result:=0
 else if t>shift+coef then
 Result :=0
 else
 Result:=1/coef;
end;


function TWave.IsHeaderValid :Boolean;
begin
 Result :=(chID='RIFF') And (fmt='WAVE') And (sch1ID='fmt ') And (NChans>0);
end;

procedure TglGraphics.ReadWaveHeader;
begin
 fDataValid :=False;
 f.Read(waveDesc.chID, 4);
 f.Seek(8,soFromBeginning);
 f.Read(waveDesc.fmt, 4);
 f.Seek(12,soFromBeginning);
 f.Read(waveDesc.sch1ID, 4);
 f.Seek(22,soFromBeginning);  // Number of Channels
 f.Read(waveDesc.Nchans, 2);
 if waveDesc.IsHeaderValid then
 begin
  f.Seek(4,soFromBeginning); // Chunk Size
  f.Read(waveDesc.chSize, 4);
  f.Seek(16,soFromBeginning); // Sub Chunk 1 Size
  f.Read(waveDesc.sch1S, 4);
  f.Seek(20,soFromBeginning); // Audio Format
  f.Read(waveDesc.AF, 2);
  f.Seek(24,soFromBeginning); // Sample Rate
  f.Read(waveDesc.SR, 4);
  f.Seek(28,soFromBeginning); // Byte Rate
  f.Read(waveDesc.BR, 4);
  f.Seek(32,soFromBeginning); // Block Align
  f.Read(waveDesc.BA, 2);
  f.Seek(34,soFromBeginning); // Bits per Sample
  f.Read(waveDesc.BpS, 2);
  f.Seek((20+waveDesc.sch1S),soFromBeginning);  // SubChunk 2 ID
  f.Read(waveDesc.Sch2ID, 4);
  f.Seek((24+waveDesc.sch1S),soFromBeginning);  // SubChunk 2 ID
  f.Read(waveDesc.sch2S, 4);
  fDataValid :=True;
 end;
end;

procedure TglGraphics.ReadSamples (startReadIndex :Integer; nReadSamples :Integer; startIBuf :Integer);
// startReadIndex -- ��������� ������� ��� ������ � ����� ��� ����� ��������. �.�. ����� ��������� dataOffset
// nReadSamples   --  ���-�� ����������� �������
// startIBuf      --  ��������� ������ � ������ � �������� �������� ��� ����������
var
 howBuf :Integer;    // ���-�� ������� � ������, ������� ����� ���������
 howFile :Integer;   // ���-�� ������� � �����, ������� ����� ������� � ������� startReadIndex
begin
 // ���������� ������� ����� ������� � �������� � ������ ��� ��������� � ������ �� ������� �����
 if startIBuf+nReadSamples-1<=Length(buf)-1 then howBuf :=nReadSamples else howBuf :=Length(buf)-startIBuf; // ���������� ���������� ������� ��� ����� �������� � ������
 if startReadIndex+nReadSamples-1<=nSamples-1 then howFile :=nReadSamples else howFile :=nSamples-startReadIndex; // ���������� ���������� ������� ��� ����� ������� �� �����
 if howBuf>howFile then howBuf := howFile;

 f.Seek((dataOffset+startReadIndex), soFromBeginning);
 f.Read(buf[startIBuf],howBuf);
end;

procedure TglGraphics.glDraw(sel_start, sel_end: integer; state,startindex,tbpos:integer; vPanel:TPanel;shft_l, shft_b:integer);
var
 i,j,npoints,n:integer;
 swpoint,pmax,pmin,offst_lt,offst_bm:real;
 check:boolean;
begin
 offst_lt:=-1.0+glGraphics1.PxToOgl(shft_l,vPanel.Width);     // �������� ����� �� ��� X ��� ����������� ����������� �����
 offst_bm:=-1.0+glGraphics1.PxToOgl(shft_b,vPanel.Height);    // �������� ����� �� Y
 npoints:=trunc(pps/vPanel.width);              // ������� �������� ���������� � 1 �������

 if npoints<1 then         // ��������� ������� ������ ���� ��������, ��� ��� �� ���������
 begin                                           // �� ��������� ��-�� �������� ��������
  glColor3f(0.0, 0.0, 0.0);
  glBegin(GL_LINE_STRIP);
  for i:=0 to pps-1 do                           // ����������� i-�� ����� ��� ���������� �������
  begin
   if (state=1) then                             // ���� ���������� ��������� ����� 1
    SWpoint:=SampleI[startindex+i]               // ������ ������������� � ��������� ������� �� �����
   else if state=2 then
    SWpoint := sinWX (A, B, lambda, startindex+i, fz)  // ������ ���������, ���������� ������� ��������
   else if state=3 then
    SWpoint := Unit1.Conv_res2[startindex+i]              // ������ ��������� ������
   else if state=4 then
    SWpoint:=RectPulse(lambda, fz, startindex+i)*127  // ������ ������������� �������
   else if state=5 then
    SWpoint:=sinc(lambda, startindex+i, strtoint(unit1.Form1.Edit1.Text))*127  // ������ ������� sin(x)/x
   else
    break;

   glVertex2f((offst_lt+(i*defcoeff(pps, 1.0, offst_lt))),(offst_bm+(SWpoint*defcoeff(256, 1.0, offst_bm))));
  end;
  glEnd;
 end
 else if npoints>=1 then                          // ���������� ��������� ������������ ��������, ��� �������
 begin                                            // ��������� ������������ � ����������� ������� ��
  for i:=0 to vPanel.width-1 do                   // npoints �������� � �������� ������ ����� �� �����������
  begin
   check:=false;
   pmin:=255;
   pmax:=0;
   n:=0;
   for j:=i*npoints to i*npoints+npoints do
   begin
    if state=1 then SWpoint:=SampleI[startindex+j]
    else if state=2 then SWpoint:=sinWX (A, B, lambda, startindex+j, fz)
    else if state=3 then SWpoint := Unit1.Conv_res2[startindex+j]
    else if state=4 then SWpoint:=(RectPulse (lambda, fz, startindex+j)+1)*127
    else if state=5 then SWpoint:=(sinc(lambda, startindex+j, strtoint(unit1.Form1.Edit1.Text))*127);

    if SWpoint>pmax then pmax:=SWpoint;
    if SWpoint<pmin then pmin:=SWpoint;
    if (pmin=pmax) then pmax:=pmax+1;

    if (j>sel_start) and (j<sel_end) then check:=true;
   end;

    if (check=true)  then                                            // ��������� ���� ������� �������������
    begin                                                             // � ���� ���������� �������������
     glColor3f(0.0, 0.0, 0.0);
     glBegin(GL_LINE_STRIP);
     glVertex2f((offst_lt+(i*defcoeff(vPanel.width, 1.0, offst_lt))),-1.0);
     glVertex2f((offst_lt+(i*defcoeff(vPanel.width, 1.0, offst_lt))),1.0);
     glEnd;
    end;
    // ���� i-�� ������ ��������� � ���������� �������, �������� ������������� ������ ������
    if (check=true)  then  glColor3f(1.0, 1.0, 1.0) else glColor3f(0.0, 0.0, 0.0);
    glBegin(GL_LINE_STRIP);
    glVertex2f((offst_lt+(i*defcoeff(vPanel.width, 1.0, offst_lt))),(offst_bm+(pmin*defcoeff(256, 1.0, offst_bm))));
    glVertex2f((offst_lt+(i*defcoeff(vPanel.width, 1.0, offst_lt))),(offst_bm+(pmax*defcoeff(256, 1.0, offst_bm))));
    glEnd;
   inc(n);
  end;
 end;

 if (tbpos<=tbselstart) then    // ������������ ������������� ������� ��� ����� ��������
 begin
  glColor3f(0.5, 0.5, 0.5);     // ����
  glpointsize(5);               // ������ �����
  glBegin(GL_POINTS);           // ��������, ��� ������ �������
  for i:=0 to pps do            // ���������� ������������ ����� (������� � pps)
  begin
   if (state=1) then SWpoint:=SampleI[startindex+i]
   else if state=2 then SWpoint:=sinWX (A, B, lambda, startindex+i, fz)
   else if (state=3) then SWpoint:=Unit1.Conv_res2[startindex+i]
   else if state=4 then SWpoint:=(RectPulse (lambda, fz, startindex+i)+1)*127
   else if state=5 then SWpoint:=(sinc(lambda, startindex+i, strtoint(unit1.Form1.Edit1.Text))*127)
   else break;
   glVertex2f((offst_lt+(i*defcoeff(pps, 1.0, offst_lt))),(offst_bm+(SWpoint*defcoeff(256, 1.0, offst_bm))));
  end;
  glEnd;
 end;
end;

function TglGraphics.GetSampleI (index:Integer) :Integer;
begin
 if (index<0) Or (index>nSamples-1) then Result :=0
 else // ���� ������ ������ �����
 begin
  // startI                -- ���. ���.
  // startI+Length(buf)-1  -- ���. ���.
  if (index>=startI) And (index<=startI+Length(buf)-1) then // ���� ������ ������ ������
   Result :=buf[index-startI]
  else
  begin
   // � ������ ��� ������ ������
   startI :=index;
   ReadSamples(index,Length(buf),0);
   Result :=buf[0];
  end;
 end;
end;
end.
