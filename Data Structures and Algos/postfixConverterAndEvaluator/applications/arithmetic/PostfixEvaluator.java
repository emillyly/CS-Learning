/**
    Emilly Ly
    111097939
    CSE 214 (Assignment #2)
*/
package applications.arithmetic;
import datastructures.sequential.Stack;

/**
 * This class evaluates an expression to a postfix one.
 *
 * @author Emilly Ly
*/
public class PostfixEvaluator implements Evaluator
{
    /**
     * This method receives a postfix expression , evaluates it, and returns the value.
     *
     * @param expressionString the given postfix expression.
     * @return the value of the expression after evaluated.
    */
    public double evaluate(String expressionString)
    {
        Stack<Double> NumStack = new Stack<>();
        String[] splitExpression = expressionString.split(" ");
        for(int i = 0; i < splitExpression.length; i++)
        {
            String temp = splitExpression[i];
            if(isOperand(temp))
            {
                NumStack.push(Double.parseDouble(temp));
            }
            else
            {
                double op2 = NumStack.pop();
                double op1 = NumStack.pop();
                if(Operator.of(temp).getSymbol() == '*')
                {
                    NumStack.push(op1 * op2);
                }
                if(Operator.of(temp).getSymbol() == '/')
                {
                    NumStack.push(op1 / op2);
                }
                if(Operator.of(temp).getSymbol() == '+')
                {
                    NumStack.push(op1 + op2);
                }
                if(Operator.of(temp).getSymbol() == '-')
                {
                    NumStack.push(op1 - op2);
                }
            }
        }

        return NumStack.pop();
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
