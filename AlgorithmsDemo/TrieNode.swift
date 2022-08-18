//
//  TrieNode.swift
//  AlgorithmsDemo
//
//  Created by Ben-Anthony Donnelly on 18/08/2022.
//

import Foundation

public class TrieNode<Key: Hashable> {
    public var key: Key? // holds the data for the node
    public weak var parent: TrieNode? // weak reference to parent simplifies the remove method
    public var children: [Key: TrieNode] = [:]
    public var isTerminating = false // indicates the end of the collection
    
    public init(key: Key?, parent: TrieNode?) {
        self.key = key
        self.parent = parent
    }
}
