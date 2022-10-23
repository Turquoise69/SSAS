object Spectrum1: TSpectrum1
  Left = 0
  Top = 0
  Caption = 'Spectrum1'
  ClientHeight = 536
  ClientWidth = 1044
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 859
    Height = 536
    Align = alClient
    Caption = 'Graph'
    TabOrder = 0
    DesignSize = (
      859
      536)
    object Panel1: TPanel
      Left = 16
      Top = 110
      Width = 824
      Height = 403
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBlack
      ParentBackground = False
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 16
      Top = 26
      Width = 824
      Height = 42
      Anchors = [akLeft, akTop, akRight]
      Color = clBlack
      ParentBackground = False
      TabOrder = 1
    end
    object TrackBar1: TTrackBar
      Left = 16
      Top = 74
      Width = 824
      Height = 30
      ParentCustomHint = False
      Anchors = [akLeft, akTop, akRight]
      Ctl3D = False
      DoubleBuffered = False
      LineSize = 0
      Max = 5
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ParentShowHint = False
      PageSize = 1
      ShowHint = False
      TabOrder = 2
      ThumbLength = 22
      TickMarks = tmTopLeft
      OnChange = TrackBar1Change
    end
  end
  object GroupBox2: TGroupBox
    Left = 859
    Top = 0
    Width = 185
    Height = 536
    Align = alRight
    Caption = 'Settings'
    TabOrder = 1
    object Label1: TLabel
      Left = 6
      Top = 16
      Width = 63
      Height = 13
      Caption = 'Window size:'
    end
    object Label12: TLabel
      Left = 16
      Top = 168
      Width = 50
      Height = 13
      Caption = 'Draw grid:'
    end
    object Label13: TLabel
      Left = 23
      Top = 146
      Width = 46
      Height = 13
      Caption = 'Digit size:'
    end
    object Label4: TLabel
      Left = 83
      Top = 168
      Width = 55
      Height = 13
      Caption = 'X presicion:'
    end
    object Label9: TLabel
      Left = 83
      Top = 195
      Width = 55
      Height = 13
      Caption = 'Y presicion:'
    end
    object ComboBox1: TComboBox
      Left = 75
      Top = 13
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '8'
      OnChange = ComboBox1Change
      Items.Strings = (
        '2'
        '4'
        '8'
        '16'
        '32'
        '64'
        '128'
        '256'
        '512'
        '1024'
        '2048'
        '4096'
        '8192')
    end
    object Button1: TButton
      Left = 61
      Top = 291
      Width = 75
      Height = 25
      Caption = 'DFT'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 61
      Top = 322
      Width = 75
      Height = 25
      Caption = 'FFT'
      TabOrder = 2
      OnClick = Button2Click
    end
    object RadioGroup1: TRadioGroup
      Left = 14
      Top = 222
      Width = 78
      Height = 43
      Caption = 'Range'
      ItemIndex = 0
      Items.Strings = (
        '0 - N-1'
        '0 - N/2-1')
      TabOrder = 3
    end
    object CheckListBox1: TCheckListBox
      Left = 16
      Top = 181
      Width = 57
      Height = 35
      ItemHeight = 13
      Items.Strings = (
        'X axis'
        'Y axis')
      TabOrder = 4
    end
    object Edit1: TEdit
      Left = 75
      Top = 143
      Width = 105
      Height = 21
      TabOrder = 5
      Text = '3'
    end
    object Edit3: TEdit
      Left = 144
      Top = 165
      Width = 32
      Height = 21
      TabOrder = 6
      Text = '2'
    end
    object Edit4: TEdit
      Left = 144
      Top = 192
      Width = 30
      Height = 21
      TabOrder = 7
      Text = '2'
    end
    object RadioGroup2: TRadioGroup
      Left = 6
      Top = 37
      Width = 176
      Height = 71
      Caption = 'Window type'
      Items.Strings = (
        'Rectangular'
        'Hann'
        'Hamming'
        'Welch'
        'Sine')
      TabOrder = 8
    end
    object ProgressBar1: TProgressBar
      Left = 19
      Top = 368
      Width = 150
      Height = 17
      TabOrder = 9
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 520
    Top = 176
  end
  object MainMenu1: TMainMenu
    Left = 736
    Top = 88
    object N1231: TMenuItem
      Caption = #1042#1080#1076
      object N2: TMenuItem
        AutoCheck = True
        Caption = #1057#1087#1077#1082#1090#1088' '#1086#1082#1085#1072
        Checked = True
        RadioItem = True
        OnClick = N2Click
      end
      object N1: TMenuItem
        AutoCheck = True
        Caption = #1057#1087#1077#1082#1090#1086#1075#1088#1072#1084#1084#1072
        RadioItem = True
        OnClick = N1Click
      end
    end
  end
end
