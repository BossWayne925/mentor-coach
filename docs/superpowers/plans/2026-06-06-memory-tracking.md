# Memory & Tracking System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a session logging system where the mentor drafts session logs, Wayne approves them, and a PostToolUse hook automatically regenerates `logs/tracker.md` from all session frontmatter.

**Architecture:** Session logs (morning/evening/weekly-review) store structured YAML frontmatter plus prose summaries. A PowerShell script reads all frontmatter and writes a computed `tracker.md`. A Claude Code PostToolUse hook fires the script automatically whenever a session log is saved.

**Tech Stack:** PowerShell 7 (pwsh), Pester 5 (testing), Markdown with YAML frontmatter, Claude Code hooks via `.claude/settings.json`.

---

## File Map

**Create:**
- `logs/sessions/.gitkeep` — directory placeholder
- `logs/weeks/.gitkeep` — directory placeholder
- `logs/tracker.md` — initial empty state (script will overwrite)
- `scripts/update-tracker.ps1` — reads all session logs, writes tracker.md and weekly summaries
- `tests/update-tracker.Tests.ps1` — Pester 5 tests for script functions
- `tests/fixtures/evening-becoming.md` — test fixture
- `tests/fixtures/evening-mixed.md` — test fixture
- `tests/fixtures/morning.md` — test fixture
- `.claude/settings.json` — project-level hook config

**Modify:**
- `CLAUDE.md` — add `logs/tracker.md` + last session log to context loading; add session-end draft/approve workflow

---

## Task 1: Create Directory Structure and Initial Files

**Files:**
- Create: `logs/sessions/.gitkeep`
- Create: `logs/weeks/.gitkeep`
- Create: `logs/tracker.md`

- [ ] **Step 1: Create the directories and placeholder files**

```powershell
New-Item -ItemType Directory -Force "E:/mentor_coach/logs/sessions"
New-Item -ItemType Directory -Force "E:/mentor_coach/logs/weeks"
New-Item -ItemType Directory -Force "E:/mentor_coach/scripts"
New-Item -ItemType Directory -Force "E:/mentor_coach/tests/fixtures"
"" | Set-Content "E:/mentor_coach/logs/sessions/.gitkeep"
"" | Set-Content "E:/mentor_coach/logs/weeks/.gitkeep"
```

- [ ] **Step 2: Create the initial tracker.md**

Write this to `logs/tracker.md`:

```markdown
---
generated: never
sessions-logged: 0
---

# Tracker

No sessions logged yet.
```

- [ ] **Step 3: Verify structure**

```powershell
Get-ChildItem "E:/mentor_coach/logs" -Recurse | Select-Object FullName
Get-ChildItem "E:/mentor_coach/scripts"
Get-ChildItem "E:/mentor_coach/tests"
```

Expected: `logs/sessions/`, `logs/weeks/`, `logs/tracker.md`, `scripts/`, `tests/fixtures/`

- [ ] **Step 4: Commit**

```powershell
cd E:/mentor_coach
git add logs/ scripts/ tests/
git commit -m "feat: scaffold logs/, scripts/, tests/ directories"
```

---

## Task 2: Test Fixtures and Frontmatter Parser (TDD)

**Files:**
- Create: `tests/fixtures/evening-becoming.md`
- Create: `tests/fixtures/evening-mixed.md`
- Create: `tests/fixtures/morning.md`
- Create: `tests/update-tracker.Tests.ps1`
- Create: `scripts/update-tracker.ps1` (functions only — no main entry point yet)

- [ ] **Step 1: Install Pester 5**

```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser -MinimumVersion 5.0.0
Import-Module Pester -MinimumVersion 5.0.0 -Force
Get-Module Pester | Select-Object Name, Version
```

Expected: `Pester  5.x.x`

- [ ] **Step 2: Create test fixture — evening-becoming.md**

Write to `tests/fixtures/evening-becoming.md`:

```markdown
---
date: 2026-06-06
type: evening
score: becoming
top-3-planned: ["Define EBC offer", "Film video", "Build CRM"]
top-3-done: ["Define EBC offer", "Film video", "Build CRM"]
commitments-touched: [3, 5]
slip: false
skills-deployed: [score-the-day]
---

## The 3 things

1. Defined the EBC offer — one sentence, one price, one client type.
2. Filmed the intro video. Raw but done.
3. Built the CRM template in Notion.

## Score rationale

All three planned tasks done. No slip. Clean day.

## Carry-forward

Map content strategy tomorrow morning.
```

- [ ] **Step 3: Create test fixture — evening-mixed.md**

Write to `tests/fixtures/evening-mixed.md`:

```markdown
---
date: 2026-06-07
type: evening
score: mixed
top-3-planned: ["Cold outreach", "Content strategy", "Record video 2"]
top-3-done: ["Content strategy"]
commitments-touched: [4]
slip: true
skills-deployed: [score-the-day, slip-recovery]
---

## The 3 things

1. Mapped content strategy — 4 video topics locked.
2. Skipped cold outreach. Felt the avoidance, didn't push through.
3. Did not record video 2.

## Score rationale

One of three. Slip on outreach. Mixed day.

## Carry-forward

Cold outreach non-negotiable tomorrow.
```

- [ ] **Step 4: Create test fixture — morning.md**

Write to `tests/fixtures/morning.md`:

```markdown
---
date: 2026-06-07
type: morning
top-3-tasks: ["Cold outreach", "Content strategy", "Record video 2"]
carry-forward: ["Map content strategy tomorrow morning"]
energy: high
---

## Plan for today

Lock three things, execute all three.

## Carry-forward from last night

Map content strategy.

## If-then activations

If outreach avoidance hits — set timer 15 minutes, do nothing but outreach.
```

- [ ] **Step 5: Write the failing test for Get-SessionFrontmatter**

Write to `tests/update-tracker.Tests.ps1`:

```powershell
BeforeAll {
    . "$PSScriptRoot/../scripts/update-tracker.ps1"
    $fixturesDir = "$PSScriptRoot/fixtures"
}

Describe "Get-SessionFrontmatter" {
    It "parses string fields" {
        $result = Get-SessionFrontmatter "$fixturesDir/evening-becoming.md"
        $result.date   | Should -Be "2026-06-06"
        $result.type   | Should -Be "evening"
        $result.score  | Should -Be "becoming"
    }

    It "parses boolean false" {
        $result = Get-SessionFrontmatter "$fixturesDir/evening-becoming.md"
        $result.slip | Should -Be $false
    }

    It "parses boolean true" {
        $result = Get-SessionFrontmatter "$fixturesDir/evening-mixed.md"
        $result.slip | Should -Be $true
    }

    It "parses integer arrays" {
        $result = Get-SessionFrontmatter "$fixturesDir/evening-becoming.md"
        $result.'commitments-touched' | Should -Be @(3, 5)
    }

    It "parses string arrays" {
        $result = Get-SessionFrontmatter "$fixturesDir/evening-becoming.md"
        $result.'skills-deployed' | Should -Be @("score-the-day")
    }

    It "parses quoted string arrays" {
        $result = Get-SessionFrontmatter "$fixturesDir/morning.md"
        $result.'top-3-tasks' | Should -Be @("Cold outreach", "Content strategy", "Record video 2")
    }

    It "returns empty hashtable for file with no frontmatter" {
        $tempFile = New-TemporaryFile
        Set-Content $tempFile.FullName "No frontmatter here"
        $result = Get-SessionFrontmatter $tempFile.FullName
        $result.Count | Should -Be 0
        Remove-Item $tempFile.FullName
    }
}
```

- [ ] **Step 6: Run the test — confirm it fails**

```powershell
cd E:/mentor_coach
Invoke-Pester tests/update-tracker.Tests.ps1 -Output Detailed
```

Expected: FAIL — `Get-SessionFrontmatter` not defined.

- [ ] **Step 7: Create scripts/update-tracker.ps1 with Get-SessionFrontmatter**

Write to `scripts/update-tracker.ps1`:

```powershell
# Parses YAML frontmatter from a session log file.
# Returns a hashtable of key-value pairs. Arrays and booleans are typed.
function Get-SessionFrontmatter {
    param([string]$FilePath)

    $content = Get-Content $FilePath -Raw -ErrorAction Stop
    if ($content -notmatch '(?s)^---\r?\n(.+?)\r?\n---') { return @{} }

    $yaml = $Matches[1]
    $result = @{}

    foreach ($line in ($yaml -split '\r?\n')) {
        if ($line -notmatch '^([^:]+):\s*(.*)$') { continue }
        $key   = $Matches[1].Trim()
        $value = $Matches[2].Trim()

        if ($value -match '^\[(.+)\]$') {
            # Array: [1, 3] or ["a", "b"] or [a, b]
            $items = $Matches[1] -split '\s*,\s*'
            $value = @($items | ForEach-Object {
                $item = $_.Trim().Trim('"')
                if ($item -match '^\d+$') { [int]$item } else { $item }
            })
        } elseif ($value -eq 'true')  { $value = $true  }
        elseif  ($value -eq 'false') { $value = $false }

        $result[$key] = $value
    }

    return $result
}

# --- Main entry point (only runs when invoked directly, not dot-sourced) ---
if ($MyInvocation.InvocationName -ne '.') {
    # Placeholder — implemented in Task 5
}
```

- [ ] **Step 8: Run the tests — confirm they pass**

```powershell
Invoke-Pester tests/update-tracker.Tests.ps1 -Output Detailed
```

Expected: All 7 tests PASS.

- [ ] **Step 9: Commit**

```powershell
git add scripts/update-tracker.ps1 tests/
git commit -m "feat: frontmatter parser with Pester tests"
```

---

## Task 3: Computation Functions (TDD)

**Files:**
- Modify: `scripts/update-tracker.ps1` — add 5 computation functions
- Modify: `tests/update-tracker.Tests.ps1` — add tests for each function

The computation functions take an array of session hashtables (parsed frontmatter) and return data for the tracker.

- [ ] **Step 1: Write failing tests for Get-AllSessions**

Append to `tests/update-tracker.Tests.ps1`:

```powershell
Describe "Get-AllSessions" {
    It "returns sessions sorted by date ascending" {
        $sessions = Get-AllSessions "$fixturesDir"
        $sessions.Count | Should -Be 3
        $sessions[0].date | Should -Be "2026-06-06"
        $sessions[2].date | Should -Be "2026-06-07"
    }

    It "includes both morning and evening types" {
        $sessions = Get-AllSessions "$fixturesDir"
        $types = $sessions | ForEach-Object { $_.type }
        $types | Should -Contain "morning"
        $types | Should -Contain "evening"
    }
}
```

- [ ] **Step 2: Write failing tests for Get-CurrentStreak**

Append to `tests/update-tracker.Tests.ps1`:

```powershell
Describe "Get-CurrentStreak" {
    It "returns 1 when the most recent evening is becoming" {
        $sessions = Get-AllSessions "$fixturesDir"
        # most recent evening is mixed (2026-06-07), so streak = 0
        $streak = Get-CurrentStreak $sessions
        $streak | Should -Be 0
    }

    It "returns count of consecutive becoming evenings from most recent" {
        $fakeSessions = @(
            @{ date = "2026-06-05"; type = "evening"; score = "becoming" },
            @{ date = "2026-06-06"; type = "evening"; score = "becoming" },
            @{ date = "2026-06-07"; type = "evening"; score = "becoming" }
        )
        Get-CurrentStreak $fakeSessions | Should -Be 3
    }

    It "stops counting at first non-becoming" {
        $fakeSessions = @(
            @{ date = "2026-06-05"; type = "evening"; score = "comfort-zone-won" },
            @{ date = "2026-06-06"; type = "evening"; score = "becoming" },
            @{ date = "2026-06-07"; type = "evening"; score = "becoming" }
        )
        Get-CurrentStreak $fakeSessions | Should -Be 2
    }

    It "returns 0 when no evening sessions exist" {
        $fakeSessions = @(
            @{ date = "2026-06-06"; type = "morning" }
        )
        Get-CurrentStreak $fakeSessions | Should -Be 0
    }
}
```

- [ ] **Step 3: Write failing tests for Get-PlanVsDone**

Append to `tests/update-tracker.Tests.ps1`:

```powershell
Describe "Get-PlanVsDone" {
    It "returns planned, done, and hit rate" {
        $sessions = Get-AllSessions "$fixturesDir"
        $result = Get-PlanVsDone $sessions
        $result.Planned  | Should -Be 6   # 3 + 3 across two evenings
        $result.Done     | Should -Be 4   # 3 + 1 across two evenings
        $result.HitRate  | Should -Be 67  # floor(4/6 * 100)
    }

    It "returns zeros when no evening sessions" {
        $result = Get-PlanVsDone @(@{ type = "morning" })
        $result.Planned | Should -Be 0
        $result.Done    | Should -Be 0
        $result.HitRate | Should -Be 0
    }
}
```

- [ ] **Step 4: Write failing tests for Get-Patterns**

Append to `tests/update-tracker.Tests.ps1`:

```powershell
Describe "Get-Patterns" {
    It "returns empty array when no patterns" {
        $fakeSessions = @(
            @{ date = "2026-06-06"; type = "evening"; score = "becoming" }
        )
        $result = Get-Patterns $fakeSessions
        $result | Should -BeNullOrEmpty
    }

    It "flags comfort-zone-won streak of 3 or more" {
        $fakeSessions = @(
            @{ date = "2026-06-04"; type = "evening"; score = "comfort-zone-won" },
            @{ date = "2026-06-05"; type = "evening"; score = "comfort-zone-won" },
            @{ date = "2026-06-06"; type = "evening"; score = "comfort-zone-won" }
        )
        $result = Get-Patterns $fakeSessions
        $result | Should -Contain "Comfort zone won 3 consecutive evenings"
    }
}
```

- [ ] **Step 5: Run all tests — confirm new ones fail**

```powershell
Invoke-Pester tests/update-tracker.Tests.ps1 -Output Detailed
```

Expected: New tests FAIL — functions not defined yet.

- [ ] **Step 6: Implement the four functions in scripts/update-tracker.ps1**

Add these functions after `Get-SessionFrontmatter` (before the main entry point comment):

```powershell
# Reads all session log files from a directory, returns array of frontmatter hashtables sorted by date.
function Get-AllSessions {
    param([string]$SessionsDir)

    $files = Get-ChildItem $SessionsDir -Filter "*.md" -ErrorAction SilentlyContinue |
             Where-Object { $_.Name -ne '.gitkeep' }

    $sessions = @()
    foreach ($file in $files) {
        $fm = Get-SessionFrontmatter $file.FullName
        if ($fm.Count -gt 0) { $sessions += $fm }
    }

    return @($sessions | Sort-Object { [datetime]$_.date })
}

# Returns count of consecutive "becoming" evening sessions from most recent backwards.
function Get-CurrentStreak {
    param([array]$Sessions)

    $evenings = @($Sessions | Where-Object { $_.type -eq 'evening' } |
                  Sort-Object { [datetime]$_.date } -Descending)
    $streak = 0
    foreach ($s in $evenings) {
        if ($s.score -eq 'becoming') { $streak++ } else { break }
    }
    return $streak
}

# Returns planned task count, done count, and integer hit rate % across all evening sessions.
function Get-PlanVsDone {
    param([array]$Sessions)

    $evenings = @($Sessions | Where-Object { $_.type -eq 'evening' })
    $planned = 0
    $done    = 0

    foreach ($s in $evenings) {
        $p = if ($s.'top-3-planned') { @($s.'top-3-planned').Count } else { 0 }
        $d = if ($s.'top-3-done')    { @($s.'top-3-done').Count    } else { 0 }
        $planned += $p
        $done    += $d
    }

    $rate = if ($planned -gt 0) { [math]::Floor($done / $planned * 100) } else { 0 }
    return @{ Planned = $planned; Done = $done; HitRate = $rate }
}

# Returns array of pattern strings detected from session history.
function Get-Patterns {
    param([array]$Sessions)

    $patterns = @()
    $evenings = @($Sessions | Where-Object { $_.type -eq 'evening' } |
                  Sort-Object { [datetime]$_.date } -Descending)

    # Consecutive comfort-zone-won streak
    $czStreak = 0
    foreach ($s in $evenings) {
        if ($s.score -eq 'comfort-zone-won') { $czStreak++ } else { break }
    }
    if ($czStreak -ge 3) {
        $patterns += "Comfort zone won $czStreak consecutive evenings"
    }

    # Low plan-vs-done rate
    $pvd = Get-PlanVsDone $Sessions
    if ($pvd.Planned -ge 6 -and $pvd.HitRate -lt 50) {
        $patterns += "Plan-vs-done hit rate below 50% ($($pvd.HitRate)%)"
    }

    return $patterns
}
```

- [ ] **Step 7: Run all tests — confirm they pass**

```powershell
Invoke-Pester tests/update-tracker.Tests.ps1 -Output Detailed
```

Expected: All tests PASS.

- [ ] **Step 8: Commit**

```powershell
git add scripts/update-tracker.ps1 tests/update-tracker.Tests.ps1
git commit -m "feat: computation functions — streak, plan-vs-done, patterns"
```

---

## Task 4: Tracker Generation (TDD)

**Files:**
- Modify: `scripts/update-tracker.ps1` — add `Get-WeeklyTable` and `New-TrackerContent`
- Modify: `tests/update-tracker.Tests.ps1` — add tests

- [ ] **Step 1: Write failing tests for Get-WeeklyTable**

Append to `tests/update-tracker.Tests.ps1`:

```powershell
Describe "Get-WeeklyTable" {
    It "returns a markdown table string" {
        $sessions = Get-AllSessions "$fixturesDir"
        $result = Get-WeeklyTable $sessions 23 2026
        $result | Should -Match '\| Day \| Morning \| Evening \| Score \|'
    }

    It "marks logged days correctly" {
        $sessions = Get-AllSessions "$fixturesDir"
        $result = Get-WeeklyTable $sessions 23 2026
        # 2026-06-06 is Saturday of W23, evening score: becoming
        $result | Should -Match 'Sat.*logged.*becoming'
    }

    It "marks missing sessions with dash" {
        $sessions = Get-AllSessions "$fixturesDir"
        $result = Get-WeeklyTable $sessions 23 2026
        $result | Should -Match 'Mon.*—.*—.*—'
    }
}
```

- [ ] **Step 2: Write failing test for New-TrackerContent**

Append to `tests/update-tracker.Tests.ps1`:

```powershell
Describe "New-TrackerContent" {
    It "includes all required sections" {
        $sessions = Get-AllSessions "$fixturesDir"
        $commitmentsFile = "$PSScriptRoot/../goals/weekly-commitments.md"
        $result = New-TrackerContent $sessions $commitmentsFile
        $result | Should -Match '# Tracker'
        $result | Should -Match '## Current streak'
        $result | Should -Match '## This week'
        $result | Should -Match '## Weekly commitments'
        $result | Should -Match '## Plan vs. done'
    }
}
```

- [ ] **Step 3: Run tests — confirm they fail**

```powershell
Invoke-Pester tests/update-tracker.Tests.ps1 -Output Detailed
```

Expected: New tests FAIL.

- [ ] **Step 4: Implement Get-WeeklyTable and New-TrackerContent**

Add to `scripts/update-tracker.ps1` after `Get-Patterns`:

```powershell
# Builds the week table rows for a given ISO week number and year.
function Get-WeeklyTable {
    param([array]$Sessions, [int]$ISOWeek, [int]$Year)

    # .NET DayOfWeek: Sunday=0, Monday=1 ... Saturday=6
    $days = [ordered]@{
        Mon = 1; Tue = 2; Wed = 3; Thu = 4; Fri = 5; Sat = 6; Sun = 0
    }

    $lines = @(
        "| Day | Morning | Evening | Score |",
        "|-----|---------|---------|-------|"
    )

    foreach ($day in $days.Keys) {
        $dotNetDay = $days[$day]
        $daySessions = @($Sessions | Where-Object {
            try {
                $d = [datetime]$_.date
                [System.Globalization.ISOWeek]::GetWeekOfYear($d) -eq $ISOWeek -and
                $d.Year -eq $Year -and
                [int]$d.DayOfWeek -eq $dotNetDay
            } catch { $false }
        })

        $morning   = if ($daySessions | Where-Object { $_.type -eq 'morning' }) { 'logged' } else { '—' }
        $eveningSess = $daySessions | Where-Object { $_.type -eq 'evening' } | Select-Object -First 1
        $evening   = if ($eveningSess) { 'logged' } else { '—' }
        $score     = if ($eveningSess) { $eveningSess.score } else { '—' }

        $lines += "| $day | $morning | $evening | $score |"
    }

    return $lines -join "`n"
}

# Reads the [x] checkboxes from weekly-commitments.md to get completion state.
function Get-CommitmentLines {
    param([string]$CommitmentsFile)

    if (-not (Test-Path $CommitmentsFile)) { return @() }
    $content = Get-Content $CommitmentsFile
    return @($content | Where-Object { $_ -match '^\d+\. \[[ x]\]' })
}

# Builds the full tracker.md content string from sessions and commitment state.
function New-TrackerContent {
    param([array]$Sessions, [string]$CommitmentsFile)

    $now        = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
    $count      = $Sessions.Count
    $streak     = Get-CurrentStreak $Sessions
    $pvd        = Get-PlanVsDone $Sessions
    $patterns   = Get-Patterns $Sessions

    # Determine current week from today
    $today   = Get-Date
    $isoWeek = [System.Globalization.ISOWeek]::GetWeekOfYear($today)
    $year    = $today.Year
    $weekTag = "W$($isoWeek.ToString('D2'))"

    $weekTable = Get-WeeklyTable $Sessions $isoWeek $year

    # Last comfort-zone-won date
    $evenings    = @($Sessions | Where-Object { $_.type -eq 'evening' } | Sort-Object { [datetime]$_.date } -Descending)
    $lastCZWObj  = $evenings | Where-Object { $_.score -eq 'comfort-zone-won' } | Select-Object -First 1
    $lastCZW     = if ($lastCZWObj) { $lastCZWObj.date } else { 'none' }

    # Commitments
    $commitLines = Get-CommitmentLines $CommitmentsFile
    $doneCount   = ($commitLines | Where-Object { $_ -match '\[x\]' }).Count
    $totalCount  = $commitLines.Count
    $pct         = if ($totalCount -gt 0) { [math]::Floor($doneCount / $totalCount * 100) } else { 0 }
    $commitBlock = if ($commitLines.Count -gt 0) { $commitLines -join "`n" } else { "(no commitments loaded)" }

    # Patterns
    $patternBlock = if ($patterns.Count -gt 0) {
        ($patterns | ForEach-Object { "- $_" }) -join "`n"
    } else {
        "- None detected"
    }

    return @"
---
generated: $now
sessions-logged: $count
---

# Tracker

## Current streak
Becoming: $streak days
Last comfort-zone-won: $lastCZW

## This week ($weekTag)
$weekTable

## Weekly commitments ($weekTag)
$commitBlock

Completion: $doneCount/$totalCount ($pct%)

## Plan vs. done (all sessions)
Tasks planned: $($pvd.Planned) | Tasks done: $($pvd.Done) | Hit rate: $($pvd.HitRate)%

## Patterns flagged
$patternBlock
"@
}
```

- [ ] **Step 5: Run all tests — confirm they pass**

```powershell
Invoke-Pester tests/update-tracker.Tests.ps1 -Output Detailed
```

Expected: All tests PASS.

- [ ] **Step 6: Smoke test the content manually**

```powershell
cd E:/mentor_coach
. scripts/update-tracker.ps1
$sessions = Get-AllSessions "tests/fixtures"
$content  = New-TrackerContent $sessions "goals/weekly-commitments.md"
Write-Host $content
```

Expected: Full tracker markdown rendered in terminal with correct data from fixtures.

- [ ] **Step 7: Commit**

```powershell
git add scripts/update-tracker.ps1 tests/update-tracker.Tests.ps1
git commit -m "feat: weekly table + tracker content generation"
```

---

## Task 5: Weekly Summary Generation + Main Entry Point

**Files:**
- Modify: `scripts/update-tracker.ps1` — add `New-WeeklySummary` and `Main` function

- [ ] **Step 1: Implement New-WeeklySummary**

Add to `scripts/update-tracker.ps1` after `New-TrackerContent`:

```powershell
# Builds the weekly summary markdown for a given ISO week.
function New-WeeklySummary {
    param([array]$Sessions, [string]$CommitmentsFile, [int]$ISOWeek, [int]$Year)

    $weekTag     = "W$($ISOWeek.ToString('D2'))"
    $weekTable   = Get-WeeklyTable $Sessions $ISOWeek $Year
    $pvd         = Get-PlanVsDone $Sessions
    $patterns    = Get-Patterns $Sessions
    $commitLines = Get-CommitmentLines $CommitmentsFile

    $doneCount  = ($commitLines | Where-Object { $_ -match '\[x\]' }).Count
    $totalCount = $commitLines.Count
    $pct        = if ($totalCount -gt 0) { [math]::Floor($doneCount / $totalCount * 100) } else { 0 }
    $commitBlock = if ($commitLines.Count -gt 0) { $commitLines -join "`n" } else { "(none)" }

    $patternBlock = if ($patterns.Count -gt 0) {
        ($patterns | ForEach-Object { "- $_" }) -join "`n"
    } else {
        "- None"
    }

    # Collect carry-forwards from the week's sessions
    $carryForwards = @()
    $weekSessions = @($Sessions | Where-Object {
        try {
            $d = [datetime]$_.date
            [System.Globalization.ISOWeek]::GetWeekOfYear($d) -eq $ISOWeek -and $d.Year -eq $Year
        } catch { $false }
    })

    return @"
---
week: $Year-$weekTag
generated: $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')
sessions: $($weekSessions.Count)
---

# Week $weekTag Summary ($Year)

## Score record
$weekTable

## Commitments — final state
$commitBlock

Completion: $doneCount/$totalCount ($pct%)

## Plan vs. done
Tasks planned: $($pvd.Planned) | Tasks done: $($pvd.Done) | Hit rate: $($pvd.HitRate)%

## Top pattern this week
$patternBlock

## Carry into next week
(Fill in during Sunday weekly review session.)
"@
}
```

- [ ] **Step 2: Implement the Main function and hook stdin handling**

Replace the placeholder main entry point at the bottom of `scripts/update-tracker.ps1` with:

```powershell
# --- Main entry point ---
function Main {
    param([string]$ProjectRoot = $PSScriptRoot\..)

    $ProjectRoot    = Resolve-Path $ProjectRoot
    $sessionsDir    = Join-Path $ProjectRoot "logs/sessions"
    $weeksDir       = Join-Path $ProjectRoot "logs/weeks"
    $trackerFile    = Join-Path $ProjectRoot "logs/tracker.md"
    $commitmentsFile = Join-Path $ProjectRoot "goals/weekly-commitments.md"

    # Check if invoked by hook — read stdin for tool use context
    $hookMode = $false
    if (-not [Console]::IsInputRedirected) {
        # Not a hook — run unconditionally
    } else {
        $stdinRaw = [Console]::In.ReadToEnd().Trim()
        if ($stdinRaw) {
            try {
                $hookData = $stdinRaw | ConvertFrom-Json
                $writtenPath = $hookData.tool_input.file_path
                # Only process if the written file is a session log
                if ($writtenPath -notmatch [regex]::Escape("logs") + "[/\\]sessions[/\\]") {
                    exit 0
                }
                $hookMode = $true
            } catch {
                # JSON parse failed — run unconditionally
            }
        }
    }

    # Load sessions
    $sessions = Get-AllSessions $sessionsDir

    # Regenerate tracker.md
    $trackerContent = New-TrackerContent $sessions $commitmentsFile
    Set-Content $trackerFile $trackerContent -Encoding UTF8
    Write-Host "tracker.md updated ($($sessions.Count) sessions)"

    # If the most recent session is a weekly-review, also generate the weekly summary
    $lastSession = $sessions | Sort-Object { [datetime]$_.date } -Descending | Select-Object -First 1
    if ($lastSession -and $lastSession.type -eq 'weekly-review') {
        $d       = [datetime]$lastSession.date
        $isoWeek = [System.Globalization.ISOWeek]::GetWeekOfYear($d)
        $year    = $d.Year
        $weekTag = "W$($isoWeek.ToString('D2'))"

        $summaryContent = New-WeeklySummary $sessions $commitmentsFile $isoWeek $year
        $summaryFile    = Join-Path $weeksDir "$year-$weekTag.md"
        Set-Content $summaryFile $summaryContent -Encoding UTF8
        Write-Host "Weekly summary written: $summaryFile"
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    Main
}
```

- [ ] **Step 3: Smoke test the full script end-to-end**

```powershell
cd E:/mentor_coach
pwsh -File scripts/update-tracker.ps1
```

Expected output:
```
tracker.md updated (0 sessions)
```

(Zero sessions because `logs/sessions/` is empty — that's correct.)

- [ ] **Step 4: Test with fixture sessions**

```powershell
Copy-Item tests/fixtures/*.md logs/sessions/
pwsh -File scripts/update-tracker.ps1
Get-Content logs/tracker.md
```

Expected: tracker.md shows 3 sessions, correct streak, week table, patterns.

- [ ] **Step 5: Clean up — remove fixture files from logs/sessions/**

```powershell
Remove-Item logs/sessions/evening-becoming.md, logs/sessions/evening-mixed.md, logs/sessions/morning.md
```

- [ ] **Step 6: Run full test suite one more time**

```powershell
Invoke-Pester tests/update-tracker.Tests.ps1 -Output Detailed
```

Expected: All tests PASS.

- [ ] **Step 7: Commit**

```powershell
git add scripts/update-tracker.ps1
git commit -m "feat: weekly summary generation + main entry point with hook stdin handling"
```

---

## Task 6: Wire the PostToolUse Hook

**Files:**
- Create: `.claude/settings.json`

- [ ] **Step 1: Create .claude/settings.json**

```powershell
New-Item -ItemType Directory -Force "E:/mentor_coach/.claude"
```

Write to `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "pwsh -NonInteractive -File scripts/update-tracker.ps1"
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: Verify the hook config is valid JSON**

```powershell
Get-Content "E:/mentor_coach/.claude/settings.json" | ConvertFrom-Json | ConvertTo-Json -Depth 5
```

Expected: Valid JSON echoed back with no errors.

- [ ] **Step 3: Manual hook test — write a fake session log and confirm tracker updates**

Write a test session log to trigger the hook manually (simulating what the hook does):

```powershell
cd E:/mentor_coach
# Simulate what the hook fires after a Write tool call
$testLog = @"
---
date: 2026-06-06
type: evening
score: becoming
top-3-planned: ["Test task 1", "Test task 2", "Test task 3"]
top-3-done: ["Test task 1", "Test task 2", "Test task 3"]
commitments-touched: [2]
slip: false
skills-deployed: [score-the-day]
---

## Test session log

This is a test entry.

## Score rationale

All three done.

## Carry-forward

None.
"@
Set-Content "logs/sessions/2026-06-06-evening.md" $testLog -Encoding UTF8
pwsh -NonInteractive -File scripts/update-tracker.ps1
Get-Content logs/tracker.md
```

Expected: tracker.md shows 1 session, streak=1 (becoming), correct week table entry for Saturday.

- [ ] **Step 4: Commit**

```powershell
git add .claude/settings.json logs/sessions/2026-06-06-evening.md logs/tracker.md
git commit -m "feat: wire PostToolUse hook to auto-regenerate tracker.md"
```

---

## Task 7: Update CLAUDE.md for Session Start/End Workflow

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Update the Context loading section**

In `CLAUDE.md`, replace the **Context loading** section:

```markdown
## Context loading

Every session, read these files in order before responding:

1. `logs/tracker.md` — current streak, week scores, patterns (if file exists)
2. Most recent file in `logs/sessions/` — carry-forward and full context (if any exist)
3. `mentor/identity.md` — who you are, your principles, your constitutional right to refuse
4. `mentor/methodology.md` — how you coach (three tools, trigger map)
5. `mentor/tone.md` — how you sound
6. `me/identity-now.md` — where Wayne is today
7. `me/becoming.md` — where Wayne is headed
8. `me/values-stated.md` + `me/values-lived.md` — the gap you exist to close

Load additional files based on session type (see routing below).
```

- [ ] **Step 2: Add Session end section after the Session routing table**

In `CLAUDE.md`, add a new section after the session routing table:

```markdown
## Session end

Every morning and evening session ends with a drafted session log. The weekly review ends with a drafted weekly-review log.

1. Mentor drafts the session log using the schema from `docs/superpowers/specs/2026-06-06-memory-tracking-design.md`
2. Mentor presents the draft: *"Here's the session summary. Does this capture it accurately?"*
3. Wayne approves or edits
4. Mentor writes the file to `logs/sessions/YYYY-MM-DD-[type].md`
5. The PostToolUse hook fires automatically — `scripts/update-tracker.ps1` runs — `logs/tracker.md` regenerates

Session log types: `morning`, `evening`, `weekly-review`, `freeform`
```

- [ ] **Step 3: Update the File permissions table**

In `CLAUDE.md`, update the permissions table to add the session log write explicitly:

```markdown
| Write session log to `logs/sessions/` | Yes — after Wayne approves the drafted summary |
```

(Add this row after the existing `Write to logs/` row.)

- [ ] **Step 4: Verify CLAUDE.md reads correctly**

```powershell
Get-Content "E:/mentor_coach/CLAUDE.md"
```

Read through and confirm:
- Context loading now starts with tracker.md and last session log
- Session end section is present and accurate
- File permissions table includes session log write

- [ ] **Step 5: Run the full test suite one final time**

```powershell
Invoke-Pester tests/update-tracker.Tests.ps1 -Output Detailed
```

Expected: All tests PASS.

- [ ] **Step 6: Final commit**

```powershell
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md — tracker loading at session start, session-end draft workflow"
```

---

## Post-Implementation Smoke Test

After all tasks are complete, do a full end-to-end test:

1. Start a new Claude Code session in `E:/mentor_coach`
2. Say "evening check-in"
3. Confirm the mentor reads `logs/tracker.md` first (it should reference current streak/patterns)
4. Complete the check-in
5. Approve the session log draft
6. Confirm the mentor writes to `logs/sessions/YYYY-MM-DD-evening.md`
7. Confirm `logs/tracker.md` auto-updates (check the `generated:` timestamp changed)
