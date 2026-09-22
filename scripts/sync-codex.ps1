[CmdletBinding()]
param(
    [string]$HandbookRoot = "",
    [string]$CodexHome = (Join-Path $HOME ".codex"),
    [string[]]$Skill,
    [string[]]$Project,
    [switch]$Apply
)

if (-not $HandbookRoot) {
    $HandbookRoot = Split-Path -Parent $PSScriptRoot
}

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$script:ApplySync = $Apply.IsPresent

function Copy-ManagedFile {
    param([string]$Source, [string]$Target, [string]$BackupRoot, [string]$Content)

    Write-Host "FILE  $Source -> $Target"
    if (-not $script:ApplySync) { return }

    $targetDirectory = Split-Path -Parent $Target
    New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
    if (Test-Path -LiteralPath $Target) {
        $backup = Join-Path $BackupRoot ($Target.TrimStart('\').Replace(':', ''))
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup) | Out-Null
        Copy-Item -LiteralPath $Target -Destination $backup -Force
    }
    if ($PSBoundParameters.ContainsKey('Content')) {
        [System.IO.File]::WriteAllText($Target, $Content, [System.Text.UTF8Encoding]::new($false))
    } else {
        Copy-Item -LiteralPath $Source -Destination $Target -Force
    }
}

function Copy-ManagedDirectory {
    param([string]$Source, [string]$Target, [string]$BackupRoot)

    Write-Host "DIR   $Source -> $Target"
    if (-not $script:ApplySync) { return }

    if (Test-Path -LiteralPath $Target) {
        $backup = Join-Path $BackupRoot ($Target.TrimStart('\').Replace(':', ''))
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup) | Out-Null
        Copy-Item -LiteralPath $Target -Destination $backup -Recurse -Force
        Remove-Item -LiteralPath $Target -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Target) | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Target -Recurse -Force
}

$backupRoot = Join-Path $CodexHome ("backups\agents-handbook\" + (Get-Date -Format "yyyyMMdd-HHmmss"))
$skillRoot = Join-Path $HandbookRoot "skills"
$projectRoot = Join-Path $HandbookRoot "projects"
$availableSkillDirectories = @(Get-ChildItem -LiteralPath $skillRoot -Directory)
$availableProjectDirectories = @(Get-ChildItem -LiteralPath $projectRoot -Directory)
$Skill = @($Skill | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$Project = @($Project | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$hasSkillFilter = $null -ne $Skill -and $Skill.Count -gt 0
$hasProjectFilter = $null -ne $Project -and $Project.Count -gt 0

if ($hasSkillFilter) {
    $missingSkills = @($Skill | Where-Object { $_ -notin $availableSkillDirectories.Name } | Sort-Object -Unique)
    if ($missingSkills.Count -gt 0) {
        $availableSkills = $availableSkillDirectories.Name -join ", "
        throw "Unknown skill(s): $($missingSkills -join ', '). Available skills: $availableSkills"
    }
}

if ($hasProjectFilter) {
    $missingProjects = @($Project | Where-Object { $_ -notin $availableProjectDirectories.Name } | Sort-Object -Unique)
    if ($missingProjects.Count -gt 0) {
        $availableProjects = $availableProjectDirectories.Name -join ", "
        throw "Unknown project(s): $($missingProjects -join ', '). Available projects: $availableProjects"
    }
}

if (-not $hasSkillFilter -and -not $hasProjectFilter) {
    $globalSource = Join-Path $HandbookRoot "global\AGENTS.md"
    $globalContent = (Get-Content -LiteralPath $globalSource -Raw).
        Replace("../skills/", "skills/").
        Replace("../knowledge/", "knowledge/")

    Copy-ManagedFile -Source $globalSource -Target (Join-Path $CodexHome "AGENTS.md") -BackupRoot $backupRoot -Content $globalContent
    Copy-ManagedDirectory -Source (Join-Path $HandbookRoot "knowledge") -Target (Join-Path $CodexHome "knowledge") -BackupRoot $backupRoot
}

$skillDirectories = if ($hasSkillFilter) {
    @($availableSkillDirectories | Where-Object { $_.Name -in $Skill })
} elseif ($hasProjectFilter) {
    @()
} else {
    $availableSkillDirectories
}

$skillDirectories | ForEach-Object {
    Copy-ManagedDirectory -Source $_.FullName -Target (Join-Path $CodexHome ("skills\" + $_.Name)) -BackupRoot $backupRoot
}

$projectDirectories = if ($hasProjectFilter) {
    @($availableProjectDirectories | Where-Object { $_.Name -in $Project })
} elseif ($hasSkillFilter) {
    @()
} else {
    $availableProjectDirectories
}

foreach ($projectDirectory in $projectDirectories) {
    $manifestPath = Join-Path $projectDirectory.FullName "project.json"
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    Copy-ManagedDirectory -Source $projectDirectory.FullName -Target (Join-Path $CodexHome ("projects\" + $projectDirectory.Name)) -BackupRoot $backupRoot
    Copy-ManagedFile -Source (Join-Path $projectDirectory.FullName "AGENTS.md") -Target (Join-Path $manifest.repositoryPath "AGENTS.md") -BackupRoot $backupRoot

    foreach ($area in @("skills", "agents", "rules")) {
        $sourceArea = Join-Path $projectDirectory.FullName $area
        if (-not (Test-Path -LiteralPath $sourceArea)) { continue }
        Get-ChildItem -LiteralPath $sourceArea -Force | ForEach-Object {
            $target = Join-Path $CodexHome ("$area\" + $_.Name)
            if ($_.PSIsContainer) {
                Copy-ManagedDirectory -Source $_.FullName -Target $target -BackupRoot $backupRoot
            } else {
                Copy-ManagedFile -Source $_.FullName -Target $target -BackupRoot $backupRoot
            }
        }
    }
}

if ($script:ApplySync) {
    Write-Host "Sync complete. Backups: $backupRoot"
} else {
    Write-Host "DRY RUN ONLY: no files were changed."
    Write-Host "Re-run the same command with -Apply to synchronize the listed targets."
}




