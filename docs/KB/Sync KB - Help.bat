@echo off
title {{PROJECT_NAME}} KB Sync — Help
echo.
echo  ================================================
echo   {{PROJECT_NAME}} KB Sync v3 — Quick Reference
echo  ================================================
echo.
echo  QUICK COMMANDS:
echo    Sync KB.bat                       Show help (bare run)
echo    Sync KB.bat -Status               File counts (fast)
echo    Sync KB.bat -Source all            Sync everything
echo    Sync KB.bat -Tier1                7 essential files only
echo    Sync KB.bat -Report               Find obsolete/stale
echo    Sync KB.bat -Stats                Full stats from index
echo.
echo  FILTERS:
echo    -Type     all, md, pdf, txt, jsx
echo    -Source   all, docs, sprints, src, root, content, web
echo    -Sprint   1, 2, ...               (specific sprint number)
echo    -Tier1                            (7 essential files)
echo.
echo  ACTIONS:
echo    -Clean                Wipe output folders first
echo    -Report               Show obsolete files report
echo    -Archive              Move obsolete to Archive/
echo    -Refresh              Re-fetch web URLs
echo    -DryRun               Preview without changes
echo.
echo  CONSOLIDATE (merge files down):
echo    -Consolidate 10       Merge 95 files into 10
echo    -Consolidate 5        Merge into 5 files
echo    -Consolidate 10 -DryRun  Preview merge plan
echo    (can only shrink — if already at/below target, no-op)
echo.
echo  WEB SCRAPING:
echo    -Scrape markdown      Web to .md (default, needs pandoc)
echo    -Scrape pdf           Web to .pdf (needs wkhtmltopdf)
echo    -Scrape html          Save raw HTML
echo.
echo  COMBOS:
echo    Sync KB.bat -Source all -MaxTier 2   Core docs only
echo    Sync KB.bat -Clean -Tier1            Fresh essentials
echo    Sync KB.bat -Consolidate 10          Merge to 10 files
echo    Sync KB.bat -Archive                 Archive obsolete
echo    Sync KB.bat -DryRun -Source all      Preview sync
echo.
echo  OUTPUT:
echo    docs\KB\Project docs\    Local project files
echo    docs\KB\External docs\   Web URL content
echo    docs\KB\Consolidated\    Merged output (after -Consolidate)
echo    docs\KB\Archive\         Archived obsolete files
echo    docs\KB\kb-index.json    Metadata index
echo    docs\KB\kb-urls.json     Web URL registry (edit this!)
echo.
pause
