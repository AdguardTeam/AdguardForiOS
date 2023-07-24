# AdGuard IOSWebExtension Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- TODO: during the libs update, `versionFormat` also should be updated in -->
<!-- AdguardExtension/AdguardApp/UI/ViewControllers/MainTabBar/MainMenu/About/AboutViewController.swift -->


## 0.0.5

### Changed

- Updated Scriptlets to v1.9.57
- Updated TSUrlFilter to v2.1.5


## 0.0.4

### Changed

- Updated Scriptlets to v1.9.37
- Updated TSUrlFilter to v2.0.6


## 0.0.3

### Changed

- Updated ExtendedCss to v2.0.52
- Updated Scriptlets to v1.9.7
- Updated TSUrlFilter to v2.0.5


## 0.0.2

## Added

- optimization to resources build config — reduces size and minifies

### Changed

- make engine sync and use it in content-script instead of background page
- update AdvanceRules on background page, convert the rules and save the converted result to the storage; do it only if advanced rules should be updated — received flag from NativeHost
