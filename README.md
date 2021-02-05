# slag-tools
(This document contains target concepts. It does not describe the state as it is.)

## Table of Content
* [Name Convention](#name-convention)

##

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

