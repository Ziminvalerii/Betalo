import Foundation
import Combine

class EventsTableViewModel {
            
    private let models: [EventModel]
        
    @Published private(set) var currentModels: [EventModel]
    
    init(models: [EventModel]) {
        self.models = models
        self.currentModels = models
    }
    
    func filter(by searchText: String) {
        if searchText == "" {
            currentModels = models
            return
        }
        currentModels = models.filter({ $0.event.hasPrefix(searchText) })
    }
}
