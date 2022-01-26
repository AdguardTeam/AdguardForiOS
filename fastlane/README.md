fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### prepare

```sh
[bundle exec] fastlane prepare
```



### generate

```sh
[bundle exec] fastlane generate
```



### auth

```sh
[bundle exec] fastlane auth
```



### upload_dsym

```sh
[bundle exec] fastlane upload_dsym
```



----


## iOS

### ios tests

```sh
[bundle exec] fastlane ios tests
```

Runs unit tests

### ios tests_sdk

```sh
[bundle exec] fastlane ios tests_sdk
```

Runs unit SDK tests

### ios build

```sh
[bundle exec] fastlane ios build
```

Builds app for appstore

### ios adhoc

```sh
[bundle exec] fastlane ios adhoc
```

Builds adhoc build for inner testing

### ios increment

```sh
[bundle exec] fastlane ios increment
```

Increments the build number and commits to the repo

### ios testflight_beta

```sh
[bundle exec] fastlane ios testflight_beta
```

Uploads the build to testflight

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
