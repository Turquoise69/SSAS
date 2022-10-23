unit window1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, opengl,ogl,window2,window3,
  Vcl.ComCtrls, unit1;

type

  TfrChild1 = class(TForm)
    GroupBox3: TGroupBox;
    ScrollBar1: TScrollBar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Update(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure SetDCPixelFormat (hdc : HDC);
    procedure Panel1DblClick(Sender: TObject); overload;
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure ShowSignal(vPanel:TPanel; vdc:hdc; vhrc: hglrc);
    procedure BitBtn2Click(Sender: TObject);

    private
    { Private declarations }
  public
    { Public declarations }
    dc:hdc;
    hrc: hglrc;
    vgp:TGridPanel;
    issyn:boolean;
  end;

var
  frChild1: TfrChild1;


implementation

{$R *.dfm}


procedure tfrchild1.SetDCPixelFormat (hdc : HDC);
var
 pfd : TPixelFormatDescriptor;
 nPixelFormat : Integer;
begin
 FillChar (pfd, SizeOf (pfd), 0);
 pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
 nPixelFormat := ChoosePixelFormat (hdc, @pfd);
 SetPixelFormat (hdc, nPixelFormat, @pfd);
end;

procedure TfrChild1.BitBtn1Click(Sender: TObject);
begin
 unit1.DSB[1].Play(0,0,0);
end;

procedure TfrChild1.BitBtn2Click(Sender: TObject);
begin
 unit1.DSB[1].Stop;
end;

procedure TfrChild1.FormCreate(Sender: TObject);
var
 tc:TComponent;
begin
 dc:=GetDC(panel1.Handle);
 SetDCPixelFormat(dc);
 hrc:=wglCreateContext(dc);
end;

procedure TfrChild1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
 showmessage(' ');
end;

procedure TfrChild1.Panel1DblClick(Sender: TObject);
begin
 if (vgp.RowCollection.Items[0].value=100) then
 begin
  vgp.ColumnCollection.BeginUpdate;
  vgp.RowCollection[2].Value:=3;
  vgp.RowCollection[1].Value:=3;
  vgp.RowCollection[0].Value:=3;
  vgp.ColumnCollection.EndUpdate;
 end
 else
 begin
  vgp.ColumnCollection.BeginUpdate;
  vgp.RowCollection.Items[0].value:=100;
  vgp.RowCollection.Items[1].Value:=0;
  vgp.RowCollection.Items[2].Value:=0;
  vgp.ColumnCollection.EndUpdate;
 end;
end;

procedure TfrChild1.Update(Sender: TObject);
begin
 showSignal(Panel1,dc,hrc);
end;

procedure TfrChild1.ShowSignal(vPanel:TPanel; vdc:hdc; vhrc: hglrc);
var
 start_I, XMax, XMin: integer;
begin
 wglMakeCurrent(vdc,vhrc);
 glViewPort(0, 0, vPanel.Width, vPanel.Height);

 glClearColor(1.0, 1.0 ,1.0 ,0.0);
 glClear(GL_COLOR_BUFFER_BIT);     // очистка буфера цвета

 start_I:=scrollbar1.Position;
 XMin:=scrollbar1.Position;
 XMax:=XMin+glGraphics1.pps;

 glGraphics1.glDrawMScale(2, start_I, Panel1, True, XMax, XMin, 2, 1,  True, 127, -127, 2, 1, 3);

 SwapBuffers(vdc);
 wglMakeCurrent(0, 0);
end;

procedure TfrChild1.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
 if issyn then
 begin
  frchild2.ScrollBar1.Position:=scrollbar1.Position;
  frchild3.ScrollBar1.Position:=scrollbar1.Position;
  frchild2.ScrollBar1Scroll(sender, scrollcode,scrollpos);
  frchild3.ScrollBar1Scroll(sender, scrollcode,scrollpos);
 end;
 showSignal(Panel1,dc,hrc);
end;
end.
