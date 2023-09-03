---
title: 'VSCode Color Customization'
date: 2021-12-06
permalink: /posts/VSCode-Color-Customization
tags:
  - Programming
  - VSCode
  - Theme
---

In VSCode, you can install various themes and enable any of them for different languages. However, the cooler thing about it is that you can customize each theme very easily.

Open your `settings.json` file and add the following tags. In the following, the editor background has been updated for both `Default Dark+` and `One Monokai` themes.

```json
    "workbench.colorCustomizations": {
        "[Default Dark+]": {
            "editor.background": "#191d22",
        },
        "[One Monokai]": {
            "editor.background": "#191d22",
            "editor.lineHighlightBackground": "#282c35",
            "editor.selectionBackground": "#3E4451"
        }
    }
```

Also, you can change every entity's color separately. For that, go to the command palette (Ctrl+Shift+P) and find the option: `Developer: Inspect Editor Tokens and Scopes`. Now you can click on any word/character in the your source file and see what its scope is. Then, you can easily change its color and format. In the following, I have changed something in LaTeX and CUDA using this method. (I have changed functions and comments foreground color for all languages)

```json
    "editor.tokenColorCustomizations": {
        "[Default Dark+]": {
            "functions": {
                "foreground": "#dada9c"
                // ,
                // "fontStyle": "italic"
            },
            "textMateRules": [
                {
                    "scope": "entity.name.section.latex",
                    "settings": {
                        "foreground": "#50b4b4",
                        "fontStyle": "italic"
                    },
                },
                {
                    "scope": "constant.numeric.decimal.cuda-cpp",
                    "settings": {
                        "foreground": "#a3ce8c"
                    }
                }
            ]
        },
        "[One Monokai]": {
            "comments": "#677d74",
        }
    },
```

For more information watch this youtube [video](https://youtu.be/7DlZHZF7P3U).
