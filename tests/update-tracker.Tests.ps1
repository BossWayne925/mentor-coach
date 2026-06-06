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
