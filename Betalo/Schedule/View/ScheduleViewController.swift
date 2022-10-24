//
//  ScheduleViewController.swift
//  Bet2
//
//  Created by mac on 13.10.2022.
//

import UIKit
import Combine

class ScheduleViewController: BaseVC {
    
    var viewModel: ScheduleViewModel! {
        didSet {
            viewModel?.$selectedSport
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] title in
                    self?.searchView.sportsButton.setTitle(title, for: .normal)
                }
                .store(in: &cancellables)
            
            searchView.sportsButton.setTitle(viewModel?.selectedSport, for: .normal)
            setupTableView()
        }
    }
    
    private(set) lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.backgroundColor = .white
        searchView.delegate = self
        searchView.searchBar.placeholder = "Search schedules on today!"

        
        return searchView
    }()
    
    private lazy var dropDownView: DropDownView = {
        let dropDownView = DropDownView()
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.dataSource = self
        dropDownView.delegate = self
        
        dropDownView.backgroundColor = .lightGray
//        dropDownView.rowHeight = 40.0
        
        return dropDownView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 250, height: 200)
        label.center = view.center
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "No scheduled events found :("
        return label
    }()
    
    private var tableView: EventsTableView!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        view.addSubview(searchView)
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        
        view.addSubview(dropDownView)
        NSLayoutConstraint.activate([
            dropDownView.leadingAnchor.constraint(equalTo: searchView.sportsButton.leadingAnchor,
                                                  constant: 4),
            dropDownView.trailingAnchor.constraint(equalTo: searchView.sportsButton.trailingAnchor,
                                                   constant: -4),
            dropDownView.topAnchor.constraint(equalTo: searchView.sportsButton.bottomAnchor,
                                              constant: 4),
            dropDownView.heightConstraint
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
        dropDownView.isOpen = false
    }
    
    private func setupTableView() {
        guard let viewModel = viewModel else {
            return
        }
        
        tableView = EventsTableView(eventType: .schedule)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.betDelegate = self
        
        viewModel.$eventsTableViewModel
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] viewModel in
                guard let self = self else {
                    return
                }
                self.tableView.viewModel = viewModel
                viewModel.$currentModels
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] models in
                        models.isEmpty ? self?.addEmptyLabel() : self?.emptyLabel.removeFromSuperview()
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)

        view.insertSubview(tableView, belowSubview: dropDownView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addEmptyLabel() {
        guard emptyLabel.superview == nil else {
            return
        }
        emptyLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        view.addSubview(emptyLabel)
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.45,
                       initialSpringVelocity: 10) { [weak self] in
            self?.emptyLabel.transform = .identity
        }
    }
}

// MARK:  SearchView delegate

extension ScheduleViewController: SearchViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.viewModel.filter(by: searchText)
    }
    
    func didPressSportsButton(searchView: SearchView) {
        dropDownView.isOpen = !dropDownView.isOpen
    }
}

// MARK:  DropDown view delegate & data source

extension ScheduleViewController: DropDownViewDataSource, DropDownViewDelegate {
    func numberOfRows(inDropDownView dropDownView: DropDownView) -> Int {
        viewModel.sportsCount
    }
    
    func dropDownView(_ dropDownView: DropDownView, buttonForRow row: Int) -> DropDownViewButton {
        let button = DropDownViewButton()
        
        let title = viewModel.sportsList[row]
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 18)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.numberOfLines = 2
        
        return button
    }
    
    func dropDownView(_ dropDownView: DropDownView, didSelectButton button: DropDownViewButton) {
        guard viewModel?.selectedSport != button.titleLabel?.text else {
            dropDownView.isOpen = false
            return
        }
        viewModel.selectedSport = button.titleLabel?.text
        
        viewModel.fetchModels()
        dropDownView.isOpen = false
    }
}

// MARK: Events talbeView Bet delegate

extension ScheduleViewController: EventsTableViewBetDelegate, BetViewDelegate {
    func eventsTableView(_ eventsTableView: EventsTableView, didPressButton team: Team, eventModel model: EventModel) {
        
        guard let window = view.window,
              !window.subviews.contains(where: { ($0 as? BetView) != nil }) else {
            return
        }
        
        let betView = BetView(event: model, team: team)
        betView.delegate = self
        
        window.addSubview(betView)
        
    }
    
    func betView(_ betView: BetView, didCreateEventBet savedModel: SavedEventModel) {
        viewModel.saveEvent(savedModel)
    }
}
