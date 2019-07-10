
import Foundation

extension NSMutableAttributedString {
    
    func alignCenter(){
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle: paragraph]
        self.addAttributes(attributes, range: NSRange(location: 0, length: length))
    }
}
