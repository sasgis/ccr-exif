{**************************************************************************************}
{                                                                                      }
{ CCR Exif - Delphi class library for reading and writing image metadata               }
{ Version 1.5.3                                                                        }
{                                                                                      }
{ The contents of this file are subject to the Mozilla Public License Version 1.1      }
{ (the "License"); you may not use this file except in compliance with the License.    }
{ You may obtain a copy of the License at http://www.mozilla.org/MPL/                  }
{                                                                                      }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT   }
{ WARRANTY OF ANY KIND, either express or implied. See the License for the specific    }
{ language governing rights and limitations under the License.                         }
{                                                                                      }
{ The Original Code is XMPBrowserForm.pas.                                             }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009-2012 Chris Rolliston. All Rights Reserved.    }
{                                                                                      }
{**************************************************************************************}

unit XMPBrowserForm;
{
  Not much to this one really. Note that according to both Adobe's XMP specification and
  Microsoft's XMP implementation, a schema's properties may be placed at various places
  in the XML structure. As presented by TXMPPacket, however, they are collated under the
  same Schema property.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtDlgs,
  ActnList, StdCtrls, ExtCtrls, ComCtrls, Buttons, CCR.Exif.Demos, XMPBrowserFrame,
  Menus;

type
  TfrmXMPBrowser = class(TForm, IOutputFrameOwner)
    panFooter: TPanel;
    dlgOpen: TOpenPictureDialog;
    btnOpen: TBitBtn;
    btnExit: TBitBtn;
    PageControl: TPageControl;
    tabOriginal: TTabSheet;
    tabResaved: TTabSheet;
    ActionList: TActionList;
    actOpen: TAction;
    lblURI: TLabel;
    mnuURI: TPopupMenu;
    itmCopyURI: TMenuItem;
    procedure actOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure itmCopyURIClick(Sender: TObject);
    procedure lblURIContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    FOriginalFrame, FResavedFrame: TOutputFrame;
  protected
    procedure ActiveURIChanged(const NewURI: string);
    procedure DoFileOpen(const FileName1, FileName2: string); override;
  end;

var
  frmXMPBrowser: TfrmXMPBrowser;

implementation

uses ClipBrd;

{$R *.dfm}

procedure TfrmXMPBrowser.FormCreate(Sender: TObject);
begin
  Application.Title := Caption;
  PageControl.Visible := TestMode;
  FOriginalFrame := TOutputFrame.Create(Self);
  FOriginalFrame.Align := alClient;
  FOriginalFrame.Name := '';
  if not TestMode then
  begin
    FOriginalFrame.Parent := Self;
    panFooter.Height := panFooter.Height - btnOpen.Top;
    btnOpen.Top := 0;
    btnExit.Top := 0;
  end
  else
  begin
    actOpen.Enabled := False;
    actOpen.Visible := False;
    ActiveControl := PageControl;
    FOriginalFrame.Parent := tabOriginal;
    FResavedFrame := TOutputFrame.Create(Self);
    FResavedFrame.Align := alClient;
    FResavedFrame.Parent := tabResaved;
  end;
  SupportOpeningFiles := True;
end;

procedure TfrmXMPBrowser.ActiveURIChanged(const NewURI: string);
begin
  lblURI.Caption := NewURI;
end;

procedure TfrmXMPBrowser.DoFileOpen(const FileName1, FileName2: string);
begin
  FOriginalFrame.LoadFromFile(FileName1);
  if FileName2 = '' then Exit;
  FResavedFrame.LoadFromFile(FileName2);
  tabOriginal.Caption := ExtractFileName(FileName1);
  tabResaved.Caption := ExtractFileName(FileName2);
end;

procedure TfrmXMPBrowser.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmXMPBrowser.actOpenExecute(Sender: TObject);
begin
  if dlgOpen.Execute then OpenFile(dlgOpen.FileName);
end;

procedure TfrmXMPBrowser.itmCopyURIClick(Sender: TObject);
begin
  Clipboard.AsText := lblURI.Caption;
end;

procedure TfrmXMPBrowser.lblURIContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  if lblURI.GetTextLen = 0 then Handled := True; //suppress if nothing to copy
end;

end.
