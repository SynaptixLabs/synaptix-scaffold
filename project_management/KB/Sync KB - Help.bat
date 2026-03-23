@echo off
title KB Sync — Help
echo.
echo  ================================================
echo   KB Sync — Quick Reference
echo  ================================================
echo.
echo  LAUNCHERS:
echo    Sync KB.bat                   Sync all (double-click)
echo    Sync KB.bat -Tier1            7 essential files only
echo    Sync KB.bat -Sprint 10        Sprint 10 only
echo    Sync KB.bat -Source web       Web URLs only
echo.
echo  FILTERS:
echo    -Type     all, md, pdf
echo    -Source   all, docs, sprints, src, root, content, web
echo    -Sprint   10, 11, ...          (specific sprint number)
echo    -Tier1                         (7 essential files)
echo    -WebOnly                       (web URLs only)
echo.
echo  ACTIONS:
echo    -Clean                Wipe output folders first
echo    -Report               Show obsolete files report
echo    -Archive              Move obsolete to Archive/
echo    -DryRun               Preview without changes
echo.
echo  WEB SCRAPING:
echo    -Scrape markdown      Web page to .md (default, needs pandoc)
echo    -Scrape pdf           Web page to .pdf (needs wkhtmltopdf)
echo    -Scrape html          Save raw HTML
echo.
echo  COMBOS:
echo    Sync KB.bat -Type md -Sprint 10          Sprint 10 markdown
echo    Sync KB.bat -Source web -Scrape pdf       URLs as PDF
echo    Sync KB.bat -Clean -Tier1                 Fresh essentials
echo    Sync KB.bat -Report                       Find obsolete files
echo    Sync KB.bat -Archive                      Archive obsolete
echo    Sync KB.bat -DryRun                       Preview everything
echo.
echo  OUTPUT:
echo    project_management\KB\Project docs\    Local project files
echo    project_management\KB\External docs\   Web URL content
echo    project_management\KB\Archive\         Archived obsolete files
echo    project_management\KB\kb-index.json    Metadata index
echo    project_management\KB\kb-urls.json     Web URL registry (edit this!)
echo.
echo  WEB SETUP (edit kb-urls.json to add URLs):
echo    {
echo      "urls": [
echo        { "name": "nextjs-docs", "url": "https://...",
echo          "tier": 3, "enabled": true, "notes": "..." }
echo      ]
echo    }
echo.
pause
