---
title: 'Latex Algorithm2e'
date: 2024-02-18
permalink: /posts/LaTeX-Algorithm2e/
tags:
  - LaTeX
  - Algorithm
  - Algorithm2e
---
## Algorithm2e

Algorithm2e is a LaTeX package for typesetting algorithms in a more convenient way.

In this post, I will show you how to use the `algorithm2e` package to write algorithms in 2 column format, and how to customize the appearance of the algorithm. It was particularly hard for me to find a good example of how to use `algorithm2e` in a 2 column format, so I hope this post will be helpful to others.

The main reference for this post is the [official documentation](https://tug.ctan.org/macros/latex/contrib/algorithm2e/doc/algorithm2e.pdf) of the `algorithm2e` package.

The first step is to include the `algorithm2e` package in the preamble of your LaTeX document:

```latex
% Usually in preamble 
\usepackage[inoutnumbered,linesnumbered,ruled,lined]{algorithm2e}
\usepackage{multicol}

\definecolor{mygreen}{rgb}{0,0.5,0}
\newcommand\mycommfont[1]{\footnotesize\ttfamily\textcolor{mygreen}{#1}}
\SetCommentSty{mycommfont}
```

The `algorithm2e` package provides a number of options for customizing the appearance of the algorithm. The options used in the above example are:

- `inoutnumbered`: Number the input and output lines.
- `linesnumbered`: Number the lines of the algorithm.
- `ruled`: Draw a horizontal line at the top and bottom of the algorithm.
- `lined`: Draw a vertical line to visually show each block of the algorithm.

The `multicol` package is used to create a two-column layout for the algorithm.

The next line defines a custom color for the comments in the algorithm. The `\mycommfont` command is used to set the font and color of the comments. The `\SetCommentSty` command is used to apply the custom font and color to the comments.

Here is an example of how to use the `algorithm2e` package to write an algorithm in a two-column format. The algorithm is split into two columns using the `multicol` environment. The `algorithm*` environment is used to create a two-column layout for the algorithm. The trick `algorithm2e` is that it does not split the algorithm into two columns right in the middle of any block. So, we need to manually split the algorithm into two parts. To make the algorithm split into two parts, we intentionally end the function body and the while loop. This way, the algorithm will be split into two parts, and each part will be placed in a separate column.

```latex
\begin{algorithm*}
  \begin{multicols}{2}
  \SetAlgoShortEnd
  \DontPrintSemicolon
  
  \SetKwInput{KwInput}{Input}
  \SetKwInput{KwOutput}{Output}              
  \SetKwFunction{FMain}{Main}
  \SetKwProg{Loop}{while}{}{}
  \SetKwProg{Fn}{Function}{:}{}
  \KwIn{$input\_graph$}
    \KwOut{$output\_graph$}
    \Fn{$random\_function$}{
      $counter \leftarrow 0$ \tcp{inline comment}
      $edges$ \tcp{another comment}

      $assign random \leftarrow 0$ \;

      \For{$i \leftarrow 0$ \KwTo sizeof($edges$)}{
        \uIf{$edges[i] \in new\_edges$ \textbf{and} $check(new\_edges, edges[i], random) > 0$}{
          $vertex[i] \leftarrow$ Enable \;
        }\Else{
          $vertex[i] \leftarrow$ Disable \;
        }

        \uIf{$edges[i] \in new\_edges$ \textbf{and} $check(old\_edges, edges[i], random) > 0$}{
          $vertex[i] \leftarrow$ Enable \;
        }\Else{
          $vertex[i] \leftarrow$ Disable \;
        }
      }

      $edges \leftarrow $ \# Enable edges $+$ \# Enable vertices \;

      \Loop {$edges\_size < edges$ \textbf{or} $counter < edges$}{
        \For{$i \leftarrow 0$ \KwTo sizeof($edges$)}{
          \uIf{$edges[i] \in new\_edges$ \textbf{and} $check(new\_edges, edges[i], random) > 0$}{
            $vertex[i] \leftarrow$ Enable \;
          }\Else{
            $vertex[i] \leftarrow$ Disable \;
          }

          \If{$edges[i] \in new\_edges$}{
            $vertex[i] \leftarrow$ Enable \;
          }
        }
      } % Here is where we end the while loop intentionally to enable split of the algorithm
    } % Here is where we end the function intentionally to enable split of the algorithm

    \SetKwBlock{Begin}{}{return}
    \tcp*[h]{Rest of the function body}
    \Begin{
      \SetKwBlock{Begin}{}{end\ while}
      \tcp*[h]{Rest of the while body}
      \Begin {

        \uIf{$check(new\_edges, edges[i], random) > 0$}{
          $vertex[i] \leftarrow$ Enable \;
        }
        \uElseIf{$check(old\_edges, edges[i], random) > 0$}{
          $vertex[i] \leftarrow$ Disable \;
        }
        \uElseIf{$check(old\_edges, edges[i], random) == 0$}{
          $vertex[i] \leftarrow$ Disable \;
        }
        \Else{
          $vertex[i] \leftarrow$ Disable \;
        }

        \For{$i \leftarrow 0$ \KwTo sizeof($edges$)}{
          \uIf{$edges[i] \in new\_edges$ \textbf{and} $check(new\_edges, edges[i], random) > 0$}{
            $vertex[i] \leftarrow$ Enable \;
          }\Else{
            $vertex[i] \leftarrow$ Disable \;
          }

          \If{$edges[i] \in new\_edges$}{
            $vertex[i] \leftarrow$ Enable \;
          }
        }

        \uIf{$check(new\_edges, edges[i], random) > 0$}{
          $vertex[i] \leftarrow$ Enable \;
        }
        \uElseIf{$check(old\_edges, edges[i], random) > 0$}{
          $vertex[i] \leftarrow$ Disable \;
        }
        \uElseIf{$check(old\_edges, edges[i], random) == 0$}{
          $vertex[i] \leftarrow$ Disable \;
        }
        \Else{
          $vertex[i] \leftarrow$ Disable \;
        }
      }  % End of while
    } % End of find_agent

    \caption{Random\ algorithm}
    \label{Random Algorithm}
  \end{multicols}
\end{algorithm*}
```

These two lines make sure that the `function` and `while` blocks are ended with no `end` or `return` keyword.

```latex
  \SetKwProg{Loop}{while}{}{}
  \SetKwProg{Fn}{Function}{:}{}
```

These two lines end the `function` and `while` blocks intentionally to enable the split of the algorithm.

```latex
  } % Here is where we end the function intentionally to enable split of the algorithm
} % Here is where we end the while loop intentionally to enable split of the algorithm
```

Then, at the start of the next split, we make sure that the `function` and `while` blocks are started with no keywords (the first curly brackets are empty).

```latex
  \SetKwBlock{Begin}{}{return}
  \tcp*[h]{Rest of the function body}
  \Begin{
    \SetKwBlock{Begin}{}{end\ while}
    \tcp*[h]{Rest of the while body}
    \Begin {
```

This is how it should look like in the final document:

![Algorithm-screenshot](https://github.com/amirsojoodi/Manuals-and-Tutorials/assets/10928452/3ac3b3bb-6690-440f-9bf2-9cc25ef692db)

## References

1. [Official documentation of algorithm2e](https://tug.ctan.org/macros/latex/contrib/algorithm2e/doc/algorithm2e.pdf)
2. [https://tex.stackexchange.com/questions/18949/algorithm2e-split-over-several-pages](https://tex.stackexchange.com/questions/18949/algorithm2e-split-over-several-pages)
