//
//  Trie.swift
//  AlgorithmsDemo
//
//  Created by Ben-Anthony Donnelly on 18/08/2022.
//

import Foundation

public class Trie<CollectionType: Collection> where CollectionType.Element: Hashable {
    public typealias Node = TrieNode<CollectionType.Element>
    private let root = Node(key: nil, parent: nil)
    public init() {}
    
    public func insert(_ collection: CollectionType) {
        var current = root // Tracks traversal progress
        for element in collection {
            if current.children[element] == nil {
                current.children[element] = Node(key: element, parent: current)
            }
            current = current.children[element]! // move to the next node
        }
        current.isTerminating = true // end node in collection, mark as terminating
    }
    
    
    public func contains(_ collection: CollectionType) -> Bool {
        var current = root
        for element in collection {
            guard let child = current.children[element] else {
                return false
            }
            current = child
        }
        return current.isTerminating
    }
    
    public func remove(_ collection: CollectionType) {
        var current = root
        for element in collection {
            guard let child = current.children[element] else {
                return
            }
            current = child
        }
        guard current.isTerminating else {
            return
        }
        current.isTerminating = false // Set to false so it can be removed
        
        // Make sure node doesn't belong to another collection and backtrack through the parent property and remove the nodes
        while let parent = current.parent, current.children.isEmpty && !current.isTerminating {
            parent.children[current.key!] = nil
            current = parent
        }
    }
}


// MARK: Prefix Matching

public extension Trie where CollectionType: RangeReplaceableCollection {
    func collections(startingWith prefix: CollectionType) -> [CollectionType] {
        var current = root
        
        // Make sure trie contains prefix
        for element in prefix {
            guard let child = current.children[element] else {
                return []
            }
            current = child
        }
        return collections(startingWith: prefix, after: current) // Recursively find all sequences after current node
    }
    
    private func collections(startingWith prefix: CollectionType,
                             after node: Node) -> [CollectionType] {
        var results: [CollectionType] = []
        if node.isTerminating {
            results.append(prefix) // Only add terminating nodes to results array
        }
        
        for child in node.children.values {
            var prefix = prefix
            prefix.append(child.key!)
            results.append(contentsOf: collections(startingWith: prefix)) // Recursively find all other terminating nodes
        }
        return results
    }
}
