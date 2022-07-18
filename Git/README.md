# Some git instructions that maybe needed

## Initialization configuration
```
git config --global user.name "username"
git config --global user.email "mail"
git config --global colur.ui true
git config --global core.editor 
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"
git config --global alias.mylog "log --pretty=format:'%h %s [%an]' --graph"
git config --global push.default current
git config --list
git config --global credential.helper cache

mkdir ~/Documents/gitStore
cd ~/Documents/gitStore

git init
```
## Make some file
```
git add gitConfig.sh
```

## Add everything in all the project in the staging area
```
git add --all
```

## Take a snapshot of everything in the staging area
```
git commit -m "a message"
```

## Print out a log of a
```
git log
```

## Add all txt files in the current directory
```
git add *.txt 
```

## Add all files in the docs directory
```
git add docs/ 
```

## Add all txt files in the entire project
```
git add "*.txt"
```

## Get the differences of files now from repository
```
git diff
git add --all
git diff --staged
git reset HEAD <file>
git commit -a -m "modify something"
```

## Undoing the last commit, put changes into staging
```
git reset --soft HEAD^
```

## Undoing the last commit and all the changes
```
git reset --hard HEAD^
```

## Undoing the last 2 commits and all the changes
```
git reset --hard HEAD^^
```

## Add to the last commit, (change the last commit)
```
git add test.txt
git commit --amend -m "this message will overwrite "
```

## Add remote repo(remote repository name is "origin")
```
git remote add origin remoteGit
git remote -v
```

## Local branch we want to push is master
```
git push -u origin master
```

## To pull changes from the remote
```
git pull 
```

## To add new remote
```
git remote add <name> <address>
```

## To remove remote
```
git remote rm <name>
```

## To push to remotes
```
git push -u <name> <branch>
```

## Don't do these after you push, because these change history
```
git reset --soft HEAD^
git commit --amend -m "new message"
git reset --hard HEAD^
git reset --hard HEAD^^ 
```

## Cloning a repository
```
git clone <url-of-repo> <local-folder>
```

## To create some branch
```
git branch cat
```

## To see what branch we are in
```
git branch
```

## To jump to the new branch
```
git checkout branch
```

## Stage an executable bit change

If you need to stage an executable bit change, you should do something like:
```
git update-index --chmod=(+|-)x <path>
```

## To merge branches
```
git checkout master
git merge branch
```

## Branch cleanup
```
git branch -d branch
```

## Create and checkout to a branch at once
```
git checkout -b admin
```

## List all remote branches
```
git branch -r
```

## Remote show
```
git remote show origin
```

## Removing a branch (remote)
```
git push origin :<branch_name>
```

## Removing a branch localy
```
git branch -d <branch_name> 
```
If you have unmerged commits, it returns errors

## Removing a branch localy (with force)
```
git branch -D <branch_name>
```

## To clean up deleted remote branches
```
git remote prune origin
```

## Add remote branches 

First, you must create your branch locally
```
git checkout -b your-branch
```
After that, you can work locally in your branch, when you are ready to share the branch, push it. The next command push the branch to the remote repository origin and tracks it:
```
git push -u origin your-branch
```
Teammates can reach your branch, by doing:
```
git fetch
git checkout origin/your-branch
```
You can continue working in the branch and pushing whenever you want without passing arguments to git push (argumentless git push will push the master to remote master, your-branch local to remote your-branch, etc...)

To fetch all remote branches:
```
git fetch --all
```
To change local branch to a track a remote branch (after fetching it from remote):
```
git checkout -b local-branch origin/remote-branch
```

## List all tags
```
git tag
```

## Add a new tag
```
git tag -a v0.0.3 -m "version 0.0.3"
```

## Checkout code at commit
```
git checkout <tag_name>
```

## To push new tags
```
git push --tags
```

## Alternative way to merge two branches (admin is another branch)
```
git checkout admin
git rebase master
git checkout master
git merge admin
```

## Important commands in rebase when facing conflicts
```
git rebase --continue
get rebase --skip
git rebase --abort
```

## Change log format
```
git log --pretty=format:"%h %ad- %s [%an]"
```
place holders: 
%h	- SHA hash
%ad	- author date
%an	- author name
%s	- subject
%d	- ref names

## To get a detailed log
```
git log --oneline -p
git log --oneline --stat
git log --oneline --graph
git log --until=1.minute.ago
git log --since=1.day.ago
git log --since=1.hour.ago
git log --since=1.month.ago --until=2.weeks.ago
git log --since=2000-01-01 --until=2012-12-21
```

## To get differences in commits
```
git diff
git diff HEAD
git diff HEAD^
git diff HEAD^^
git diff HEAD~5
git diff HEAD^..HEAD
```

## Between 2 specific commits
```
git diff <sha1> <sha2>
```

## Get sha of each commit:
```
git log --oneline
```

## Get differences between 2 branches
```
git diff master admin
```

## To see history of a file commits
```
git blame <filename> --date short
```

## Remove a file from git (also removing from disk)
```
git rm <filename>
```

## Stop a file from tracking (not removing from disk)
```
git rm --cached <filename>
```
Tell git to ignore some files
create a file named: .gitignore
edit the file:
```
vim .gitignore:
logs/*.log
```
Add it to the repo so every body will have it.
```
git add .gitignore
git commit -m "Ignore all log files"
```

## How to view the differences between two commits:
```
git diff *commit_id1* *commit_id2*
```

## How to view the differences between two commits (name of files only):
```
git diff --name-only *commit_id1* *commit_id2*
```

## How to view the differences between two commits 
Stats: number of insertions and deletions:
```
git diff --stat *commit_id1* *commit_id2*
```

## To see the changes done by a commit
Copy the first four or more characters of the commit ID with this command:
```
# if the commit id is : 27c0f0ce1340dkljadlk...
git show 27c0
```

## Modify a specific commit
```
# If the commit is the Z-th commit before the HEAD then,
git rebase -i HEAD~Z  #Shows the last Z commits in a text editor
# Modify pick to edit/e in the line mentioning the specific commit
# Edit your changes
git commit --am 
git rebase --continue
```

## Git submodules
```
# Adding a submodule
git submodule add <submodule-url>

# Cloning a repo with its submodule(s)
git clone --recurse-submodules <repo-url>

# Pulling in upstream changes from the submodules remote
git submodule update --remote

# Pulling in upstream changes from a specific submodule remote
# Submodule names can be found in the local file .gitmodules
git submodule update --remote <submodule-name>

# When you have submodules, everytime you checkout a tag in the 
# parent repo,  you should update the submodules as well to make
# sure that their heads point to the correct commit.
git checkout <tag_name>
git submodule update
``` 
More [information](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

