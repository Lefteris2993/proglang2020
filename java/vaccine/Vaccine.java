import java.io.*;
import java.util.*;

public class Vaccine {

    static Queue<NewNode> q = new LinkedList<>();

    public static void main(String args[]) throws Exception {
        BufferedReader br = new BufferedReader(new FileReader(args[0]));
        String line;

        int x = 0, y = 0;
        line = br.readLine();

        while((line = br.readLine()) != null){
            //System.out.println(line);

            boolean A1 = false;
            boolean U1 = false;
            boolean G1 = false;
            boolean C1 = false;
            if (line.charAt(line.length()-1) == 'A') A1 = true;
            if (line.charAt(line.length()-1) == 'U') U1 = true;
            if (line.charAt(line.length()-1) == 'G') G1 = true;
            if (line.charAt(line.length()-1) == 'C') C1 = true;
            //System.out.println(line.charAt(line.length()-2));

            String res = "";
            String RNA = line;
            q.add(new NewNode(false, line.length()-2, line.charAt(line.length() -1), line.charAt(line.length() -1), "p", 'p', 'Z', A1, U1, G1, C1));

            while (!q.isEmpty()) {
                NewNode node = q.remove();

                boolean comp = node.getComp();
                int I = node.getI();
                char head = node.getHead();
                char tail = node.getTail();
                String result = node.getResult();
                char prev1 = node.getPrev1();
                char prev2 = node.getPrev2();
                boolean A = node.getA();
                boolean U = node.getU();
                boolean G = node.getG();
                boolean C = node.getC();

                //System.out.print(comp);
                //System.out.print(" ");
                //System.out.print(I);
                //System.out.print(" ");
                //System.out.print(RNA);
                //System.out.print(" ");
                //System.out.print(head);
                //System.out.print(" ");
                //System.out.print(tail);
                //System.out.print(" ");
                //System.out.print(result);
                //System.out.print(" ");
                //System.out.print(prev1);
                //System.out.print(" ");
                //System.out.print(prev2);
                //System.out.print(" ");
                //System.out.print(A);
                //System.out.print(" ");
                //System.out.print(U);
                //System.out.print(" ");
                //System.out.print(G);
                //System.out.print(" ");
                //System.out.print(C);
                //System.out.print("\n");

                
                res = result;

                if (I == -1)
                    break;
                
                char cur = RNA.charAt(I);

                if (comp) {
                    if (RNA.charAt(I) == 'A') cur = 'U';
                    if (RNA.charAt(I) == 'U') cur = 'A';
                    if (RNA.charAt(I) == 'G') cur = 'C';
                    if (RNA.charAt(I) == 'C') cur = 'G';
                }

                //System.out.println(cur);
                if (prev1 != 'c' && !((prev1 == 'r' && prev2 == 'c') || (prev1 == 'c' && prev2 =='r')) && prev1 != 'r') {
                    //System.out.println("1");
                    q.add(new NewNode(!comp, I, head, tail, result + 'c', 'c', prev1, A, U, G, C));
                }

                if (head == cur || ((cur == 'A' && A == false) || (cur == 'U' && U == false) || (cur == 'G' && G == false) || (cur == 'C' && C == false))) {
                    //System.out.println("2");
                    A1 = A;
                    U1 = U;
                    G1 = G;
                    C1 = C;
                    if (cur == 'A') A1 = true;
                    if (cur == 'U') U1 = true;
                    if (cur == 'G') G1 = true;
                    if (cur == 'C') C1 = true;
                    q.add(new NewNode(comp, I-1, cur, tail, result + 'p', 'p', prev1, A1, U1, G1, C1));
                }

                if (prev1 != 'r' && !((prev1 == 'r' && prev2 == 'c') || (prev1 == 'c' && prev2 == 'r'))) {
                    //System.out.println("3");
                    q.add(new NewNode(comp, I, tail, head, result + 'r', 'r', prev1, A, U, G, C));
                }
            }

            System.out.println(res);

            while(!q.isEmpty()){
                NewNode tsifsa = q.remove();
            }

            //Thread.sleep(10000);
                
        }
    }
}
