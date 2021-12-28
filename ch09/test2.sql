begin
    for i in 1 .. 5000
    loop
        update small set y = i where x= &1;
        commit;
    end loop;
end;
/
exit
