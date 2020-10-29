(* Input parse code by Stavros Aronis, modified by Nick Korasidis and me :) *)
fun parse file =
    let
        fun readInt input = (* A function to read an integer from specified input. *)
            Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        (* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
        val test_cases = readInt inStream
        val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
        fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
            | readInts i acc =
            let
                fun bin l 0 = rev l
                    | bin l n = bin ((n mod 2)::l) (n div 2) 
            in
                readInts (i - 1) ((bin [] (readInt inStream), readInt inStream ):: acc)
            end
             
    in
   	    (test_cases, readInts test_cases [], ())
    end

fun print_list l =
    let
        fun print_help [] = ()
            | print_help [a] = print(Int.toString(a))
            | print_help l = (print(Int.toString(hd l)); print(","); print_help (tl l))
    in 
        (print("["); print_help l; print("]\n"))
    end

fun count_ones ([], n) = n
    | count_ones (l, n) = 
        if hd l = 1 then
            count_ones ((tl l), (n + 1))
        else count_ones ((tl l), n)

fun listPP (l1, l2) =
    if (hd l2) = 0 then 
        listPP (((hd l2)::l1), (tl l2))
    else
        (rev((hd l1 + 2)::(tl l1)))@((hd l2 - 1)::(tl l2))

fun the_thing (l, 0) = l
    | the_thing (l, ~1) = []
    | the_thing (l, i) =
        the_thing ((listPP (hd l::[], tl l)), (i - 1))

fun remove_zeroes [] = []
    |remove_zeroes l =
    if (hd (rev l)) = 0 then
        remove_zeroes (rev (tl (rev l)))
    else 
        l

fun solve (0, l, useless_shit) = ()
    | solve (n, l, useless_shit) = 
        let
            fun process_head (l, n) = 
            let 
                val k = count_ones (l, 0)
                val iterations = 
                    if n < k then
                        ~1
                    else 
                        n - k
            in
                the_thing (l, iterations)
            end
        in
            solve ((n - 1), (tl l), print_list (remove_zeroes(process_head (hd l)))) 
        end

fun powers2 file = solve (parse file) 
