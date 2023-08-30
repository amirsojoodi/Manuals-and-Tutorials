# About Pandoc

Pandoc is a universal document converter. Read more [here](https://pandoc.org/index.html)

## Install Pandoc

You can obtain pandoc installer from [here](https://pandoc.org/installing.html)
Or you can install it with choco:

```bash
choco install pandoc
```

## Add Templates

If you want to add templates to pandoc, you should figure out its working directory. You can obtain its working directory by checking the output of `pandoc --version`, e.g:

```bash
pandoc.exe 2.10.1
Compiled with pandoc-types 1.21, texmath 0.12.0.2, skylighting 0.8.5
Default user data directory: C:\Users\USERNAME\AppData\Roaming\pandoc
Copyright (C) 2006-2020 John MacFarlane
Web:  https://pandoc.org
This is free software; see the source for copying conditions.
There is no warranty, not even for merchantability or fitness
for a particular purpose.
```

You can create a directory named `Templates` in the obtained directory and put your templates there.

## Convert formats

To convert from docx to markdown:

```bash
pandoc.exe -f docx -t markdown_strict -i <source_filename> -o <output.md> --wrap=none --atx-headers --extract-media=.
```

- `markdown-strict` is the type of Markdown. Other variants exist in the Pandoc [documentation](https://pandoc.org/MANUAL.html#markdown-variants). For example, gfm is for Github-Flavored Markdown.
- `--wrap=none` ensures that text in the new .md files doesn't get wrapped to new lines after 80 characters
- `--atx-headers` makes headers in the new .md files appear as # h1, ## h2 and so on
- `--extract-media=.` selects the current directory to store the media files.

To convert from markdown to docx (gfm = github flavoured markdown):

```bash
pandoc.exe -f gfm -t docx -i Research-Ideas.md -o Research-Ideas1.docx
# or 
pandoc.exe -f markdown -t docx -i Research-Ideas.md -o Research-Ideas1.docx
```

On windows Powershell, one can run this command to convert all of the docx files in the current directory to markdown format:

```bash
ForEach ($result in Get-ChildItem | select Name, BaseName) { pandoc.exe -f docx -t markdown_strict -i $result.Name -o "$($result.BaseName).md" --wrap=none --atx-headers --extract-media=. }
```
