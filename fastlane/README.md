fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### prepare
```
fastlane prepare
```

### generate
```
fastlane generate
```

### auth
```
fastlane auth
```

### upload_dsym
```
fastlane upload_dsym
```


----

## iOS
### ios tests
```
fastlane ios tests
```
Runs unit tests
### ios build
```
fastlane ios build
```
Builds app for appstore
### ios adhoc
```
fastlane ios adhoc
```
Builds adhoc build for inner testing
### ios increment
```
fastlane ios increment
```
Increments the build number and commits to the repo
### ios testflight_beta
```
fastlane ios testflight_beta
```
Uploads the build to testflight

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
