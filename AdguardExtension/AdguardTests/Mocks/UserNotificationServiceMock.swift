import Foundation

class UserNotificationServiceMock: UserNotificationServiceProtocol {
    
    func requestPermissions() {
    }
    
    func postNotification(title: String, body: String, userInfo: [AnyHashable : Any]?) {
    }
    
    func postNotificationInForeground(body: String, title: String) {
        
    }
    
    func removeNotifications() {
    }
}
