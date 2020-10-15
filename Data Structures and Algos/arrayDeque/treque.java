/*
    Emilly Ly
    ID:111097939
    CSE 214
*/

package homework1;

public interface treque<T>
{
    void addFirst(T t);
    void addLast(T t);
    void addMiddle(T t);
    T removeFirst();
    T removeLast();
    T removeMiddle();
    void resize();
}
