program Project2;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  window1 in 'window1.pas' {frChild1},
  window2 in 'window2.pas' {frChild2},
  window3 in 'window3.pas' {frChild3},
  Ogl in 'Ogl.pas',
  Spectrum in 'Spectrum.pas' {Spectrum1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrChild2, frChild2);
  Application.CreateForm(TfrChild3, frChild3);
  Application.CreateForm(TfrChild1, frChild1);
  Application.CreateForm(TSpectrum1, Spectrum1);
  Application.CreateForm(TSpectrum1, Spectrum1);
  Application.Run;
end.
