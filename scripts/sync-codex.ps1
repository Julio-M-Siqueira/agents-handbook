[CmdletBinding()]
param(
    [string]$HandbookRoot = "",
    [string]$CodexHome = (Join-Path $HOME ".codex"),
    [string[]]$Skill,
    [string[]]$Project,
    [switch]$Global,
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

function Remove-RetiredSkill {
    param([string]$Target, [string]$BackupRoot)

    # The selected manifest's name and target were validated before publishing.
    if (-not (Test-Path -LiteralPath $Target)) { return }
    Write-Host "RETIRE $Target"
    if (-not $script:ApplySync) { return }

    $backup = Join-Path $BackupRoot ($Target.TrimStart('\').Replace(':', ''))
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup) | Out-Null
    Copy-Item -LiteralPath $Target -Destination $backup -Recurse -Force
    Remove-Item -LiteralPath $Target -Recurse -Force
}

function Assert-RequiredSource {
    param([string]$Path, [ValidateSet('Leaf', 'Container')][string]$PathType)

    if (-not (Test-Path -LiteralPath $Path -PathType $PathType)) {
        throw "Required $PathType source is missing or has the wrong type: $Path"
    }
}

$HandbookRoot = [System.IO.Path]::GetFullPath($HandbookRoot)
$CodexHome = [System.IO.Path]::GetFullPath($CodexHome)
$skillRoot = Join-Path $HandbookRoot "skills"
$projectRoot = Join-Path $HandbookRoot "projects"
Assert-RequiredSource -Path $skillRoot -PathType Container
Assert-RequiredSource -Path $projectRoot -PathType Container
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

$includeGlobal = $Global.IsPresent -or (-not $hasSkillFilter -and -not $hasProjectFilter)
if ($includeGlobal) {
    $globalSource = Join-Path $HandbookRoot "global\AGENTS.md"
    $knowledgeSource = Join-Path $HandbookRoot "knowledge"
    Assert-RequiredSource -Path $globalSource -PathType Leaf
    Assert-RequiredSource -Path $knowledgeSource -PathType Container
    $globalContent = (Get-Content -LiteralPath $globalSource -Raw).
        Replace("../skills/", "skills/").
        Replace("../knowledge/", "knowledge/")
}

$skillDirectories = if ($hasSkillFilter) {
    @($availableSkillDirectories | Where-Object { $_.Name -in $Skill })
} elseif ($hasProjectFilter -or $Global.IsPresent) {
    @()
} else {
    $availableSkillDirectories
}

foreach ($skillDirectory in $skillDirectories) {
    Assert-RequiredSource -Path (Join-Path $skillDirectory.FullName 'SKILL.md') -PathType Leaf
}

$projectDirectories = if ($hasProjectFilter) {
    @($availableProjectDirectories | Where-Object { $_.Name -in $Project })
} elseif ($hasSkillFilter -or $Global.IsPresent) {
    @()
} else {
    $availableProjectDirectories
}

$managedSkillRoot = [System.IO.Path]::GetFullPath((Join-Path $CodexHome 'skills'))
# Preflight the complete selected input set before copying or backing up any target.
# The executor below consumes these parsed and normalized project records directly.
$validatedProjects = @(foreach ($projectDirectory in $projectDirectories) {
    $manifestPath = Join-Path $projectDirectory.FullName "project.json"
    $projectInstructions = Join-Path $projectDirectory.FullName 'AGENTS.md'
    Assert-RequiredSource -Path $manifestPath -PathType Leaf
    Assert-RequiredSource -Path $projectInstructions -PathType Leaf
    $manifestJson = [string](Get-Content -LiteralPath $manifestPath -Raw)
    try {
        $manifest = ConvertFrom-Json -InputObject $manifestJson
    } catch {
        throw "Invalid project manifest JSON in ${manifestPath}: $($_.Exception.Message)"
    }
    # PowerShell 7 unwraps singleton JSON arrays. Check the original root token
    # so such an array cannot become an apparently valid project object.
    if (-not $manifestJson.TrimStart().StartsWith('{')) {
        throw "Project manifest must be a JSON object: $manifestPath"
    }
    if ($manifest.PSObject.Properties.Name -notcontains 'repositoryPath' -or
        $manifest.repositoryPath -isnot [string] -or
        [string]::IsNullOrWhiteSpace($manifest.repositoryPath)) {
        throw "Project manifest requires a configured repositoryPath: $manifestPath"
    }
    $repositoryPath = $manifest.repositoryPath.Trim()
    $repositoryRoot = [System.IO.Path]::GetPathRoot($repositoryPath)
    if ($repositoryPath -match '(^|[\\/])path[\\/]to([\\/]|$)|[<>]' -or
        -not [System.IO.Path]::IsPathRooted($repositoryPath) -or
        $repositoryRoot -eq '\' -or $repositoryRoot.EndsWith(':')) {
        throw "repositoryPath must be a fully qualified, configured path in ${manifestPath}: $repositoryPath"
    }
    $repositoryPath = [System.IO.Path]::GetFullPath($repositoryPath)
    if (-not (Test-Path -LiteralPath $repositoryPath -PathType Container)) {
        throw "repositoryPath must identify an existing repository directory in ${manifestPath}: $repositoryPath"
    }
    $retiredSkills = if ($manifest.PSObject.Properties.Name -contains 'retiredSkills') {
        @($manifest.retiredSkills)
    } else { @() }
    $retiredTargets = @(foreach ($retiredSkill in $retiredSkills) {
        if ($retiredSkill -isnot [string] -or $retiredSkill -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
            throw "Invalid retired skill name in ${manifestPath}: $retiredSkill"
        }
        $activeSources = @((Join-Path $skillRoot $retiredSkill)) + @(
            $availableProjectDirectories | ForEach-Object { Join-Path $_.FullName "skills\$retiredSkill" }
        )
        foreach ($activeSource in $activeSources) {
            if (Test-Path -LiteralPath $activeSource) {
                throw "Cannot retire a skill that still has a source: $activeSource"
            }
        }
        $retiredTarget = [System.IO.Path]::GetFullPath((Join-Path $managedSkillRoot $retiredSkill))
        if ((Split-Path -Parent $retiredTarget) -ne $managedSkillRoot) {
            throw "Retired skill target is outside the managed skills directory: $retiredTarget"
        }
        $retiredTarget
    })

    $areaItems = @(foreach ($area in @('skills', 'agents', 'rules')) {
        $sourceArea = Join-Path $projectDirectory.FullName $area
        if (-not (Test-Path -LiteralPath $sourceArea)) { continue }
        Assert-RequiredSource -Path $sourceArea -PathType Container
        foreach ($sourceItem in (Get-ChildItem -LiteralPath $sourceArea -Force)) {
            if ($area -eq 'skills' -and $sourceItem.PSIsContainer) {
                Assert-RequiredSource -Path (Join-Path $sourceItem.FullName 'SKILL.md') -PathType Leaf
            }
            [pscustomobject]@{
                Source = $sourceItem.FullName
                Target = Join-Path $CodexHome ("$area\" + $sourceItem.Name)
                IsDirectory = $sourceItem.PSIsContainer
            }
        }
    })
    [pscustomobject]@{
        Source = $projectDirectory.FullName
        Target = Join-Path $CodexHome ("projects\" + $projectDirectory.Name)
        InstructionsSource = $projectInstructions
        InstructionsTarget = Join-Path $repositoryPath 'AGENTS.md'
        AreaItems = $areaItems
        RetiredTargets = $retiredTargets
    }
})

$backupName = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N')
$backupRoot = Join-Path $CodexHome ("backups\agents-handbook\" + $backupName)
if ($includeGlobal) {
    Copy-ManagedFile -Source $globalSource -Target (Join-Path $CodexHome 'AGENTS.md') -BackupRoot $backupRoot -Content $globalContent
    Copy-ManagedDirectory -Source $knowledgeSource -Target (Join-Path $CodexHome 'knowledge') -BackupRoot $backupRoot
}
foreach ($skillDirectory in $skillDirectories) {
    Copy-ManagedDirectory -Source $skillDirectory.FullName -Target (Join-Path $CodexHome ("skills\" + $skillDirectory.Name)) -BackupRoot $backupRoot
}
foreach ($validatedProject in $validatedProjects) {
    Copy-ManagedDirectory -Source $validatedProject.Source -Target $validatedProject.Target -BackupRoot $backupRoot
    Copy-ManagedFile -Source $validatedProject.InstructionsSource -Target $validatedProject.InstructionsTarget -BackupRoot $backupRoot
    foreach ($item in $validatedProject.AreaItems) {
        if ($item.IsDirectory) {
            Copy-ManagedDirectory -Source $item.Source -Target $item.Target -BackupRoot $backupRoot
        } else {
            Copy-ManagedFile -Source $item.Source -Target $item.Target -BackupRoot $backupRoot
        }
    }
    foreach ($retiredTarget in $validatedProject.RetiredTargets) {
        Remove-RetiredSkill -Target $retiredTarget -BackupRoot $backupRoot
    }
}

if ($script:ApplySync) {
    Write-Host "Sync complete. Backups: $backupRoot"
} else {
    Write-Host "DRY RUN ONLY: no files were changed."
    Write-Host "Re-run the same command with -Apply to synchronize the listed targets."
}




