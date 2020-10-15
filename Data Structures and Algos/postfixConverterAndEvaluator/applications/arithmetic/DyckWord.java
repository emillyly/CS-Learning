/**
    Emilly Ly
    111097939
    CSE 214 (Assignment #2)
*/
package applications.arithmetic;
import datastructures.sequential.Stack;
/**
 * @author Ritwik Banerjee
 */
public class DyckWord {

    private final String word;

    public DyckWord(String word) {
        if (isDyckWord(word))
            this.word = word;
        else
            throw new IllegalArgumentException(String.format("%s is not a valid Dyck word.", word));
    }

    /**
     * Determines whether or not a string is a valid dyckword.
     *
     * @param word the given string.
    */
    private static boolean isDyckWord(String word)
    {
        Stack<Character> brackets = new Stack<>();
        char[] charArr = word.toCharArray();
        for(int i = 0; i < charArr.length; i++)
        {
            if(Brackets.isLeftBracket(charArr[i]))
                brackets.push(charArr[i]);
            if(Brackets.isRightBracket(charArr[i]))
            {
                if(brackets.isEmpty())
                    return false;
                if(!Brackets.correspond(brackets.pop(),charArr[i]))
                    return false;
            }
        }
        return brackets.isEmpty();
    }

    public String getWord() {
        return word;
    }

}
