package app;

import datastructures.trees.BinarySearchTree;
import datastructures.trees.Traversal;
import products.Laptop;

import java.security.InvalidParameterException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 * !!DO NOT MODIFY THIS CODE!!
 *
 * @author Ritwik Banerjee
 */
public class Main {
    
    public static void main(String... args) {
        System.out.println("Enter product instances (format: <brand>,<processor-speed>,<memory>,<price>,<screen-size>):");
        Scanner      scanner = new Scanner(System.in);
        List<Laptop> laptops = new ArrayList<>();
        for (String line = ""; !line.equalsIgnoreCase("done"); line = scanner.nextLine()) {
            Laptop laptop = Laptop.fromString(line.trim());
            if (laptop != null)
                laptops.add(laptop);
        }
        
        BinarySearchTree<Laptop> laptopTree = new BinarySearchTree<>(laptops);
        laptopTree.print();
        
        System.out.println("Enter traversal type: ");
        Traversal<Laptop> traversal = Traversal.ofType(validated(scanner.nextLine().trim()));
        for (Laptop laptop : traversal.of(laptopTree))
            System.out.println(laptop);
    }
    
    private static String validated(String s) {
        if (s.equalsIgnoreCase("inorder") || s.equalsIgnoreCase("preorder") || s.equalsIgnoreCase("postorder"))
            return s;
        throw new InvalidParameterException(String.format("%s is not a valid tree traversal.", s));
    }
}
