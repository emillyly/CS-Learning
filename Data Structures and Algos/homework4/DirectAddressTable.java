/**
 Emilly Ly
 111097939
 CSE 214 (Assignment #4)
 */
import java.util.ArrayList;

public class DirectAddressTable<V extends Hashable> implements Dictionary<V> {

    private ArrayList<V> table = new ArrayList();
    private int fin = 0;
    public DirectAddressTable()
    {
        for(int i = 0; i < 26; i++)
            table.add(null);
    }
    @Override
    public String toString()
    {
        String pTable = "";
        for(int i = 0; i <= fin; i++)
             pTable += i + " -- " + table.get(i) + "\n";
        return pTable;
    }

    @Override
    public boolean isEmpty() {
        for(int i = 0; i < table.size(); i++)
        {
            if(table.get(i) != null)
                return false;
        }
        return true;
    }

    @Override
    public void insert(V value)
    {
        if(value == null)
            throw new NullPointerException();
        table.set(value.hash(), value);
        if(fin < value.hash())
            fin = value.hash();
    }

    @Override
    public V delete(V value)
    {
        if(value == null)
            throw new NullPointerException();
        if(table.get(value.hash()) == null)
            return null;

        if(fin == value.hash())
        {
            for(int i = fin-1; i > -1; i--)
            {
                if(table.get(i) != null)
                {
                    fin = i;
                    break;
                }
                fin = 0;
            }
        }
        return table.set(value.hash(),null);
    }

    @Override
    public V find(int key)
    {
        return table.get(key);
    }
}
