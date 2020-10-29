structure Map = BinaryMapFn(struct
  type ord_key = int * int
  fun compare ((a1, b1), (a2, b2)) =
    case Int.compare (a1, a2) of
        EQUAL => Int.compare (b1, b2)
      | other => other
end)

exception Wtf

fun createGrid l =
  let
    fun aux [#"\n"] m _ _ home wuhan start airports = (m, home, wuhan, start, airports)
      | aux (#"\n" :: xs) m i _ home wuhan start airports = aux xs m (i + 1) 0 home wuhan start airports
      | aux ( #"T" :: xs) m i j home wuhan start airports = aux xs (Map.insert (m, (i, j), (#"T", #"A", 1000000))) i (j + 1) (i, j) wuhan start airports
      | aux ( #"W" :: xs) m i j home wuhan start airports = aux xs (Map.insert (m, (i, j), (#"W", #"A", 1000000))) i (j + 1) home (i, j) start airports
      | aux ( #"S" :: xs) m i j home wuhan start airports = aux xs (Map.insert (m, (i, j), (#"S", #"A", 1000000))) i (j + 1) home wuhan (i, j) airports
      | aux ( #"A" :: xs) m i j home wuhan start airports = aux xs (Map.insert (m, (i, j), (#"A", #"A", 1000000))) i (j + 1) home wuhan start ((i, j) :: airports)
      | aux (x :: xs) m i j home wuhan start airports = aux xs (Map.insert (m, (i, j), (x, #"A", 1000000))) i (j + 1) home wuhan start airports
      | aux _ _ _ _ _ _ _ _ = raise Wtf
  in
   aux l Map.empty 0 0 (0, 0) (0, 0) (0, 0) []
  end

fun helpAirports ([], grid, t, queue) = (grid, queue)
  | helpAirports (((x, y)::airports), grid, t, queue) =
    case Map.find (grid, (x, y)) of
       SOME (char, dire, time) => 
        if time > t then 
            helpAirports (airports, (Map.insert (grid, (x, y), (char, dire, t + 5))), t, (Fifo.enqueue (queue, (x, y, t + 7))))
        else 
            helpAirports (airports, grid, t, (Fifo.enqueue (queue, (x, y, t + 7))))
     | NONE => raise Wtf

fun expandWuhanHelp (airports, grid, queue, air, i, j, t) =
  case Map.find (grid, (i, j)) of
     SOME (char, dire, time) => 
     if ((char = #"." orelse char = #"S" orelse char = #"T" orelse char = #"W") andalso time > t) then
        (((Map.insert (grid, (i, j), (char, dire, t))), (Fifo.enqueue (queue, (i, j, t + 2)))), air)
    else if (char = #"A" andalso air) then
        ((helpAirports (airports, grid, t, queue)), false) 
    else ((grid, queue), air)
   | NONE => ((grid, queue), air)

fun expandWuhan (airports, grid, queue, air) =
    case Fifo.isEmpty queue of
       true => grid
     | false => 
        let
            val (headless, (i, j, t)) = Fifo.dequeue queue
            val ((g1, q1), a1) = expandWuhanHelp(airports, grid, headless, air, i + 1, j, t)
            val ((g2, q2), a2) = expandWuhanHelp(airports, g1, q1, a1, i, j - 1, t)
            val ((g3, q3), a3) = expandWuhanHelp(airports, g2, q2, a2, i, j + 1, t)
            val ((g4, q4), a4) = expandWuhanHelp(airports, g3, q3, a3, i - 1, j, t)
        in
            expandWuhan (airports, g4, q4, a4)
        end

fun expandSotirisHelp (grid, queue, safe, i, j, d, t) = 
    case Map.find (grid, (i, j)) of
       SOME (char, dire, time) => 
        if not (t <= time andalso char <> #"X") then
          (grid, queue, safe)
        else if (t = time andalso dire = #"A" andalso char <> #"T") then
          (grid, queue, safe)
        else if (char = #"T" andalso dire = #"A") then 
          ((Map.insert (grid, (i, j), (char, d, t))), (Fifo.enqueue (queue, (i, j, t + 1))), true)
        else if (char <> #"T" andalso dire = #"A") then 
          ((Map.insert (grid, (i, j), (char, d, t))), (Fifo.enqueue (queue, (i, j, t + 1))), safe)
        else if (char = #"T" andalso dire <> #"A") then
          (grid, queue, true)
        else if (char <> #"T" andalso dire <> #"A") then
          ((Map.insert (grid, (i, j), (char, dire, t))), queue, safe)
        else raise Wtf
     | NONE => (grid, queue, safe)

fun expandSotiris (grid, queue, safe, time) = 
  case Fifo.isEmpty queue of
     true => (grid, safe, time)
   | false => 
      let
        val (headless, (i, j, t)) = Fifo.dequeue queue
        val (NewGrid, NewQueue, NewSafe) = if (safe andalso t > time) then
            (grid, queue, safe)
          else  let
                    val (g1, q1, s1) = expandSotirisHelp(grid, headless, safe, i + 1, j, #"D", t)
                    val (g2, q2, s2) = expandSotirisHelp(g1, q1, s1, i, j - 1, #"L", t)
                    val (g3, q3, s3) = expandSotirisHelp(g2, q2, s2, i, j + 1, #"R", t)
                    val (g4, q4, s4) = expandSotirisHelp(g3, q3, s3, i - 1, j, #"U", t)
                in
                    (g4, q4, s4)
                end
      in
        if (safe andalso t > time) then
          (NewGrid, safe, time)
        else expandSotiris (NewGrid, NewQueue, NewSafe, t)
      end

fun findPath (grid, home, start) =
  let
    val (i, j) = home
    val (x, y) = start
    fun aux (grid, i, j, x, y, acc) =
      case Map.find (grid, (i, j)) of
         SOME (char, dire, time) => 
          if (i = x andalso j = y) then
            acc
          else if (dire = #"D") then
            aux (grid, i - 1, j, x, y, (#"D"::acc))
          else if (dire = #"L") then
            aux (grid, i, j + 1, x, y, (#"L"::acc))
          else if (dire = #"R") then
            aux (grid, i, j - 1, x, y, (#"R"::acc))
          else if (dire = #"U") then
            aux (grid, i + 1, j, x, y, (#"U"::acc))
          else raise Wtf
       | NONE => raise Wtf
  in  
    aux (grid, i, j, x, y, [])
  end

fun printList l =
    let
        fun print_help [] = ()
            | print_help [a] = print(Char.toString(a))
            | print_help l = (print(Char.toString(hd l)); print_help (tl l))
    in 
        (print_help l; print("\n"))
    end

fun solve l = 
    let
      val (grid, home, wuhan, start, airports) = createGrid l
      val (x, y) = wuhan 
      val (i, j) = start
      val tempq1 = (Fifo.enqueue (Fifo.empty, (x, y, 2)))
      val tempq2 = (Fifo.enqueue (Fifo.empty, (i, j, 1)))
      val coronagrid = expandWuhan (airports, grid, tempq1, true)
      val (finaGrid, safe, time) = expandSotiris (coronagrid, tempq2, false, 1)
      val _ = if safe then (print (Int.toString(time)); print("\n") ; printList (findPath (finaGrid, home, start)))
              else print("IMPOSSIBLE\n")
    in
      ()
    end

fun parse file = explode (TextIO.inputAll (TextIO.openIn file))

fun stayhome file = solve (parse file)

(*
stayhome("stayhome/stayhome.in1");
*) 
