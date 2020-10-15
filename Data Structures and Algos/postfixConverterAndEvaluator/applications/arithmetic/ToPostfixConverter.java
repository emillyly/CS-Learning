/**
    Emilly Ly
    111097939
    CSE 214 (Assignment #2)
*/
package applications.arithmetic;
import datastructures.sequential.Stack;

/**
 * This class converts the an arithmetic expression into it's postfix form.
 *
 * @author Emilly Ly
*/
public class ToPostfixConverter implements Converter
{
    /**
     * Converts the given arithmetic expression into postfix.
     *
     * @param expression given arithmetic expression.
     * @return postfix form of expression.
     */
    public String convert(ArithmeticExpression expression)
    {
        String expressionString = expression.getExpression();
        String convertedExpression = "";
        Stack<String> OpStack = new Stack<>();

        int startIndex = 0;
        while(startIndex < expressionString.length())
        {
            if(isOperand(nextToken(expressionString,startIndex)))
            {
                convertedExpression += nextToken(expressionString,startIndex);
                convertedExpression += " ";

            }
            if(Brackets.isLeftBracket(nextToken(expressionString,startIndex)))
            {
                OpStack.push(nextToken(expressionString,startIndex));
            }
            if(Brackets.isRightBracket(nextToken(expressionString,startIndex)))
            {
                String topOp = OpStack.pop();
                while(!Brackets.isLeftBracket(topOp))
                {
                    convertedExpression += topOp;
                    convertedExpression += " ";
                    topOp = OpStack.pop();
                }
            }
            if(Operator.isOperator(nextToken(expressionString,startIndex)))
            {
                Operator temp = Operator.of(nextToken(expressionString,startIndex));
                if(OpStack.isEmpty())
                {
                    OpStack.push(nextToken(expressionString, startIndex));
                }
                else
                {
                    Operator topOp = Operator.of(OpStack.peek());
                    while (topOp.getRank() <= temp.getRank())
                    {
                        convertedExpression += OpStack.pop();
                        convertedExpression += " ";
                        topOp = Operator.of(OpStack.peek());
                    }
                    OpStack.push(nextToken(expressionString, startIndex));

                }
            }
            if(isOperand(nextToken(expressionString,startIndex)))
                startIndex += nextToken(expressionString,startIndex).length();
            else
                startIndex++;
        }
        while(!OpStack.isEmpty())
        {
            convertedExpression += OpStack.pop();
            convertedExpression += " ";
        }
        return convertedExpression;
    }

    /**
     * This method receives a string and an index and returns the next token starting at that index.
     *
     * @param s     the given string.
     * @param start the given index.
     * @return the next token starting at the given index in the string received.
    */
    public String nextToken(String s, int start)
    {
        TokenBuilder token = new TokenBuilder();
        char[] temp = s.toCharArray();
        int count = start;
        if(Operator.isOperator(temp[start]) || Brackets.isLeftBracket(temp[start]) || Brackets.isRightBracket(temp[start]))
        {
            return temp[start] + "";
        }
        while(count < temp.length && isOperand(temp[count] + ""))
        {
            token.append(temp[count]);
            count++;
        }
        return token.build();
    }

    /**
     * This method checks whether the given string is a operator or a bracket, if not then it is a operand and returns true.
     *
     * @param s the given string.
     * @return if the given string is a valid operand then <code>true</code> , and otherwise <code>false</code>.
    */
    public boolean isOperand(String s)
    {
        return !Operator.isOperator(s) && !Brackets.isLeftBracket(s) && !Brackets.isRightBracket(s);
    }
}
