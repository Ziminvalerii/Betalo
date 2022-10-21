import UIKit

enum Team: Int, Codable {
    case home = 0
    case away = 1
    
    var string: String {
        switch self {
        case .home:
            return "Home"
        case .away:
            return "Away"
        }
    }
}

class EventModel: Codable, Hashable {
    let event: String
    
    let sport: String
    
    let league: String?
    
    let homeTeam: String
    
    let awayTeam: String
    
    let homeScore: String?
    
    let awayScore: String?
    
    let eventTime: String?
    
    let homeOdd: String?
    
    let awayOdd: String?
    
    init(event: String,
         sport: String,
         league: String?,
         homeTeam: String,
         awayTeam: String,
         homeScore: String?,
         awayScore: String?,
         eventTime: String?,
         homeOdd: String?,
         awayOdd: String?) {
        
        self.event = event
        self.sport = sport
        self.league = league
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.eventTime = eventTime
        self.homeOdd = homeOdd
        self.awayOdd = awayOdd
    }
    
    static func == (lhs: EventModel, rhs: EventModel) -> Bool {
        lhs.homeTeam == rhs.homeTeam &&
        lhs.awayTeam == rhs.awayTeam &&
        lhs.eventTime == rhs.eventTime
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
