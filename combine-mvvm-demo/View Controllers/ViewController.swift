//
//  ViewController.swift
//  combine-mvvm-demo
//
//  Created by Niels Nørskov on 30/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var _searchItemListVM: SearchItemListViewModel?
    private var _fetchJSONSubscriber: AnyCancellable?
    private var _searchTextChangedSubscriber:AnyCancellable?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Listen for text changes on the search text field.
        _searchTextChangedSubscriber = NotificationCenter.Publisher(center: .default, name: UITextField.textDidChangeNotification, object: searchTextField)
                .compactMap{ return ($0.object as? UITextField)?.text }
                .debounce(for: 2.0, scheduler: DispatchQueue.main)
                .sink { self.performSearch(for: $0) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let detailViewController = segue.destination as? DetailViewController, let selected = tableView.indexPathForSelectedRow {
            detailViewController.itemVM = _searchItemListVM?.item(at: selected.row)
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: animated)
        }
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _searchItemListVM?.searchItemList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as? SearchResultCell, let item = _searchItemListVM?.item(at: indexPath.row) else { return UITableViewCell() }
        
        cell.configure(with: item)
        return cell
    }
    
    // MARK: - Private methods
    
    private func performSearch(for keyword: String)
    {
        guard let baseURL = URL( string: "https://images-api.nasa.gov" ), let request = URLRequest(for: "search", httpMethod: .GET, query: ["q" : keyword], baseURL: baseURL ) else { return }
        
        let resource = Resource<SearchResult>(request: request)
        
        _fetchJSONSubscriber?.cancel()
        _fetchJSONSubscriber = URLSession.shared.fetchJSON(for: resource)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("The publisher finished normally.")
                case .failure(let error):
                    print("An error occured: \(error).")
                }
            }, receiveValue: { result in
                let itemsWithImage = result.collection.items.filter { $0.thumbnailURL != nil }
                self._searchItemListVM = SearchItemListViewModel(itemsWithImage)
                self.tableView.reloadData()
            })
    }
}

