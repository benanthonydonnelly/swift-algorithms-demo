
# Swift Algorithms by example

This app is designed to demonstrate various algorithms and data structures

## Binary Trees
A tree where each node has at most two children, left and right.
The basis for many tree structures and algorithms.

### In-order traversal
- Starting at the root node, if the current node has a left child, recursively visit this child first.
- Then visit the node itself.
- If the current node has a right child, recursively visit this child.

### Pre-order traversal
- Always visits the current node first, then recursively visits the left and right child.

### Post-order traversal
- Only visits the current node after the left and right child have been visited recursively.


## Binary Search Trees (BST)
A data structure that facilitates fast lookup, addition, and removal operations.
Achieves time complexity O(log n) by:

- Value of a left child must be less than the value of its parent.
- Value of a right child must be greater than or equal to the value of its parent.

This avoids unnecessary checks and cuts the search space in half every time you pick a left or right child.
By definition, binary search trees can only hold values that are Comparable.


## Tries
