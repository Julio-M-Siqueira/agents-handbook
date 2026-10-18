$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$syncScript = Join-Path (Split-Path -Parent $PSScriptRoot) 'sync-codex.ps1'
$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ('handbook-sync-test-' + [guid]::NewGuid())

function Write-FixtureFile([string]$Path, [string]$Content) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    [IO.File]::WriteAllText($Path, $Content)
}

function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}

function New-SyncFixture([string]$Name) {
    $caseRoot = Join-Path $fixtureRoot $Name
    $handbook = Join-Path $caseRoot 'handbook'
    $codex = Join-Path $caseRoot 'codex'
    $repository = Join-Path $caseRoot 'repository'
    $manifestPath = Join-Path $handbook 'projects/demo/project.json'
    $manifest = @{ id = 'demo'; repositoryPath = $repository; retiredSkills = @('legacy-review') }
    Write-FixtureFile $manifestPath ($manifest | ConvertTo-Json)
    Write-FixtureFile (Join-Path $handbook 'projects/demo/AGENTS.md') 'project guidance'
    Write-FixtureFile (Join-Path $handbook 'projects/demo/rules/demo.mdc') 'project rule'
    Write-FixtureFile (Join-Path $handbook 'projects/demo/agents/demo.md') 'project agent'
    Write-FixtureFile (Join-Path $handbook 'skills/shared/SKILL.md') 'shared workflow'
    Write-FixtureFile (Join-Path $handbook 'global/AGENTS.md') 'global ../skills/shared/SKILL.md ../knowledge/note.md'
    Write-FixtureFile (Join-Path $handbook 'knowledge/note.md') 'knowledge'
    Write-FixtureFile (Join-Path $codex 'AGENTS.md') 'original global'
    Write-FixtureFile (Join-Path $codex 'knowledge/note.md') 'original knowledge'
    Write-FixtureFile (Join-Path $codex 'skills/shared/SKILL.md') 'original shared'
    Write-FixtureFile (Join-Path $codex 'skills/legacy-review/SKILL.md') 'old skill to preserve in backup'
    Write-FixtureFile (Join-Path $codex 'skills/personal/SKILL.md') 'personal skill'
    Write-FixtureFile (Join-Path $codex 'projects/demo/AGENTS.md') 'original bundle'
    Write-FixtureFile (Join-Path $codex 'rules/demo.mdc') 'original rule'
    Write-FixtureFile (Join-Path $codex 'agents/demo.md') 'original agent'
    # A successful sync uses a configured root that already exists.
    Write-FixtureFile (Join-Path $repository 'AGENTS.md') 'original project'
    [pscustomobject]@{
        Root = $caseRoot; Handbook = $handbook; Codex = $codex
        Repository = $repository; ManifestPath = $manifestPath; Manifest = $manifest
    }
}

function Get-FixtureSnapshot([string]$Root) {
    @(Get-ChildItem -LiteralPath $Root -Recurse -Force | Sort-Object FullName | ForEach-Object {
        if ($_.PSIsContainer) { 'DIR ' + $_.FullName }
        else { 'FILE ' + $_.FullName + ' ' + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash }
    }) -join "`n"
}

function Assert-PreflightReject([string]$Name, [scriptblock]$Mutate, [string]$ExpectedError) {
    $fixture = New-SyncFixture $Name
    & $Mutate $fixture
    $before = Get-FixtureSnapshot $fixture.Root
    $rejected = $false
    try {
        # Default selection includes all global, skill, and project destinations.
        & $syncScript -HandbookRoot $fixture.Handbook -CodexHome $fixture.Codex -Apply
    } catch {
        if ($_.Exception.Message -notlike $ExpectedError) { throw }
        $rejected = $true
    }
    Assert-True $rejected "$Name was accepted"
    Assert-True ((Get-FixtureSnapshot $fixture.Root) -eq $before) "$Name changed files or directories before rejection"
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $fixture.Codex 'backups'))) "$Name created backups"
}

function Invoke-FixedTimeProjectSync($Fixture) {
    # The child script sees the same second for both applies; GUID identity must
    # separate the backups even when no clock tick occurs between them.
    function Get-Date { param([string]$Format) '20000101-000000' }
    & $syncScript -HandbookRoot $Fixture.Handbook -CodexHome $Fixture.Codex -Project demo -Apply
}

try {
    $fixture = New-SyncFixture 'successful-sync'
    $syncArgs = @{ HandbookRoot = $fixture.Handbook; CodexHome = $fixture.Codex; Project = 'demo' }
    $legacyFile = Join-Path $fixture.Codex 'skills/legacy-review/SKILL.md'
    $unmanagedFile = Join-Path $fixture.Codex 'skills/personal/SKILL.md'
    $before = Get-FixtureSnapshot $fixture.Root
    & $syncScript @syncArgs
    Assert-True ((Get-FixtureSnapshot $fixture.Root) -eq $before) 'Dry run changed the fixture'

    # Unselected malformed manifests and project retirements remain isolated.
    Write-FixtureFile (Join-Path $fixture.Handbook 'projects/unselected/project.json') '{ invalid'
    & $syncScript -HandbookRoot $fixture.Handbook -CodexHome $fixture.Codex -Skill shared -Apply
    Assert-True (Test-Path -LiteralPath $legacyFile) 'Skill filter retired another project skill'
    Assert-True ((Get-Content -LiteralPath (Join-Path $fixture.Codex 'AGENTS.md') -Raw) -eq 'original global') 'Skill filter published global guidance'
    & $syncScript -HandbookRoot $fixture.Handbook -CodexHome $fixture.Codex -Global -Apply
    Assert-True (Test-Path -LiteralPath $legacyFile) 'Global filter retired another project skill'
    Assert-True ((Get-Content -LiteralPath (Join-Path $fixture.Repository 'AGENTS.md') -Raw) -eq 'original project') 'Global filter published project guidance'
    Assert-True ((Get-Content -LiteralPath (Join-Path $fixture.Codex 'AGENTS.md') -Raw) -eq 'global skills/shared/SKILL.md knowledge/note.md') 'Global links were not normalized'

    & $syncScript @syncArgs -Apply
    Assert-True (-not (Test-Path -LiteralPath $legacyFile)) 'Apply left the retired skill active'
    Assert-True ((Get-Content -LiteralPath $unmanagedFile -Raw) -eq 'personal skill') 'Apply changed an unmanaged skill'
    Assert-True ((Get-Content -LiteralPath (Join-Path $fixture.Repository 'AGENTS.md') -Raw) -eq 'project guidance') 'Project guidance was not published'
    Assert-True ((Get-Content -LiteralPath (Join-Path $fixture.Codex 'rules/demo.mdc') -Raw) -eq 'project rule') 'Project rule was not published'
    Assert-True ((Get-Content -LiteralPath (Join-Path $fixture.Codex 'agents/demo.md') -Raw) -eq 'project agent') 'Project agent was not published'
    $backups = @(Get-ChildItem -LiteralPath (Join-Path $fixture.Codex 'backups') -Recurse -File |
        Where-Object { $_.Name -eq 'SKILL.md' -and (Get-Content -LiteralPath $_.FullName -Raw) -eq 'old skill to preserve in backup' })
    Assert-True ($backups.Count -eq 1) 'Retirement did not preserve the original skill'
    & $syncScript @syncArgs -Apply
    Assert-True (-not (Test-Path -LiteralPath $legacyFile)) 'Repeated sync recreated a retired skill'
    $fixture.Manifest.Remove('retiredSkills')
    Write-FixtureFile $fixture.ManifestPath ($fixture.Manifest | ConvertTo-Json)
    & $syncScript @syncArgs -Apply
    Assert-True (Test-Path -LiteralPath $unmanagedFile) 'Legacy manifest changed unmanaged skills'

    Assert-PreflightReject 'malformed-json' { param($f)
        Write-FixtureFile $f.ManifestPath '{ invalid'
    } 'Invalid project manifest JSON*'
    Assert-PreflightReject 'later-malformed-project' { param($f)
        Write-FixtureFile (Join-Path $f.Handbook 'projects/z-broken/project.json') '{ invalid'
        Write-FixtureFile (Join-Path $f.Handbook 'projects/z-broken/AGENTS.md') 'later project'
    } 'Invalid project manifest JSON*'
    Assert-PreflightReject 'nonobject-json' { param($f)
        Write-FixtureFile $f.ManifestPath '[]'
    } 'Project manifest must be a JSON object*'
    Assert-PreflightReject 'singleton-array-json' { param($f)
        Write-FixtureFile $f.ManifestPath ('[' + ($f.Manifest | ConvertTo-Json) + ']')
    } 'Project manifest must be a JSON object*'
    Assert-PreflightReject 'scalar-json' { param($f)
        Write-FixtureFile $f.ManifestPath '12'
    } 'Project manifest must be a JSON object*'
    Assert-PreflightReject 'missing-manifest' { param($f)
        Remove-Item -LiteralPath $f.ManifestPath
    } 'Required Leaf source*'
    Assert-PreflightReject 'missing-repository-path' { param($f)
        $f.Manifest.Remove('repositoryPath')
        Write-FixtureFile $f.ManifestPath ($f.Manifest | ConvertTo-Json)
    } 'Project manifest requires a configured repositoryPath*'
    foreach ($invalidPath in @('', '   ', 12, '/path/to/demo', '.\repository', 'C:repository', '\repository')) {
        Assert-PreflightReject ('invalid-path-' + [guid]::NewGuid().ToString('N')) { param($f)
            $f.Manifest.repositoryPath = $invalidPath
            Write-FixtureFile $f.ManifestPath ($f.Manifest | ConvertTo-Json)
        } '*repositoryPath*'
    }
    Assert-PreflightReject 'nonexistent-repository' { param($f)
        $f.Manifest.repositoryPath = Join-Path $f.Root 'must-not-be-created'
        Write-FixtureFile $f.ManifestPath ($f.Manifest | ConvertTo-Json)
    } 'repositoryPath must identify an existing repository directory*'
    Assert-PreflightReject 'file-repository' { param($f)
        $f.Manifest.repositoryPath = Join-Path $f.Root 'file-repository'
        Write-FixtureFile $f.Manifest.repositoryPath 'not a directory'
        Write-FixtureFile $f.ManifestPath ($f.Manifest | ConvertTo-Json)
    } 'repositoryPath must identify an existing repository directory*'
    Assert-PreflightReject 'missing-project-guidance' { param($f)
        Remove-Item -LiteralPath (Join-Path $f.Handbook 'projects/demo/AGENTS.md')
    } 'Required Leaf source*'
    Assert-PreflightReject 'directory-project-guidance' { param($f)
        $path = Join-Path $f.Handbook 'projects/demo/AGENTS.md'
        Remove-Item -LiteralPath $path
        New-Item -ItemType Directory -Path $path | Out-Null
    } 'Required Leaf source*'
    Assert-PreflightReject 'missing-global-guidance' { param($f)
        Remove-Item -LiteralPath (Join-Path $f.Handbook 'global/AGENTS.md')
    } 'Required Leaf source*'
    Assert-PreflightReject 'missing-knowledge' { param($f)
        Remove-Item -LiteralPath (Join-Path $f.Handbook 'knowledge/note.md')
        Remove-Item -LiteralPath (Join-Path $f.Handbook 'knowledge')
    } 'Required Container source*'
    Assert-PreflightReject 'missing-shared-skill' { param($f)
        Remove-Item -LiteralPath (Join-Path $f.Handbook 'skills/shared/SKILL.md')
    } 'Required Leaf source*'
    Assert-PreflightReject 'invalid-project-area' { param($f)
        Remove-Item -LiteralPath (Join-Path $f.Handbook 'projects/demo/rules/demo.mdc')
        Remove-Item -LiteralPath (Join-Path $f.Handbook 'projects/demo/rules')
        Write-FixtureFile (Join-Path $f.Handbook 'projects/demo/rules') 'rules must be a directory'
    } 'Required Container source*'
    Assert-PreflightReject 'missing-project-skill' { param($f)
        New-Item -ItemType Directory -Force -Path (Join-Path $f.Handbook 'projects/demo/skills/project-skill') | Out-Null
    } 'Required Leaf source*'
    Assert-PreflightReject 'retirement-path-traversal' { param($f)
        $f.Manifest.retiredSkills = @('../personal')
        Write-FixtureFile $f.ManifestPath ($f.Manifest | ConvertTo-Json)
    } 'Invalid retired skill name*'
    Assert-PreflightReject 'active-retirement-source' { param($f)
        $f.Manifest.retiredSkills = @('shared')
        Write-FixtureFile $f.ManifestPath ($f.Manifest | ConvertTo-Json)
    } 'Cannot retire a skill that still has a source*'
    Assert-PreflightReject 'active-project-retirement-source' { param($f)
        Write-FixtureFile (Join-Path $f.Handbook 'projects/other/skills/legacy-review/SKILL.md') 'still active'
    } 'Cannot retire a skill that still has a source*'

    $fixedFixture = New-SyncFixture 'fixed-time-backups'
    Write-FixtureFile (Join-Path $fixedFixture.Handbook 'projects/demo/AGENTS.md') 'first replacement'
    Invoke-FixedTimeProjectSync $fixedFixture
    Write-FixtureFile (Join-Path $fixedFixture.Handbook 'projects/demo/AGENTS.md') 'second replacement'
    Invoke-FixedTimeProjectSync $fixedFixture
    $runs = @(Get-ChildItem -LiteralPath (Join-Path $fixedFixture.Codex 'backups/agents-handbook') -Directory)
    Assert-True ($runs.Count -eq 2) 'Same-second applies reused a backup directory'
    Assert-True (@($runs | Where-Object { $_.Name -notmatch '^20000101-000000-[a-f0-9]{32}$' }).Count -eq 0) 'Backup identity does not include the fixed timestamp and unique suffix'
    $repositoryBackupPath = (Join-Path $fixedFixture.Repository 'AGENTS.md').TrimStart('\').Replace(':', '')
    $savedGuidance = @($runs | ForEach-Object {
        Get-Content -LiteralPath (Join-Path $_.FullName $repositoryBackupPath) -Raw
    })
    Assert-True (@($savedGuidance | Where-Object { $_ -eq 'original project' }).Count -eq 1) 'Repeated apply lost the original repository guidance'
    Assert-True (@($savedGuidance | Where-Object { $_ -eq 'first replacement' }).Count -eq 1) 'Repeated apply lost the intermediate repository guidance'
    Assert-True ((Get-Content -LiteralPath (Join-Path $fixedFixture.Repository 'AGENTS.md') -Raw) -eq 'second replacement') 'Repeated apply did not publish the final guidance'
    Write-Host 'PASS: dry run, filter isolation, normalization, source/destination/manifest preflight, no writes on rejection, retirement, legacy manifests, and fixed-time backup uniqueness'
} finally {
    $resolvedFixture = [IO.Path]::GetFullPath($fixtureRoot)
    $resolvedTemp = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\', '/')
    if ((Split-Path -Parent $resolvedFixture) -ne $resolvedTemp -or
        (Split-Path -Leaf $resolvedFixture) -notlike 'handbook-sync-test-*') {
        throw "Refusing cleanup outside the test fixture: $resolvedFixture"
    }
    if (Test-Path -LiteralPath $resolvedFixture) {
        Remove-Item -LiteralPath $resolvedFixture -Recurse -Force
    }
}
