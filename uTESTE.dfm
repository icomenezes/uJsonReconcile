object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 483
  ClientWidth = 1050
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btn_open: TButton
    Left = 24
    Top = 8
    Width = 105
    Height = 25
    Caption = 'Gerar Um'
    TabOrder = 0
    OnClick = btn_openClick
  end
  object memo: TMemo
    Left = 24
    Top = 80
    Width = 993
    Height = 377
    TabOrder = 1
  end
  object btn_openAll: TButton
    Left = 24
    Top = 39
    Width = 105
    Height = 25
    Caption = 'Gerar V'#225'rios'
    TabOrder = 2
    OnClick = btn_openAllClick
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DataSource=RICARDOAPI'
      'DriverID=ODBC')
    LoginPrompt = False
    Left = 392
    Top = 16
  end
end
