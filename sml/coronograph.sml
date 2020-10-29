fun parse file = (*should return *)
    let
      fun readInt input = 
            Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

      val inStream = TextIO.openIn file

        val test_cases = readInt inStream
        val _ = TextIO.inputLine inStream

      fun readInput 0 acc = acc
        | readInput  i acc =
          let
            fun readCases 0 acc = acc
              | readCases i acc =
                let
                  val Vert = readInt inStream
                  val Edge = readInt inStream

                  fun readEdges 0 acc = acc
                    | readEdges i acc = 
                      readEdges (i - 1) ((readInt inStream, readInt inStream) :: acc)
                in
                  ((Vert, Edge) :: (readEdges Edge []))
                end            
          in
            readInput (i - 1) ((acc @ (readCases test_cases []) :: []))
          end
    in
      (test_cases, readInput test_cases [])
    end

exception Wtf

fun print_list l =
    let
        fun print_help [] = ()
          | print_help [a] = print(Int.toString(a))
          | print_help l = (print(Int.toString(hd l)); print(" "); print_help (tl l))
    in 
        (print_help l; print("\n"))
    end

structure Map = BinaryMapFn(struct
  type ord_key = int
  fun compare (a1, a2) = Int.compare (a1, a2)
end)

fun createGraph (m, []) = m
    | createGraph (m, (a,b)::l) =
    let
        val newM = 
        case Map.find (m, b) of 
            SOME x => Map.insert (m, b, a::x)
            | NONE => Map.insert (m, b, a::[])
    in 
        case Map.find (m, a) of
            SOME x => createGraph ((Map.insert (newM, a, b::x)), l)
            | NONE => createGraph ((Map.insert (newM, a, b::[])), l)
    end

fun traversal (graph, [], visited, path, backEdges, count) = ([], count)
  | traversal (graph, (cur, prev)::stack, visited, path, 1, count) = (path, 0)
  | traversal (graph, (cur, prev)::stack, visited, path, backEdges, count) = 
    let
      val isVisited = 
        case Map.find (visited, cur) of
            NONE => false
          | SOME X => true
      
      val newVisited = Map.insert (visited, cur, ())

      val newBackEdges = 
        if (isVisited) then
            1
        else 
            0

      val node = case Map.find (graph, cur) of
            SOME l => l
          | NONE => raise Wtf

      fun getAdjList (l, p) = List.filter (fn x => x <> p) l

      fun createNewStack (node, c) =
        let
          fun aux ([], n) = []
            | aux (l, n) = (hd l, n)::aux(tl l, n)
        in
          aux ((getAdjList (node, prev)), c)
        end
      val newStack = if (isVisited)
        then
          (stack)
        else
          (createNewStack (node, cur))@(stack)
      val newPrev = 
        let 
          fun getNode (a,b) = b
        in
          if newStack <> [] then
            getNode (hd newStack)
          else
            42
        end

      val newCur = 
        let 
          fun getNode (a,b) = a
        in
          if newStack <> [] then
            getNode (hd newStack)
          else 
            42
        end

      val newPath =
        if newBackEdges = 0 then
          if (cur = newPrev) then 
            newCur::path
          else 
            let
              fun cutUntil (a :int, []) = []
                | cutUntil (a :int, l :int list) = 
                if a = hd l then
                  l
                else 
                  cutUntil (a, tl l)
            in
              newCur::(cutUntil (newPrev, path))
            end 
        else 
          path
      
      val newCount = count + 1

    in
      traversal (graph, newStack, newVisited, newPath, newBackEdges, newCount)
    end

fun helpTraversal (neiborList, i, [], graph) = 0
  | helpTraversal (neiborList, i, circle, graph) =
  let
    val start = (i, 0)

    fun getAdjList (( l :int list), []) = l
      | getAdjList (( l :int list), cir :int list) = 
        getAdjList (((List.filter (fn x => x <> (hd cir)) l)), tl cir)

    fun creatNewStack (node, c) = 
        let
          fun help ([], n :int) = []
            | help (l :int list, n :int) =
              (hd l, n)::help(tl l, n)  
        in
          help ((getAdjList (node, neiborList), c))
        end
    val node = 
        case Map.find (graph, i) of
            SOME l => l
            | NONE => raise Wtf
    
    val stack = (creatNewStack (node, i))
    val trav = traversal (graph, stack, Map.empty, [], 0, 1)
    val count =
        let
          fun getCount (p, c) = c
        in
          getCount trav
        end
  in
    count
  end

fun solveCase ((v, e)::l) = 
  let
    val graph = createGraph (Map.empty, l)

    val trav = 
        if v <> e then
            ([], 0)
        else
            (traversal (graph, [(1,0)], Map.empty, [1], 0, 1))

    val path = 
        let
            fun getPath (p, v) = p
        in
            getPath trav
        end
    fun prettyfyPath ([], a :int) = []
      | prettyfyPath (l :int list, a :int) = 
        if (hd l) = a then
            (hd l)::[]
        else 
            (hd l)::(prettyfyPath (tl l, a))

    val circle = 
        if path <> [] then
            prettyfyPath (tl path, hd path)
        else 
            []
    val _ = 
        if (circle = []) orelse (v <> e) then
            print ("NO CORONA\n")
        else let
          fun sum [] = 0
            | sum (h::l) = h + sum l 
          fun getLast ([], a) = a
            | getLast (l, a) = getLast (tl l, hd l) 

          fun countTrees (a::b::[], i, cir, g, flag) = (helpTraversal (a::(hd cir)::[], b, cir, g))::countTrees(b::[], i - 1, cir, g, flag)
            | countTrees (a::[], _, _, _, _) = []
            | countTrees (_, _, [], _, _) = [0]
            | countTrees (a::b::c::l, i, cir, g, 42) = (helpTraversal (b::(getLast(cir, 0))::[], a, cir, g))::countTrees(a::b::c::l, i - 1, cir, g, 17)
            | countTrees (a::b::c::l, i, cir, g, 17) = (helpTraversal (a::c::[], b, cir, g))::countTrees(b::c::l, i - 1, cir, g, 17)

          val trees = (countTrees(circle ,List.length circle, circle, graph, 42)) (*42 = treu, 17 = false*)
          val treesSum = sum trees
        in
          if treesSum <> v then 
            print ("NO CORONA\n")
          else 
            (print ("CORONA "); print (Int.toString (List.length circle)); print ("\n"); print_list (ListMergeSort.sort (fn(x,y)=> x>y) trees))
        end
  in
    ()
  end

fun solve (0, l) = ()
    | solve (i, l) =
        let
            val _ = solveCase (hd l)
        in
            solve ((i-1), (tl l))
        end

fun coronograph file = solve (parse file)
