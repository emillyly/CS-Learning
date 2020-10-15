/**
 Emilly Ly
 111097939
 CSE 214 (Assignment #3)
 */
package datastructures.trees;

import java.util.Collection;
import java.util.List;
import java.util.ArrayList;

/**
 * @author Ritwik Banerjee
 */
public class BinarySearchTree<T extends Comparable<T>> implements BinaryTree<T> {
    
    private BinaryTreeNode<T> root;
    private int               size;
    
    /**
     * !!DO NOT MODIFY THIS CODE!!
     * Consrtucts a binary search tree consisting of items from the given collection. Duplicates in the collection are
     * ignored, i.e., every item will be considered only once for the tree being constructed.
     *
     * @param collection the given collection
     */
    public BinarySearchTree(Collection<T> collection) {
        this();
        for (T t : collection)
            add(t);
    }
    
    /**
     * !!DO NOT MODIFY THIS CODE!!
     * Constructs an empty binary search tree.
     */
    private BinarySearchTree() {
        root = null;
        size = 0;
    }
    
    @Override
    public void add(T t) {
        // TODO: implement the insert algorithm for binary search trees
        BinaryTreeNode<T> newNode = new BinaryTreeNode(t);
        if(root == null)
        {
            root = newNode;
            return;
        }

        BinaryTreeNode<T> temp = root;
        while(true)
        {
            if(t.compareTo(temp.element()) < 0)
            {
                if(temp.left() == null)
                {
                    temp.setLeft(newNode);
                    newNode.setParent(temp);
                    break;
                }
                else
                    temp = temp.left();
            }
            if(t.compareTo(temp.element()) > 0)
            {
                if(temp.right() == null)
                {
                    temp.setRight(newNode);
                    newNode.setParent(temp);
                    break;
                }
                else
                    temp = temp.right();
            }
        }
        size++;
    }
    
    @Override
    public void remove(T t) {
        // TODO: implement the delete algorithm for binary search trees
        BinaryTreeNode<T> current = root;
        while(t.compareTo(current.element()) != 0)
        {
            if(t.compareTo(current.element()) < 0)
            {
                if(current.left() == null)
                    return;
                else
                    current = current.left();
            }
            if(t.compareTo(current.element()) > 0)
            {
                if(current.right() == null)
                    return;
                else
                    current = current.right();
            }
        }

        BinaryTreeNode<T> parent = current.parent();
        BinaryTreeNode<T> temp = null;
        size--;

        if(current.left() == null && current.right() == null)
        {
            if(current == root)
            {
                root = null;
                return;
            }
            else
            {
                if(parent.element().compareTo(current.element()) > 0)
                    parent.setLeft(null);
                else
                    parent.setRight(null);
                return;
            }
        }

        if(current.left() != null && current.right() == null)
        {
            temp = current.left();
            parent.setLeft(temp);
            current.setParent(parent);
            return;
        }

        if(current.left() == null && current.right() != null)
        {
            temp = current.right();
            parent.setRight(temp);
            current.setParent(parent);
            return;
        }

        BinaryTreeNode<T> successor = current.right();
        while(true)
        {
            if(successor.left() != null)
                successor = successor.left();
            else
                break;
        }

        current.setElement(successor.element());
        if(successor.right() == null)
        {
            successor.parent().setLeft(null);
            return;
        }
        else
        {
            temp = successor.right();
            successor.parent().setRight(temp);
        }
    }
    
    /**
     * Returns the search path that starts at the root node of the tree, and ends at the node containing the specified
     * item. If such a node exists in the tree, it is the last object in the returned list. Otherwise, this method will
     * still return the path corresponding to the search for this item, but append a <code>null</code> element at the
     * end of the list.
     *
     * @param t the specified item
     * @return the search path, with a node containing the specified item as the last object in the list if the item is
     * found in the tree, and the <code>null</code> node if item is not found in the tree.
     */
    @Override
    public List<BinaryTreeNode<T>> find(T t) {
        // TODO: implement the search/find algorithm for binary search trees
        List<BinaryTreeNode<T>> list = new ArrayList();
        BinaryTreeNode<T> temp = root;
        BinaryTreeNode<T> nullNode = null;
        while(true)
        {
            if(t.compareTo(temp.element()) == 0)
            {
                list.add(temp);
                break;
            }
            if(t.compareTo(temp.element()) < 0)
            {
                list.add(temp);
                if(temp.left() == null)
                {
                    list.add(nullNode);
                    break;
                }
                else
                temp = temp.left();
            }
            else
            {
                if (t.compareTo(temp.element()) > 0)
                {
                    list.add(temp);
                    if (temp.right() == null) {
                        list.add(nullNode);
                        break;
                    } else
                        temp = temp.right();
                }
            }
        }
        return list;
    }
    
    /**
     * !!DO NOT MODIFY THIS CODE!!
     */
    @Override
    public void print() {
        root.print();
    }
    
    /**
     * !!DO NOT MODIFY THIS CODE!!
     *
     * @return the root node of this tree
     */
    @Override
    public BinaryTreeNode<T> root() {
        return root;
    }
    
    /**
     * !!DO NOT MODIFY THIS CODE!!
     *
     * @return the size, i.e., the number of nodes in this tree
     */
    @Override
    public int size() {
        return size;
    }
}