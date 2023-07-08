fun prime (n : int) : int
        var i : int;
    {
        if n<0 then return prime(-1);
        else if n<2 then return 0;
        else if n=2 then return 1;
        else if n mod 2 = 0 then return 0;
        else {
            i <- 3;
            while i <= n / 2 do {
                if n mod i = 0 then
                    return 0;
                i <- i + 2;
            }
            return 1;
        }
    }