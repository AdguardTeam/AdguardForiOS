<p align="center">
  <img src="https://cdn.adguard.com/public/Adguard/Common/Logos/ios.svg" width="300px" alt="AdGuard for iOS"
 />
  </p>
<h3 align="center">The most advanced Safari content blocker and privacy keeper for iOS</h3>
<p align="center">
  Top-notch ad blocking in Safari, anti-tracking protection and DNS privacy.
</p>
  
  <p align="center">
    <a href="https://adguard.com/">Website</a> |
    <a href="https://reddit.com/r/Adguard">Reddit</a> |
    <a href="https://twitter.com/AdGuard">Twitter</a> |
    <a href="https://t.me/adguard_en">Telegram</a>
    <br/><br/>

  <a href="https://github.com/AdguardTeam/AdguardForiOS/releases">
      <img src="https://img.shields.io/github/release/AdguardTeam/AdguardForiOS/all.svg" alt="Latest release" />
  </a>
  <a href="https://agrd.io/ios">
    <img alt="iTunes App Store" src="https://img.shields.io/itunes/v/1047223162.svg">
  </a>
  </p>

- [Contribution](#contribution)
  - [How to report an issue](#issue)
  - [Translating AdGuard](#contribution-translating)
  - [Other options](#contribution-other)
  - [How to become a Beta tester](#beta-tester)
- [Our plans](#our-plans)
- [How to build](#how-to-build)

AdGuard for iOS is an app that blocks ads in Safari browser at exceptional level, and also provides additional Premium features like configurable DNS settings, encrypted DNS support (DOH, DOT, DNSCrypt), and custom ad blocking subscriptions. To get more information and to download AdGuard for iOS, [visit our website](https://adguard.com/adguard-ios/overview.html).

<img src="https://cdn.adguard.com/public/Adguard/iOS/screenshots/iOS2.png" width="280">&nbsp;<img src="https://cdn.adguard.com/public/Adguard/iOS/screenshots/iOS3.png" width="280">&nbsp;<img src="https://cdn.adguard.com/public/Adguard/iOS/screenshots/iOSD.png" width="280">

<a id="contribution"></a>

## Contribution

<a id="issue"></a>

### How to report an issue?

GitHub can be used to report a bug or to submit a feature request. To do so, go to [this page](https://github.com/AdguardTeam/AdGuardforiOS/issues) and click the _New issue_ button.

> **Note:** for the filter-related issues (missed ads, false positives etc.) use our [reporting tool](https://reports.adguard.com/new_issue.html).

<a id="contribution-translating"></a>

### Translating AdGuard

If you want to help with AdGuard translations, please learn more about translating our products here: https://kb.adguard.com/en/general/adguard-translations

<a id="contribution-other"></a>

### Other options

Here is a [dedicated page](https://adguard.com/contribute.html) for those who are willing to contribute.

<a id="beta-tester"></a>

### How to become a beta tester?

You can submit an application to participate in AdGuard for beta-testing program. All necessary information on this topic can be found on the [dedicated page](https://adguard.com/beta.html).

<a id="our-plans"></a>

## Our plans

To see the 'big picture', to watch current progress and to get an idea of approximate dates for upcoming AdGuard for iOS releases, see this page: https://github.com/AdguardTeam/AdguardForIos/milestones

<a id="how-to-build"></a>

## How to build

### (optional) Install a newer ruby version:

```
brew install ruby
```

Add to your `~/.bash_profile`

```
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"
```

### Prepare

Prepare and install Ruby bundler:

```
sudo gem install bundler
```

Then run bundle install:

```
bundle install
```

**IMPORTANT:** before running Fastlane, you need to place the [App Store Connect API key](https://docs.fastlane.tools/app-store-connect-api/#using-an-app-store-connect-api-key) to `fastlane/AuthKey.p8`.

Then you can run Fastlane using a command like this:

```
bundle exec fastlane [lane]
```

### Codesigning

Run this command to get proper codesigning certificates:

```
MATCH_KEYCHAIN_PASSWORD="YOUR_ACCOUNT_PASSWORD" bundle exec fastlane prepare
```

### Actions

- `bundle exec fastlane tests` -- run tests
- `bundle exec fastlane build` -- build version for App Store

Actions below are supposed to be used from CI only:

- `bundle exec fastlane adhoc` -- build adhoc version (for inner testing)
- `bundle exec fastlane increment` -- increments build number, commits it to git
- `bundle exec fastlane testflight_beta` -- upload previously built version to testflight

In the case when certificate expires, you may need to nuke the old certs and generate them again:

```
bundle exec fastlane match nuke development
bundle exec fastlane match nuke distribution
bundle exec fastlane generate
```

In order for fastlane to work properly in CI environment, we use [spaceauth](https://docs.fastlane.tools/best-practices/continuous-integration/#use-of-application-specific-passwords-and-spaceauth).

Run this command to generate `FASTLANE_SESSION` which you'll then need to use on the CI server:

```
bundle exec fastlane auth
```

### Acknowledgments

This software wouldn't have been possible without:

- [DnsLibs](https://github.com/AdguardTeam/DnsLibs)
- [SafariConverterLib](https://github.com/AdguardTeam/SafariConverterLib)
- [StaticDataTableViewController](https://github.com/peterpaulis/StaticDataTableViewController) by peterpaulis
- [GZIP](https://github.com/nicklockwood/GZIP) by nicklockwood
- [Reachability component](https://github.com/tonymillion/Reachability) by Tony Million
- [Fmdb](https://github.com/ccgus/fmdb) by August «Gus» Mueller
- [NSStringPunycodeAdditions](https://github.com/Wevah/Punycode-Cocoa) by Nate Weaver
- [SSZipArchive](https://github.com/ZipArchive/ZipArchive) by Sam Soffes, Joshua Hudson and Antoine Cœur
