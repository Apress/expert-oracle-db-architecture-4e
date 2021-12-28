declare
begin
   for i in 1 .. 25000 loop
     begin
       execute immediate
         'insert into t1 values(:i)' using i;
     exception
       when no_data_found then null;
     end;
   end loop;
end;
/
