unit PowerManager;

interface

uses
  Windows, SysUtils, Classes, SyncObjs, Messages;

type
  TWakeUpEvent = procedure(Sender: TObject) of object;

type
  TIsPwrHibernateAllowed = function: Boolean; stdcall;
  TIsPwrSuspendAllowed = function: Boolean; stdcall;
  TLockWorkStation = function: Boolean; stdcall;

type
  TPowerManager = class;
  TWakeUpTimer = class;

  TPowerManager = class(TComponent)
  private
    { Private declarations }
    FWakeUpTimerEnabled: Boolean;
    FOnWakeUp: TWakeUpEvent;
  protected
    { Protected declarations }
  public
    { Public declarations }
    function IsSuspendAllowed: Boolean;
    function IsHibernateAllowed: Boolean;
    function Hibernate(Force: Boolean): Boolean;
    function Suspend(Force: Boolean): Boolean;
    function LockWorkStation: Boolean;
    function Shutdown(Force: Boolean): Boolean;
    function Poweroff(Force: Boolean): Boolean;
    function Reboot(Force: Boolean): Boolean;
    function Logoff(Force: Boolean): Boolean;
    function StartWakeUpTimer(Interval: Cardinal): Boolean;
    function StopWakeUpTimer: Boolean;
    function IsWakeUpTimerEnabled: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property OnWakeUp: TWakeUpEvent read FOnWakeUp write FOnWakeUp;
  end;

  TWakeUpTimer = class(TThread)
  private
    FInterval: Cardinal;
    FStartEvent: TEvent;
    FStopEvent: TEvent;
    FTimer: THandle;
    FOnTimer: TNotifyEvent;
    procedure DoOnTimer;
  protected
    ThreadOwner: TPowerManager;
    procedure Execute; override;
  public
    constructor Create(AThreadOwner: TPowerManager); virtual;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    property Interval: Cardinal read FInterval write FInterval;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;

  end;

var
  DLLHandle: HMODULE;
  FWakeUpTimer: TWakeUpTimer;
  _IsPwrHibernateAllowed: TIsPwrHibernateAllowed;
  _IsPwrSuspendAllowed: TIsPwrSuspendAllowed;
  _LockWorkStation: TLockWorkStation;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Standard', [TPowerManager]);
end;

function _EnablePrivilege(Privilege: String): Boolean;
var
  TokenHandle: THandle;
  TokenPrivileges: TTokenPrivileges;
  ReturnLength: Cardinal;
begin
  Result := False;
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TokenHandle);
  if TokenHandle <> 0 then
  begin
    try
      LookupPrivilegeValue(nil, PAnsiChar(Privilege), TokenPrivileges.Privileges[0].Luid);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      if AdjustTokenPrivileges(TokenHandle, False, TokenPrivileges, 0, nil, ReturnLength) then
        Result := True;
    finally
      CloseHandle(TokenHandle);
    end;
  end;
end;

constructor TPowerManager.Create(AOwner: TComponent);
begin
  inherited;
  _EnablePrivilege('SeShutdownPrivilege');
  DLLHandle := LoadLibrary('powrprof.dll');
  if DLLHandle <> 0 then
  begin
    @_IsPwrHibernateAllowed := GetProcAddress(DLLHandle, 'IsPwrHibernateAllowed');
    @_IsPwrSuspendAllowed := GetProcAddress(DLLHandle, 'IsPwrSuspendAllowed');
    DLLHandle := 0;
  end;
end;

destructor TPowerManager.Destroy;
begin
  inherited;
end;

function TPowerManager.IsHibernateAllowed: Boolean;
begin
  if (@_IsPwrHibernateAllowed = nil) then
  begin
    Result := False;
    Exit;
  end;
  Result := _IsPwrHibernateAllowed;
end;

function TPowerManager.IsSuspendAllowed: Boolean;
begin
  if (@_IsPwrSuspendAllowed = nil) then
  begin
    Result := False;
    Exit;
  end;
  Result := _IsPwrSuspendAllowed;
end;

function TPowerManager.Hibernate(Force: Boolean): Boolean;
begin
  Result := False;
  if (not _IsPwrHibernateAllowed) then
    Exit;
  if Force then
  begin
    if SetSystemPowerState(False, True) then
      Result := True;
  end
  else
  begin
    if SetSystemPowerState(False, False) then
      Result := True;
  end;
end;

function TPowerManager.Suspend(Force: Boolean): Boolean;
begin
  Result := False;
  if (not _IsPwrSuspendAllowed) then
    Exit;
  if Force then
  begin
    if SetSystemPowerState(True, True) then
      Result := True;
  end
  else
  begin
    if SetSystemPowerState(True, False) then
      Result := True;
  end;
end;

function TPowerManager.LockWorkStation: Boolean;
begin
  if (@_LockWorkStation = nil) then
  begin
    Result := False;
    Exit;
  end;
  Result := _LockWorkStation;
end;

function TPowerManager.Shutdown(Force: Boolean): Boolean;
begin
  Result := False;
  if Force then
  begin
    if ExitWindowsEx(EWX_SHUTDOWN or EWX_FORCE, 0) then
      Result := True;
  end
  else
  begin
    if ExitWindowsEx(EWX_SHUTDOWN, 0) then
      Result := True;
  end;
end;

function TPowerManager.Poweroff(Force: Boolean): Boolean;
begin
  Result := False;
  if Force then
  begin
    if ExitWindowsEx(EWX_POWEROFF or EWX_FORCE, 0) then
      Result := True;
  end
  else
  begin
    if ExitWindowsEx(EWX_POWEROFF, 0) then
      Result := True;
  end;
end;

function TPowerManager.Reboot(Force: Boolean): Boolean;
begin
  Result := False;
  if Force then
  begin
    if ExitWindowsEx(EWX_REBOOT or EWX_FORCE, 0) then
      Result := True;
  end
  else
  begin
    if ExitWindowsEx(EWX_REBOOT, 0) then
      Result := True;
  end;
end;

function TPowerManager.Logoff(Force: Boolean): Boolean;
begin
  Result := False;
  if Force then
  begin
    if ExitWindowsEx(EWX_LOGOFF or EWX_FORCE, 0) then
      Result := True;
  end
  else
  begin
    if ExitWindowsEx(EWX_LOGOFF, 0) then
      Result := True;
  end;
end;

constructor TWakeUpTimer.Create(AThreadOwner: TPowerManager);
begin
  inherited
  Create(True);
  ThreadOwner := AThreadOwner;
  FStartEvent := TEvent.Create(nil, False, False, '');
  FStopEvent := TEvent.Create(nil, False, False, '');
  FTimer := CreateWaitableTimer(nil, False, nil);
  FreeOnTerminate := True;
  Resume;
end;

destructor TWakeUpTimer.Destroy;
begin
  FStartEvent.Free;
  FStopEvent.Free;
  CloseHandle(FTimer);
  inherited;
end;

procedure TWakeUpTimer.DoOnTimer;
begin
  if Assigned(ThreadOwner.FOnWakeUp) then
    ThreadOwner.FOnWakeUp(Self);
end;

procedure TWakeUpTimer.Execute;
var
  _Event: array[0..2] of THandle;
  WaitUntil: TDateTime;
  SystemTime: TSystemTime;
  FileTime, LocalFileTime: TFileTime;
begin
  _Event[0] := FStartEvent.Handle;
  _Event[1] := FStopEvent.Handle;
  _Event[2] := FTimer;
  while not Terminated do
  begin
    case WaitForMultipleObjects(3, @_Event, False, INFINITE) of
      WAIT_OBJECT_0:
        begin
          WaitUntil := Now + 1 / 24 / 60 / 60 * Interval;
          DateTimeToSystemTime(WaitUntil, SystemTime);
          SystemTimeToFileTime(SystemTime, LocalFileTime);
          LocalFileTimeToFileTime(LocalFileTime, FileTime);
          SetWaitableTimer(FTimer, TLargeInteger(FileTime), 0, nil, nil, True);
          ThreadOwner.FWakeUpTimerEnabled := True;
        end;
      WAIT_OBJECT_0 + 1:
        begin
          ThreadOwner.FWakeUpTimerEnabled := False;
          CancelWaitableTimer(FTimer);
          Terminate;
        end;
      WAIT_OBJECT_0 + 2:
        begin
          Terminate;
          ThreadOwner.FWakeUpTimerEnabled := False;
          Synchronize(DoOnTimer);
        end;
    end;
  end;
end;

procedure TWakeUpTimer.Start;
begin
  FStartEvent.SetEvent;
end;

procedure TWakeUpTimer.Stop;
begin
  FStopEvent.SetEvent;
end;

function TPowerManager.StartWakeUpTimer(Interval: Cardinal): Boolean;
begin
  Result := False;
  if FWakeUpTimerEnabled = False then
  begin
    FWakeUpTimer := TWakeUpTimer.Create(Self);
    FWakeUpTimer.Interval := Interval;
    FWakeUpTimer.Start;
    Result := True;
  end;
end;

function TPowerManager.StopWakeUpTimer: Boolean;
begin
  Result := False;
  if FWakeUpTimerEnabled = True then
  begin
    FWakeUpTimer.Stop;
    Result := True;
  end;
end;

function TPowerManager.IsWakeUpTimerEnabled: Boolean;
begin
  Result := FWakeUpTimerEnabled;
end;

end.

 