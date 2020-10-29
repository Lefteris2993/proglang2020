from collections import deque

def solve(f):
    RNAList = [list(line) for line in f]
    testCases = len(RNAList)

    for i in range(1, testCases):
        #print(RNAList[i])

        queue = deque()
        I = len(RNAList[i]) - 2

        A1 = False
        U1 = False
        G1 = False
        C1 = False
        if RNAList[i][I] == 'A' : A1 = True
        if RNAList[i][I] == 'U' : U1 = True
        if RNAList[i][I] == 'G' : G1 = True
        if RNAList[i][I] == 'C' : C1 = True

        queue.append((False, I - 1 ,RNAList[i] , RNAList[i][I], RNAList[i][I], 'p','p', 'Z', A1, U1, G1, C1))
        
        while queue:
            comp, I, RNA, head, tail, result, prev1, prev2, A, U, G, C = queue.popleft()

            #print(comp, I, RNA, head, tail, result, prev1, prev2, A, U, G, C)

            if I == -1:
                break
            
            if comp:
                if RNA[I] == 'A': cur = 'U'
                if RNA[I] == 'U': cur = 'A'
                if RNA[I] == 'G': cur = 'C'
                if RNA[I] == 'C': cur = 'G'
                #print("---------------> new cur = ", cur)
            else : cur = RNA[I]

            if (prev1 != 'c' and not((prev1 == 'r' and prev2 == 'c') or (prev1 == 'c' and prev2 == 'r')) and prev1 != 'r'):
                queue.append((not comp, I, RNA, head, tail, result + 'c', 'c', prev1, A, U, G, C))
                #print(2)

            if head == cur or ((cur == 'A' and A == False) or (cur == 'U' and U == False) or (cur == 'G' and G == False) or (cur == 'C' and C == False)):
                A1 = A
                U1 = U
                G1 = G
                C1 = C
                if cur == 'A' : A1 = True
                if cur == 'U' : U1 = True
                if cur == 'G' : G1 = True
                if cur == 'C' : C1 = True
                if tail == 'Z' : tail = cur
                queue.append((comp, I-1, RNA, cur, tail, result + 'p', 'p', prev1, A1, U1, G1, C1))
                #print(1)


            if (prev1 != 'r' and not ((prev1 == 'r' and prev2 == 'c') or (prev1 == 'c' and prev2 == 'r'))):
                queue.append((comp, I, RNA, tail, head, result + 'r', 'r', prev1, A, U, G, C))
                #print(3)

            

        print(result)



if __name__ == '__main__':
    import sys
    with open(sys.argv[1], 'rt') as f:
        solve(f)
