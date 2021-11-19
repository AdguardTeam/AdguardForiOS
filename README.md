
### [VisafeiOS Legacy Repository](https://github.com/Visafe/VisafeIOS) migrated and now maintained at [VisafeLiteiOSClient](https://github.com/Visafe/VisafeLiteiOSClient)


<p align="center">
  <img width="300px" src="https://app.visafe.vn/static/media/wesafe_icon.ddf9251c.png"/>
</p>

<h1 align="center">Visafe - Internet an toàn</h1>

<p align="left">
  <h5>Ngôn ngữ: Tiếng Việt</h5> 
</p>

<div style="text-align: center">Visafe Lite iOS Client là ứng dụng miễn phí để người sử dụng có thể bảo vệ mình và người thân trên không gian mạng khỏi các hình thức tấn công mạng cơ bản của mã độc, trang web độc hại, lừa đảo, quảng cáo nguy hiểm. </div>
<br>
<div style="text-align: center">Đây là phiên bản rút gọn của Visafe dành cho các thiết bị thấp hơn iOS, iPadOS 14 với duy nhất tính năng 1 chạm để bảo vệ do các thiết bị này chưa hỗ trợ native DNS Over HTTPS để được bảo vệ qua máy chủ của Visafe. Để contribute các tính năng nâng cao khác (security scan, custom,...) vui lòng tham khảo project <a href=https://github.com/Visafe/VisafeiOSClient> VisafeiOS </a> </div>
<br>
<div style="text-align: center"> Đây là bản fork từ dự án mã nguồn mở  <a href=https://github.com/AdguardTeam/AdguardForiOS> AdguardForiOS </a> theo giấy phép GPL-v3. Bạn có thể chỉnh sửa để cấu hình thành client DNS over HTTPS sử dụng pseudo VPN bằng cách cấu hình trong file config. Để xây dựng hạ tầng DNS Over HTTPS, bạn có thể tham khảo thêm hướng dẫn chi tiết của dự án DNS privacy (https://dnsprivacy.org/) hoặc liên hệ với chúng tôi để được chia sẻ kinh nghiệm.
  </div>


## Cách build (theo tài liệu hướng dẫn của adguardteam)

Bạn có thể build manual hoặc sử dụng `fastlane`

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

### Build

- `bundle exec fastlane build` 


## Đóng góp
Mọi ý kiến đóng góp, vui lòng tạo issue trên Repo này.

Phát triển dựa trên dự án mã nguồn mở AdguardForiOS theo giấy phép GPL-v3.
https://github.com/AdguardTeam/AdguardForiOS
Xem thêm tại: https://visafe.vn


----
<p align="left">
  <h5>Language: English</h5> 
</p>


<div style="text-align: center">VisafeLiteiOSClient, forked from AdguardForiOS, is a free application created to protect users and their families from malware, unsafe websites, scams, and dangerous advertisements.</div>

<br>
<div style="text-align: center">This is a light-weight version of Visafe for iOS and iPadOS < 14. Since prior to iOS 14, native DNS Over HTTPS is not build in, VisafeLiteiOSClient allow users device connect to Visave server with a single button. In order to use advanced features, please use <a href=https://github.com/Visafe/VisafeiOSClient> VisafeiOS </a>.</div>
<br>

<div style="text-align: center">   This version of Visafe is a forked repository from <a href=https://github.com/AdguardTeam/AdguardForiOS> AdguardForiOS </a> follow GPL-v3 lience. Feel free to change its config file to modify DNS over HTTPS using pseudo VPN. Checkout more detail about DNS privacy at https://dnsprivacy.org/ or reach out to us for more information.

  </div>



## How to build (follow adguardteam's installation manual)

you can build this manually or use `fastlane`

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

### Build

- `bundle exec fastlane build`

## Contribute 

To contribute, feel free to creat any issue on this repository.
Developed upon open-source AdguardForiOS with GPL-v3 License.  
https://github.com/AdguardTeam/AdguardForiOS

Detailed information: https://visafe.vn 
