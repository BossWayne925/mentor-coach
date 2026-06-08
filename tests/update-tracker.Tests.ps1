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

    It "parses quoted string arrays with commas" {
        $tempFile = New-TemporaryFile
        Set-Content $tempFile.FullName @"
---
date: 2026-06-07
type: morning
top-3-tasks: ["Task one, first", "Task two"]
---
"@
        $result = Get-SessionFrontmatter $tempFile.FullName
        $result.'top-3-tasks' | Should -Be @("Task one, first", "Task two")
        Remove-Item $tempFile.FullName
    }

    It "returns empty hashtable for file with no frontmatter" {
        $tempFile = New-TemporaryFile
        Set-Content $tempFile.FullName "No frontmatter here"
        $result = Get-SessionFrontmatter $tempFile.FullName
        $result.Count | Should -Be 0
        Remove-Item $tempFile.FullName
    }
}

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

Describe "Get-CurrentStreak" {
    It "returns 0 when the most recent evening is not becoming" {
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

Describe "Get-PlanVsDone" {
    It "returns planned, done, and hit rate" {
        $sessions = Get-AllSessions "$fixturesDir"
        $result = Get-PlanVsDone $sessions
        $result.Planned  | Should -Be 6   # 3 + 3 across two evenings
        $result.Done     | Should -Be 4   # 3 + 1 across two evenings
        $result.HitRate  | Should -Be 66  # floor(4/6 * 100) = floor(66.67) = 66
    }

    It "returns zeros when no evening sessions" {
        $result = Get-PlanVsDone @(@{ type = "morning" })
        $result.Planned | Should -Be 0
        $result.Done    | Should -Be 0
        $result.HitRate | Should -Be 0
    }
}

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

Describe "Get-LowestScoringDayPattern" {
    It "returns null with fewer than three evening sessions" {
        $result = Get-LowestScoringDayPattern @(
            @{ date = "2026-06-06"; type = "evening"; score = "becoming" },
            @{ date = "2026-06-07"; type = "evening"; score = "mixed" }
        )
        $result | Should -BeNullOrEmpty
    }

    It "flags the lowest scoring weekday when there is a clear pattern" {
        $fakeSessions = @(
            @{ date = "2026-06-02"; type = "evening"; score = "mixed" },
            @{ date = "2026-06-09"; type = "evening"; score = "mixed" },
            @{ date = "2026-06-03"; type = "evening"; score = "becoming" },
            @{ date = "2026-06-10"; type = "evening"; score = "becoming" }
        )
        $result = Get-LowestScoringDayPattern $fakeSessions
        $result | Should -Match 'Lowest average evening score'
    }
}

Describe "Main" {
    It "generates tracker.md from session logs" {
        $root = Join-Path $env:TEMP ("tracker-test-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path (Join-Path $root "logs/sessions") | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $root "logs/weeks") | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $root "goals") | Out-Null
        Set-Content (Join-Path $root "goals/weekly-commitments.md") "1. [ ] Test commitment"
        Set-Content (Join-Path $root "logs/sessions/2026-06-06-evening.md") @"
---
date: 2026-06-06
type: evening
score: becoming
top-3-planned: ["A","B","C"]
top-3-done: ["A","B","C"]
commitments-touched: [1]
slip: false
skills-deployed: [score-the-day]
---
"@
        Main $root
        (Test-Path (Join-Path $root "logs/tracker.md")) | Should -BeTrue
        $trackerText = Get-Content (Join-Path $root "logs/tracker.md") -Raw
        $trackerText | Should -Match 'sessions-logged: 1'
    }

    It "creates a weekly summary when the latest session is weekly-review" {
        $root = Join-Path $env:TEMP ("tracker-test-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path (Join-Path $root "logs/sessions") | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $root "logs/weeks") | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $root "goals") | Out-Null
        Set-Content (Join-Path $root "goals/weekly-commitments.md") "1. [ ] Test commitment"
        Set-Content (Join-Path $root "logs/sessions/2026-06-05-evening.md") @"
---
date: 2026-06-05
type: evening
score: mixed
top-3-planned: ["A"]
top-3-done: ["A"]
commitments-touched: [1]
slip: false
skills-deployed: [score-the-day]
---
"@
        Set-Content (Join-Path $root "logs/sessions/2026-06-06-weekly-review.md") @"
---
date: 2026-06-06
type: weekly-review
---
"@
        Main $root
        $weekPath = Join-Path $root "logs/weeks/2026-W23.md"
        (Test-Path $weekPath) | Should -BeTrue
        $summaryText = Get-Content $weekPath -Raw
        $summaryText | Should -Match 'Week W23 Summary'
    }
}
