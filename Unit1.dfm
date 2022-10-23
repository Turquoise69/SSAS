object Form1: TForm1
  Left = 0
  Top = 0
  Width = 1133
  Height = 819
  ParentCustomHint = False
  HorzScrollBar.Visible = False
  VertScrollBar.ButtonSize = 4
  VertScrollBar.Color = clLime
  VertScrollBar.Margin = 1
  VertScrollBar.ParentColor = False
  VertScrollBar.Visible = False
  AutoScroll = True
  BiDiMode = bdLeftToRight
  Caption = 'VASIC v1.0'
  Color = clAppWorkSpace
  Constraints.MaxHeight = 10000
  Constraints.MaxWidth = 10000
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  ParentBiDiMode = False
  ScreenSnap = True
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 1117
    Height = 165
    Align = alTop
    BiDiMode = bdLeftToRight
    Caption = 'Information'
    Color = clWhite
    Ctl3D = False
    DoubleBuffered = False
    ParentBackground = False
    ParentBiDiMode = False
    ParentColor = False
    ParentCtl3D = False
    ParentDoubleBuffered = False
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 1
      Top = 47
      Width = 1115
      Height = 107
      Align = alClient
      Caption = 'Wave Header'
      TabOrder = 0
      object Label1: TLabel
        Tag = 1
        Left = -20
        Top = 18
        Width = 102
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'ChunkID:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_SubCh1S: TLabel
        AlignWithMargins = True
        Left = 88
        Top = 88
        Width = 113
        Height = 14
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label11: TLabel
        AlignWithMargins = True
        Left = 215
        Top = 18
        Width = 79
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'SubChunk2ID:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_SubCh2ID: TLabel
        AlignWithMargins = True
        Left = 300
        Top = 18
        Width = 113
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_SubCh2S: TLabel
        Left = 300
        Top = 35
        Width = 113
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label15: TLabel
        Tag = 1
        Left = 207
        Top = 52
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Audio Format :'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_AF: TLabel
        Tag = 1
        Left = 300
        Top = 52
        Width = 121
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label17: TLabel
        AlignWithMargins = True
        Left = 209
        Top = 70
        Width = 85
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Channels:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_Chnls: TLabel
        AlignWithMargins = True
        Left = 300
        Top = 70
        Width = 119
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label19: TLabel
        Left = 207
        Top = 89
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Sample Rate (hz):'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_ChID: TLabel
        Tag = 1
        Left = 88
        Top = 18
        Width = 113
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        ShowAccelChar = False
        Transparent = False
      end
      object lbl_SR: TLabel
        Left = 300
        Top = 89
        Width = 121
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label21: TLabel
        Left = 419
        Top = 18
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Byte Rate:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_BR: TLabel
        Left = 512
        Top = 18
        Width = 121
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label23: TLabel
        Left = 419
        Top = 35
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Block Align:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_BA: TLabel
        Left = 512
        Top = 35
        Width = 121
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label25: TLabel
        Left = 419
        Top = 52
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Bits Per Sample:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_BPS: TLabel
        Left = 512
        Top = 52
        Width = 121
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label27: TLabel
        Left = 419
        Top = 70
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'File Size:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_FS: TLabel
        Left = 512
        Top = 70
        Width = 121
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label29: TLabel
        Tag = 1
        Left = 427
        Top = 89
        Width = 79
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Duration:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label3: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 35
        Width = 79
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = ' Chunk size:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_Drtn: TLabel
        Tag = 1
        Left = 512
        Top = 89
        Width = 121
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label31: TLabel
        Left = 615
        Top = 18
        Width = 79
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Samples:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_Smpls: TLabel
        Left = 700
        Top = 18
        Width = 121
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label33: TLabel
        Left = 615
        Top = 35
        Width = 79
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Header Size:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_HS: TLabel
        Left = 700
        Top = 35
        Width = 121
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 52
        Width = 79
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        BiDiMode = bdLeftToRight
        Caption = 'Format:'
        Color = clWhite
        ParentBiDiMode = False
        ParentColor = False
        Transparent = False
      end
      object lbl_Format: TLabel
        AlignWithMargins = True
        Left = 88
        Top = 52
        Width = 113
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label7: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 70
        Width = 79
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'SubChunk1ID:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_SubCh1ID: TLabel
        AlignWithMargins = True
        Left = 88
        Top = 70
        Width = 113
        Height = 13
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label9: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 88
        Width = 79
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'SubChunk1Size:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_ChSize: TLabel
        Left = 88
        Top = 35
        Width = 113
        Height = 14
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 215
        Top = 35
        Width = 79
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'SubChunk2Size:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label13: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 115
        Width = 79
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'SChunk2Size:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
    end
    object GroupBox7: TGroupBox
      Left = 1
      Top = 14
      Width = 1115
      Height = 33
      Align = alTop
      Color = clCream
      ParentBackground = False
      ParentColor = False
      TabOrder = 1
      DesignSize = (
        1115
        33)
      object Label43: TLabel
        Tag = 1
        Left = 8
        Top = 9
        Width = 22
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'File:'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object lbl_FileName: TLabel
        Tag = 1
        Left = 44
        Top = 9
        Width = 1063
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '-'
        Color = clWhite
        ParentColor = False
        ShowAccelChar = False
        Transparent = False
      end
    end
    object btn_HideUP: TButton
      Left = 1
      Top = 154
      Width = 1115
      Height = 10
      Align = alBottom
      Caption = #9650
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -5
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      WordWrap = True
      OnClick = btn_HideUP_Click
    end
  end
  object GroupBox6: TGroupBox
    Left = 863
    Top = 165
    Width = 254
    Height = 596
    Align = alRight
    Caption = 'Settings'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      254
      596)
    object Label49: TLabel
      Left = 17
      Top = 18
      Width = 40
      Height = 13
      Caption = 'Density:'
    end
    object Label51: TLabel
      Left = 50
      Top = 149
      Width = 10
      Height = 13
      Caption = #955':'
    end
    object Label53: TLabel
      Left = 147
      Top = 149
      Width = 18
      Height = 13
      Caption = #966'o:'
    end
    object Label54: TLabel
      Left = 56
      Top = 543
      Width = 83
      Height = 13
      Caption = 'Points per screen'
    end
    object Label56: TLabel
      Left = 49
      Top = 124
      Width = 11
      Height = 13
      Caption = 'A:'
    end
    object Label57: TLabel
      Left = 155
      Top = 126
      Width = 10
      Height = 13
      Caption = 'B:'
    end
    object Label58: TLabel
      Left = 85
      Top = 182
      Width = 59
      Height = 13
      Caption = 'Kernel width'
    end
    object btn_SaveInF: TButton
      Left = 104
      Top = 268
      Width = 81
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Save in file'
      Enabled = False
      TabOrder = 0
      OnClick = btn_SaveInF_Click
    end
    object btn_Result: TButton
      Left = 56
      Top = 237
      Width = 177
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Convolve signals'
      TabOrder = 1
      OnClick = btn_Result_Click
    end
    object Edit20: TEdit
      Left = 66
      Top = 147
      Width = 41
      Height = 19
      Anchors = [akTop, akRight]
      Color = clSilver
      Enabled = False
      TabOrder = 2
      Text = '15'
    end
    object Edit18: TEdit
      Left = 66
      Top = 124
      Width = 45
      Height = 19
      Anchors = [akTop, akRight]
      Color = clSilver
      Enabled = False
      TabOrder = 3
      Text = '128'
    end
    object UpDown1: TUpDown
      Left = 111
      Top = 124
      Width = 12
      Height = 19
      Anchors = [akTop, akRight]
      Associate = Edit18
      Max = 200
      Position = 128
      TabOrder = 4
      Thousands = False
      OnChanging = UpDown1Changing
    end
    object UpDown2: TUpDown
      Left = 107
      Top = 147
      Width = 12
      Height = 19
      Anchors = [akTop, akRight]
      Associate = Edit20
      Max = 99999
      Position = 15
      TabOrder = 5
      Wrap = True
    end
    object Edit19: TEdit
      Left = 167
      Top = 122
      Width = 45
      Height = 19
      Anchors = [akTop, akRight]
      BevelInner = bvNone
      BevelOuter = bvNone
      Color = clSilver
      Ctl3D = False
      Enabled = False
      NumbersOnly = True
      ParentCtl3D = False
      TabOrder = 6
      Text = '117'
    end
    object UpDown3: TUpDown
      Left = 212
      Top = 122
      Width = 12
      Height = 19
      Anchors = [akTop, akRight]
      Associate = Edit19
      Max = 117
      Position = 117
      TabOrder = 7
      Thousands = False
      OnChanging = UpDown3Changing
    end
    object Edit21: TEdit
      Left = 167
      Top = 147
      Width = 44
      Height = 19
      Anchors = [akTop, akRight]
      Color = clSilver
      Enabled = False
      TabOrder = 8
      Text = '0'
    end
    object UpDown4: TUpDown
      Left = 211
      Top = 147
      Width = 12
      Height = 19
      Anchors = [akTop, akRight]
      Associate = Edit21
      TabOrder = 9
      Thousands = False
      OnChanging = UpDown4Changing
    end
    object CheckBox1: TCheckBox
      Left = 145
      Top = 205
      Width = 97
      Height = 17
      BiDiMode = bdRightToLeft
      Caption = 'Synchro'
      Enabled = False
      ParentBiDiMode = False
      TabOrder = 10
      OnClick = CheckBox1Click
    end
    object TrackBar5: TTrackBar
      Tag = 1
      Left = 14
      Top = 37
      Width = 27
      Height = 500
      Anchors = [akLeft, akTop, akRight]
      Ctl3D = False
      Enabled = False
      Max = 4
      Min = 3
      Orientation = trVertical
      ParentCtl3D = False
      ParentShowHint = False
      PageSize = 1
      Position = 3
      PositionToolTip = ptRight
      SelEnd = 10
      SelStart = 1
      ShowHint = True
      TabOrder = 11
      OnChange = TrackBar5Change
    end
    object Edit29: TEdit
      Left = 17
      Top = 540
      Width = 33
      Height = 19
      Color = clSilver
      Enabled = False
      TabOrder = 12
      Text = '3'
    end
    object btn_HideRight: TButton
      Left = 1
      Top = 14
      Width = 10
      Height = 581
      Align = alLeft
      Caption = #9658
      TabOrder = 13
      WordWrap = True
      OnClick = btn_HideRight_Click
    end
    object Edit1: TEdit
      Left = 150
      Top = 180
      Width = 94
      Height = 19
      Enabled = False
      TabOrder = 14
      Text = '8096'
      OnChange = Edit1Change
    end
    object ProgressBar1: TProgressBar
      Left = 56
      Top = 425
      Width = 177
      Height = 17
      TabOrder = 15
    end
    object RadioGroup2: TRadioGroup
      Left = 39
      Top = 41
      Width = 204
      Height = 73
      Caption = 'Kernel function'
      Color = clWhite
      Enabled = False
      ItemIndex = 2
      Items.Strings = (
        'f(x(i))=A+B*cos((4*pi/'#955')*x(i)+'#966'o)'
        'Rectangular pulse ('#966'o - shft, '#955' - len) '
        'Sin(2*pi*'#955'*x)/x')
      ParentBackground = False
      ParentColor = False
      TabOrder = 16
      OnClick = RadioGroup2Click
    end
  end
  object GridPanel1: TGridPanel
    Left = 0
    Top = 165
    Width = 863
    Height = 596
    ParentCustomHint = False
    Align = alClient
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Color = clInactiveCaptionText
    ColumnCollection = <
      item
        Value = 1.970705053790393000
      end
      item
        Value = 98.030127462340670000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = Panel1
        Row = 0
      end
      item
        Column = 0
        Control = Panel2
        Row = 1
      end
      item
        Column = 0
        Control = Panel3
        Row = 2
      end>
    Ctl3D = False
    UseDockManager = False
    DragKind = dkDock
    FullRepaint = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentBackground = False
    ParentCtl3D = False
    ParentFont = False
    RowCollection = <
      item
        Value = 26.580752332169760000
      end
      item
        Value = 26.580752332169770000
      end
      item
        Value = 46.979865771812080000
      end>
    ShowCaption = False
    TabOrder = 2
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 17
      Height = 158
      Align = alClient
      Caption = #9658
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 0
      Top = 158
      Width = 17
      Height = 158
      Align = alClient
      Caption = #9658
      TabOrder = 1
    end
    object Panel3: TPanel
      Left = 0
      Top = 316
      Width = 17
      Height = 280
      Align = alClient
      Caption = #9658
      TabOrder = 2
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'WAVE files only|*.wav'
    Left = 1048
    Top = 63
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    Left = 120
    Top = 63
  end
  object SaveDialog1: TSaveDialog
    Left = 984
    Top = 47
  end
  object MainMenu1: TMainMenu
    Left = 118
    Top = 118
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
    end
    object ghj1: TMenuItem
      AutoCheck = True
      AutoHotkeys = maManual
      AutoLineReduction = maManual
      Caption = 'Windows'
      object Information1: TMenuItem
        AutoCheck = True
        Caption = 'Information'
        Checked = True
        OnClick = Information1Click
      end
      object Settings1: TMenuItem
        AutoCheck = True
        Caption = 'Settings'
        Checked = True
        OnClick = Settings1Click
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object Locked1: TMenuItem
        AutoCheck = True
        Caption = 'Locked'
        Checked = True
        RadioItem = True
        OnClick = Locked1Click
      end
      object Unlocked1: TMenuItem
        AutoCheck = True
        Caption = 'Unlocked'
        RadioItem = True
        OnClick = Unlocked1Click
      end
    end
    object Analysis1: TMenuItem
      Caption = 'Analysis'
      object Spectrogram1: TMenuItem
        Caption = 'Spectrogram'
        Enabled = False
        OnClick = Spectrogram1Click
      end
    end
  end
end
