<#
.SYNOPSIS
    SynaptixLabs KB Sync v2 - Build a clean, indexed KB for Claude Projects.
    Generic scaffold version — customize tier1Paths and excludeDirs for your project.
.DESCRIPTION
    Collects local .md/.pdf/.txt/.jsx files and web URLs into output folders.
    Generates kb-index.json with metadata. Detects obsolete and stale files.
.PARAMETER Type
    File type: all (default), md, pdf, txt, jsx
.PARAMETER Source
    Source area: all (default), docs, sprints, src, root, content, web
.PARAMETER Sprint
    Specific sprint number (e.g. 10). Implies -Source sprints.
.PARAMETER MaxTier
    Maximum tier to include: 1, 2, or 3 (default: 3).
    Tier 1 = 7 essentials. Tier 2 = core docs. Tier 3 = everything else.
.PARAMETER Tier1
    Shortcut for -MaxTier 1 (only 7 essential files).
.PARAMETER WebOnly
    Only fetch web URLs (skip local files).
.PARAMETER Clean
    Wipe output folders before syncing.
.PARAMETER Report
    Show obsolete + stale files report without changes.
.PARAMETER Archive
    Move obsolete files to Archive/ instead of deleting.
.PARAMETER Refresh
    Force re-download of web URLs even if already fetched.
.PARAMETER Scrape
    Web fetch method: markdown (default), pdf, html.
.PARAMETER Stats
    Show KB statistics from existing index without syncing.
.PARAMETER DryRun
    Preview without changes.
.PARAMETER ProjectRoot
    Override project root (default: auto-detect from script location).
.EXAMPLE
    .\sync-kb.ps1                        # Sync everything
    .\sync-kb.ps1 -MaxTier 2            # Only tier 1+2 (~12 files)
    .\sync-kb.ps1 -Tier1                # 7 essentials only
    .\sync-kb.ps1 -Type md              # Only markdown
    .\sync-kb.ps1 -Sprint 10            # Sprint 10 only
    .\sync-kb.ps1 -Source web           # Web URLs only
    .\sync-kb.ps1 -Source web -Refresh  # Re-fetch all URLs
    .\sync-kb.ps1 -Source web -Scrape pdf  # URLs as PDF
    .\sync-kb.ps1 -Report               # Obsolete + stale report
    .\sync-kb.ps1 -Archive              # Archive obsolete
    .\sync-kb.ps1 -Stats                # KB stats from index
    .\sync-kb.ps1 -Clean -MaxTier 2     # Fresh lean KB
    .\sync-kb.ps1 -DryRun               # Preview only
#>
param(
    [ValidateSet("all","md","pdf","txt","jsx")][string]$Type = "all",
    [ValidateSet("all","docs","sprints","src","root","content","web")][string]$Source = "all",
    [int]$Sprint = 0,
    [ValidateSet(1,2,3)][int]$MaxTier = 3,
    [switch]$Tier1,
    [switch]$WebOnly,
    [switch]$Clean,
    [switch]$Report,
    [switch]$Archive,
    [switch]$Refresh,
    [ValidateSet("markdown","pdf","html")][string]$Scrape = "markdown",
    [switch]$Stats,
    [switch]$DryRun,
    [switch]$Help,
    [string]$ProjectRoot = ""
)
$ErrorActionPreference = "Stop"

# -- CONFIG --
if ($ProjectRoot -eq "") {
    $ProjectRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
}
$kbRoot    = Join-Path $ProjectRoot "docs\KB"
$projDocs  = Join-Path $kbRoot "Project docs"
$extDocs   = Join-Path $kbRoot "External docs"
$archDir   = Join-Path $kbRoot "Archive"
$idxFile   = Join-Path $kbRoot "kb-index.json"
$urlsFile  = Join-Path $kbRoot "kb-urls.json"
$logFile   = Join-Path $kbRoot "kb-sync-log.txt"
$staleAge  = 90

if ($Help) { Get-Help $MyInvocation.MyCommand.Path -Detailed; exit 0 }
if ($Tier1) { $MaxTier = 1 }

$extensions = switch ($Type) {
    "md"  { @("*.md") }
    "pdf" { @("*.pdf") }
    "txt" { @("*.txt") }
    "jsx" { @("*.jsx") }
    default { @("*.md","*.pdf","*.txt","*.jsx") }
}

$tier1Paths = @(
    "CLAUDE.md","CODEX.md","AGENTS.md",
    "docs\0k_PRD.md","docs\01_ARCHITECTURE.md",
    "docs\03_MODULES.md","docs\0l_DECISIONS.md"
)
$tier2Patterns = @("^docs--00_","^docs--01_","^docs--02_","^docs--03_",
    "^docs--04_","^docs--05_","^docs--06_","^docs--0k_","^docs--0l_",
    "^docs--ui--","^README\.md$","^CHANGELOG\.md$")
$excludeDirs = @(
    "ARCHIVE","node_modules",".git",".next",".vercel",
    ".windsurf",".claude",".playwright-mcp",".github",
    "playwright-report","test-results","_global","KB"
)
$excludeFiles = @("package-lock.json","tsconfig.tsbuildinfo")

# -- HELPERS --
function Test-Excluded([string]$p) {
    $r = $p.Substring($ProjectRoot.Length + 1)
    foreach ($s in ($r -split "[/\\]")) {
        if ($excludeDirs -contains $s) { return $true }
    }
    return $false
}

function Get-FlatName([string]$p) {
    return ($p.Substring($ProjectRoot.Length + 1) -replace "[/\\]","--")
}

function Get-Tier([string]$flat) {
    $t1flat = $tier1Paths | ForEach-Object { $_ -replace "[/\\]","--" }
    if ($t1flat -contains $flat) { return 1 }
    foreach ($pat in $tier2Patterns) {
        if ($flat -match $pat) { return 2 }
    }
    return 3
}

function Test-SourceOK([string]$p) {
    $r = $p.Substring($ProjectRoot.Length + 1)
    if ($Sprint -gt 0) {
        $tag = "sprint_{0:D2}" -f $Sprint
        return ($r -match [regex]::Escape($tag))
    }
    switch ($Source) {
        "docs"    { return $r.StartsWith("docs\") }
        "sprints" { return $r.StartsWith("docs\sprints\") }
        "src"     { return $r.StartsWith("src\") }
        "content" { return ($r.StartsWith("content\") -or $r.StartsWith("public\")) }
        "root"    { return (-not $r.Contains("\")) }
        "web"     { return $false }
        default   { return $true }
    }
}

function Get-SafeName([string]$n) {
    return ($n -replace '[^a-zA-Z0-9_.\-]','_')
}

function Get-DaysOld([datetime]$modified) {
    return [math]::Round(((Get-Date) - $modified).TotalDays, 0)
}

function Write-Log([string]$msg) {
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$ts | $msg" | Add-Content $logFile -Encoding UTF8
}

function Fetch-WebPage([string]$url, [string]$name, [string]$method, [string]$outDir) {
    $safe = Get-SafeName $name
    try {
        switch ($method) {
            "pdf" {
                $out = Join-Path $outDir "$safe.pdf"
                $wk = Get-Command wkhtmltopdf -ErrorAction SilentlyContinue
                if ($wk) {
                    & wkhtmltopdf --quiet $url $out 2>$null
                    return $out
                }
                Write-Host "    wkhtmltopdf not found (winget install wkhtmltopdf)" -ForegroundColor DarkYellow
                $out = Join-Path $outDir "$safe.html"
                Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
                return $out
            }
            "markdown" {
                $tmp = Join-Path $env:TEMP "$safe.html"
                Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing
                $pc = Get-Command pandoc -ErrorAction SilentlyContinue
                if ($pc) {
                    $out = Join-Path $outDir "$safe.md"
                    & pandoc $tmp -f html -t gfm -o $out 2>$null
                    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
                    return $out
                }
                Write-Host "    pandoc not found (winget install pandoc)" -ForegroundColor DarkYellow
                $out = Join-Path $outDir "$safe.html"
                Move-Item $tmp $out -Force
                return $out
            }
            default {
                $out = Join-Path $outDir "$safe.html"
                Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
                return $out
            }
        }
    } catch {
        Write-Host "    [ERR] $url - $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# -- STATS MODE --
if ($Stats) {
    if (-not (Test-Path $idxFile)) {
        Write-Host "No kb-index.json found. Run a sync first." -ForegroundColor Red; exit 1
    }
    $idx = Get-Content $idxFile -Raw | ConvertFrom-Json
    Write-Host ""
    Write-Host "=== KB Stats ===" -ForegroundColor Cyan
    Write-Host "  Generated: $($idx.generated)"
    Write-Host "  Total: $($idx.totalFiles) files"
    Write-Host "  Tier 1: $($idx.tier1) | Tier 2: $($idx.tier2) | Tier 3: $($idx.tier3)"
    $sc = 0; $bc = 0
    foreach ($f in $idx.files) {
        if ($f.modified) {
            $a = Get-DaysOld ([datetime]$f.modified)
            if ($a -gt $staleAge) { $sc++ }
        }
        if ($f.size -gt 1MB) { $bc++ }
    }
    Write-Host "  Stale (>$staleAge days): $sc"
    Write-Host "  Large (>1MB): $bc"
    $bs = $idx.files | Group-Object { $_.folder } | ForEach-Object { "$($_.Name): $($_.Count)" }
    Write-Host "  By folder: $($bs -join ' | ')"
    Write-Host ""; exit 0
}

# -- INIT --
foreach ($d in @($projDocs, $extDocs, $archDir)) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}
if (-not (Test-Path $urlsFile)) {
    @{ _comment = "Add URLs. Run sync-kb.ps1 -Source web to fetch."; urls = @(
        @{ name="example-nextjs-docs"; url="https://nextjs.org/docs/app"; tier=3; enabled=$false; notes="Set enabled=true" }
    ) } | ConvertTo-Json -Depth 4 | Set-Content $urlsFile -Encoding UTF8
    Write-Host "  [INIT] Created kb-urls.json" -ForegroundColor DarkGray
}

# -- HEADER --
Write-Host ""
Write-Host "=== KB Sync v2 ===" -ForegroundColor Cyan
$dm = if ($DryRun) { " [DRY RUN]" } else { "" }
$fl = "Type=$Type, Source=$Source, MaxTier=$MaxTier"
if ($Sprint -gt 0) { $fl = "Type=$Type, Sprint=$Sprint, MaxTier=$MaxTier" }
if ($Tier1) { $fl = "Tier-1 only" }
if ($WebOnly) { $fl = "Web only"; $Source = "web" }
if ($Report) { $fl += " +Report" }
Write-Host "  $fl$dm" -ForegroundColor DarkGray
Write-Host "  Root: $ProjectRoot" -ForegroundColor DarkGray
Write-Host ""

# -- CLEAN --
if ($Clean -and -not $DryRun -and -not $Report) {
    $c1 = @(Get-ChildItem -Path $projDocs -File -ErrorAction SilentlyContinue).Count
    $c2 = @(Get-ChildItem -Path $extDocs -File -ErrorAction SilentlyContinue).Count
    Get-ChildItem -Path $projDocs -File -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem -Path $extDocs -File -ErrorAction SilentlyContinue | Remove-Item -Force
    Write-Host "  [CLEAN] Removed $($c1+$c2) files" -ForegroundColor Magenta
    Write-Host ""
}

$added=0; $updated=0; $skipped=0; $tierSkip=0; $webAdd=0; $webSkip=0
$obsolete = @(); $staleFiles = @(); $bigFiles = @()
$index = @(); $kbMap = @{}
$skipLocal = ($Source -eq "web")
$isFiltered = ($Source -ne "all" -or $Sprint -gt 0 -or $Type -ne "all" -or $Tier1)

# PHASE 1: LOCAL FILES
if (-not $skipLocal -and -not $Report) {
    if ($MaxTier -eq 1) {
        $eligible = @()
        foreach ($tp in $tier1Paths) {
            $fp = Join-Path $ProjectRoot $tp
            if (Test-Path $fp) { $eligible += Get-Item $fp }
            else { Write-Host "  [MISS] $tp" -ForegroundColor Red }
        }
    } else {
        $all = @()
        foreach ($ext in $extensions) {
            $all += @(Get-ChildItem -Path $ProjectRoot -Filter $ext -Recurse -File -ErrorAction SilentlyContinue)
        }
        $eligible = @($all | Where-Object {
            -not (Test-Excluded $_.FullName) -and
            $excludeFiles -notcontains $_.Name -and
            (Test-SourceOK $_.FullName)
        })
    }
    Write-Host "Local: $($eligible.Count) eligible" -ForegroundColor Yellow

    foreach ($file in $eligible) {
        $flat = Get-FlatName $file.FullName
        $tier = Get-Tier $flat
        $rel  = $file.FullName.Substring($ProjectRoot.Length + 1)
        $age  = Get-DaysOld $file.LastWriteTime

        if ($tier -gt $MaxTier) { $tierSkip++; continue }

        $dest = Join-Path $projDocs $flat
        $kbMap["local::$flat"] = $true
        $act = "skip"

        if (-not (Test-Path $dest)) {
            if (-not $DryRun) { Copy-Item $file.FullName -Destination $dest -Force }
            Write-Host "  [ADD] $flat" -ForegroundColor Green
            $added++; $act = "add"
        } elseif ($file.LastWriteTime -gt (Get-Item $dest).LastWriteTime) {
            if (-not $DryRun) { Copy-Item $file.FullName -Destination $dest -Force }
            Write-Host "  [UPD] $flat" -ForegroundColor Yellow
            $updated++; $act = "update"
        } else { $skipped++ }

        if ($file.Length -gt 1MB) {
            $sizeMB = [math]::Round($file.Length / 1MB, 2)
            $bigFiles += @{ name=$flat; size=$sizeMB }
            Write-Host "  [WARN] $flat is ${sizeMB}MB" -ForegroundColor DarkYellow
        }

        if ($age -gt $staleAge) {
            $staleFiles += @{ name=$flat; days=$age }
        }

        $index += @{
            name=$flat; source=$rel; type="local"; tier=$tier
            size=$file.Length; modified=$file.LastWriteTime.ToString("yyyy-MM-ddTHH:mm:ss")
            daysOld=$age; folder="Project docs"; action=$act
        }
    }
    if ($tierSkip -gt 0) {
        Write-Host "  ($tierSkip files skipped by tier filter)" -ForegroundColor DarkGray
    }
}

# PHASE 2: WEB URLs
$doWeb = ($Source -eq "all" -or $Source -eq "web") -and ($MaxTier -gt 1) -and (-not $Report)

if ($doWeb -and (Test-Path $urlsFile)) {
    $urlData = Get-Content $urlsFile -Raw | ConvertFrom-Json
    $enabled = @($urlData.urls | Where-Object { $_.enabled -eq $true })
    Write-Host ""
    Write-Host "Web: $($enabled.Count) enabled URLs (method=$Scrape)" -ForegroundColor Yellow

    foreach ($entry in $enabled) {
        $safe = Get-SafeName $entry.name
        $ext2 = switch ($Scrape) { "pdf" { ".pdf" } "markdown" { ".md" } default { ".html" } }
        $destFile = Join-Path $extDocs "$safe$ext2"
        $kbMap["web::$safe$ext2"] = $true

        $exists = Test-Path $destFile
        if ($exists -and -not $Refresh) {
            Write-Host "  [SKIP] $safe$ext2 (use -Refresh to re-fetch)" -ForegroundColor DarkGray
            $webSkip++
        } else {
            $label = if ($exists) { "REFRESH" } else { "FETCH" }
            Write-Host "  [$label] $($entry.url)" -ForegroundColor Cyan
            if (-not $DryRun) {
                if ($exists) { Remove-Item $destFile -Force }
                $result = Fetch-WebPage $entry.url $entry.name $Scrape $extDocs
                if ($result) { $webAdd++ }
            } else { $webAdd++ }
        }

        $t = 3
        if ($entry.PSObject.Properties.Name -contains "tier") { $t = [int]$entry.tier }
        $n = ""
        if ($entry.PSObject.Properties.Name -contains "notes") { $n = $entry.notes }

        $index += @{
            name="$safe$ext2"; source=$entry.url; type="web"; tier=$t
            size=0; modified=(Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
            daysOld=0; folder="External docs"; action="fetch"; notes=$n
        }
    }
}

# PHASE 3: OBSOLETE + STALE
if ($Report) {
    Write-Host "=== Obsolete + Stale Report ===" -ForegroundColor Cyan
    foreach ($f in @(Get-ChildItem -Path $projDocs -File -ErrorAction SilentlyContinue)) {
        $rel = $f.Name -replace "--","\"
        $src = Join-Path $ProjectRoot $rel
        if (-not (Test-Path $src)) {
            $obsolete += @{ name=$f.Name; path=$f.FullName; folder="Project docs"; reason="Source deleted" }
        } elseif ((Get-DaysOld $f.LastWriteTime) -gt $staleAge) {
            $staleFiles += @{ name=$f.Name; days=(Get-DaysOld $f.LastWriteTime) }
        }
    }
    if (Test-Path $urlsFile) {
        $urlData = Get-Content $urlsFile -Raw | ConvertFrom-Json
        $names = @($urlData.urls | ForEach-Object { Get-SafeName $_.name })
        foreach ($f in @(Get-ChildItem -Path $extDocs -File -ErrorAction SilentlyContinue)) {
            $base = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
            if ($names -notcontains $base) {
                $obsolete += @{ name=$f.Name; path=$f.FullName; folder="External docs"; reason="URL removed" }
            }
        }
    }
    if ($obsolete.Count -eq 0 -and $staleFiles.Count -eq 0) {
        Write-Host "  KB is clean. No obsolete or stale files." -ForegroundColor Green
    } else {
        if ($obsolete.Count -gt 0) {
            Write-Host "  Obsolete ($($obsolete.Count)):" -ForegroundColor Red
            foreach ($o in $obsolete) {
                Write-Host "    [DEAD] $($o.folder)/$($o.name) - $($o.reason)" -ForegroundColor Red
            }
        }
        if ($staleFiles.Count -gt 0) {
            Write-Host "  Stale (>$staleAge days, $($staleFiles.Count)):" -ForegroundColor DarkYellow
            $top = $staleFiles | Sort-Object { $_.days } -Descending | Select-Object -First 15
            foreach ($s in $top) {
                Write-Host "    [STALE] $($s.name) ($($s.days) days)" -ForegroundColor DarkYellow
            }
            if ($staleFiles.Count -gt 15) {
                Write-Host "    ... and $($staleFiles.Count - 15) more" -ForegroundColor DarkGray
            }
        }
        Write-Host ""
        Write-Host "  -Archive to move obsolete | -Clean to start fresh" -ForegroundColor Yellow
    }
    Write-Host ""; exit 0
}

# Non-report: detect orphans (only for unfiltered sync)
if (-not $isFiltered) {
    foreach ($f in @(Get-ChildItem -Path $projDocs -File -ErrorAction SilentlyContinue)) {
        if (-not $kbMap.ContainsKey("local::$($f.Name)")) {
            $obsolete += @{ name=$f.Name; path=$f.FullName; folder="Project docs" }
        }
    }
    foreach ($f in @(Get-ChildItem -Path $extDocs -File -ErrorAction SilentlyContinue)) {
        if (-not $kbMap.ContainsKey("web::$($f.Name)")) {
            $obsolete += @{ name=$f.Name; path=$f.FullName; folder="External docs" }
        }
    }
} else {
    Write-Host "  (Filtered sync - orphan detection skipped)" -ForegroundColor DarkGray
}

$deleted = 0
foreach ($o in $obsolete) {
    if ($Archive) {
        if (-not $DryRun) {
            $ad = Join-Path $archDir $o.name
            Move-Item $o.path -Destination $ad -Force
        }
        Write-Host "  [ARCHIVE] $($o.name)" -ForegroundColor DarkYellow
        $deleted++
    } else {
        if (-not $DryRun) { Remove-Item $o.path -Force }
        Write-Host "  [DEL] $($o.name)" -ForegroundColor Red
        $deleted++
    }
}

# PHASE 4: WRITE INDEX
if (-not $DryRun -and $index.Count -gt 0) {
    $indexObj = @{
        generated  = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
        project    = (Split-Path $ProjectRoot -Leaf)
        totalFiles = $index.Count
        tier1 = @($index | Where-Object { $_.tier -eq 1 }).Count
        tier2 = @($index | Where-Object { $_.tier -eq 2 }).Count
        tier3 = @($index | Where-Object { $_.tier -eq 3 }).Count
        staleCount = $staleFiles.Count
        largeCount = $bigFiles.Count
        filters = $fl
        files = @($index | Sort-Object { $_.tier },{ $_.name })
    }
    $tmpIdx = Join-Path $kbRoot "kb-index.tmp.json"
    $indexObj | ConvertTo-Json -Depth 4 | Set-Content $tmpIdx -Encoding UTF8
    try {
        if (Test-Path $idxFile) { Remove-Item $idxFile -Force }
        Move-Item $tmpIdx $idxFile -Force
    } catch {
        Write-Host "  [WARN] Could not update kb-index.json (file locked?). Saved as kb-index.tmp.json" -ForegroundColor DarkYellow
    }
}

# PHASE 5: SUMMARY + LOG
Write-Host ""
Write-Host "=== Summary$dm ===" -ForegroundColor Cyan
Write-Host "  Local:    +$added ~$updated =$skipped x$tierSkip(tier)"
Write-Host "  Web:      +$webAdd =$webSkip(skip)"
Write-Host "  Obsolete: $($obsolete.Count) found, $deleted handled"
Write-Host "  Index:    $($index.Count) entries"
if ($staleFiles.Count -gt 0) {
    Write-Host "  Stale:    $($staleFiles.Count) files >$staleAge days old" -ForegroundColor DarkYellow
}
if ($bigFiles.Count -gt 0) {
    Write-Host "  Large:    $($bigFiles.Count) files >1MB" -ForegroundColor DarkYellow
}
Write-Host ""

Write-Host "=== Tier-1 Checklist ===" -ForegroundColor Cyan
foreach ($t1 in $tier1Paths) {
    $flat = $t1 -replace "[/\\]","--"
    $ok = Test-Path (Join-Path $projDocs $flat)
    $mark  = if ($ok) { "[OK]" } else { "[!!]" }
    $color = if ($ok) { "Green" } else { "Red" }
    Write-Host "  $mark $flat" -ForegroundColor $color
}

$pCnt = @(Get-ChildItem -Path $projDocs -File -ErrorAction SilentlyContinue).Count
$eCnt = @(Get-ChildItem -Path $extDocs -File -ErrorAction SilentlyContinue).Count
$pSum = (Get-ChildItem -Path $projDocs -File -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
$eSum = (Get-ChildItem -Path $extDocs -File -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
if (-not $pSum) { $pSum = 0 }
if (-not $eSum) { $eSum = 0 }
$pMB = [math]::Round($pSum / 1MB, 2)
$eMB = [math]::Round($eSum / 1MB, 2)

Write-Host ""
Write-Host "=== KB Folders ===" -ForegroundColor Cyan
Write-Host "  Project docs:  $pCnt files ($pMB MB)"
Write-Host "  External docs: $eCnt files ($eMB MB)"
$totalMB = [math]::Round($pMB + $eMB, 2)
Write-Host "  Total: $($pCnt + $eCnt) files ($totalMB MB)"
Write-Host ""
Write-Host "Upload to Claude Project from:" -ForegroundColor Cyan
Write-Host "  $projDocs" -ForegroundColor White
Write-Host "  $extDocs" -ForegroundColor White
Write-Host ""

if (-not $DryRun) {
    $logMsg = "$fl | +$added ~$updated =$skipped x$tierSkip web+$webAdd del=$deleted"
    $logMsg += " | $($index.Count) files | stale=$($staleFiles.Count) large=$($bigFiles.Count)"
    try { Write-Log $logMsg } catch { Write-Host "  [WARN] Could not write to log file" -ForegroundColor DarkYellow }
}
