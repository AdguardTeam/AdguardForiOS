//
//  StoreData.swift
//  visafe_ios
//
//  Created by NCSC P5 on 6/13/21.
//
import UIKit
class StoreData{
    
    static var username:String = ""
    static var email:String = ""
    static var phoneNumber:String = ""
    static var forgot_password:Bool = false
    static var OTP:String = ""
    //lấy dữ liệu
    static func getMyPlist(key: String) -> Any? {
           // Lấy ra đường dẫn vào file Property List của bạn
           let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ViSafeData.plist")
           // Sử dụng NSDIctionary để lấy nội dung từ URL
           guard let myDict = NSDictionary(contentsOf: path) else { return nil }
           // Trả về giá trị theo key trong Dictionary
           return myDict[key]
       }
    //lưu dữ liệu
    static func saveMyPlist(key: String, value: Any) {
           let fileManager = FileManager.default
           // Tạo đường dẫn file
           let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ViSafeData.plist")
           guard let myDict = NSMutableDictionary(contentsOf: path) else {
               // nếu file chưa tồn tại chúng ta sẽ ghi vào file với bộ key/value đầu tiên.
               let myData: NSDictionary = [key: value]
               myData.write(to: path, atomically: true)
               return
           }
           // nếu file đã tồn tại chúng ta sẽ update dữ liệu
           myDict[key] = value
           myDict.write(to: path, atomically: true)
       }
    
    //xoá dữ liệu
    static func removeMyPlist(key: String) {
           let fileManager = FileManager.default
           // Tạo đường dẫn file
           let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ViSafeData.plist")
           guard let myDict = NSMutableDictionary(contentsOf: path) else { return }
           // nếu file đã tồn tại chúng ta sẽ update dữ liệu
           myDict.removeObject(forKey: key)
           myDict.write(to: path, atomically: true)
       }
    
}
