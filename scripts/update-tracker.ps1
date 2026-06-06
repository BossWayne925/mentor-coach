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
