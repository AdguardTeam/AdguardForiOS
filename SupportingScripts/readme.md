# App localization

There are two types of strings in project: 
1) strings that we get by ACLocalizedStrings() function
2) strings that are used in .storyboard files

The first type of strings we manually add to .strings file ('Localizable.strings')
.strings files for .storyboard files are generated through 'localization.py' script

We use 'en' language as base language

We also use 'localization.py' to import and export strings to [remote localization service](https://crowdin.com/project/adguard-applications)

### Prerequisites

```
sudo pip3 install requests
```


### Steps to export strings to localization service

1) generate .strings files from .storyboard files. 

`python3 localization.py -s`

2) check by git diff that there are no trash strings or mistakenly deleted strings

3) `git commit`

4) import strings from localization service

`python3 localization.py -i`

5) check by `git diff` and merge our strings with strings from remote service

6) import strings from **.strings** to **.storyboard** files. It is necessary to avoid mistaken overwriting of current changes at first step

`python3 localization.py -x`

8) export english strings to remote server

`python3 localization.py -e`



### Steps to import strings from remote localization server

1) import only english strings from remote server

`python3 localization.py -i`

2) watch git diff to check that we didn't forget to export new strings to remote server

3) if you found unexported strings you must merge them with strings from remote server

4) import all localization files

`python3 localization.py -i -l all`

5) git commit push at third step you must export the resulting files to remote server

6) if new strings are found at third step you must export those files to remote server


## How to use import.py

### requirements

You must have python3 with installed ['requests' package](https://2.python-requests.org/en/master/user/install/)

### usage

`python3 localization.py command arguments`

Commands:

 -e --export - export strings

 -i --import - import strings

 -s --generate-strings - generate strings filters from .storyboard files

 -x --update-xibs - update .storyboard files with strings from .strings files

Arguments:

-l --lang - language for export or import. Can be 'en', 'ru', etc for single locale or 'all' for all locales. Default value is 'en'. **NOTE: use '-export -lang all' only if you really understand what you want to do.**

--dry-run - test run. Do not export/import any files and do not change .strings and .storyboard files
