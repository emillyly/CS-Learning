/**
 Emilly Ly
 111097939
 CSE 214 (Assignment #5)
 */

import java.util.Comparator;
import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;

public class MergeSort<T extends Comparable<T>> implements NaturalOrderSorting<T>
{
    @Override
    public void sort(List<? extends T> list)
    {
        List mList = (List)list;
        int len = list.size();
        if(len > 1)
        {
            List<T> l = new ArrayList<>();
            List<T> r = new ArrayList<>();

            int mid = len/2;
            for(int i = 0; i < mid; i++)
                l.add(list.get(i));
            for(int i = mid; i < len; i++)
                r.add(list.get(i));

            sort(l);
            sort(r);
            merge(l,r,mList);
        }
    }

    private void merge(List<T> left, List<T> right,List<T> list)
    {
        int lIndex = 0;
        int rIndex = 0;
        int index = 0;

        while(lIndex < left.size() && rIndex < right.size())
        {
            if(left.get(lIndex).compareTo(right.get(rIndex)) <= 0)
            {
                list.set(index,left.get(lIndex));
                lIndex++;
            }
            else
            {
                list.set(index,right.get(rIndex));
                rIndex++;
            }
            index++;
        }

        if(lIndex == left.size())
        {
            while(rIndex < right.size())
            {
                list.set(index, right.get(rIndex));
                rIndex++;
                index++;
            }
        }
        else
        {
            while(lIndex < left.size())
            {
                list.set(index, left.get(lIndex));
                lIndex++;
                index++;
            }
        }
    }

    public static class Unnatural<E> implements TotalOrderSorting<E>
    {
        @Override
        public void sort(List<? extends E> list, Comparator<E> c)
        {
            List<E> mList = (List)list;
            int len = list.size();
            if(len > 1)
            {
                List<E> l = new ArrayList<>();
                List<E> r = new ArrayList<>();

                int mid = len/2;
                for(int i = 0; i < mid; i++)
                    l.add(list.get(i));
                for(int i = mid; i < len; i++)
                    r.add(list.get(i));

                sort(l,c);
                sort(r,c);
                merge(l,r,mList,c);
            }}

        private void merge(List<E> left, List<E> right, List<E> list, Comparator<E> c)
        {
            int lIndex = 0;
            int rIndex = 0;
            int index = 0;

            while(lIndex < left.size() && rIndex < right.size())
            {
                if(c.compare(left.get(lIndex), right.get(rIndex)) <= 0)
                {
                    list.set(index,left.get(lIndex));
                    lIndex++;
                }
                else
                {
                    list.set(index,right.get(rIndex));
                    rIndex++;
                }
                index++;
            }

            if(lIndex == left.size())
            {
                while(rIndex < right.size())
                {
                    list.set(index, right.get(rIndex));
                    rIndex++;
                    index++;
                }
            }
            else
            {
                while(lIndex < left.size())
                {
                    list.set(index, left.get(lIndex));
                    lIndex++;
                    index++;
                }
            }
        }
    }
}
