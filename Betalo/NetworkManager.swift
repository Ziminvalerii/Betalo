import UIKit
import Combine

class NetworkManager {
    
    private let urlAssembler = URLAssembler()
    
    enum NetworkError: Error {
        case url
        case responce
        case jsonDecoding
    }
    
    func requestSchedule(forDate date: Date, sport: String?) -> Future<[ScheduleJSON], NetworkError> {
        return Future { [weak self] promise in
            guard let url = self?.urlAssembler.eventsScheduleURL(forDate: date, sport: sport) else {
                promise(.failure(.url))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    promise(.failure(.responce))
                    return
                }
                
                guard let result = try? JSONDecoder().decode(ScheduleResponse.self, from: data) else {
                    promise(.failure(.jsonDecoding))
                    return
                }
                
                promise(.success(result.events ?? []))

            }.resume()
        }
    }
    
    func requestLive(sport: String) -> Future<[LiveJSON], NetworkError> {
        return Future { [weak self] promise in
            guard let url = self?.urlAssembler.liveURL(sport: sport) else {
                promise(.failure(.url))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    promise(.failure(.responce))
                    return
                }
                
                guard let result = try? JSONDecoder().decode(LiveResponse.self, from: data) else {
                    promise(.failure(.jsonDecoding))
                    return
                }
                
                promise(.success(result.events ?? []))

            }.resume()
        }
    }
}


struct URLAssembler {
    private let v1 = "https://www.thesportsdb.com/api/v1/json/"
    private let v2 = "https://www.thesportsdb.com/api/v2/json/"
    
    let apiKey = "50130162"
    
    func eventsScheduleURL(forDate date: Date, sport: String?) -> URL? {
        var stringURL = v1 + apiKey + "/eventsday.php?" + "d=\(String(fromDate: date))"
        if let sport = sport?.replacingOccurrences(of: " ", with: "%20") {
            stringURL += "&s=\(sport)"
        }
        
        return URL(string: stringURL)
    }
    
    func liveURL(sport: String) -> URL? {
        let stringURL = v2 + apiKey + "/livescore.php?s=" + sport.replacingOccurrences(of: " ", with: "%20")
        return URL(string: stringURL)
    }
}
