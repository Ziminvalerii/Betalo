import Foundation
import Combine

class LiveViewModel: EventViewModel {
    
    override func fetchModels() {
        guard let selectedSport = selectedSport else {
            return
        }
        networkManager.requestLive(sport: selectedSport)
            .receive(on: DispatchQueue.main)
            .compactMap { eventsJson in
                eventsJson.compactMap { json -> EventModel? in
                    guard json.intHomeScore != nil,
                          json.intAwayScore != nil else {
                        return nil
                    }
                    
                    return EventModel(liveJSON: json)
                }
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
    
}
