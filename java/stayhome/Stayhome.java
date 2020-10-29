import java.io.*;
import java.util.*;

public class Stayhome {
    public static void main(String args[]) throws Exception {
        BufferedReader br = new BufferedReader(new FileReader(args[0]));
        String line;

        int x = 0, y = 0;

        while ((line = br.readLine()) != null) {
            String[] values = line.split("(?!^)");
            for (y = 0; y < values.length; y++) {
                char c = values[y].charAt(0);
                grid[x][y] = new Node(c, 'A', 1000000);
            }
            x++;
        }

        br.close();

        int N = x, M = y, sta, rt, ho, me, wu, han;
        sta = rt = ho = me = wu = han = -1;

        for (int i = 0; i < N; i++)
            for (int j = 0; j < M; j++)
            {
                int symbol = grid[i][j].getI();
                if (symbol == 'S')
                {
                    sta = i;
                    rt = j;
                }
                if (symbol == 'W')
                {
                    wu = i;
                    han = j;
                }
                if (symbol == 'T')
                {
                    ho = i;
                    me = j;
                }
                if (symbol == 'A')
                {
                    airports.add(new Node(i,j,-1));
                }
            }

        //System.out.println(sta + " " + rt + " " + ho + " " + me + " " + wu + " " + han);
        //System.out.println((char) grid[sta][rt].getI());
        safe = false;
        queue1.add(new Node(wu, han, 2));
        while (!queue1.isEmpty()) {
            Node head = queue1.remove();

            int i = head.getI();
            int j = head.getJ();
            int t = head.getT();

            //System.out.println(i + " " + j);

            if (j > 0)
                expandWuhan(i, j - 1, t);
            if (j < M - 1)
                expandWuhan(i, j + 1, t);
            if (i > 0)
                expandWuhan(i - 1, j, t);
            if (i < N - 1)
                expandWuhan(i + 1, j, t);

        }

        //System.out.println("----------------------------");

        air = true;
        queue2.add(new Node(sta, rt, 1));
        int time = 1;
        while (!queue2.isEmpty()) {
            Node head = queue2.remove();

            int i = head.getI();
            int j = head.getJ();
            int t = head.getT();

            //System.out.println(i + " " + j);

            if (safe && t > time)
                break;

            if (i < N - 1)
                expandSotiris(i + 1, j, 'D', t);
            if (j > 0)
                expandSotiris(i, j - 1, 'L', t);
            if (j < M - 1)
                expandSotiris(i, j + 1, 'R', t);
            if (i > 0)
                expandSotiris(i - 1, j, 'U', t);
            
            time = t;
        }

        if (safe)
        {
            String outstr = "";
            int i = ho, j = me;
            while (true)
            {
                int dire = grid[i][j].getJ();
                if(i == sta && j == rt)
                    break;
                outstr = (char) dire + outstr;
                if (dire == 'D')
                {
                    i = i - 1;
                    j = j;
                }
                else if (dire == 'L')
                {
                    i = i;
                    j = j + 1;
                }
                else if (dire == 'R')
                {
                    i = i;
                    j = j - 1;
                }
                else if (dire == 'U')
                {
                    i = i + 1;
                    j = j;
                }
            }
            System.out.println(time);
            System.out.println(outstr);
        }
        else 
            System.out.println("IMPOSSIBLE");
    }

    static Node[][] grid = new Node[1000][1000];
    static Queue<Node> queue1 = new LinkedList<>();
    static Queue<Node> queue2 = new LinkedList<>();
    static Queue<Node> airports = new LinkedList<>();
    static boolean safe = false;
    static boolean air = true;

    static void expandWuhan (int i, int j, int t)
    {
        int cha = grid[i][j].getI();
        int dire = grid[i][j].getJ();
        int time = grid[i][j].getT();
        if ((cha == '.' || cha == 'S' || cha == 'T' || cha == 'W') && time > t)
        {
            grid[i][j] = new Node (cha, dire, t);
            queue1.add(new Node(i, j, t + 2));
        }else if (cha == 'A' && air)
        {
            while(!airports.isEmpty())
            {
                Node head = airports.remove();
                int x = head.getI();
                int y = head.getJ();
                int temp0 = grid[x][y].getI();
                int temp1 = grid[x][y].getJ();
                int temp2 = grid[x][y].getT();
                if (temp2 > t + 5)
                    grid[x][y] = new Node(temp0, temp1, t + 5);
                queue1.add(new Node(x, y, t + 7));
            }
            air = false;
        }
    }

    static void expandSotiris (int i, int j, int d, int t)
    {
        int cha = grid[i][j].getI();
        int dire = grid[i][j].getJ();
        int time = grid[i][j].getT();
        if (t <= time && cha != 'X')
        {
            if (t == time && dire == 'A' && cha != 'T')
                return;
            if (cha == 'T')
                safe = true;
            else
                grid[i][j] = new Node(cha, dire, t);
            if (dire == 'A')
            {
                queue2.add(new Node(i, j, t + 1));
                grid[i][j] = new Node(cha, d, t);
            }
        }
    }
}
