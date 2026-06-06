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

# --- Main entry point (only runs when invoked directly, not dot-sourced) ---
if ($MyInvocation.InvocationName -ne '.') {
    # Placeholder — implemented in Task 5
}
