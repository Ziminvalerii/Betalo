import Foundation

class BetsTableViewModel {
    
    let userDefaultsManager: UserDefaultsManager
    
    private(set) var models: [SavedEventModel]
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
        models = userDefaultsManager.savedEvents
    }
    
    func removeModel(at index: Int) {
        userDefaultsManager.savedEvents.remove(at: index)
        models = userDefaultsManager.savedEvents
    }
    
}
