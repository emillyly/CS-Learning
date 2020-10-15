/**
    Emilly Ly
    111097939
    CSE 214 (Assignment #2)
*/
package datastructures.sequential;
import java.util.EmptyStackException;

/**
 * The class acts as a Last In First Out(LIFO) queue containing nodes.
 * The class can insert elements to the queue while only removing the most recent inserted element.
 * The class can peek which allows the data of the first node to be given without it being removed.
 *
 * @author Emilly Ly
*/
public class Stack<E> implements LIFOQueue<E>
{
    /** The node at the top of the stack. */
    private SNode<E> top;

    /**
     * A constructor that creates an empty stack.
    */
    public Stack()
    {
        top = null;
    }

    /**
     * A constructor to create a stack with the given data as the top node.
     *
     * @param element the given element given as the first node.
    */
    public Stack(E element)
    {
        top = new SNode<>(element);
    }

    /**
     * Retrieves and removes the element at the top of this stack.
     *
     * @return the element at the top of this stack.
     * @throws EmptyStackException if the stack is empty.
    */
    public E pop()
    {
        if(size() == 0)
            throw new EmptyStackException();
        E element = top.getData();
        top = top.getNext();
        return element;
    }

    /**
     * Pushes the element given onto the top of this stack.
     *
     * @param element the element to be pushed onto the top of this stack.
    */
    public void push(E element)
    {
        SNode<E> temp = new SNode<>(element,top);
        top = temp;
    }

    /**
     * Retrieves the element at the top of this stack without removing it.
     *
     * @return the element at the top of this stack.
     * @throws EmptyStackException if the stack is empty.
    */
    public E peek()
    {
        if(size() == 0)
            throw new EmptyStackException();
        return top.getData();
    }

    /**
     * Returns the number of elements in this stack. If this stack has more than <code>Integer.MAX_VALUE</code>
     * elements, returns <code>Integer.MAX_VALUE</code>.
     *
     * @return the number of elements in this stack.
    */
    public int size()
    {
        int size = 0;
        SNode<E> temp = top;
        while(temp != null)
        {
            if(size == Integer.MAX_VALUE)
                return Integer.MAX_VALUE;
            size++;
            temp = temp.getNext();
        }
        return size;
    }

    /**
     * @return If the stack contains no elements <code>true</code>, otherwise <code>false</code>.
    */
    public boolean isEmpty()
    {
        if(size() == 0)
            return true;
        return false;
    }
}
