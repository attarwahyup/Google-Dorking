Write-Host "=== Tools Dorking Recon - Mode Windows ===" -ForegroundColor Cyan

# List file .txt yang ada di folder biar lu gak lupa namanya
Write-Host "`nFile yang tersedia di folder ini:" -ForegroundColor Gray
Get-ChildItem *.txt | Select-Object Name

# Input nama file dari user
$fileName = Read-Host "`nMasukkan nama file list domain (contoh: sub-kementan.txt)"

# Cek apakah file ada
if (-not (Test-Path $fileName)) {
    Write-Host "Waduh! File '$fileName' gak nemu. Pastiin ngetiknya bener bro." -ForegroundColor Red
    exit
}

# Daftar Dork Maut
$dorks = @(
    'intitle:"slot" | intitle:"judi" | intitle:"togel" | intitle:"casino"',
    'intext:"slot gacor" | intext:"jackpot" | intext:"maxwin" | intext:"bet"',
    'inurl:"slot" | inurl:"bet" | inurl:"deposit" | inurl:"poker"',
    'intitle:"hacked by" | intitle:"defaced by" | intext:"security was an illusion"',
    'inurl:wp-config.php.bak | inurl:.env | intitle:"index of" "sh.php"'
)

$domains = Get-Content $fileName

Write-Host "`n[!] Memulai scanning dari file: $fileName" -ForegroundColor Yellow

foreach ($domain in $domains) {
    if (-not [string]::IsNullOrWhiteSpace($domain)) {
        Write-Host "`nTarget: $domain" -ForegroundColor White
        
        foreach ($dork in $dorks) {
            $query = "site:$domain $dork"
            $encodedQuery = [Uri]::EscapeDataString($query)
            $url = "https://www.google.com/search?q=$encodedQuery"
            
            Write-Host "[+] Dork: $query"
            
            # Membuka link otomatis
            Start-Process $url
            
            # Jeda dikit biar gak dianggap serangan DDoS ama Google (CAPTCHA)
            Start-Sleep -Seconds 2
        }
    }
}

Write-Host "`n------------------------------------------------" -ForegroundColor Cyan
Write-Host "Beres! Cek tab browser lu satu-satu." -ForegroundColor Green