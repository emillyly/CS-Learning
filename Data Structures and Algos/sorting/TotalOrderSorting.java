/**
 Emilly Ly
 111097939
 CSE 214 (Assignment #5)
 */

import java.util.Comparator;
import java.util.List;

public interface TotalOrderSorting<E> {
    public void sort(List<? extends E> list, Comparator<E> c);
}
