# ShareNotes

Public Markdown notes for GitHub Pages.

## Privacy Model

Each shared note uses a cryptographically random filename under `notes/`.
This keeps note URLs difficult to guess.

Do not publish Obsidian workspace state. The repository ignores
`notes/.obsidian/` and `notes/.trash/`.

Important: if this repository is public, people can still browse the GitHub
repository file list. Unpredictable URLs only protect against guessing Pages
URLs, not against browsing a public source repo.

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
unpredictable filename, and prints the GitHub Pages URL.

## Protect an Existing Obsidian Note

If Obsidian created a readable filename, rename it before publishing:

```powershell
.\scripts\Protect-ShareNoteName.ps1 -Path "notes\my-readable-note.md"
```

The script preserves the file content, gives it a random filename, and prints
the GitHub Pages URL.

## Publish Notes

After editing Markdown files in Obsidian, run:

```powershell
.\scripts\Publish-ShareNotes.ps1
```

The script commits and pushes new or modified Markdown files under `notes/`,
then prints their GitHub Pages URLs.

Publishing refuses Markdown files whose names are not 32 lowercase hexadecimal
characters, so readable Obsidian filenames do not get pushed accidentally.
