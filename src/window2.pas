unit window2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, ogl, opengl, unit1, varcmplx;

type
  TfrChild2 = class(TForm)
    GroupBox4: TGroupBox;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    ScrollBar1: TScrollBar;
    Panel1: TPanel;
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox4DblClick(Sender: TObject);
    procedure ShowSignal(vPanel:TPanel; vdc:hdc; vhrc: hglrc);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Update(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    dc:hdc;
    hrc: hglrc;
    vgp:TGridPanel;
  end;

var
  frChild2: TfrChild2;

implementation

{$R *.dfm}

procedure SetDCPixelFormat (hdc : HDC);
var
 pfd:TPixelFormatDescriptor;
 nPixelFormat:Integer;
begin
 FillChar(pfd, SizeOf (pfd), 0);
 pfd.dwFlags:=PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
 nPixelFormat:=ChoosePixelFormat (hdc, @pfd);
 SetPixelFormat(hdc, nPixelFormat, @pfd);
end;

procedure TfrChild2.BitBtn3Click(Sender: TObject);
begin
 Unit1.Form1.InitSoundBuffer(frChild2.Panel1,2,@TempBuf2[0],length(conv_res2));
 unit1.DSB[2].Play(0,0,0);
end;

procedure TfrChild2.BitBtn4Click(Sender: TObject);
begin
 unit1.DSB[2].Stop;
end;

procedure TfrChild2.FormCreate(Sender: TObject);
begin
 dc:=GetDC(Panel1.Handle);
 SetDCPixelFormat(dc);
 hrc:=wglCreateContext(dc);
end;

procedure TfrChild2.Update(Sender: TObject);
begin
 showSignal(Panel1,dc,hrc);
end;

procedure TfrChild2.ShowSignal(vPanel:TPanel; vdc:hdc; vhrc: hglrc);
var
 start_I, XMax, XMin: integer;
begin
 wglMakeCurrent(vdc,vhrc);
 glViewPort(0, 0, vPanel.Width, vPanel.Height);

 glClearColor(1.0, 1.0 ,1.0 ,0.0);
 glClear(GL_COLOR_BUFFER_BIT);     // очистка буфера цвета

 start_I:=scrollbar1.Position;
 XMin:=start_I;
 XMax:=XMin+glGraphics1.pps;

 if Unit1.Form1.RadioGroup2.ItemIndex=0 then
  glGraphics1.glDrawMScale(3, start_I, Panel1, True, XMax, XMin, 2, 1,  True, 128, -127, 2, 1, 3)
 else if Unit1.Form1.RadioGroup2.ItemIndex=1 then
  glGraphics1.glDrawMScale(5, start_I, Panel1, True, XMax, XMin, 2, 1,  True, 128, -127, 2, 1, 3)
 else if Unit1.Form1.RadioGroup2.ItemIndex=2 then
  glGraphics1.glDrawMScale(6, start_I, Panel1, True, XMax, XMin, 2, 1,  True, 128, -127, 2, 1, 3);

 SwapBuffers(vdc);
 wglMakeCurrent(0, 0);
end;

procedure TfrChild2.GroupBox4DblClick(Sender: TObject);
begin
 if (vgp.RowCollection[1].value=100) then
 begin
  vgp.ColumnCollection.BeginUpdate;
  vgp.RowCollection[2].Value:=3;
  vgp.RowCollection[0].Value:=3;
  vgp.RowCollection[1].Value:=3;
  vgp.ColumnCollection.EndUpdate;
 end
 else
 begin
  vgp.ColumnCollection.BeginUpdate;
  vgp.RowCollection.Items[0].value:=0;
  vgp.RowCollection.Items[1].Value:=100;
  vgp.RowCollection.Items[2].Value:=0;
  vgp.ColumnCollection.EndUpdate;
 end;
end;

procedure TfrChild2.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
 showSignal(Panel1,dc,hrc);
end;
end.
