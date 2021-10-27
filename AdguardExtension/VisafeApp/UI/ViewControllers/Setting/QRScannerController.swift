//
//  QRScannerController.swift
//  visafe_ios
//
//  Created by Thai on 5/10/21.
//


import UIKit
import Foundation
import AVFoundation
import Network
import NetworkExtension
class QRScannerController: UIViewController {

    @IBOutlet var GroupNameLabel: UILabel!
    @IBOutlet var popupView: UIView!
    @IBOutlet var nameTextField: UITextField!
    var status_code:Int = 0
    var msg:String = ""
    @IBAction func accessButton(_ sender: UIButton) {
        postRequest()
        popupView.removeFromSuperview()
    }
    
    var count:Int = 0
    func postRequest(){
        struct RequestData: Codable {
            var deviceId:String
            var groupName:String
            var groupId:String
            var deviceName:String
            var macAddress:String
            var ipAddress:String
            var deviceType:String
            var deviceOwner:String
            var deviceDetail:String
        }

        let url = URL(string: DOMAIN_SEND)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("applicsation/json", forHTTPHeaderField: "Content-Type")
        var device_name:String = ""
        if nameTextField.text == UIDevice.current.name
        {
            device_name = UIDevice.current.name
        }
        else
        {
            device_name = nameTextField.text!
        }
    
        let request_json = RequestData(
            deviceId: StoreData.getMyPlist(key: "userid") as! String,
            groupName: groupName,
            groupId: groupId,
            deviceName: UIDevice.current.name,
            macAddress: StoreData.getMyPlist(key: "uuid") as! String,
            ipAddress: "127.0.0.1",
            deviceType: UIDevice.current.model,
            deviceOwner: device_name.lowercased().capitalized,
            deviceDetail: StoreData.getMyPlist(key: "uuid") as! String)
        print(request_json)
        let jsonData = try? JSONEncoder().encode(request_json)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                DispatchQueue.main.async {
                    if (json["status_code"] as! Int == 200)
                   {
                       StoreData.saveMyPlist(key: "status_code", value: 1)
                       let alert = UIAlertController(title: "Thông báo", message: "Tham gia nhóm thành công" , preferredStyle: UIAlertController.Style.alert)
                       let okAction = UIAlertAction(title: "Xác nhận", style:
                       UIAlertAction.Style.default) {
                          UIAlertAction in
                           self.navigationController?.popViewController(animated: true)
                           }
                          // add an action (button)
                          alert.addAction(okAction)
                          // show the alert
                       self.present(alert, animated: true, completion: nil)
                   }
                    else if (json["status_code"] as! Int == 504)
                    {
                        StoreData.saveMyPlist(key: "status_code", value: 0)
                        let alert = UIAlertController(title: "Thông báo", message: "Mất kết nối với máy chủ" , preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "Xác nhận", style:
                        UIAlertAction.Style.default) {
                           UIAlertAction in
                            self.captureSession.startRunning()
                            }
                           // add an action (button)
                           alert.addAction(okAction)
                           // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                   else{
                       StoreData.saveMyPlist(key: "status_code", value: 0)
                       var message_alert:String = json["msg"] as! String
                       if json["msg"] as! String == "Device was in group"
                       {
                           message_alert = "Thiết bị đã tồn tại trong nhóm"
                       }
                       else if json["msg"] as! String == "Device is in another group, please out group before join another group"
                       {
                           message_alert = "Thiết bị đang tồn tại trong nhóm khác"
                       }
                       let alert = UIAlertController(title: "Thông báo", message: message_alert , preferredStyle: UIAlertController.Style.alert)
                       let okAction = UIAlertAction(title: "Xác nhận", style:
                       UIAlertAction.Style.default) {
                          UIAlertAction in
                            self.captureSession.startRunning()
                           }
                          // add an action (button)
                          alert.addAction(okAction)
                          // show the alert
                       self.present(alert, animated: true, completion: nil)
                   }
                }
            }catch let jsonErr{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Thông báo", message: "Mất kết nối với máy chủ" , preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "Xác nhận", style:
                    UIAlertAction.Style.default) {
                       UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                        }
                       // add an action (button)
                       alert.addAction(okAction)
                       // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
           }
        }
        task.resume()
    }
    func check_regex (text: String) -> String {
            
            if !text.contains("https://app.visafe.vn/control/invite/device") || !text.contains("groupId") || !text.contains("groupName")
            {
                return ""
            }
            if(text[51] != "=" || text[88] != "&")
            {
                return ""
            }
            var count: Int = 0
            for i in 51...88 {
                if(text[i] == "-")
                {
                    count = count + 1
                }
            }
            if(count != 4)
            {
                return ""
            }
            return text
        }
    func getGroupId(text: String) -> String {
        var result: String = ""
        for i in 52...87 {
            result = result + text[i]
        }
        return result
    }
    func getGroupName(text: String) -> String {
        return text.substring(fromIndex: 99)
    }
    func setString(text: String) -> String {
            var text = text.lowercased()
            text = text.replacingOccurrences(of: " ", with: "")
            
            let to_a = ["ă", "â", "ằ", "ắ", "ẳ", "ẵ", "ặ", "ầ", "ấ", "ẳ", "ẫ", "ậ"]
            for i in to_a {
                text = text.replacingOccurrences(of: i, with: "a")
            }
            
            let to_e = ["è", "é", "ẻ", "ẽ", "ẹ", "ê", "ề", "ế", "ể", "ễ", "ệ"]
            for i in to_e {
                text = text.replacingOccurrences(of: i, with: "e")
            }
            
            let to_o = ["ò", "ó", "ỏ", "õ", "ọ", "ô", "ồ", "ố", "ổ", "ỗ", "ộ", "ơ", "ờ", "ớ", "ở", "ỡ", "ợ"]
            for i in to_o {
                text = text.replacingOccurrences(of: i, with: "o")
            }
            
            let to_i = ["ì", "í", "ỉ", "ĩ", "ị"]
            for i in to_i {
                text = text.replacingOccurrences(of: i, with: "i")
            }
            
            let to_u = ["ù", "ú", "ủ", "ũ", "ụ", "ư", "ừ", "ứ", "ử", "ữ", "ự"]
            for i in to_u {
                text = text.replacingOccurrences(of: i, with: "u")
            }
            
            let Chars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
            text = text.filter {Chars.contains($0)}
            return text
        }
    func checkLength(text: String) -> Bool {
        if((text.count >= 0) && (text.count) <= 50){
            return true
        }else{
            return false
        }
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        popupView.removeFromSuperview()
        self.captureSession.startRunning()
    }
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var didSendData: ((String) -> Void)?

    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
//        view.bringSubviewToFront(messageLabel)
//        view.bringSubviewToFront(topbar)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.systemYellow.cgColor
            qrCodeFrameView.layer.borderWidth = 3
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    var groupName:String = ""
    var groupId:String=""
    func launchApp(decodedURL: String) {
        self.groupId = self.getGroupId(text: decodedURL)
        self.groupName = self.getGroupName(text: decodedURL)
        if check_regex(text: decodedURL) != ""
        {
            
            nameTextField.text = UIDevice.current.name
            let text = NSMutableAttributedString()
                text.append(NSAttributedString(string: "Bạn có chắc chắn muốn tham gia nhóm với tên là:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
            GroupNameLabel.attributedText = text

            if presentedViewController != nil {
                return
            }
            
                popupView.layer.cornerRadius = 10
                view.addSubview(popupView)
                view.bringSubviewToFront(popupView)
            
            //dismiss Keyboard:
            let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tap)
        }
        else
        {
            let alert = UIAlertController(title: "Thông báo", message: "URL không hợp lệ" as? String, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Xác nhận", style:
                UIAlertAction.Style.default) {
                   UIAlertAction in
                        self.captureSession.startRunning()
                    }
                   // add an action (button)
                   alert.addAction(okAction)
                   // show the alert
                   self.present(alert, animated: true, completion: nil)
        }
    }
    
    
  private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
    layer.videoOrientation = orientation
    videoPreviewLayer?.frame = self.view.bounds
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if let connection =  self.videoPreviewLayer?.connection  {
      let currentDevice: UIDevice = UIDevice.current
      let orientation: UIDeviceOrientation = currentDevice.orientation
      let previewLayerConnection : AVCaptureConnection = connection
      
      if previewLayerConnection.isVideoOrientationSupported {
        switch (orientation) {
        case .portrait:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        case .landscapeRight:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
          break
        case .landscapeLeft:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
          break
        case .portraitUpsideDown:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
          break
        default:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        }
      }
    }
  }

}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
            }
        }
        self.captureSession.stopRunning()
    }
    
}

extension StringProtocol {
    func startIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
extension String {
 
  var length: Int {
    return count
  }
 
  subscript (i: Int) -> String {
    return self[i ..< i + 1]
  }
 
  func substring(fromIndex: Int) -> String {
    return self[min(fromIndex, length) ..< length]
  }
 
  func substring(toIndex: Int) -> String {
    return self[0 ..< max(0, toIndex)]
  }
 
  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                        upper: min(length, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }
 
}
