declare
begin
   for i in 1 .. 25000 loop
     begin
       execute immediate
         'insert into t' || &1 || ' values(' || i || ')';
     exception
       when no_data_found then null;
     end;
   end loop;
end;
/
exit;
