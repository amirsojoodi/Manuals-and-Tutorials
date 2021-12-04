## Setting up latex in VS Code

Install [LaTeX-Workshop](https://github.com/James-Yu/LaTeX-Workshop) extension, and follow the instruction to setting up the environment. 

If your latex installation has an embedded `latexindent` you don't need to do anything else. However, if you have `MiKTeX` installed you should do the following to make it work if you don't have its requirements (such as perl):
	1. Find `latexindent.exe` from [this repo](https://github.com/cmhughes/latexindent.pl)
	2. Also download the file `defaultSettings.yaml` from the same repo. (I have also uploaded it here)
	3. Put them somewhere together and add their directory to the PATH.
	4. Go to the MiXTeX bin folder, (probably C:\Program Files\MiKTeX\miktex\bin\x64) and delete `latexindent.exe`. Don't worry! Just delete it. You could simply combine this step with the previous one with replacing the executable file.
	5. In the VS Code, open up latex-workshop settings and search for *format*.
	6. Find the one saying `Latex-workshop › Latexindent: Args`, and add `-m` as another item.
	7. Test and enjoy! If the editor raised any error, test it with command line: `latexindent a.tex -m -w`
	8. For wrapping the lines, just change the value of the `columns` under `textWrapOptions` in `defaultSettings.yaml` file.



