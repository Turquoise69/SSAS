unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, mmsystem,
  Vcl.MPlayer, Vcl.ComCtrls, OpenGL, Math, DirectSound, Vcl.Buttons,
  Vcl.Menus, VarCmplx;

   type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    GroupBox1: TGroupBox;
    lbl_FileName: TLabel;

    // Элементы label для вывода информации о файле
    lbl_ChSize: TLabel;                 // Chunk Size
    lbl_Format: TLabel;
    lbl_SubCh1ID: TLabel;
    lbl_SubCh1S: TLabel;
    lbl_SubCh2ID: TLabel;
    lbl_SubCh2S: TLabel;
    lbl_Chnls: TLabel;                  // Number of Samples
    lbl_SR: TLabel;                     // Sample Rate
    lbl_BR: TLabel;                     // Byte Rate
    lbl_BA: TLabel;                     // Block Align
    lbl_BPS: TLabel;                    // Bits Per Sample
    lbl_ChID: TLabel;                   // Chunk ID
    lbl_Smpls: TLabel;                  // Number of Samples
    lbl_HS: TLabel;                     // Header Size
    lbl_Drtn: TLabel;                   // Duration
    lbl_AF: TLabel;                     // Audio Format
    lbl_FS: TLabel;                     // File Size

    // Статичные элементы label
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    Label43: TLabel;
    Label49: TLabel;
    Label51: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;

    // Кнопки
    btn_HideUP: TButton;
    btn_HideRight: TButton;
    btn_SaveInF: TButton;
    btn_Result: TButton;

    // Остальные элементы
    Label2: TLabel;
    Label13: TLabel;
    Label19: TLabel;
    Timer1: TTimer;
    Edit1: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit29: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    GroupBox2: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    TrackBar5: TTrackBar;
    CheckBox1: TCheckBox;
    MainMenu1: TMainMenu;
    ghj1: TMenuItem;
    Information1: TMenuItem;
    File1: TMenuItem;
    Open1: TMenuItem;
    GridPanel1: TGridPanel;
    Settings1: TMenuItem;
    View1: TMenuItem;
    Locked1: TMenuItem;
    Unlocked1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Analysis1: TMenuItem;
    Spectrogram1: TMenuItem;
    ProgressBar1: TProgressBar;
    RadioGroup2: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btn_Result_Click(Sender: TObject);
    procedure btn_SaveInF_Click(Sender: TObject);
    procedure TrackBar5Change(Sender: TObject);
    procedure UpDown3Changing(Sender: TObject; var AllowChange: Boolean);
    procedure UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure glFormInitiate(Panel1: TPanel; Panel2: TPanel; Panel3: TPanel);
    procedure CheckBox1Click(Sender: TObject);
    procedure Panel1MouseLeave(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure GroupBox3Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Information1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Locked1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Unlocked1Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btn_HideUP_Click(Sender: TObject);
    procedure btn_HideRight_Click(Sender: TObject);
    procedure Spectrogram1Click(Sender: TObject);
    procedure UpDown4Changing(Sender: TObject; var AllowChange: Boolean);
    procedure Edit1Change(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure Edit20Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);

   public
   { Public declarations }
    procedure InitSoundBuffer(Sender:TObject; SBIndex: Integer; PTemp: Pdword; buf_len: integer);
   end;

Const
  numBuffers = 3; // количество звуковых буферов

var
  Form1: TForm1;
  HS, MouseX, MouseY, ActivePanel, smpl, scale_min: integer;
  isFileInit: boolean;  // Проверка инициализации звукового файла
  DataArr4: array of AnsiChar;
  DSB: array [0..numBuffers] of IDirectSoundBuffer;
  TempBuf, TempBuf2, Conv_res2: array of byte; // конечные массивы отсчетов, ядра, результата свертки
  TempBufCmx, Kernel, Conv_res, xArr, CmxArr, CmxArrAmp: variant;
  xa, CmxArrModule, AmpArr: array of real;

  DS: IDirectSound;
  dc,dc2, dc3, dc4 : HDC;
  hrc,hrc2, hrc3, hrc4: HGLRC;

type
  TWaveFile = Class

  public
  //

end;

implementation
{$R *.dfm}
uses window1,window0, window2, window3, ogl, spectrum;

procedure TForm1.GroupBox3Click(Sender: TObject);
begin
 ActivePanel:=1;
end;

procedure TForm1.Information1Click(Sender: TObject);
begin
 if information1.checked then GroupBox1.Visible:=True else GroupBox1.Visible:=False;
end;

procedure TForm1.Locked1Click(Sender: TObject);
begin
 formactivate(form1);
 gridpanel1.Visible:=true;
end;

// Процедура инициализации буфера звукового файла
// SBIndex - порядковый номер буфера звукового сигнала
// PTemp - указатель на массив отсчётов сигнала
// buf_len - размер массива отсчётов
procedure TForm1.InitSoundBuffer(Sender:TObject; SBIndex: Integer; PTemp: Pdword; buf_len: integer);
var
 DSBytes1, DSBytes2, DSBytes1a, DSBytes2a: DWord;
 DSPtr1, DSPtr2, DSPtr1a, DSPtr2a: ^dword;
 DSBD: TDSBufferDesc;
 PCM: TWaveFormatEx;
 ret: hresult;
 ErrMsg: string;
begin
 //Проверка существования буфера под номером SBIndex
 if (SBIndex<0) Or (SBIndex>numBuffers)  then
 begin
  ErrMsg :='Ошибка! Звуковой буфер №'+IntToStr(SBIndex)+' за границами диапазона';
  raise Exception.Create(ErrMsg);
 end;

 FillChar(DSBD, SizeOf(DSBUFFERDESC),0);
 FillChar(PCM, SizeOf(TWaveFormatEx),0);

 // Буфер с индексом 0 - буфер исходного звукового сигнала
 if (SBIndex=0) then                                               
 begin
  DirectSoundCreate(NIL, DS, NIL);
  if DirectSoundCreate(nil, DS, nil) <> DS_OK then
   raise Exception.Create('Ошибка создания объекта IDirectSound');
  with DSBD do
  begin
   PCM.wFormatTag:=WAVE_FORMAT_PCM;
   PCM.nChannels:=glgraphics1.waveDesc.NChans;
   PCM.nSamplesPerSec:=glgraphics1.waveDesc.SR;
   PCM.nBlockAlign:=glgraphics1.waveDesc.BA;
   PCM.nAvgBytesPerSec:=PCM.nSamplesPerSec * PCM.nBlockAlign;
   PCM.wBitsPerSample:=glgraphics1.waveDesc.BpS;
   dwSize:=SizeOf(DSBUFFERDESC);
   dwFlags:=DSBCAPS_PRIMARYBUFFER;
   dwBufferBytes:=0;
   lpwfxFormat:=nil;
  end;
  DS.SetCooperativeLevel(handle, DSSCL_PRIORITY);
  if DS.SetCooperativeLevel(handle, DSSCL_PRIORITY) <> DS_OK then
   raise Exception.Create('Невозможно установить Coopeative Level');
  if DS.CreateSoundBuffer(DSBD, DSB[SBIndex],nil) <> DS_OK then
   raise Exception.Create('Ошибка создания звукового буфера');
  if DSB[SBIndex].SetFormat(@PCM) <> DS_OK then
   raise Exception.Create('Ошибка установки формата');
 end
 // Прочие звуковые буферы
 else
 begin
  with DSBD do
  begin
   PCM.wFormatTag:=WAVE_FORMAT_PCM;
   PCM.nChannels:=glgraphics1.waveDesc.NChans;
   PCM.nSamplesPerSec:=glgraphics1.waveDesc.SR;
   PCM.nBlockAlign:=glgraphics1.waveDesc.BA;
   PCM.nAvgBytesPerSec:=PCM.nSamplesPerSec * PCM.nBlockAlign;
   PCM.wBitsPerSample:=glgraphics1.waveDesc.BpS;
   PCM.cbSize:=0;
   dwSize:=SizeOf(DSBUFFERDESC);
   dwFlags:=DSBCAPS_GLOBALFOCUS and DSBCAPS_static;
   dwBufferBytes:=buf_len;
   lpwfxFormat:=@pcm;
  end;

  DS.CreateSoundBuffer(DSBD, DSB[SBIndex], NIL);
  if DS.CreateSoundBuffer(DSBD,DSB[SBIndex],NIL) <> DS_OK then
   raise Exception.Create('Ошибка создания звукового буфера');

  ret:=DSB[SBIndex].Lock(0, DSBD.dwBufferBytes, @DSPtr1, @DSBytes1, @DSPtr2, @DSBytes2, 0);

  if ret = DSERR_BUFFERLOST then
  begin
   DSB[SBIndex].Restore;
   if ret <> DS_OK then
    raise Exception.Create('Unable to Lock Sound Buffer');
  end
  else if ret=DSERR_INVALIDCALL then
   showmessage('invalidcall')
  else if ret=DSERR_INVALIDPARAM then
   showmessage('INVALIDPARAM')
  else if ret=DSERR_PRIOLEVELNEEDED then
   showmessage('PRIOLEVELNEEDED');

  Move(PTemp^, DSPtr1^, DSBytes1);

  ret:=DSB[SBIndex].UnLock(DSPtr1, DSBytes1, DSPtr2, DSBytes2);

  if ret <> DS_OK then
   raise Exception.Create('Unable to UnLock Sound Buffer');
  if ret=DSERR_INVALIDCALL then
   showmessage('invalidcall')
  else if ret=DSERR_INVALIDPARAM then
   showmessage('INVALIDPARAM')
  else if ret=DSERR_PRIOLEVELNEEDED then
   showmessage('PRIOLEVELNEEDED');
 end;
end;

// Процедура открытия нового файла
procedure TForm1.Open1Click(Sender: TObject);
var
 i,x:integer;
begin
 if Not OpenDialog1.Execute then Exit;                               // Если не произошло открытия файла - выход
 glGraphics1:=TglGraphics.CreateNew(OpenDialog1.Files[0]);           // иначе создать диалоговое окно открытия файла
 lbl_FileName.Caption:=OpenDialog1.Files[0];                         // вывод пути к файлу

 // Проверка корректности заголовка открываемого WAVE файла
 lbl_ChID.Caption:=' '+glGraphics1.waveDesc.chID;
 if (lbl_ChID.Caption=' '+'RIFF') then (lbl_ChID.Color:=clGreen) else (lbl_ChID.Color:=clRed);

 lbl_Format.Caption:=glGraphics1.waveDesc.fmt;
 if (lbl_Format.Caption='WAVE') then (lbl_Format.Color:=clGreen) else (lbl_Format.Color:=clRed);

 lbl_SubCh1ID.Caption:=glGraphics1.waveDesc.sch1ID;
 if (lbl_SubCh1ID.Caption='fmt ') then (lbl_SubCh1ID.Color:=clGreen) else (lbl_SubCh1ID.Color:=clRed);

 lbl_Chnls.Caption:=IntToStr(glGraphics1.waveDesc.NChans);
 if (glGraphics1.waveDesc.Nchans>0) then (lbl_Chnls.Color:=clGreen) else (lbl_Chnls.Color:=clRed);

 // Если заголовок корректен, выводим информацию на экран
 if glGraphics1.waveDesc.IsHeaderValid then
  begin
   lbl_ChSize.Caption:=IntToStr(glGraphics1.waveDesc.chSize)+' bytes';
   lbl_SubCh1S.Caption:=IntToStr(glGraphics1.waveDesc.sch1S);

   if glGraphics1.waveDesc.AF=1 then
    lbl_AF.Caption:=IntToStr(glGraphics1.waveDesc.AF)+' (PCM)'
   else
    lbl_AF.Caption:=IntToStr(glGraphics1.waveDesc.AF)+' (Compressed)';

   lbl_SR.Caption:=IntToStr(glGraphics1.waveDesc.SR);
   lbl_BR.Caption:=IntToStr(glGraphics1.waveDesc.BR)+' Bps';
   lbl_BA.Caption:=IntToStr(glGraphics1.waveDesc.BA)+' bytes';
   lbl_BPS.Caption:=IntToStr(glGraphics1.waveDesc.BpS);
   lbl_SubCh2ID.Caption:=glGraphics1.waveDesc.Sch2ID;
   lbl_SubCh2S.Caption:=IntToStr(glGraphics1.waveDesc.sch2S);
   lbl_FS.Caption:=IntToStr(glGraphics1.waveDesc.chSize+8)+' bytes';
   lbl_HS.Caption:=IntToStr(20+glGraphics1.waveDesc.sch1S+8)+' bytes';
   glGraphics1.nSamples:=glGraphics1.waveDesc.sch2S div glGraphics1.waveDesc.BA;
   lbl_Smpls.Caption:=IntToStr(glGraphics1.nSamples);

   if (glGraphics1.nSamples = 0) and (glGraphics1.waveDesc.BPS > 0) then
    glGraphics1.waveDesc.drn:=(glGraphics1.waveDesc.chSize+8-HS)/glGraphics1.waveDesc.BPS;
   if (glGraphics1.nSamples > 0) and (glGraphics1.waveDesc.SR > 0) then
    glGraphics1.waveDesc.drn:=Round((glGraphics1.nSamples/glGraphics1.waveDesc.SR)*1000);

   glGraphics1.waveDesc.drn:=trunc(glGraphics1.waveDesc.drn)/1000;
   lbl_Drtn.Caption:=FloatToStr(glGraphics1.waveDesc.drn)+' seconds';
  end;

 // Разблокировка элементов управления
 frchild1.ScrollBar1.Enabled:=True;                                  // полоса прокрутки исходного сигнала
 RadioGroup2.Enabled:=True;
 Edit1.Enabled:=True;
 Edit18.Enabled:=True;
 Edit19.Enabled:=True;
 Edit20.Enabled:=True;
 Edit21.Enabled:=True;
 TrackBar5.Enabled:=True;

 frchild1.ScrollBar1.Max:=glGraphics1.nSamples;                      //  устанавливаем максимум прокрутки в соответствии с окном

 // Настройка полосы регулировки масштаба отображаемого сигнала
 i:=glgraphics1.Calculations(glGraphics1.nSamples,frchild1.Panel1);
 frchild1.ScrollBar1.Position:=0;
 TrackBar5.SelStart:=Ceil(glGraphics1.nSamples/math.power(2,i));      //  Позиция полосы масштаба, с которой начинают отображаться точки сигнала
 TrackBar5.Max:=i+TrackBar5.SelStart;                                 //  Максимальная позиция
 TrackBar5.SelEnd:=TrackBar5.Max;
 TrackBar5.Position:=TrackBar5.Max;

 glgraphics1.TBSelStart:= TrackBar5.SelStart;
 glGraphics1.pps:=strtoint(edit29.Text);
 glgraphics1.tbpos:=TrackBar5.Position;

 frchild1.ScrollBar1.PageSize:=glGraphics1.pps;                      //  устанавливаем размер подвижной части
 frchild2.ScrollBar1.PageSize:=glGraphics1.pps;                      //  полос прокрутки в соответствии с масштабом
 frchild3.ScrollBar1.PageSize:=glGraphics1.pps;                      //

 Analysis1.Items[0].Enabled:=True;                                   // сделать активным пункт меню "Analysis > Spectrogram"

 InitSoundBuffer(frChild1,0,nil,0);
 InitSoundBuffer(frChild1.Panel1,1,@TempBuf[0], length(TempBuf));
 frchild1.BitBtn1.Enabled:=True;

 x:=0;
 for I := 0 to length(tempbuf) do
 begin
  if tempbuf[i]>x then
  x:=tempbuf[i];
 end;

 sleep(1000);
 frchild1.Update(frChild1);
 isFileInit := True;
end;

procedure SetDCPixelFormat(hdc: HDC);
var
 pfd:TPixelFormatDescriptor;
 nPixelFormat:Integer;
begin
 FillChar(pfd, SizeOf (pfd), 0);
 pfd.dwFlags:=PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
 nPixelFormat:=ChoosePixelFormat (hdc, @pfd);
 SetPixelFormat(hdc, nPixelFormat, @pfd);
end;

procedure TForm1.GLFormInitiate(Panel1: TPanel; Panel2: TPanel; Panel3:TPanel);
begin
 dc:=GetDC(frchild1.Panel1.Handle);
 dc2:=GetDC(frchild1.Panel1.Handle);
 dc3:=GetDC(frchild1.Panel1.Handle);
 dc4:=GetDC(Panel1.Handle);

 SetDCPixelFormat(dc);
 SetDCPixelFormat(dc2);
 SetDCPixelFormat(dc3);
 SetDCPixelFormat(dc4);

 hrc:=wglCreateContext(dc);
 hrc2:=wglCreateContext(dc2);
 hrc3:=wglCreateContext(dc3);
 hrc4:=wglCreateContext(dc4);
end;

procedure TForm1.Panel1MouseLeave(Sender: TObject);
begin
 MouseX:=0;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
 frchild2.ScrollBar1.Position:=0;
end;

procedure TForm1.Edit20Click(Sender: TObject);
begin
 glGraphics1.lambda:=strtofloat(Edit20.Text);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked=True then
 begin
  frchild1.issyn:=True;
  frchild2.Scrollbar1.Visible:=False;
  frchild2.Scrollbar1.Position:=frchild1.ScrollBar1.Position;
  frchild3.Scrollbar1.Visible:=False;
  frchild3.Scrollbar1.Position:=frchild1.ScrollBar1.Position;
 end
 else
 begin
  frchild2.Scrollbar1.Visible:=True;
  frchild3.Scrollbar1.Visible:=True;
  frchild1.issyn:=False;
 end;
end;

procedure TForm1.RadioGroup2Click(Sender: TObject);
begin
if RadioGroup2.ItemIndex=0 then
begin
 Edit18.Enabled:=true;
 Edit19.Enabled:=true;
 Updown1.Enabled:=true;
 Updown3.Enabled:=true;
end
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
 DSB[1].Play(0,0,0);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
 DSB[1].Stop;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
 DSB[2].Play(0,0,0);
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
 DSB[2].Stop;
end;

procedure TForm1.Btn_SaveInF_Click(Sender: TObject);
var
 SaveNWF: TextFile; // Новый текстовый файл
 i:integer;
begin
 i:=0;
 SaveDialog1 := TSaveDialog.Create(self);
 SaveDialog1.Title := 'Save your WAVE file';
 SaveDialog1.InitialDir := GetCurrentDir;
 SaveDialog1.Filter := 'WAVE file|*.wav';
 SaveDialog1.DefaultExt := 'wav';
 if SaveDialog1.Execute=True then
 begin
  AssignFile(SaveNWF, SaveDialog1.FileName);
  ReWrite(SaveNWF);
  for i:=0 to Length(DataArr4) do  // пишем в файл...
  begin
   write(SaveNWF,DataArr4[i]);
  end;
  Reset(SaveNWF);
  CloseFile(SaveNWF);
  i:=0;
 end;
end;

procedure TForm1.btn_HideUP_Click(Sender: TObject);
begin
 if GroupBox1.Height<>25 then
 begin
  GroupBox1.Height:=25;
  btn_HideUP.Caption:='▼';
 end
 else
 begin
  GroupBox1.Height:=170;
  btn_HideUP.Caption:='▲';
 end;
end;

procedure TForm1.btn_HideRight_Click(Sender: TObject);
begin
if GroupBox6.Width<>13 then
 begin
  GroupBox6.Width:=13;
  btn_HideRight.Caption:='◄';
 end
 else
 begin
  GroupBox6.Width:=255;
  btn_HideRight.Caption:='►';
 end;
end;

procedure TForm1.Settings1Click(Sender: TObject);
begin
 if settings1.Checked then GroupBox6.Visible:=true else GroupBox6.Visible:=false;
end;

procedure TForm1.Spectrogram1Click(Sender: TObject);
begin
 // Показать форму если закрыта и наоборот
 if spectrum1.Showing=False then spectrum1.Show else spectrum1.Hide;
end;

procedure TForm1.btn_Result_Click(Sender: TObject);
var
 i:integer;
begin
 Kernel:=VarArrayCreate([0, strtoint(Edit1.Text)], varVariant);              // Создаём массив ядра свёртки
 Conv_res:=VarArrayCreate([0, 1], varVariant);                               // Создаём массив результата свёртки
 // Заполняем его сгенерированными значениями
 for i := 0 to strtoint(Edit1.Text)-1 do
 begin
 if RadioGroup2.ItemIndex=0 then       // Гармонический сигнал
  Kernel[i]:=VarComplexCreate(glGraphics1.sinWX(glGraphics1.A, glGraphics1.B, glGraphics1.lambda, i, glGraphics1.fz), 0)
 else if RadioGroup2.ItemIndex=1 then  // Прямоугольный импульс
  Kernel[i]:=VarComplexCreate(glGraphics1.RectPulse(glGraphics1.lambda, glGraphics1.fz, i), 0)
 else if RadioGroup2.ItemIndex=2 then  // Взвешенный синус
  Kernel[i]:=VarComplexCreate((glGraphics1.sinc(glGraphics1.lambda, i, strtoint(unit1.Form1.Edit1.Text))-1)/2, 0)
 end;

 SetLength(Unit1.TempBuf2, strtoint(unit1.Form1.Edit1.Text)-1);

 if Unit1.Form1.RadioGroup2.ItemIndex=0 then
 begin
 for i := 0 to strtoint(unit1.Form1.Edit1.Text)-1 do
  TempBuf2[i]:=trunc(glGraphics1.sinWX(glGraphics1.A, glGraphics1.B, glGraphics1.lambda, i, glGraphics1.fz));
 end
 else if Unit1.Form1.RadioGroup2.ItemIndex=1 then
 begin
 for i := 0 to strtoint(unit1.Form1.Edit1.Text)-1 do
  TempBuf2[i]:=trunc((glGraphics1.RectPulse(glGraphics1.fz, glGraphics1.lambda, i)+1)*127)
 end
 else if Unit1.Form1.RadioGroup2.ItemIndex=2 then
 begin
  for i := 0 to strtoint(unit1.Form1.Edit1.Text)-1 do
  TempBuf2[i]:=trunc((glGraphics1.sinc(glGraphics1.lambda, i, strtoint(unit1.Form1.Edit1.Text)))*127);
 end;

 spectrum1.FFT_convolution(Conv_res,TempBufCmx,Kernel);
 SetLength(Conv_res2,VarArrayHighBound(Conv_res,1)+1);

 for i:= 0 to VarArrayHighBound(conv_res,1) do
  Conv_res2[i]:=(Conv_res[i]+1)*128;

 frchild2.BitBtn3.Enabled:=True;
 frchild2.BitBtn4.Enabled:=True;

 frchild3.BitBtn1.Enabled:=True;
 frchild3.BitBtn2.Enabled:=True;

 CheckBox1.Enabled:=True;

 ProgressBar1.Position:=100;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
 frchild1.GroupBox3.parent:=gridpanel1;
 frchild2.GroupBox4.parent:=gridpanel1;
 frchild3.GroupBox1.parent:=gridpanel1;

 gridpanel1.ControlCollection.AddControl(frchild1.GroupBox3,0,0);

 frchild1.dc:=GetDC(frchild1.panel1.Handle);
 SetDCPixelFormat(frchild1.dc);
 frchild1.hrc:=wglCreateContext(frchild1.dc);

 frchild2.dc:=GetDC(frchild2.panel1.Handle);
 SetDCPixelFormat(frchild2.dc);
 frchild2.hrc:=wglCreateContext(frchild2.dc);

 frchild3.dc:=GetDC(frchild3.panel1.Handle);
 SetDCPixelFormat(frchild3.dc);
 frchild3.hrc:=wglCreateContext(frchild3.dc);
end;

Procedure TForm1.FormCreate(Sender: TObject);
begin
 isFileInit:=False;
 application.HintHidePause:=99999;
 TrackBar5.Enabled:=False;
 scale_min:=1;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
 mousepos:TPoint;
begin
 mousepos.x:=X;
 mousepos.y:=Y;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
 if PtinRect(frchild1.Panel1.ClientRect, frchild1.Panel1.ScreenToClient(MousePos)) or
 PtinRect(frchild2.Panel1.ClientRect, frchild2.Panel1.ScreenToClient(MousePos)) or
 PtinRect(frchild3.Panel1.ClientRect, frchild2.Panel1.ScreenToClient(MousePos)) then
 begin
 if (WheelDelta>0) then
  TrackBar5.Position:=TrackBar5.Position+1
 else
  TrackBar5.Position:=TrackBar5.Position-1;
 end;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
 if isFileInit then frchild1.Update(frChild1);
 if ProgressBar1.Position=100 then
 begin
  frchild2.Update(frChild2);
  frchild3.Update(frChild3);
 end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 FormActivate(Form1);
 frchild1.vgp:=gridpanel1;
 frchild2.vgp:=gridpanel1;
 frchild3.vgp:=gridpanel1;
end;

procedure TForm1.TrackBar5Change(Sender: TObject);
begin
 glGraphics1.pps:=StrToInt(edit29.Text);
 glgraphics1.tbpos:=TrackBar5.Position;
 frchild1.ScrollBar1.PageSize:=glGraphics1.pps;             //  установить размер подвижной части полосы прокрутки первого окна
 frchild2.ScrollBar1.PageSize:=glGraphics1.pps;             //  2-го
 frchild3.ScrollBar1.PageSize:=glGraphics1.pps;             //  3-го

 frchild1.ScrollBar1.Max:=glGraphics1.nSamples;             //  установить максимум прокрутки первого окна
 frchild2.ScrollBar1.Max:=StrToInt(edit1.Text);             //  2-го
 frchild3.ScrollBar1.Max:=glGraphics1.nSamples+StrToInt(edit1.Text);             //  3-го

 if (glGraphics1.pps=glGraphics1.nSamples) then                  //  Если все точки нарисованы, то
 begin
  frchild1.ScrollBar1.Enabled:=False;                                //  сделать неактивным scrollbar1, 2, 3
  frchild2.ScrollBar1.Enabled:=False;                                //
  frchild3.ScrollBar1.Enabled:=False;                                //
 end;

 if (TrackBar5.Position<=TrackBar5.SelStart) then         //  If trackbar's slider in selected area
  Edit29.Text:=inttostr(TrackBar5.Position)               //  then edit.text=slider position = points per screen
 else                                                     //  else conversion: slider position --> real number of points per screen
  Edit29.Text:=inttostr(Round(glGraphics1.nSamples/math.Power(2,(TrackBar5.Max-trackbar5.Position))));

 if strtoint(Edit1.Text)<strtoint(Edit29.Text) then
 begin
  glGraphics1.pps:=StrToInt(edit29.Text);
  frchild2.ScrollBar1.Enabled:=false;
  frchild2.ShowSignal(frchild2.Panel1,dc,hrc);
 end
 else
  frchild2.ScrollBar1.Max:=StrToInt(edit1.Text);

  if isFileInit then frchild1.Update(frChild1);
 end;

procedure TForm1.Unlocked1Click(Sender: TObject);
begin
 frchild1.GroupBox3.parent:=frchild1;

 frchild2.GroupBox4.parent:=frchild2;
 frchild3.GroupBox1.parent:=frchild3;

 frchild1.dc:=GetDC(frchild1.panel1.Handle);
 SetDCPixelFormat(frchild1.dc);
 frchild1.hrc:=wglCreateContext(frchild1.dc);

 frchild2.dc:=GetDC(frchild2.panel1.Handle);
 SetDCPixelFormat(frchild2.dc);
 frchild2.hrc:=wglCreateContext(frchild2.dc);

 frchild3.dc:=GetDC(frchild3.panel1.Handle);
 SetDCPixelFormat(frchild3.dc);
 frchild3.hrc:=wglCreateContext(frchild3.dc);

 gridpanel1.Visible:=false;
end;

procedure TForm1.UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
begin
 UpDown1.Max:=256-StrToInt(Edit19.Text)-5;
 UpDown1.Min:=StrToInt(Edit19.Text)+5;

 glGraphics1.A:=strtofloat(Edit18.Text);
 frchild2.ShowSignal(frchild2.Panel1,frchild2.dc,frchild2.hrc);
end;

procedure TForm1.UpDown3Changing(Sender: TObject; var AllowChange: Boolean);
begin
 glGraphics1.B:=strtofloat(Edit19.Text);
 frchild2.ShowSignal(frchild2.Panel1,frchild2.dc,frchild2.hrc);
end;

procedure TForm1.UpDown4Changing(Sender: TObject; var AllowChange: Boolean);
begin
 glGraphics1.fz:=strtofloat(Edit21.Text);
 frchild2.ShowSignal(frchild2.Panel1,frchild2.dc,frchild2.hrc);
end;
end.
