# Julia Hub Portal

This is a static information portal for support notes, HWID lock instructions, and key-management reminders.

## Real Protection

The built-in passphrase gate is only a convenience layer because static files can be inspected by anyone who can download them. For real protection, host this folder behind one of these:

- Cloudflare Access with your email allowlist.
- Netlify password protection.
- Vercel/Pages behind an authenticated reverse proxy.
- A private web server with basic auth or SSO.

## Configure The Local Gate

Generate a SHA-256 hash for your portal passphrase:

```powershell
$s = "your-passphrase-here"
$sha = [Security.Cryptography.SHA256]::Create()
([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($s)))).Replace("-", "").ToLower()
```

Paste that hash into `site/app.js` as `passphraseSha256`.

## Safe Content Rule

Do not put plaintext customer keys, private key CSVs, GitHub tokens, backend API secrets, or private admin passwords into this folder.
