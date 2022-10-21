import Foundation

class LoaderViewModel {
    
    let networkManager: NetworkManager
    let userDefaultsManager: UserDefaultsManager
    
    init(networkManager: NetworkManager, userDefaultsManager: UserDefaultsManager) {
        self.networkManager = networkManager
        self.userDefaultsManager = userDefaultsManager
    }
    
    private(set) var scheduleViewModel: ScheduleViewModel!
    private(set) var liveViewModel: LiveViewModel!
    private(set) var betsViewModel: BetsViewModel!
    private(set) var settingsViewModel: SettingsViewModel!
    
    func setupViewModels() {
        scheduleViewModel = ScheduleViewModel(networkManager: networkManager)
        scheduleViewModel.userDefaultsManager = userDefaultsManager
        
        liveViewModel = LiveViewModel(networkManager: networkManager)
        betsViewModel = BetsViewModel(userDefaultsManager: userDefaultsManager)
        settingsViewModel = SettingsViewModel(userDefaultsManager: userDefaultsManager)
    }
    
    
}
