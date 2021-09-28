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

/// FileShareHelper is reponsible for exporting and importing files to Files App
protocol FileShareHelperProtocol {
    /// exports @text to Files App with @filename
    func exportFile(for vc: UIViewController, filename: String, text: String)

    /// imports text from Files App. Returns @text of imported file as a string in callback
    func importFile(for vc: UIViewController, _ completion: @escaping (Result<String, Error>) -> Void)
}

final class FileShareHelper: NSObject, UIDocumentPickerDelegate, FileShareHelperProtocol {

    private var importCompletion: ((Result<String, Error>) -> Void)?

    func exportFile(for vc: UIViewController, filename: String, text: String) {
        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

        do {
            try text.write(to: tmp, atomically: true, encoding: .utf8)
            let activityItem = tmp
            let objectsToShare = [activityItem]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = vc.view
            activityVC.popoverPresentationController?.sourceRect = vc.view.frame
            vc.present(activityVC, animated: true, completion: nil)
        }
        catch {
            DDLogError("(FileShareHelper) - exportFile; Error: \(error)")
        }
    }

    func importFile(for vc: UIViewController, _ completion: @escaping (Result<String, Error>) -> Void) {
        let controller = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .open)
        controller.popoverPresentationController?.sourceView = vc.view
        controller.popoverPresentationController?.sourceRect = vc.view.frame
        controller.delegate = self
        controller.allowsMultipleSelection = false

        importCompletion = completion
        vc.present(controller, animated: true, completion: nil)
    }

    /// Delegate method. It is called from `importFile`
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, url.startAccessingSecurityScopedResource() else {
            return
        }

        do {
            let text = try String(contentsOf: url)
            url.stopAccessingSecurityScopedResource()
            importCompletion?(.success(text))
        }
        catch {
            DDLogError("(FileShareHelper) - documentPicker; Error: \(error)")
            importCompletion?(.failure(error))
        }
    }
}
