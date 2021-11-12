<p align="left">
  <h5>Ngôn ngữ: Tiếng Việt</h5> 
</p>
<p align="center">
  <img width="300px" src="https://app.visafe.vn/static/media/wesafe_icon.ddf9251c.png"/>
</p>
<h1 align="center">Visafe - Internet an toàn cho người Việt</h1>

<div style="text-align: center">Visafe là ứng dụng miễn phí dành cho mọi người dân Việt Nam có thể tự bảo vệ mình và người thân trên không gian mạng khỏi mã độc, trang web độc hại, lừa đảo, quảng cáo nguy hiểm</div>
<br>
<div style="text-align: center">Visafe Lite là phiên bản rút gọn của Visafe dành cho các thiết bị thấp hơn iOS, iPadOS 14 với duy nhất tính năng 1 chạm để bảo vệ. Để sử dụng các tính năng nâng cao, cá nhân hóa, vui lòng sử dụng phiên bản Visafe đầy đủ.</div>

<h3 align="left">1. Các tính năng của Visafe</h3>

+ Bảo vệ mọi lúc mọi nơi
    * Chặn mã độc, tấn công mạng
    + Chặn theo dõi và những quảng cáo vi phạm
+ Tự làm chủ Internet của mình
    * Quản lý nội dung tìm kiếm
+ Sử dụng Internet hiệu quả



<h3 align="left">2. Cách sử dụng mã nguồn</h3>

+ Phiên bản Xcode 12.5
+ Phiên bản hệ điều hành: macOS Big Sur 11.6.1 
### Cài đặt Ruby:

```
brew install ruby
```

Sao chép và dán vào tệp `~/.bash_profile`

```
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"
```

Cài đặt Ruby bundler:

- `sudo gem install bundler`

Chạy câu lệnh bundle install:

- `bundle install`

**LƯU Ý:** trước khi chạy fastlane, cần có file Authley.p8 trong thư mục có đường dẫn `fastlane/AuthKey.p8` [App Store Connect API key](https://docs.fastlane.tools/app-store-connect-api/#using-an-app-store-connect-api-key).


### Codesigning

- `bundle exec fastlane prepare`

### Cách build tự động

- `bundle exec fastlane build` 

Phát triển dựa trên dự án mã nguồn mở AdguardForiOS theo giấy phép GPL-v3.  
https://github.com/AdguardTeam/AdguardForiOS

Xem thêm tại: https://visafe.vn 

----
<p align="left">
  <h5>Language: English</h5> 
</p>
<p align="center">
  <img width="300px" src="https://app.visafe.vn/static/media/wesafe_icon.ddf9251c.png"/>
</p>
<h1 align="center">Visafe - Vietnam Internet Secure Access For Everyone</h1>
<div style="text-align: center">Visafe is a free application created for all Vietnamese people to protect themselves and their families from malware, unsafe websites, scams, and dangerous advertisements.</div>
<br>
<div style="text-align: center">Visafe Lite is a stripped-down version of Visafe-Internet an toàn for iOS and iPad devices, whose software version is under 14. This app can protect you with the 1-touch feature. To use advanced features, please use Visafe - Internet an toàn.</div>


<h3 align="left">1. Visafe’s features</h3>

+ Protection at any time and everywhere:
    * Prevents malware and cyber attacks.
    + Blocks tracking and illegal advertisements.
+ Internet under control:
    * Safe search.
+ Better internet.



<h3 align="left">2. How to build</h3>

+ Xcode version: 12.5
+ Operating system version: macOS Big Sur 11.6.1 
### Install Ruby:

```
brew install ruby
```

Add to your `~/.bash_profile`

```
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"
```


Install Ruby bundler:

- `sudo gem install bundler`

Run bundle install:

- `bundle install`

**IMPORTANT:** before running Fastlane, you need to place the [App Store Connect API key](https://docs.fastlane.tools/app-store-connect-api/#using-an-app-store-connect-api-key) to `fastlane/AuthKey.p8`.


### Codesigning

- `bundle exec fastlane prepare`

### Actions

- `bundle exec fastlane build`


Developed upon open-source AdguardForiOS with GPL-v3 License.  
https://github.com/AdguardTeam/AdguardForiOS

Detailed information: https://visafe.vn 
