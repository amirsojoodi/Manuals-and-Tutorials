# Some git instructions that maybe needed

## Initialization configuration

```bash
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
git config --global alias.changes "show --stat --oneline --name-status"
git config --global push.default current
git config --list
git config --global credential.helper cache

mkdir ~/Documents/gitStore
cd ~/Documents/gitStore

git init
```

## Make some file

```bash
git add gitConfig.sh
```

## Add everything in all the project in the staging area

```bash
git add --all
```

## Take a snapshot of everything in the staging area

```bash
git commit -m "a message"
```

## Print out a log of a

```bash
git log
```

## Add all txt files in the current directory

```bash
git add *.txt 
```

## Add all files in the docs directory

```bash
git add docs/ 
```

## Add all txt files in the entire project

```bash
git add "*.txt"
```

## Get the differences of files now from repository

```bash
git diff
git add --all
git diff --staged
git reset HEAD <file>
git commit -a -m "modify something"
```

## Undoing the last commit, put changes into staging

```bash
git reset --soft HEAD^
```

## Undoing the last commit and all the changes

```bash
git reset --hard HEAD^
```

## Undoing the last 2 commits and all the changes

```bash
git reset --hard HEAD^^
```

## Add to the last commit, (change the last commit)

```bash
git add test.txt
git commit --amend -m "this message will overwrite "
```

## Add remote repo(remote repository name is "origin")

```bash
git remote add origin remoteGit
git remote -v
```

## Local branch we want to push is master

```bash
git push -u origin master
```

## To pull changes from the remote

```bash
git pull 
```

## To add new remote

```bash
git remote add <name> <address>
```

## To remove remote

```bash
git remote rm <name>
```

## To push to remotes

```bash
git push -u <name> <branch>
```

## Don't do these after you push, because these change history

```bash
git reset --soft HEAD^
git commit --amend -m "new message"
git reset --hard HEAD^
git reset --hard HEAD^^ 
```

## Cloning a repository

```bash
git clone <url-of-repo> <local-folder>
```

## To create some branch

```bash
git branch cat
```

## To see what branch we are in

```bash
git branch
```

## To jump to the new branch

```bash
git checkout branch
```

## To merge branches

```bash
git checkout master
git merge branch
```

## Branch cleanup

```bash
git branch -d branch
```

## Create and checkout to a branch at once

```bash
git checkout -b admin
```

## List all remote branches

```bash
git branch -r
```

## Remote show

```bash
git remote show origin
```

## Removing a branch (remote)

```bash
git push origin :<branch_name>
```

## Removing a branch localy

```bash
git branch -d <branch_name> 
```

If you have unmerged commits, it returns errors

## Removing a branch localy (with force)

```bash
git branch -D <branch_name>
```

## To clean up deleted remote branches

```bash
git remote prune origin
```

## Add remote branches

First, you must create your branch locally

```bash
git checkout -b your-branch
```

After that, you can work locally in your branch, when you are ready to share the branch, push it. The next command push the branch to the remote repository origin and tracks it:

```bash
git push -u origin your-branch
```

Teammates can reach your branch, by doing:

```bash
git fetch
git checkout origin/your-branch
```

You can continue working in the branch and pushing whenever you want without passing arguments to git push (argumentless git push will push the master to remote master, your-branch local to remote your-branch, etc...)

To fetch all remote branches:

```bash
git fetch --all
```

To change local branch to a track a remote branch (after fetching it from remote):

```bash
git checkout -b local-branch origin/remote-branch
```

## List all tags

```bash
git tag
```

## Add a new tag

```bash
git tag -a v0.0.3 -m "version 0.0.3"
```

## Checkout code at commit

```bash
git checkout <tag_name>
```

## To push new tags

```bash
git push --tags
```

## Alternative way to merge two branches (admin is another branch)

```bash
git checkout admin
git rebase master
git checkout master
git merge admin
```

## Important commands in rebase when facing conflicts

```bash
git rebase --continue
get rebase --skip
git rebase --abort
```

## Change log format

```bash
git log --pretty=format:"%h %ad- %s [%an]"
```

place holders:
%h - SHA hash
%ad - author date
%an - author name
%s - subject
%d - ref names

## To get a detailed log

```bash
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

```bash
git diff
git diff HEAD
git diff HEAD^
git diff HEAD^^
git diff HEAD~5
git diff HEAD^..HEAD
```

## Between 2 specific commits

```bash
git diff <sha1> <sha2>
```

## Get sha of each commit

```bash
git log --oneline
```

## Get differences between 2 branches

```bash
git diff master admin
```

## To see history of a file commits

```bash
git blame <filename> --date short
```

## Remove a file from git (also removing from disk)

```bash
git rm <filename>
```

## Stop a file from tracking (not removing from disk)

```bash
git rm --cached <filename>
```

Tell git to ignore some files
create a file named: .gitignore
edit the file:

```bash
vim .gitignore:
logs/*.log
```

Add it to the repo so every body will have it.

```bash
git add .gitignore
git commit -m "Ignore all log files"
```

## How to view the differences between two commits

```bash
git diff *commit_id1* *commit_id2*
```

## How to view the differences between two commits (name of files only)

```bash
git diff --name-only *commit_id1* *commit_id2*
```

## How to view the differences between two commits with stats

Statsbash: number of insertions and deletions:

```bash
git diff --stat *commit_id1* *commit_id2*
```

## To see the changes done by a commit

Copybash the first four or more characters of the commit ID with this command:

```bash
# if the commit id is : 27c0f0ce1340dkljadlk...
git show 27c0
```

## Modify a specific commit

```bash
# If the commit is the Z-th commit before the HEAD then,
git rebase -i HEAD~Z  #Shows the last Z commits in a text editor
# Modify pick to edit/e in the line mentioning the specific commit
# Edit your changes
git commit --am 
git rebase --continue
```

## Deal with "old mode 100755 new mode 100644" message

Ignore filemode in current git repo:

```bash
git config core.filemode false
```

You can also apply the settings globally. See [here](https://stackoverflow.com/q/1257592/2328389).
However, if you do want to stage the file modes, see the next item.

## Stage an executable bit change or file mode

If you need to stage an executable bit change, you should do something like:

```bash
git update-index --chmod=(+|-)x <path>
```

## Git submodules

```bash
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

## Fork a public repo to a private one

Assume you want to fork a repo named *oldRepo* on Github and make it private.

```bash
# 1. Create an empty repo on Github (e.g. newRepo)

# 2. Clone the old repo locally
git clone --recursive (url of oldRepo)
cd oldRepo

# 3. (Optional) Fetch all other information
git fetch --all

# 4. (Optional) Create local branches for all remote ones
for remote in `git branch -r`; do git branch --track ${remote#origin/} $remote; done

# 5. Push to the newRepo
git push --mirror (url to newRepo)

# 6. (Optional) You can give the newRepo upstream a name
git remote add (newRepo upstream) (newRepo url)

# 7. Push all other info
git push --all (newRepo upstream)

# 8. (Optional) Set default push behavior
git push (newRepo upstream) -u (localBranch)

# Check the remote branches and upstreams
git remote -v
git branch -r

# 9. (Optional) Disable "push" to the oldRepo upstream
git remote set-url --push (oldRepo upstream) DISABLE

# 10. (Optional) Update the newRepo with the oldRepo changes
git fetch (oldRepo upstream)
git rebase (oldRepo upstream)/master
# Then resolve any conflicts
```

See [here](https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository) and [there](https://stackoverflow.com/questions/10312521/how-do-i-fetch-all-git-branches) for more information.
