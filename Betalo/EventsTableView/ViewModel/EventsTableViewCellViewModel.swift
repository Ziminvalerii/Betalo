import Foundation

class EventsTableViewCellViewModel {
    
    @Published private(set) var model: EventModel
    
    init(model: EventModel) {
        self.model = model
    }
    
}
