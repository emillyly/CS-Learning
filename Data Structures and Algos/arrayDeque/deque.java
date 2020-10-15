/*
    Emilly Ly
    ID:111097939
    CSE 214
*/

package homework1;

public interface deque<T>
{
    void addFirst(T t);
    void addLast(T t);
    T removeFirst();
    T removeLast();
    void resize();
}
