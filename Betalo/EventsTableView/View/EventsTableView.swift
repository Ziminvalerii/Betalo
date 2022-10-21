import UIKit
import Combine

protocol EventsTableViewBetDelegate: AnyObject {
    func eventsTableView(_ eventsTableView: EventsTableView, didPressButton team: Team, eventModel model: EventModel)
}

protocol EventsTableViewRowEditingDelegate: AnyObject {
    func eventsTableView(_ eventsTableView: EventsTableView, didRemoveRowAt index: Int)
}

class EventsTableView: UITableView {
    
    var viewModel: EventsTableViewModel! {
        didSet {
            viewModel?.$currentModels
                .receive(on: DispatchQueue.main)
                .sink { [weak self] models in
                    self?.delegate = self
                    self?.dataSource = self
                    self?.reloadData()
                }
                .store(in: &cancellables)
        }
    }
    
    weak var betDelegate: EventsTableViewBetDelegate?
    weak var rowEditingDelegate: EventsTableViewRowEditingDelegate?
    
    enum EventType {
        case schedule, live
    }
    
    let eventType: EventType
    
    private var cancellables = Set<AnyCancellable>()
    
    init(eventType: EventType) {
        self.eventType = eventType
        super.init(frame: .zero, style: .plain)
        
        let cellClass: EventsTableViewCell.Type
        
        switch eventType {
        case .schedule:
            cellClass = ScheduleTableViewCell.self
        case .live:
            cellClass = LiveTableViewCell.self
        }
        
        separatorColor = .black
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EventsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = viewModel.currentModels[indexPath.row]
        
        switch eventType {
        case .schedule:
            let identifier = String(describing: ScheduleTableViewCell.self)
            guard let scheduleCell = dequeueReusableCell(withIdentifier: identifier,
                                                         for: indexPath) as? ScheduleTableViewCell else {
                return ScheduleTableViewCell()
            }
            
            scheduleCell.viewModel = EventsTableViewCellViewModel(model: model)
            
            scheduleCell.oddButtonAction
                .receive(on: DispatchQueue.main)
                .sink { [weak self] (eventModel, team) in
                    guard let self = self else {
                        return
                    }
                    self.betDelegate?.eventsTableView(self, didPressButton: team, eventModel: eventModel)
                }
                .store(in: &cancellables)
            
            return scheduleCell
            
        case .live:
            let identifier = String(describing: LiveTableViewCell.self)
            guard let liveCell = dequeueReusableCell(withIdentifier: identifier,
                                                     for: indexPath) as? LiveTableViewCell else {
                return LiveTableViewCell()
            }
            
            liveCell.viewModel = EventsTableViewCellViewModel(model: model)
            
            return liveCell
        }
    }
}

extension EventsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return eventType == .schedule ? 130.0 : 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
    }
}
