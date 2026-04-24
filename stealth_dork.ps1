# Mendeteksi folder tempat script ini disimpan secara otomatis
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$gowitnessPath = Join-Path $scriptPath "gowitness.exe"

Write-Host "=== Tools Dorking Recon - Stealth Mode V2 ===" -ForegroundColor Cyan
Write-Host "Folder Aktif: $scriptPath" -ForegroundColor Gray

# Cek gowitness di folder script
if (-not (Test-Path $gowitnessPath)) {
    Write-Host "[!] gowitness.exe gak nemu di: $scriptPath" -ForegroundColor Red
    Write-Host "Taro gowitness.exe satu folder sama script ini bro!" -ForegroundColor Yellow
    exit
}

# List file txt di folder script
$txtFiles = Get-ChildItem -Path $scriptPath -Filter *.txt
if ($txtFiles.Count -eq 0) {
    Write-Host "[!] Gak ada file .txt di folder script!" -ForegroundColor Red
    exit
}

Write-Host "`nFile tersedia:" -ForegroundColor Gray
$txtFiles | Select-Object Name

$fileName = Read-Host "`nMasukkan nama file list domain"
$fullFilePath = Join-Path $scriptPath $fileName

if (-not (Test-Path $fullFilePath)) {
    Write-Host "File '$fileName' gak ada!" -ForegroundColor Red ; exit
}

$domains = Get-Content $fullFilePath
$folderName = "Evidence_$(Get-Date -Format 'dd-MM-yyyy_HHmm')"
$fullReportDir = Join-Path $scriptPath $folderName
New-Item -Path $fullReportDir -ItemType Directory | Out-Null

foreach ($domain in $domains) {
    if (-not [string]::IsNullOrWhiteSpace($domain)) {
        Write-Host "`n------------------------------------------------" -ForegroundColor White
        Write-Host "Target: $domain" -ForegroundColor Cyan
        
        # Mega Dork (Satu Tab per Domain buat hindarin Captcha)
        $megaDork = "site:$domain (intitle:slot OR intitle:judi OR intext:gacor OR intext:jackpot OR intitle:hacked OR intext:deface)"
        $url = "https://www.google.com/search?q=$([Uri]::EscapeDataString($megaDork))"
        
        Start-Process $url
        
        Write-Host ">>> Paste URL temuan buat screenshot (N = Lanjut, Q = Stop):" -ForegroundColor Yellow
        $action = Read-Host "Input"

        if ($action -eq "q") { break }
        if ($action -ne "n" -and -not [string]::IsNullOrWhiteSpace($action)) {
            Write-Host "[*] Memotret bukti..." -ForegroundColor Cyan
            # Memanggil gowitness pake path absolut
            & $gowitnessPath single $action --destination $fullReportDir --fullpage
            Write-Host "[V] Berhasil! Cek folder $folderName" -ForegroundColor Green
        }
        
        # Jeda manusiawi
        $jeda = Get-Random -Minimum 5 -Maximum 10
        Start-Sleep -Seconds $jeda
    }
}
Write-Host "`nDone Bro! Semua aman di $fullReportDir" -ForegroundColor Green