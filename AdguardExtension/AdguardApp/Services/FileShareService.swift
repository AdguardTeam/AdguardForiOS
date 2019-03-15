/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.
 
       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.
 
       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.
 
       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation

/**
 FileShareService is reponsible for exporting and importing files to Files App
 */
protocol FileShareServiceProtocol {
    /**
     exports @text to Files App with @filename
    */
    func exportFile(parentController: UIViewController, filename: String, text: String, completionHandler:(_ error: String?)->Void)
    
    /**
     imports text from Files App. Returns @text of imported file as a string in callback
     */
    func importFile(parentController: UIViewController, completionHandler: @escaping (_ text:String, _ error: String?)->Void)
}

class FileShareService : NSObject, UIDocumentPickerDelegate, FileShareServiceProtocol {

    private var importCompletionHandler: ( (String, String?) -> Void)?
    
    func exportFile(parentController: UIViewController, filename: String, text: String, completionHandler: (String?) -> Void) {
        
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)

        do {
            try text.write(to: path, atomically: true, encoding: .utf8)
            
            let activityItem = path
            let objectsToShare = [activityItem]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            parentController.present(activityVC, animated: true, completion: nil)
        }
        catch  {
            NSLog("err: \(error)")
        }
    }
    
    func importFile(parentController: UIViewController, completionHandler: @escaping (String, String?) -> Void) {
        
        let controller = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .open)
        controller.delegate = self
        if #available(iOS 11.0, *) {
            controller.allowsMultipleSelection = false
        } else {
            // Fallback on earlier versions
        }
        importCompletionHandler = completionHandler
        parentController.present(controller, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if urls.count == 0 {
            return
        }

        do {
            let url = urls.first!
            if !url.startAccessingSecurityScopedResource() {
                return
            }

            guard let text: String = try String(contentsOf: url) else {
                return
            }

            url.stopAccessingSecurityScopedResource()
            importCompletionHandler?(text, nil)

        }
        catch {
            NSLog("\(error)")
        }
    }
}
