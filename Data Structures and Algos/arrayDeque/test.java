package homework1;

public class test
{
    public static void main(String[] args)
    {
        String[] arr = {"a","b","c","d","e"};
        arrayDeque test1 = new arrayDeque(arr);
        test1.addFirst("a");
        test1.addFirst("a");
        test1.addFirst("a");
        test1.addFirst("a");
        test1.addFirst("a");
        test1.addFirst("a");
        test1.addLast("e");
        test1.addLast("e");
        test1.addLast("e");
        test1.addLast("e");
        test1.addLast("e");
        test1.addLast("e");
        test1.addLast("e");
        test1.removeFirst();
        test1.removeFirst();
        test1.removeFirst();
        test1.removeFirst();
        test1.removeFirst();
        test1.removeFirst();
        test1.removeLast();
        test1.removeLast();
        test1.removeLast();
        test1.removeLast();
        test1.removeLast();
        test1.removeLast();
        test1.removeLast();
        for(int i = 0; i < test1.a.length; i++)
        {
            System.out.print(test1.a[i] + " ");
        }

        System.out.println();

        String[] arr2 = {"a","b","c","d","e"};
        arrayTreque test2 = new arrayTreque(arr2);
        test2.removeMiddle();
        test2.removeMiddle();
        test2.removeMiddle();
        test2.removeMiddle();
        test2.removeMiddle();
        test2.addMiddle("a");
        for(int i = 0; i < test2.a.length; i++)
        {
            System.out.print(test2.a[i] + " ");
        }
        test2.addMiddle("b");
        for(int i = 0; i < test2.a.length; i++)
        {
            System.out.print(test2.a[i] + " ");
        }
        test2.addMiddle("c");
        for(int i = 0; i < test2.a.length; i++)
        {
            System.out.print(test2.a[i] + " ");
        }
        test2.addMiddle("d");
        for(int i = 0; i < test2.a.length; i++)
        {
            System.out.print(test2.a[i] + " ");
        }
        test2.addMiddle("e");
        //test2.addMiddle("e");

        for(int i = 0; i < test2.a.length; i++)
        {
            System.out.print(test2.a[i] + " ");
        }
    }

}
