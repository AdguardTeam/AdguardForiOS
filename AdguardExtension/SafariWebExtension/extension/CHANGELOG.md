# AdGuard IOSWebExtension Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- TODO: during the libs update, `versionFormat` also should be updated in -->
<!-- AdguardExtension/AdguardApp/UI/ViewControllers/MainTabBar/MainMenu/About/AboutViewController.swift -->

## 1.0.1

### Changed

- Updated `@adguard/safari-extension` to v4.0.4

## 1.0.0

### Changed

- Start using `@adguard/safari-extension`.

## 0.0.13

### Changed

- Updated [@adguard/scriptlets] to v1.11.16
- Updated [@adguard/tsurlfilter] to v2.2.23

## 0.0.12

### Changed

- Updated [@adguard/scriptlets] to v1.11.1
- Updated [@adguard/tsurlfilter] to v2.2.20

## 0.0.11

### Changed

- Updated [@adguard/scriptlets] to v1.10.25
- Updated [@adguard/tsurlfilter] to v2.2.18

## 0.0.10

### Changed

- Updated [@adguard/scriptlets] to v1.10.1
- Updated [@adguard/tsurlfilter] to v2.2.13

## 0.0.9

### Changed

- Updated [@adguard/scriptlets] to v1.9.105
- Updated [@adguard/tsurlfilter] to v2.2.9

## 0.0.8

### Changed

- Updated [@adguard/scriptlets] to v1.9.101
- Updated [@adguard/tsurlfilter] to v2.2.7

## 0.0.7

### Changed

- Updated [@adguard/scriptlets] to v1.9.83
- Updated [@adguard/tsurlfilter] to v2.2.1

## 0.0.6

### Changed

- Updated [@adguard/tsurlfilter] to v2.1.12

## 0.0.5

### Changed

- Updated [@adguard/scriptlets] to v1.9.72
- Updated [@adguard/tsurlfilter] to v2.1.11

## 0.0.4

### Changed

- Updated [@adguard/scriptlets] to v1.9.37
- Updated [@adguard/tsurlfilter] to v2.0.6

## 0.0.3

### Changed

- Updated [@adguard/extended-css] to v2.0.52
- Updated [@adguard/scriptlets] to v1.9.7
- Updated [@adguard/tsurlfilter] to v2.0.5

## 0.0.2

## Added

- optimization to resources build config — reduces size and minifies

### Changed

- make engine sync and use it in content-script instead of background page
- update AdvanceRules on background page, convert the rules and save the converted result to the storage; do it only if advanced rules should be updated — received flag from NativeHost

[@adguard/extended-css]: https://github.com/AdguardTeam/ExtendedCss/blob/master/CHANGELOG.md
[@adguard/scriptlets]: https://github.com/AdguardTeam/Scriptlets/blob/master/CHANGELOG.md
[@adguard/tsurlfilter]: https://github.com/AdguardTeam/tsurlfilter/blob/master/packages/tsurlfilter/CHANGELOG.md
