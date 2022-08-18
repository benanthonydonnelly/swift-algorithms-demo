//
//  ViewController.swift
//  AlgorithmsDemo
//
//  Created by Ben-Anthony Donnelly on 18/08/2022.
//

import UIKit

class TriesController: UITableViewController  {
    var names = Trie<String>()
    var filteredNames:Array<String> = []
    var namesArray:Array<String> = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table View
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Names"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Create all results
        createResults()
    }
    
    func createResults() {
        if let path = Bundle.main.path(forResource: "boy_names", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let jsonNames = jsonResult["names"] as? [Any] {
                    
                    for name in jsonNames {
                        names.insert(name as! String)
                    }
                }
            } catch {
                assert(false, "Could not load boy_names file")
            }
        }
        
        namesArray = names.collections(startingWith: "")
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredNames = names.collections(startingWith: searchText)
        tableView.reloadData()
    }
}

// MARK: Search

extension TriesController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

// MARK: TableView

extension TriesController  {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNames.count
          }
        return namesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell",for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if isFiltering {
            let searchText = searchController.searchBar.text ?? ""
            let editedText = String(filteredNames[indexPath.row].dropFirst(searchText.count)) // Remove the preceeding search term
            content.attributedText =  NSMutableAttributedString().normal(searchText).bold(editedText) // Make the suggestions bold
        }else{
            content.text = namesArray[indexPath.row]
        }
        cell.contentConfiguration = content
        return cell
    }
}


extension NSMutableAttributedString {
    var fontSize:CGFloat { return 18 }
    var boldFont:UIFont { return UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
