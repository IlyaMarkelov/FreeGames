//
//  GamesViewController.swift
//  FreeGames
//
//  Created by Илья Маркелов on 04.12.2021.
//

import UIKit

class GamesViewController: UITableViewController {
    
    private var mmoGames: [MMOGames] = []
    private var filteredMmoGames: [MMOGames] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.backgroundColor = .black
        
        setupNavigationBar()
        setupSearchController()
        fetchData(from: Link.mmmoGamesApi.rawValue)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredMmoGames.count : mmoGames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let game = isFiltering ? filteredMmoGames[indexPath.row] : mmoGames[indexPath.row]
        cell.configure(with: game)
        return cell
    }
    
    // MARK: - Private methods
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
    
    // Setup navigation bar
    private func setupNavigationBar() {
        
        title = "MMO Games"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = .black
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
    }
    
    
    private func fetchData(from url: String?) {
        NetworkManager.shared.fetchData(from: url) { result in
            switch result {
            case .success(let mmoGames):
                self.mmoGames = mmoGames
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let mmoGame = isFiltering ? filteredMmoGames[indexPath.row] : mmoGames[indexPath.row]
        guard let detailVC = segue.destination as? GameDescriptionViewController else {return}
        detailVC.mmoGame = mmoGame
    }

}

// MARK: - UISearchResultsUpdating
extension GamesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredMmoGames = mmoGames.filter { mmoGame in
            mmoGame.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}
