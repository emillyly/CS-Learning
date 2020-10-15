/**
 Emilly Ly
 111097939
 CSE 214 (Assignment #4)
 */
public class Alphabet implements Hashable
{
    private char letter;

    public Alphabet(char c)
    {
        letter = c;
    }

    @Override
    public String toString()
    {
        return String.valueOf(letter);
    }

    /**
     * The method returns the index where the value should be placed.
     * The numeric value of the char using the getNumericValue,
     * which returns a value between 10 - 35, is stored in a variable.
     * The numeric value of the char subtracted by 10 will result in a
     * value between 0 and 25.
     * @return the index at which the value should be placed.
     */
    @Override
    public int hash()
    {
        int num = Character.getNumericValue(letter);
        return num-10;
    }
}
