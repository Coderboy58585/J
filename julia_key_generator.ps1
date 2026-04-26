param(
	[int]$Weekly = 300,
	[int]$Monthly = 100,
	[int]$SixMonth = 25,
	[int]$Yearly = 10,
	[int]$Lifetime = 65,
	[string]$OutputManifest = "julia_keys.lua",
	[string]$OutputPrivateCsv = "julia_private_keys.csv"
)

$ErrorActionPreference = "Stop"
$alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789".ToCharArray()
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

function New-SecureToken([int]$Length) {
	$chars = New-Object System.Collections.Generic.List[string]
	$bytes = New-Object byte[] ($Length * 2)
	while ($chars.Count -lt $Length) {
		$rng.GetBytes($bytes)
		foreach ($byte in $bytes) {
			$chars.Add([string]$alphabet[$byte % $alphabet.Length])
			if ($chars.Count -ge $Length) {
				break
			}
		}
	}
	return ($chars -join "")
}

function New-JuliaKey([string]$Prefix) {
	return "$Prefix-$(New-SecureToken 5)-$(New-SecureToken 5)-$(New-SecureToken 5)-$(New-SecureToken 5)"
}

function Get-Sha256Hex([string]$Text) {
	$sha = [System.Security.Cryptography.SHA256]::Create()
	$bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
	$hash = $sha.ComputeHash($bytes)
	return (($hash | ForEach-Object { $_.ToString("x2") }) -join "")
}

$groups = @(
	@{ Count = $Weekly; Duration = "7d"; Prefix = "JH-WK"; Note = "1 Week Key" },
	@{ Count = $Monthly; Duration = "1mo"; Prefix = "JH-MO"; Note = "1 Month Key" },
	@{ Count = $SixMonth; Duration = "6mo"; Prefix = "JH-6M"; Note = "6 Month Key" },
	@{ Count = $Yearly; Duration = "1y"; Prefix = "JH-YR"; Note = "1 Year Key" },
	@{ Count = $Lifetime; Duration = "lifetime"; Prefix = "JH-LT"; Note = "Lifetime Key" }
)

$seen = @{}
$records = New-Object System.Collections.Generic.List[object]
foreach ($group in $groups) {
	for ($index = 1; $index -le $group.Count; $index++) {
		do {
			$key = New-JuliaKey $group.Prefix
		} while ($seen.ContainsKey($key))
		$seen[$key] = $true
		$records.Add([pscustomobject]@{
			Key = $key
			Hash = Get-Sha256Hex $key
			Duration = $group.Duration
			Note = ("{0} #{1:000}" -f $group.Note, $index)
		})
	}
}

$records | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $OutputPrivateCsv

$manifest = New-Object System.Collections.Generic.List[string]
$manifest.Add("return {")
$manifest.Add("`tMeta = {")
$manifest.Add("`t`tName = `"Julia Hub Public Key Manifest`",")
$manifest.Add("`t`tGeneratedAt = `"$((Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ"))`",")
$manifest.Add("`t`tHashAlgorithm = `"SHA256`",")
$manifest.Add("`t`tTotal = $($records.Count),")
$manifest.Add("`t},")
$manifest.Add("`tKeys = {")
foreach ($record in $records) {
	$manifest.Add("`t`t{ Hash = `"$($record.Hash)`", Duration = `"$($record.Duration)`", Note = `"$($record.Note)`" },")
}
$manifest.Add("`t},")
$manifest.Add("`tRevokedHashes = {")
$manifest.Add("`t`t-- [`"paste_sha256_hash_here`"] = true,")
$manifest.Add("`t},")
$manifest.Add("}")

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($OutputManifest, ($manifest -join "`r`n"), $utf8NoBom)

Write-Host "Wrote public hashed manifest: $OutputManifest"
Write-Host "Wrote private plaintext keys: $OutputPrivateCsv"
