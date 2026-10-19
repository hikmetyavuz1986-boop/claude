# Bir HTML animasyonunu Chrome'da kare kare çekip 15 sn'lik MP4'e çevirir.
# Kullanım: powershell -ExecutionPolicy Bypass -File render.ps1 -Html A-konu-eksikleri.html
param(
  [Parameter(Mandatory)] [string]$Html,
  [int]$Fps = 30,
  [double]$Seconds = 15
)
$ErrorActionPreference = 'Stop'
$here   = Split-Path -Parent $MyInvocation.MyCommand.Path
$page   = Join-Path $here $Html
$name   = [IO.Path]::GetFileNameWithoutExtension($Html)
$frames = Join-Path $env:TEMP "zeus-frames-$name"
$outDir = Join-Path (Split-Path $here -Parent | Split-Path -Parent) 'reklamlar\reels-video'
$chrome = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
$ffmpeg = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Recurse -Filter ffmpeg.exe | Select-Object -First 1 -ExpandProperty FullName
$port   = 9333

Remove-Item $frames -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $frames, $outDir | Out-Null
$userData = Join-Path $env:TEMP "zeus-chrome-profile"

$proc = Start-Process $chrome -PassThru -ArgumentList @(
  '--headless=new', "--remote-debugging-port=$port", "--user-data-dir=$userData",
  '--hide-scrollbars', '--window-size=1080,1920', '--force-device-scale-factor=1',
  '--disable-gpu', '--no-first-run', 'about:blank')

try {
  $ws = $null
  for ($i = 0; $i -lt 80 -and -not $ws; $i++) {
    Start-Sleep -Milliseconds 500
    try { $list = Invoke-RestMethod "http://127.0.0.1:$port/json"; $ws = ($list | Where-Object { $_.type -eq 'page' } | Select-Object -First 1).webSocketDebuggerUrl } catch {}
  }
  if (-not $ws) { throw 'Chrome could not start.' }

  $sock = New-Object System.Net.WebSockets.ClientWebSocket
  $sock.Options.KeepAliveInterval = [TimeSpan]::FromSeconds(30)
  $sock.ConnectAsync([Uri]$ws, [Threading.CancellationToken]::None).Wait()
  $script:id = 0
  $buf = New-Object byte[] 1048576

  function Cdp([string]$method, $params = @{}) {
    $script:id++
    $msg = @{ id = $script:id; method = $method; params = $params } | ConvertTo-Json -Depth 10 -Compress
    $bytes = [Text.Encoding]::UTF8.GetBytes($msg)
    $sock.SendAsync((New-Object ArraySegment[byte] -ArgumentList (, $bytes)), 'Text', $true, [Threading.CancellationToken]::None).Wait()
    while ($true) {
      $ms = New-Object IO.MemoryStream
      do {
        $r = $sock.ReceiveAsync((New-Object ArraySegment[byte] -ArgumentList (, $buf)), [Threading.CancellationToken]::None).Result
        $ms.Write($buf, 0, $r.Count)
      } while (-not $r.EndOfMessage)
      $obj = [Text.Encoding]::UTF8.GetString($ms.ToArray()) | ConvertFrom-Json
      if ($obj.id -eq $script:id) {
        if ($obj.error) { throw "$method : $($obj.error.message)" }
        return $obj.result
      }
    }
  }

  Cdp 'Emulation.setDeviceMetricsOverride' @{ width = 1080; height = 1920; deviceScaleFactor = 1; mobile = $false } | Out-Null
  Cdp 'Page.enable' | Out-Null
  Cdp 'Page.navigate' @{ url = ([Uri]$page).AbsoluteUri } | Out-Null
  Start-Sleep -Seconds 2
  $ready = "Promise.all([document.fonts.ready, ...[...document.images].map(i => i.complete ? 1 : new Promise(r => { i.onload = i.onerror = r }))]).then(() => new Promise(r => setTimeout(r, 500))).then(() => document.fonts.size)"
  Cdp 'Runtime.evaluate' @{ expression = $ready; awaitPromise = $true } | Out-Null

  $total = [int]($Fps * $Seconds)
  for ($f = 0; $f -lt $total; $f++) {
    $t = [math]::Round($f * 1000.0 / $Fps, 3)
    $js = "document.getAnimations().forEach(a => { a.pause(); a.currentTime = $t }); new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)))"
    Cdp 'Runtime.evaluate' @{ expression = $js; awaitPromise = $true } | Out-Null
    $shot = Cdp 'Page.captureScreenshot' @{ format = 'jpeg'; quality = 95; captureBeyondViewport = $false }
    [IO.File]::WriteAllBytes((Join-Path $frames ('{0:D4}.jpg' -f $f)), [Convert]::FromBase64String($shot.data))
    if ($f % 75 -eq 0) { Write-Host "  kare $f / $total" }
  }
  $sock.Dispose()
}
finally {
  if ($proc -and -not $proc.HasExited) { Stop-Process -Id $proc.Id -Force }
}

$mp4 = Join-Path $outDir "$name.mp4"
& $ffmpeg -y -hide_banner -loglevel error -framerate $Fps -i (Join-Path $frames '%04d.jpg') -f lavfi -t $Seconds -i 'anullsrc=r=44100:cl=stereo' `
  -map 0:v -map 1:a -c:v libx264 -preset medium -crf 19 -pix_fmt yuv420p -r $Fps -c:a aac -b:a 128k -shortest -movflags +faststart $mp4
Write-Host ("HAZIR: {0}  ({1:N1} MB)" -f $mp4, ((Get-Item $mp4).Length / 1MB))
