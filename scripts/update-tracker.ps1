# Parses YAML frontmatter from a session log file.
# Returns a hashtable of key-value pairs. Arrays and booleans are typed.
function Get-SessionFrontmatter {
    param([string]$FilePath)

    $content = Get-Content $FilePath -Raw -ErrorAction Stop
    if ($content -notmatch '(?s)^---\r?\n(.+?)\r?\n---') { return @{} }

    $yaml = $Matches[1]
    $result = @{}

    if (Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue) {
        $yamlBlock = "---`n$yaml`n---"
        $parsed    = $yamlBlock | ConvertFrom-Yaml
        foreach ($prop in $parsed.PSObject.Properties) {
            $result[$prop.Name] = $prop.Value
        }
        return $result
    }

    foreach ($line in ($yaml -split '\r?\n')) {
        if ($line -notmatch '^([^:]+):\s*(.*)$') { continue }
        $key   = $Matches[1].Trim()
        $value = $Matches[2].Trim()

        if ($value -match '^\[(.+)\]$') {
            $items = Split-FrontmatterArray $Matches[1]
            $value = @($items | ForEach-Object {
                $item = $_.Trim()
                if ($item -match '^"(.+)"$') { $item = $Matches[1] }
                if ($item -match '^\d+$') { [int]$item } else { $item }
            })
        } elseif ($value -eq 'true')  { $value = $true  }
        elseif  ($value -eq 'false') { $value = $false }

        $result[$key] = $value
    }

    return $result
}

function Split-FrontmatterArray {
    param([string]$ArrayText)

    $items   = @()
    $current = ''
    $inQuote = $false

    for ($i = 0; $i -lt $ArrayText.Length; $i++) {
        $char = $ArrayText[$i]
        if ($char -eq '"') {
            $inQuote = -not $inQuote
            $current += $char
            continue
        }

        if (-not $inQuote -and $char -eq ',') {
            $items += $current.Trim()
            $current = ''
            continue
        }

        $current += $char
    }

    if ($current -ne '') { $items += $current.Trim() }

    return $items | ForEach-Object {
        $item = $_.Trim()
        if ($item -match '^"(.+)"$') { $item = $Matches[1] }
        $item
    }
}

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

    $dayPattern = Get-LowestScoringDayPattern $Sessions
    if ($dayPattern) {
        $patterns += $dayPattern
    }

    return $patterns
}

function Get-ScoreValue {
    param([string]$Score)
    switch ($Score) {
        'becoming'         { 3 }
        'mixed'            { 2 }
        'comfort-zone-won' { 1 }
        default            { 0 }
    }
}

function Get-LowestScoringDayPattern {
    param([array]$Sessions)

    $evenings = @($Sessions | Where-Object { $_.type -eq 'evening' })
    if ($evenings.Count -lt 3) { return $null }

    $scoresByDay = @{}
    foreach ($s in $evenings) {
        try {
            $day = ([datetime]$s.date).DayOfWeek.ToString().Substring(0,3)
        } catch {
            continue
        }
        if (-not $scoresByDay.ContainsKey($day)) { $scoresByDay[$day] = @() }
        $scoresByDay[$day] += Get-ScoreValue $s.score
    }

    $dayAverages = $scoresByDay.GetEnumerator() | ForEach-Object {
        [PSCustomObject]@{
            Day   = $_.Key
            Avg   = ($_.Value | Measure-Object -Average).Average
            Count = $_.Value.Count
        }
    } | Sort-Object Avg, Day

    if ($dayAverages.Count -lt 2) { return $null }

    $best   = $dayAverages[0]
    $second = $dayAverages[1]

    if (($second.Avg - $best.Avg) -lt 0.25) { return $null }

    return "Lowest average evening score: $($best.Day) ($([math]::Round($best.Avg,2))) over $($best.Count) sessions"
}

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
    return @($content | Where-Object { $_ -match '^\d+\. \[[ xX]\]' })
}

function Get-CommitmentBlock {
    param([string]$CommitmentsFile)

    $commitLines = Get-CommitmentLines $CommitmentsFile
    if ($commitLines.Count -gt 0) {
        return $commitLines -join "`n"
    }
    return "(no commitments loaded)"
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
    $commitBlock = Get-CommitmentBlock $CommitmentsFile
    $commitLines = Get-CommitmentLines $CommitmentsFile
    $doneCount   = ($commitLines | Where-Object { $_ -match '\[x\]' }).Count
    $totalCount  = $commitLines.Count
    $pct         = if ($totalCount -gt 0) { [math]::Floor($doneCount / $totalCount * 100) } else { 0 }

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

# Builds the weekly summary markdown for a given ISO week.
function New-WeeklySummary {
    param([array]$Sessions, [string]$CommitmentsFile, [int]$ISOWeek, [int]$Year)

    $weekTag     = "W$($ISOWeek.ToString('D2'))"
    $weekTable   = Get-WeeklyTable $Sessions $ISOWeek $Year
    $pvd         = Get-PlanVsDone $Sessions
    $patterns    = Get-Patterns $Sessions
    $commitLines = Get-CommitmentLines $CommitmentsFile

    $doneCount    = ($commitLines | Where-Object { $_ -match '\[x\]' }).Count
    $totalCount   = $commitLines.Count
    $pct          = if ($totalCount -gt 0) { [math]::Floor($doneCount / $totalCount * 100) } else { 0 }
    $commitBlock  = Get-CommitmentBlock $CommitmentsFile

    $patternBlock = if ($patterns.Count -gt 0) {
        ($patterns | ForEach-Object { "- $_" }) -join "`n"
    } else {
        "- None"
    }

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

# --- Main entry point ---
function Main {
    param([string]$ProjectRoot = "$PSScriptRoot/..")

    $ProjectRoot     = Resolve-Path $ProjectRoot
    $sessionsDir     = Join-Path $ProjectRoot "logs/sessions"
    $weeksDir        = Join-Path $ProjectRoot "logs/weeks"
    $trackerFile     = Join-Path $ProjectRoot "logs/tracker.md"
    $commitmentsFile = Join-Path $ProjectRoot "goals/weekly-commitments.md"

    # Check if invoked by hook — read stdin for tool use context
    if ([Console]::IsInputRedirected) {
        $stdinRaw = [Console]::In.ReadToEnd().Trim()
        if ($stdinRaw) {
            try {
                $hookData    = $stdinRaw | ConvertFrom-Json
                $writtenPath = $hookData.tool_input.file_path
                # Only process if the written file is a session log
                if ($writtenPath -notmatch 'logs[/\\]sessions[/\\]') {
                    exit 0
                }
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

        if (-not (Test-Path $weeksDir)) { New-Item -ItemType Directory -Force $weeksDir | Out-Null }
        $summaryContent = New-WeeklySummary $sessions $commitmentsFile $isoWeek $year
        $summaryFile    = Join-Path $weeksDir "$year-$weekTag.md"
        Set-Content $summaryFile $summaryContent -Encoding UTF8
        Write-Host "Weekly summary written: $summaryFile"
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    Main
}
