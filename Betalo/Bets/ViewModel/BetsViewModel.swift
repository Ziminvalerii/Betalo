import Foundation

class BetsViewModel {
    
    private(set) var tableViewModel: BetsTableViewModel!
    
    private let userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func getTableViewModel() -> BetsTableViewModel {
        tableViewModel = BetsTableViewModel(userDefaultsManager: userDefaultsManager)
        return tableViewModel
    }
    
}
