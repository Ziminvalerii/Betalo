import Foundation
import UIKit

class UserDefaultsManager {
    
    struct Keys {
        static let savedEvents = "savedEvents"
        static let userImage = "userImage"
        static let notificationsEnabled = "notificationsEnabled"
    }
    
    var savedEvents: [SavedEventModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.savedEvents),
                  let events = try? JSONDecoder().decode([SavedEventModel].self, from: data) else {
                return []
            }
            
            return events
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: Keys.savedEvents)
        }
    }
    
    var userImage: UIImage? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.userImage),
                  let decoded = try? PropertyListDecoder().decode(Data.self, from: data),
                  let image = UIImage(data: decoded) else {
                return UIImage(named: "male-avatar")
            }
            
            return image
        }
        
        set {
            guard let data = newValue?.jpegData(compressionQuality: 0.5),
                  let encoded = try? PropertyListEncoder().encode(data) else {
                return
            }
            
            UserDefaults.standard.set(encoded, forKey: Keys.userImage)
        }
    }
    
    var notificationsEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.notificationsEnabled)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.notificationsEnabled)
        }
    }
    
}


class SavedEventModel: EventModel {
    let betAmount: Double
    let betTeam: Team
    
    init(event: EventModel, betAmount: Double, team: Team) {
        self.betTeam = team
        self.betAmount = betAmount
        
        super.init(event: event.event,
                   sport: event.sport,
                   league: event.league,
                   homeTeam: event.homeTeam,
                   awayTeam: event.awayTeam,
                   homeScore: event.homeScore,
                   awayScore: event.awayScore,
                   eventTime: event.eventTime,
                   homeOdd: event.homeOdd,
                   awayOdd: event.awayOdd)
    }
    
    private enum CodingKeys: String, CodingKey {
        case betAmount = "betAmount"
        case betTeam = "betTeam"
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(betAmount, forKey: .betAmount)
        try container.encode(betTeam, forKey: .betTeam)
        
        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            betAmount = try container.decode(Double.self, forKey: .betAmount)
        } catch {
            throw error
        }
        betTeam = try container.decode(Team.self, forKey: .betTeam)
        
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
}
