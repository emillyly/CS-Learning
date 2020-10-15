/**
 * The <code>Hashable</code> interface provides the basic structure for any data type that can
 * be hashed. That is, any instance of the data type should be interpretable as an integer. The
 * <code>hash()</code> method of this interface achieves this. For example, to get the integer
 * value corresponding to an instance <code>s</code>, <code>s.hash()</code> must be invoked.
 *
 * @author Ritwik Banerjee
 */
public interface Hashable {
    /**
     * Converts an instance of a hashable data type to a non-negative integer.
     * @return the integer value.
     */
    int hash();
}