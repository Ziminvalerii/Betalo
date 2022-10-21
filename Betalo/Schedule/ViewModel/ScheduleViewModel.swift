import Foundation
import Combine

class EventViewModel {
    let networkManager: NetworkManager
    
    @Published var eventsTableViewModel: EventsTableViewModel?

    var cancellables = Set<AnyCancellable>()
    
    let sportsList = [
        "Cricket",
        "Basketball",
        "Baseball",
        "ESports",
        "Ice Hockey",
        "Soccer"
    ]
    
    var sportsCount: Int {
        return sportsList.count
    }
    
    @Published var selectedSport: String?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.selectedSport = sportsList.first
        
        fetchModels()
    }
    
    func fetchModels() {}
}

class ScheduleViewModel: EventViewModel {
    
    var userDefaultsManager: UserDefaultsManager!
    
    override func fetchModels() {
        networkManager.requestSchedule(forDate: Date(), sport: selectedSport)
            .receive(on: DispatchQueue.main)
            .map { eventsJson in
                eventsJson.compactMap { EventModel(scheduleJSON: $0) }
            }
            .sink { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] eventModels in
                self?.eventsTableViewModel = EventsTableViewModel(models: eventModels)
            }
            .store(in: &cancellables)
    }
    
    func saveEvent(_ model: SavedEventModel) {
        userDefaultsManager?.savedEvents.append(model)
    }
    
}
