/*
    Emilly Ly
    ID:111097939
    CSE 214
*/

package homework1;


public class arrayUtils
{
    public static void rotate(int[] a, int r)
    {
        int[] temp = new int[a.length];
        for(int i = 0; i < a.length; i++)
        {
            temp[i] = a[(i+r) % a.length];
        }

        for(int i = 0; i < a.length; i++)
        {
            a[i] = temp[i];
        }
    }

    public static void rotate(char[] a, int r)
    {
        char[] temp = new char[a.length];
        for(int i = 0; i < a.length; i++)
        {
            temp[i] = a[(i+r) % a.length];
        }
        for(int i = 0; i < a.length; i++)
        {
            a[i] = temp[i];
        }
    }

    public static int[] merge(int[] a, int[] b)
    {
        int[] c = new int[a.length + b.length];
        int count = 0;
        for(int j = 0; j < a.length; j++)
        {
            c[count] = a[j];
            count++;
        }
        for(int k = 0; k < b.length; k++)
        {
            c[count] = b[k];
            count++;
        }

        return c;
    }
}
