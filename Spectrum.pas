unit Spectrum;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, VarCmplx, opengl, unit1, ogl, math,
  Vcl.ComCtrls, Vcl.CheckLst, Vcl.Menus;

type
  TSpectrum1 = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    Panel2: TPanel;
    TrackBar1: TTrackBar;
    RadioGroup1: TRadioGroup;
    CheckListBox1: TCheckListBox;
    Label12: TLabel;
    Label13: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label4: TLabel;
    Label9: TLabel;
    MainMenu1: TMainMenu;
    N1231: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    RadioGroup2: TRadioGroup;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure SetDCPixelFormat (hdc : HDC);
    procedure DFT(offset,N:integer;inverse:boolean);
    procedure showFFT(vPanel:TPanel; vdc:hdc; vhrc: hglrc; N:integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
   
  private
    { Private declarations }

  public
    { Public declarations }
    dc, dc2:hdc;
    hrc, hrc2: hglrc;
    procedure FFT(var Smpls: Variant; wSize, N: integer; inverse:boolean);
    function FFT_convolution(var res:Variant;a,b: Variant):variant;
  end;

  const
  glLB=-1.0;                            // �����
  glRB=1.0;                             // ������
  glTB=1.0;                             // �������
  glBB=-1.0;                            // � ������ ������� ���� � ����������� OpenGL

var
  Spectrum1: TSpectrum1;
  TCmxArr: Variant;
  SR: integer;                        // Sample rate

implementation

{$R *.dfm}

// ������������� PixelFormat
procedure TSpectrum1.SetDCPixelFormat (hdc : HDC);
var
 pfd : TPixelFormatDescriptor;
 nPixelFormat : Integer;
begin
 FillChar (pfd, SizeOf (pfd), 0);
 pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
 nPixelFormat := ChoosePixelFormat (hdc, @pfd);
 SetPixelFormat (hdc, nPixelFormat, @pfd);
end;

// ������� ������ ������������� ����
// �����: mode - ��� ����, i - ���������� ����� i-�� ������� �������, ������ ���� � ��������
function Window_type(mode, i, N: integer): double;
begin
 if mode=0 then                       // ������������� ����
  Result:=1
 else if mode=1 then                  // ��������
  Result:=0.5*(1-cos((2*pi*i)/(N-1)))
 else if mode=2 then                  // ��������
  Result:=0.53836-0.46164*cos(2*pi*i/(N-1))
 else if mode=3 then                  // Welch
  Result:=1-sqr((i-(N-1)/2)/((N-1)/2))
 else if mode=4 then                  // �������� ����
  Result:=sin(pi*i/(N-1));
end;

// ��������� ����������� �������� ��� ��������� ��������� ����������� �������
// ���������� ��� ������������ ���������� ������� ������� �������
procedure TSpectrum1.TrackBar1Change(Sender: TObject);
var
 i,N,nSamples:integer;
begin
 N:=strtoint(Combobox1.Text);                  // ������ ����
 nSamples:=glGraphics1.nSamples;               // ���������� ��������
 if (TrackBar1.Position+N)<nSamples then       // ���� ����������� ���������� � �������� �����,
 begin                                         // ����������� ������ ��������� �������
  Trackbar1.SelStart:=TrackBar1.Position;      // �� ������ ���������
  TrackBar1.SelEnd:=TrackBar1.Position+N;
 end
 else                                          // ���� ����� ����������� ������� ������� �� ������� �����
 begin                                         // ������ ����������� �������� ���������
  TrackBar1.Position:=nSamples-N;
  Trackbar1.SelStart:=TrackBar1.Position;
  TrackBar1.SelEnd:=nSamples;
 end;

 for I := 0 to (N-1) do      // �������� ������� � ����������� ������
  TCmxArr[i]:=VarComplexCreate(TempBuf[TrackBar1.SelStart+i],0);

 FFT(TCmxArr, N, N,false);  // ��������� ���
 showFFT(Panel1,dc,hrc,N);  // � ������� �� �������

 // ��� ���� �������� �� ����� ���� ������������� � ���������� �������� ������������
 // �� ������� ������
 wglMakeCurrent(dc2,hrc2);
 glViewPort(0, 0, Panel2.Width, Panel2.Height);
 glClearColor(1.0, 1.0 ,1.0 ,0.0);
 glClear(GL_COLOR_BUFFER_BIT);
 glGraphics1.glDraw(TrackBar1.Position,TrackBar1.Position+N,1,0,unit1.Form1.TrackBar5.Max,Panel2,0,0);
 SwapBuffers(dc2);
 wglMakeCurrent(0, 0);
end;


procedure TSpectrum1.Button1Click(Sender: TObject);      // ���������� �������������, ��������� ���
var
 i,N:integer;
begin
 N:=strtoint(Combobox1.Text);
 DFT(TrackBar1.SelStart,N,false);
 showFFT(Panel1,dc,hrc,N);
end;

// ������������ ��������� ��� ���
procedure Rearrange(N, StartI:integer; var Smpls: Variant);
var
 i:integer;
 x:variant;
begin
 x:=VarArrayCreate([0, N],  varVariant);       // �������� ����������� �������

 for i := 0 to N-1 do
 begin
  x[i]:=Smpls[StartI+(i shl 1)+1]; // ���������� ��� �������� �������� � ���������� ������
 end;

 for i:=0 to N-1 do
 begin
  Smpls[StartI+i]:=Smpls[StartI+(i shl 1)]; // ���������� ��� ������ �������� � ������ �������� �������
 end;

 for i := 0 to N-1 do
 begin
  Smpls[StartI+(N+1)+i]:=X[I];             // ����������� �������� �� ����������� �������
 end;                                      // �� ������ �������� ������������ ������� ��������
end;

procedure TSpectrum1.FFT(var Smpls: Variant; wSize, N: integer; inverse:boolean);
var
i,j,k3,k2:integer;
x: Variant;
Re,Im,k: Extended;
begin
 if N=2 then
 begin
  while N<=wSize do
  begin
  k:=6.28318/N;
  k3:=N shr 1;
   for j := 0 to (wSize div N)-1 do         // ���-�� N-�������� ��� �� ������ �����
   begin
    for i:=0 to k3-1 do                                 // ���-�� �������� ������ ������� N-��������� ���
    begin
     Re:=cos(k*i);
     Im:=-sin(k*i);
     k2:=j*N+i;
     if inverse=false then
      x:=Smpls[k2]+VarComplexCreate(Re,Im)*Smpls[k2+k3]
     else  // ��� ���� ������ ���������� ���������� �����������
      x:=Smpls[k2]+VarComplexConjugate(VarComplexCreate(Re,Im))*Smpls[k2+k3];

     if inverse=false then
      Smpls[k2+k3]:=(Smpls[k2]-VarComplexCreate(Re,Im)*Smpls[k2+k3])
     else
      Smpls[k2+k3]:=(Smpls[k2]-VarComplexConjugate(VarComplexCreate(Re,Im))*Smpls[k2+k3]);

     Smpls[k2]:=x;
    end;
   end;
   N:=N shl 1;
  end;
 end
 else
 begin
  for i := 0 to (wSize div N)-1 do         // ������ ������������ ���������
   Rearrange((N shr 1)-1, (i*N), Smpls);                           // ���� N �� ����� 2

  FFT(Smpls, wSize, N shr 1,inverse);
 end;
end;

procedure TSpectrum1.DFT(offset,N:integer; inverse: boolean);
var
 m,k:integer;
 Re, Im, coef, dblpi: Double;
begin
 dblpi:=2*pi;
 TCmxArr:=VarArrayCreate([0, N-1], varVariant); // �������� ������������ �������
 for k:=0 to N-1 do
 begin
  TCmxArr[k]:=VarComplexCreate(0,0);
  coef :=dblpi*k/N;
  for m:=0 to N-1 do
  begin
   Re:=cos(coef*m);
   Im:=-sin(coef*m);
   TCmxArr[k]:=TCmxArr[k]+(VarComplexCreate(Re,Im)*TCmxArr[offset+m]);
  end;
  if inverse=True then TCmxArr[k]:=TCmxArr[k]/N;   // ������������ ��� ����
 end;
end;

// ������� �������� ������: �� ���� ������� ������ res ��� ������ �
// ���� ����������, � ����� 2 ����������� ������� � ��������
// �������� � �������� ���� ������
function TSpectrum1.FFT_convolution(var res:Variant; a,b: Variant):variant;
var
 m,i:integer;
 conv_res:variant;
 expon, real_size, rsize_a, rsize_b:integer;
begin
 rsize_a:=VarArrayHighBound(a,1)+1;       // ���������� ����� ������� � (������� ������ �������� + 1)
 rsize_b:=VarArrayHighBound(b,1)+1;       // ������� b
 real_size:=rsize_a+rsize_b-1;            // ���������� ������ ����� ������� � ������������

 repeat                                    // ��� ���������� ��� ��������� ���������� �����
 begin                                     // �������� �������, ���������� �������� ������.
  real_size:=real_size div 2;              // ��� ����� ��������� ������ �������
  inc(expon);                              //
 end;                                      //
 until real_size<1;                        //

 real_size:=trunc(power(2, expon));        // ������������ ����� ������ �������, ������� ������

 VarArrayRedim(a, real_size);              // ��������� ������ �� ������� ������
 VarArrayRedim(b, real_size);              // ����� ������� ��������

 for i:=rsize_a to real_size-1 do
 begin
  a[i]:=VarComplexCreate(0,0);             // ���������� ������� ������� a �������� ���������
 end;

 for i:=rsize_b to real_size-1 do
 begin
  b[i]:=VarComplexCreate(0,0);             // �� ��
 end;

 Unit1.Form1.ProgressBar1.Position:=2;

 FFT(a, real_size, real_size, false);      // ��������� ��� ��� ������� � ���������
 Unit1.Form1.ProgressBar1.Position:=4;
 FFT(b, real_size, real_size, false);
 Unit1.Form1.ProgressBar1.Position:=6;     // ��� ������� ���� ������

 VarArrayRedim(res, real_size);            // ��������� ������ ���������� �� ������� �������

 for m:=0 to real_size-1 do                // ���������� ������������ � ��������� �������
 begin                                     //
  res[m]:=a[m]*b[m];                        //
 end;


 FFT(res, real_size, real_size, true);     // ���������� ���� ��� ������� �����������
 Unit1.Form1.ProgressBar1.Position:=8;

 for m:=0 to real_size-1 do                // ���������� ������������ ����������� ����
 begin                                     //
  res[m]:=res[m]/real_size;                 //
 end;                                      //
 Unit1.Form1.ProgressBar1.Position:=10;
end;

procedure TSpectrum1.Button2Click(Sender: TObject);
var
 i,N:integer;
begin
 N:=strtoint(Combobox1.Text);
 for I := 0 to N shl RadioGroup1.ItemIndex-1 do
  TCmxArr[i]:=VarComplexCreate(TempBuf[TrackBar1.SelStart+i]*window_type(RadioGroup2.ItemIndex, i, N), 0);

 FFT(TCmxArr, N shl RadioGroup1.ItemIndex, N shl RadioGroup1.ItemIndex,false);
 showFFT(Panel1,dc,hrc,(N shl RadioGroup1.ItemIndex));
end;

procedure TSpectrum1.ComboBox1Change(Sender: TObject);
var
 i,N:integer;
begin
 N:=strtoint(Combobox1.Text);
 TCmxArr:=VarArrayCreate([0, N], varVariant);
 AmpArr:=VarArrayCreate([0, N], varVariant);
end;

function DefCoeff(scale:real) :real; overload;
begin
 result:=((glRB-glLB)/(scale));
end;

function DefCoeff(scale, glRB, glLB:real) :real; overload;
begin
 result:=((glRB-glLB)/(scale));
end;

procedure TSpectrum1.ShowFFT(vPanel:TPanel; vdc:hdc; vhrc: hglrc; N:integer);
var
 i, j, cnt, t, lt,z,z2:integer;
 ws,expon, range,size, step2:integer;
 Rec: TRect;
 x1,x2,y1,y2,clr,amp_max,amp_min, step:double;

begin
 wglMakeCurrent(dc,hrc);
 glViewPort(0, 0, vPanel.Width, vPanel.Height);

 glClearColor(1.0, 1.0 ,1.0 ,0.0);
 glClear(GL_COLOR_BUFFER_BIT);     // ������� ������ �����

 SR:=strtoint(unit1.Form1.lbl_SR.Caption);        // �������� �������� ������
 step:=SR/N;                                       // ��� ������ �������

  if N2.Checked=true then                   // ����� ���������� ������� �����
  begin
   for i := 0 to N-1 do    // ���������� ������� AmpArr ����������� ������ � dB � ���������� � ����� � max ��������� = 0
   begin
    AmpArr[i]:=20*math.Log10(VarComplexAbs(TCmxArr[i]/N));
    if amp_max<AmpArr[i] then amp_max:=AmpArr[i];  // ���������� ������������ � ����������� ��������� ������ � dB
    if amp_min>AmpArr[i] then amp_min:=AmpArr[i];
   end;

   for i := 0 to N-1 do    // ���������� � ����� � max ��������� = 0
   begin
    AmpArr[i]:=AmpArr[i]-amp_max;
   end;

   glGraphics1.glDrawMScale(0,0,Panel1,checklistbox1.Checked[0], N, 0, strtoint(Edit3.Text), step,  checklistbox1.Checked[1], 0, -(ceil(amp_max)-trunc(amp_min)), strtoint(Edit4.Text), 1, strtoint(Edit1.Text));
  end
  else  if (N1.Checked=true) then        // ������� �������������
  begin
   if RadioGroup1.ItemIndex=0 then
    CmxArrAmp:=VarArrayCreate([0, N-1], varVariant)
   else if RadioGroup1.ItemIndex=1 then
    CmxArrAmp:=VarArrayCreate([0, N*2-1], varVariant);

   ws:=(glGraphics1.nSamples-(N div 2));

   if ws>1000 then                      // ����������
   begin
    step2:=ceil(ws/1000);
   end
   else step2:=1;
   size:=ws div step2;

   ProgressBar1.Max:=size;            // ����������� ������ ����
   for i:=0 to size do                // ���� ������� �� ����� ������
    begin
     ProgressBar1.Position:=i;

     for j := 0 to (N shl RadioGroup1.ItemIndex)-1 do
     begin
      if (i*step2+j)<glGraphics1.nSamples then CmxArrAmp[j]:=TempBuf[i*step2+j]   // �������� ������� � ����������� ������
      else CmxArrAmp[j]:=VarComplexCreate(127,0);
     end;

     FFT(CmxArrAmp, (N shl RadioGroup1.ItemIndex), (N shl RadioGroup1.ItemIndex), false);

     for j := 0 to N-1 do
     begin
      CmxArrAmp[j]:=20*math.Log10(VarComplexAbs(CmxArrAmp[j]/N));          // ����������� ��������� � ������� � ������
     end;

     glGraphics1.glDrawMScale(7, i, Panel1, false, (N shl RadioGroup1.ItemIndex), 0, strtoint(Edit3.Text), step,  false, size, 0, strtoint(Edit4.Text), 1, strtoint(Edit1.Text));
    end;
  end;
 SwapBuffers(dc);
 wglMakeCurrent(0, 0);
end;

procedure TSpectrum1.FormCreate(Sender: TObject);
begin
 dc:=GetDC(Panel1.Handle);
 SetDCPixelFormat(dc);
 hrc := wglCreateContext(dc);

 dc2:=GetDC(Panel2.Handle);
 SetDCPixelFormat(dc2);
 hrc2 := wglCreateContext(dc2);
end;

procedure TSpectrum1.FormShow(Sender: TObject);   // ��� �������� ���� ���������� �������������
var
 i,N:integer;
begin
 N:=strtoint(Combobox1.Text);
 TCmxArr:=VarArrayCreate([0, N], varVariant);  // �������� ������������ ������� ��������
 AmpArr:=VarArrayCreate([0, N], varVariant);  // �������� ������������ ������� �������� ������

 TrackBar1.Max:=glGraphics1.nSamples;      // max �������� �������� ����� ���-�� ��������
 TrackBar1.SelStart:=0;                    // ������ ���������
 TrackBar1.SelEnd:=N;                      // �����
end;

procedure TSpectrum1.N1Click(Sender: TObject);
begin                              // ��������� ���������� �������� ��� ��� ��������
 TrackBar1.Enabled:=False;         // ������������� ����� �������
end;

procedure TSpectrum1.N2Click(Sender: TObject);
begin                              // ��������� ������������� �������� ��� ������� �� �����
 TrackBar1.Enabled:=True;          // ��� ���������� ������� ������� �����
end;

end.

