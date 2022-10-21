import Foundation

struct LiveResponse : Codable {
    let events : [LiveJSON]?

    enum CodingKeys: String, CodingKey {
        case events = "events"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        events = try values.decodeIfPresent([LiveJSON].self, forKey: .events)
    }
}

struct LiveJSON : Codable {
    let idLiveScore : String?
    let idEvent : String?
    let strSport : String?
    let idLeague : String?
    let strLeague : String?
    let idHomeTeam : String?
    let idAwayTeam : String?
    let strHomeTeam : String?
    let strAwayTeam : String?
    let strHomeTeamBadge : String?
    let strAwayTeamBadge : String?
    let intHomeScore : String?
    let intAwayScore : String?
    let strPlayer : String?
    let idPlayer : String?
    let intEventScore : String?
    let intEventScoreTotal : String?
    let strStatus : String?
    let strProgress : String?
    let strEventTime : String?
    let dateEvent : String?
    let updated : String?

    enum CodingKeys: String, CodingKey {

        case idLiveScore = "idLiveScore"
        case idEvent = "idEvent"
        case strSport = "strSport"
        case idLeague = "idLeague"
        case strLeague = "strLeague"
        case idHomeTeam = "idHomeTeam"
        case idAwayTeam = "idAwayTeam"
        case strHomeTeam = "strHomeTeam"
        case strAwayTeam = "strAwayTeam"
        case strHomeTeamBadge = "strHomeTeamBadge"
        case strAwayTeamBadge = "strAwayTeamBadge"
        case intHomeScore = "intHomeScore"
        case intAwayScore = "intAwayScore"
        case strPlayer = "strPlayer"
        case idPlayer = "idPlayer"
        case intEventScore = "intEventScore"
        case intEventScoreTotal = "intEventScoreTotal"
        case strStatus = "strStatus"
        case strProgress = "strProgress"
        case strEventTime = "strEventTime"
        case dateEvent = "dateEvent"
        case updated = "updated"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idLiveScore = try values.decodeIfPresent(String.self, forKey: .idLiveScore)
        idEvent = try values.decodeIfPresent(String.self, forKey: .idEvent)
        strSport = try values.decodeIfPresent(String.self, forKey: .strSport)
        idLeague = try values.decodeIfPresent(String.self, forKey: .idLeague)
        strLeague = try values.decodeIfPresent(String.self, forKey: .strLeague)
        idHomeTeam = try values.decodeIfPresent(String.self, forKey: .idHomeTeam)
        idAwayTeam = try values.decodeIfPresent(String.self, forKey: .idAwayTeam)
        strHomeTeam = try values.decodeIfPresent(String.self, forKey: .strHomeTeam)
        strAwayTeam = try values.decodeIfPresent(String.self, forKey: .strAwayTeam)
        strHomeTeamBadge = try values.decodeIfPresent(String.self, forKey: .strHomeTeamBadge)
        strAwayTeamBadge = try values.decodeIfPresent(String.self, forKey: .strAwayTeamBadge)
        intHomeScore = try values.decodeIfPresent(String.self, forKey: .intHomeScore)
        intAwayScore = try values.decodeIfPresent(String.self, forKey: .intAwayScore)
        strPlayer = try values.decodeIfPresent(String.self, forKey: .strPlayer)
        idPlayer = try values.decodeIfPresent(String.self, forKey: .idPlayer)
        intEventScore = try values.decodeIfPresent(String.self, forKey: .intEventScore)
        intEventScoreTotal = try values.decodeIfPresent(String.self, forKey: .intEventScoreTotal)
        strStatus = try values.decodeIfPresent(String.self, forKey: .strStatus)
        strProgress = try values.decodeIfPresent(String.self, forKey: .strProgress)
        strEventTime = try values.decodeIfPresent(String.self, forKey: .strEventTime)
        dateEvent = try values.decodeIfPresent(String.self, forKey: .dateEvent)
        updated = try values.decodeIfPresent(String.self, forKey: .updated)
    }

}

extension EventModel {
    convenience init(liveJSON json: LiveJSON) {
        let home = (json.strHomeTeam ?? "Home")
        let away = (json.strAwayTeam ?? "Away")
        
        self.init(event: home + " vs " + away,
                  sport: json.strSport ?? "Sport",
                  league: json.strLeague,
                  homeTeam: home,
                  awayTeam: away,
                  homeScore: json.intHomeScore,
                  awayScore: json.intAwayScore,
                  eventTime: json.strEventTime,
                  homeOdd: nil,
                  awayOdd: nil)
    }
}
