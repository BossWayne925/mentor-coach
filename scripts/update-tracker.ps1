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

# --- Main entry point (only runs when invoked directly, not dot-sourced) ---
if ($MyInvocation.InvocationName -ne '.') {
    # Placeholder — implemented in Task 5
}
