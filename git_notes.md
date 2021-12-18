= Git Notes =

Cause I do the same dumb things over and over and git, and never remember how
to do them

== Undo the last commit ==

== Git filter ==

Had an entire Advent of Code folder in a repo, filled with unrelated source and
git commits.  Wanted to move the Advent of Code source into it's own repo on
GitHub.

This is my best recollection of the commands / stepped I used to accomplish this.

* Download git-filter-repo python script into a folder

Made a new AdventOfCode repository

I had problems with the format of the education repo being education/AdventOfCode/2020.
I could not easily just remove the AdventOfCode directory name and use it as
root of the filtered path.  So I had to create a script to take the year folders
and put them in the root directory

=== Create a new repo using contents of existing repo ===

* Create a separate clone of the github education repo
* Create the following script in the directory above (where the filter script is)
  and execute it

```
#!/bin/bash
cd education
../git-filter-repo \
        --path AdventOfCode/2015 --path-rename AdventOfCode/2015:2015 \
        --path AdventOfCode/2017 --path-rename AdventOfCode/2017:2017 \
        --path AdventOfCode/2019 --path-rename AdventOfCode/2019:2019 \
        --path AdventOfCode/2020 --path-rename AdventOfCode/2020:2020 \
        --path AdventOfCode/2021 --path-rename AdventOfCode/2021:2021
```

* That should make the repo just have the year folders in it for AoC.  Now we want
  to push it into our new github repo
* Create a new empty repo to push into on github
* git remote add AoC git@github.com:mwales/AdventOfCode.git
* git push AoC
* I believe that must have errored, which leads the following command:
* git push --set-upstream AoC master (new repos don't have master branch, they have main now)

=== Create a new repo that won't have all source you are moving out ===

* Made a clone of old education repository
* cd education
* Remove all files in the AdventOfCode folder by filtering out their commits with
  the following line.  (Not sure what would happen if a commit had both AoC and
  other code in the same commit)
* ../git-filter-repo --path AdventOfCode --invert-paths
* Rename education repo on github to education_old
* Make a new education repo on github
* Push the filtered repo into the new empty github repo
