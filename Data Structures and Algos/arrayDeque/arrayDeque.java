/*
    Emilly Ly
    ID:111097939
    CSE 214
*/

package homework1;

public class arrayDeque implements deque<Object>
{
    Object[] a ;
    int j;
    int k;
    int n;

    public arrayDeque(Object[] b)
    {
        a = b;
        j = 0;
        k = a.length - 1;
        n = 0;
        for(int i = 0; i < a.length; i++)
        {
            if (a[i] != null)
            {
                n++;
            }
        }
    }

    public void addFirst(Object obj)
    {
        if(a[0] != null)
        {
            resize();
        }
        else
        {
            int m = j;
            while(a[m] == null)
                m++;
            j = m;
        }

        a[j - 1] = obj;
        if(j > a.length)
            a[a.length/2] = obj;
        j--;
        n++;
    }

    public void addLast(Object obj)
    {

        if(a[a.length-1] != null)
        {
            resize();
        }
        else
        {
            int p = k;
            while(a[p] == null)
                p--;
            k = p;
        }

        a[k + 1] = obj;
        if(k < 0)
            a[a.length/2] = obj;
        k++;
        n++;
    }

    public Object removeFirst()
    {
        Object temp = a[j];
        a[j] = null;
        j++;
        n--;
        return temp;
    }

    public Object removeLast()
    {
        Object temp = a[k];
        a[k] = null;
        k--;
        n--;
        return temp;
    }

    public void resize()
    {
        Object[] temp = new Object[n * 2];
        for(int i = 0; i < a.length - j; i++)
        {
            temp[(n/2) + i] = a[j+i];
        }
        a = temp;

        int m = 0;
        while(a[m] == null)
            m++;
        j = m;

        int p = a.length - 1;
        while(a[p] == null)
            p--;
        k = p;
    }
}
