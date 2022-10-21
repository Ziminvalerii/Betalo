import Foundation
import UIKit

class SettingsViewModel {
    
    let userDefaultsManager: UserDefaultsManager
    
    var appStoreLink: String {
        "https://apps.apple.com/ua/app/betalo-app-tracker/id6443959244"
    }
    
    var privacyPolicyLink: String {
        "https://docs.google.com/document/d/1Neuo7c-S8ClYSM_7KUe3T0bBb66z41stDFRoE0W02Ik/edit?usp=sharing"
    }
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    var notificationsEnabled: Bool {
        get {
            return userDefaultsManager.notificationsEnabled
        }
        
        set {
            userDefaultsManager.notificationsEnabled = newValue
        }
    }
    
    func saveUserImage(_ image: UIImage?) {
        userDefaultsManager.userImage = image
    }
    
    func userImage() -> UIImage? {
       return userDefaultsManager.userImage
    }
    
}
