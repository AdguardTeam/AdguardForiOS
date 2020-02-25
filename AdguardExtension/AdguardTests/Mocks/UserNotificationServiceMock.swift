import Foundation

class UserNotificationServiceMock: UserNotificationServiceProtocol {
    
    var postNotificationWasCalled = false
    
    func requestPermissions() {
    }
    
    func postNotification(title: String, body: String, userInfo: [AnyHashable : Any]?) {
        postNotificationWasCalled = true
    }
    
    func postNotificationInForeground(body: String, title: String) {
        
    }
    
    func removeNotifications() {
    }
}
