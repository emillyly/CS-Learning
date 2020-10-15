/**
 Emilly Ly
 111097939
 CSE 214 (Assignment #5)
 */

import java.util.List;
/**
 * @author Ritwik Banerjee
 */
public interface NaturalOrderSorting<T extends Comparable<T>> {
    public void sort(List<? extends T> list);
}