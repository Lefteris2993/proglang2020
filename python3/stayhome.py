from collections import deque

def solve(f):
    global grid, air, queue, safe
    grid = [list(line) for line in f]

    N, M = len(grid), len(grid[0])

    airports = []

    queue = deque()

    for i in range(N):
        for j in range(M):
            if grid[i][j] == 'S':
                start = i, j
            if grid[i][j] == 'W':
                wuhan = i, j
            if grid[i][j] == 'T':
                home = i, j
            if grid[i][j] == 'A':
                airports.append((i, j))
            grid[i][j] = (grid[i][j], 'A', 1000000)
    
    def expandWuhan (i, j, t):
        global grid, queue, air
        char, dire, time = grid[i][j]
        if (char in ('.', 'S', 'T') and time > t):
            grid[i][j] = (char, dire, t)#dire not W
            queue.append((i, j, t + 2))
        elif (char == 'W' and time > t):
            grid[i][j] = (char, dire, t) #dire not W
            queue.append((i, j, t + 2))
        elif (char == 'A' and air):
            for (x, y) in airports:
                if (grid[x][y][2] > t +5):
                    grid[x][y] = (grid[x][y][0], grid[x][y][1], t + 5)#grid[x][y][1] not W
                queue.append((x, y, t + 7))
            air = False

    def expandSotiris (i, j, d, t):
        global grid, queue, safe
        char, dire, time = grid[i][j]
        if (t <= time and char != 'X'):
            if (t == time and dire == 'A' and char != 'T'):
                return
            if (char == 'T'): safe = True
            else: grid[i][j] = (char, dire, t)
            if (dire == 'A'):
                queue.append((i, j, t + 1))
                grid[i][j] = (char, d, t)

    air = True
    x, y = wuhan
    queue.append((x, y, 2))
    while queue:
        i, j, t = queue.popleft()
        if j > 0:
            expandWuhan(i, j - 1, t)
        if j < M - 1:
            expandWuhan(i, j + 1, t)
        if i > 0:
            expandWuhan(i - 1, j, t)
        if i < N - 1:
            expandWuhan(i + 1, j, t)

    safe = False
    x, y = start
    queue = deque()
    queue.append((x, y, 1))
    time = 1
    while queue:
        i, j, t = queue.popleft()
        if (safe and t > time):
            break
        if i < N - 1:
            expandSotiris(i + 1, j, 'D', t)
        if j > 0:
            expandSotiris(i, j - 1, 'L', t)
        if j < M - 1:
            expandSotiris(i, j + 1, 'R', t)
        if i > 0:
            expandSotiris(i - 1, j, 'U', t)
        time = t

    if safe:
        i, j = home
        x, y = start
        outstr = ''
        while True:
            if (i == x and j == y):
                break
            outstr = grid[i][j][1] + outstr
            if (grid[i][j][1] == 'D'):
                i, j = i - 1, j
            elif (grid[i][j][1] == 'L'):
                i, j = i, j + 1
            elif (grid[i][j][1] == 'R'):
                i, j = i, j - 1
            elif (grid[i][j][1] == 'U'):
                i, j = i + 1, j
            
        print(time)
        print(outstr)
    else:
        print('IMPOSSIBLE')


if __name__ == '__main__':
    import sys
    with open(sys.argv[1], 'rt') as f:
        solve(f)
