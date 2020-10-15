/**
 Emilly Ly
 111097939
 CSE 214 (Assignment #5)
 */

import java.util.Comparator;
import java.util.Arrays;
import java.util.List;

public class QuickSort<T extends Comparable<T>> implements NaturalOrderSorting<T> {

    List<T> qList;

    @Override
    public void sort(List<? extends T> list)
    {
        qList = (List) list;
        quickSort(0, list.size()-1);
    }

    private void quickSort(int start, int end)
    {
        T pivot = qList.get(start+(end-start)/2);
        int p1 = start;
        int p2 = end;

        while (p1 <= p2)
        {
            while (qList.get(p1).compareTo(pivot) < 0)
                p1++;

            while (qList.get(p2).compareTo(pivot) > 0)
                p2--;

            if (p1 <= p2)
            {
                swap(p1, p2);
                p1++;
                p2--;
            }
        }
        if (start < p2)
            quickSort(start, p2);
        if (p1 < end)
            quickSort(p1, end);
    }

    public void swap(int a, int b)
    {
        T temp = qList.get(a);
        qList.set(a, qList.get(b));
        qList.set(b, temp);
    }

    public static class Unnatural<E> implements TotalOrderSorting<E>
    {
        List<E> qList;

        @Override
        public void sort(List<? extends E> list, Comparator<E> c)
        {
            qList = (List) list;
            quickSort(0, list.size()-1, c);
        }

        private void quickSort(int start, int end, Comparator<E> c)
        {
            E pivot = qList.get(start+(end-start)/2);
            int p1 = start;
            int p2 = end;

            while (p1 <= p2) {

                while (c.compare(qList.get(p1), pivot) < 0) {
                    p1++;
                }

                while (c.compare(qList.get(p2), pivot) > 0) {
                    p2--;
                }

                if (p1 <= p2) {
                    swap(p1, p2);
                    p1++;
                    p2--;
                }
            }
            if (start < p2)
                quickSort(start, p2, c);
            if (p1 < end)
                quickSort(p1, end, c);
        }

        public void swap(int a, int b)
        {
            E temp = qList.get(a);
            qList.set(a, qList.get(b));
            qList.set(b, temp);
        }
    }
}
