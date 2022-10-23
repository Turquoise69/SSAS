unit window3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, ogl, opengl, unit1;

type
  TfrChild3 = class(TForm)
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    ScrollBar1: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GroupBox1DblClick(Sender: TObject);
    procedure OnMove(var Msg: TWMMove); message WM_MOVe;
    procedure ShowSignal(vPanel:TPanel; vdc:hdc; vhrc: hglrc);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
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
  frChild3: TfrChild3;

implementation

{$R *.dfm}
procedure SetDCPixelFormat ( hdc : HDC);
var
 pfd : TPixelFormatDescriptor;
 nPixelFormat : Integer;
begin
 FillChar (pfd, SizeOf (pfd), 0);
 pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
 nPixelFormat := ChoosePixelFormat (hdc, @pfd);
 SetPixelFormat (hdc, nPixelFormat, @pfd);
end;

procedure TfrChild3.BitBtn1Click(Sender: TObject);
begin
 Unit1.Form1.InitSoundBuffer(frChild3.Panel1,3,@conv_res2[0],length(conv_res2));
 unit1.DSB[3].Play(0,0,0);
end;

procedure TfrChild3.BitBtn2Click(Sender: TObject);
begin
 unit1.DSB[3].Stop;
end;

procedure TfrChild3.FormActivate(Sender: TObject);
begin
 GroupBox1.Color:=$565555;
end;

procedure TfrChild3.FormCreate(Sender: TObject);
begin
 dc:=GetDC(panel1.Handle);
 SetDCPixelFormat(dc);
 hrc := wglCreateContext(dc);
 frchild3.SetBounds(0,0,255,255);
end;

procedure TfrChild3.Update(Sender: TObject);
begin
 showSignal(Panel1,dc,hrc);
end;

procedure TfrChild3.FormDeactivate(Sender: TObject);
begin
 GroupBox1.Color:=$FFFFFF;
end;

procedure TfrChild3.ShowSignal(vPanel:TPanel; vdc:hdc; vhrc: hglrc);
begin
 wglMakeCurrent(vdc,vhrc);
 glViewPort(0, 0, vPanel.Width, vPanel.Height);

 glClearColor(1.0, 1.0 ,1.0 ,0.0);
 glClear(GL_COLOR_BUFFER_BIT);     // очистка буфера цвета

 glGraphics1.glDrawMScale(4, scrollbar1.Position, Panel1,True, scrollbar1.Position+glGraphics1.pps, scrollbar1.Position, 2, 1,  True, 128, -127, 2, 1, 3);

 SwapBuffers(vdc);
 wglMakeCurrent(0, 0);
end;

procedure TfrChild3.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if frchild3.Left<0 then
  frchild3.Left:=0;
end;

procedure TfrChild3.GroupBox1DblClick(Sender: TObject);
begin
 if (vgp.RowCollection.Items[2].value=100) then
 begin
  vgp.ColumnCollection.BeginUpdate;
  vgp.RowCollection[0].Value:=3;
  vgp.RowCollection[1].Value:=3;
  vgp.RowCollection[2].Value:=3;
  vgp.ColumnCollection.EndUpdate;
 end
 else
 begin
  vgp.ColumnCollection.BeginUpdate;
  vgp.RowCollection.Items[0].value:=0;
  vgp.RowCollection.Items[1].Value:=0;
  vgp.RowCollection.Items[2].Value:=100;
  vgp.ColumnCollection.EndUpdate;
 end;
end;

procedure TfrChild3.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
 showSignal(Panel1,dc,hrc);
end;

procedure TfrChild3.OnMove(var Msg: TWMMove);
begin
 inherited;
 if frchild3.Left<0 then
  frchild3.Left:=0;
end;
end.

