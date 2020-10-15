/**
    Emilly Ly
    111097939
    CSE 214 (Assignment #2)
*/
package applications.arithmetic;

/**
 * This interface defines the structure of any evaluator to be used for evaluating an expression.
 *
 * @author Emilly Ly
*/
public interface Evaluator
{
    /**
     * The fundamental method of any class implementing this interface.
     * It evaluates the given expression to a value.
     *
     * @param expressionString the given string to be evaluated.
    */
    double evaluate(String expressionString);
}
