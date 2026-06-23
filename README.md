# ShareNotes

Public Markdown notes.

## Create a New Note

Run:

```powershell
.\scripts\New-ShareNote.ps1
```

Or with a title:

```powershell
.\scripts\New-ShareNote.ps1 -Title "My note title"
```

The script creates a Markdown file in `notes/` with a cryptographically random,
unpredictable filename.
