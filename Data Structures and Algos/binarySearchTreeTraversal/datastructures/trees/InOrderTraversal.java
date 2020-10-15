/**
 Emilly Ly
 111097939
 CSE 214 (Assignment #3)
 */
package datastructures.trees;

import java.util.List;
import java.util.ArrayList;

/**
 * @author Ritwik Banerjee
 */
public class InOrderTraversal<E> extends Traversal<E> {
    List<E> traversed = new ArrayList();
    @Override
    public List<E> of(BinaryTree tree) {
        // TODO: implement inorder traversal of binary trees
        of(tree.root());
        return traversed;
    }

    public void of(BinaryTreeNode node)
    {
        BinaryTreeNode<E> enode = node;
        if(enode.left() != null)
            of(enode.left());
        traversed.add(enode.element());
        if(enode.right() != null)
            of(enode.right());
    }
}
