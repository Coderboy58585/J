param(
    [ValidateSet("Lock", "Reset", "Show", "List")]
    [string]$Action = "Show",

    [string]$Key,
    [string]$Hwid,
    [string]$HwidHash,
    [string]$ManifestPath = ".\julia_hwid_locks.json",
    [switch]$CommitPush
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-Sha256Hex {
    param([Parameter(Mandatory = $true)][string]$Text)

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
        return ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace("-", "").ToLowerInvariant()
    }
    finally {
        $sha.Dispose()
    }
}

function Get-CleanKey {
    param([Parameter(Mandatory = $true)][string]$Value)
    return (($Value -replace "\s", "").ToUpperInvariant())
}

function Get-KeyActivationId {
    param([Parameter(Mandatory = $true)][string]$Value)
    return "sha256:" + (Get-Sha256Hex (Get-CleanKey $Value))
}

function Get-NormalizedHwidHash {
    param(
        [string]$RawHwid,
        [string]$ExistingHash
    )

    if ($ExistingHash) {
        $cleanHash = ($ExistingHash -replace "\s", "").ToLowerInvariant()
        if ($cleanHash -notmatch "^[a-f0-9]{64}$") {
            throw "HwidHash must be a 64-character SHA-256 hex string."
        }
        return $cleanHash
    }

    if (-not $RawHwid) {
        throw "Provide -Hwid or -HwidHash."
    }

    return Get-Sha256Hex ("JuliaHubHWID:" + $RawHwid)
}

function New-EmptyManifest {
    return [ordered]@{
        Meta = [ordered]@{
            Name = "Julia Hub HWID Lock Manifest"
            GeneratedAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
            KeyHashAlgorithm = "SHA256(cleaned key)"
            HwidHashAlgorithm = 'SHA256("JuliaHubHWID:" + raw HWID)'
            Notes = "Only key hashes and HWID hashes are stored here. Use julia_hwid_admin.ps1 to lock or reset a key."
        }
        Locks = [ordered]@{}
    }
}

function Read-Manifest {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return New-EmptyManifest
    }

    $json = Get-Content -LiteralPath $Path -Raw
    if (-not $json.Trim()) {
        return New-EmptyManifest
    }

    $parsed = $json | ConvertFrom-Json
    $manifest = New-EmptyManifest

    if ($parsed.Meta) {
        foreach ($property in $parsed.Meta.PSObject.Properties) {
            $manifest.Meta[$property.Name] = $property.Value
        }
    }

    $locks = [ordered]@{}
    if ($parsed.Locks) {
        foreach ($property in $parsed.Locks.PSObject.Properties) {
            $value = $property.Value
            if ($value -and $value.HwidHash) {
                $locks[$property.Name] = [ordered]@{
                    HwidHash = [string]$value.HwidHash
                    UpdatedAt = [string]$value.UpdatedAt
                    Note = [string]$value.Note
                }
            }
        }
    }
    $manifest.Locks = $locks
    return $manifest
}

function Write-Manifest {
    param(
        [Parameter(Mandatory = $true)]$Manifest,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $Manifest.Meta.GeneratedAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $json = $Manifest | ConvertTo-Json -Depth 8
    Set-Content -LiteralPath $Path -Value $json -Encoding UTF8
}

$manifest = Read-Manifest -Path $ManifestPath

if ($Action -eq "List") {
    if ($manifest.Locks.Count -eq 0) {
        Write-Host "No HWID locks are currently set."
    }
    else {
        foreach ($entry in $manifest.Locks.GetEnumerator()) {
            Write-Host "$($entry.Key) => $($entry.Value.HwidHash)"
        }
    }
    return
}

if (-not $Key) {
    throw "Provide -Key for $Action."
}

$activationId = Get-KeyActivationId $Key

if ($Action -eq "Show") {
    if ($manifest.Locks.Contains($activationId)) {
        $lock = $manifest.Locks[$activationId]
        Write-Host "Key lock found:"
        Write-Host "  ActivationId: $activationId"
        Write-Host "  HwidHash: $($lock.HwidHash)"
        Write-Host "  UpdatedAt: $($lock.UpdatedAt)"
    }
    else {
        Write-Host "No HWID lock found for $activationId"
    }
    return
}

if ($Action -eq "Reset") {
    if ($manifest.Locks.Contains($activationId)) {
        $manifest.Locks.Remove($activationId)
        Write-Host "Removed HWID lock for $activationId"
    }
    else {
        Write-Host "No HWID lock existed for $activationId"
    }
}
elseif ($Action -eq "Lock") {
    $normalizedHwidHash = Get-NormalizedHwidHash -RawHwid $Hwid -ExistingHash $HwidHash
    $manifest.Locks[$activationId] = [ordered]@{
        HwidHash = $normalizedHwidHash
        UpdatedAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        Note = "HWID locked by admin script"
    }
    Write-Host "Locked $activationId to HWID hash $normalizedHwidHash"
}

Write-Manifest -Manifest $manifest -Path $ManifestPath

if ($CommitPush) {
    git add -- $ManifestPath
    git commit -m "Update Julia Hub HWID locks"
    git push origin main
}
