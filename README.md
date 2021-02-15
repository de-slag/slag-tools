# slag-tools
(This document contains target concepts. It does not describe the state as it is.)

## Table of Content
1. [Name Convention](#name-convention)
2. [Release-Procedure](#release-procedure)

## Name Convention
### Prefixes
|Prefix|Description|
|---|---|
|bkp-|scripts to make backups, actually a subtype of 'rtn'|
|ins-|installer that should run only once|
|nfo-|helper scripts that show information about system and its state|
|mtn-|maintenance and monitoring scripts, actually a subtype of 'rtn'|
|rtn-|routinely executed scripts to support daily, hourly, minutely... work|
|utl-|utils scripts with no extra logic|
### Postfixes

|Postfix|Description|
|---|---|
|-wizard|an interactive script that does not change a system itself. It only generates scripts and files to do that.|

## Release-Procedure

In this case we want to release number 'x.y'

0. on branch 'develop'...
    0. ...do development
    0. ...implement unit-tests
    0. ...the version number is 'x.y-SNAPSHOT'
0. feature freeze, **don't do developments until release procedure is done!**
0. until all unit tests are stable do...
    0. ...run all unit tests
    0. ...fix logic and tests
0. create release candidate branch from 'develop'
    0. ...branch name 'x.y-rc'
    0. ...change version in this branch to 'x.y-rc1'
0. do stabilization activities
    0. ...run unit tests
    0. ...run manual tests
    0. ...fix logic and tests if any
0. test release candidate stuff on a production near instance
0. test release candidate stuff on one or more productive instances, by checkout rc branch on this instance
0. create release branch and prepare rc-branch for hotfixes
     0. ...branch name 'x.y.0' from 'x.y-rc'
     0. ...change version to 'x.y.0' in branch 'x.y.0'
     0. ...change version to 'x.y-rc2' in branch 'x.y-rc'
0. test release branch on one or more productive instances, by checkout release branch on this instance
0. merge branch 'x.y.0' into 'master'
0. merge branch 'master' into 'develop'
0. change version number of 'develop' to next iteration version, i.e. 'x.z-SNAPSHOT'
0. final rollout: run a 'git pull' on all productive instances to get new version

### In case of an hotfix...
* repeat steps 5 to 10 with minor version +1 towards previous iteration (i.e. x.y-rc2 to x.y-rc3 and release version x.y.1) 
* cherry pick hot fix stuff to 'develop'




