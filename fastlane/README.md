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
or alternatively using `brew cask install fastlane`

# Available Actions
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
### ios testflight_beta
```
fastlane ios testflight_beta
```
Builds an app store version, uploads it to testflight, increments build number

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
