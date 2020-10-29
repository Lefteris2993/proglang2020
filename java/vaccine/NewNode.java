public class NewNode {
    private boolean comp;
    private int I;
    private char head;
    private char tail;
    private String result;
    private char prev1;
    private char prev2;
    private boolean A;
    private boolean U;
    private boolean G;
    private boolean C;

    public NewNode(boolean comp, int I, char head, char tail, String result, char prev1, char prev2, boolean A, boolean U, boolean G, boolean C) {
        this.comp = comp;
        this.I = I;
        this.head = head;
        this.tail = tail;
        this.result = result;
        this.prev1 = prev1;
        this.prev2 = prev2;
        this.A = A;
        this.U = U;
        this.G = G;
        this.C = C;
    }

    public boolean getComp() {
        return comp;
    }

    public int getI() {
        return I;
    }

    public char getHead() {
        return head;
    }

    public char getTail() {
        return tail;
    }

    public String getResult() {
        return result;
    }

    public char getPrev1() {
        return prev1;
    }

    public char getPrev2() {
        return prev2;
    }

    public boolean getA() {
        return A;
    }

    public boolean getU() {
        return U;
    }

    public boolean getG() {
        return G;
    }

    public boolean getC() {
        return C;
    }
}
