show parameter PRIVATE_TEMP_TABLE_PREFIX

create private temporary table ora$ptt_temp1(a int) on commit drop definition;
insert into ora$ptt_temp1 values(1);
select * from ora$ptt_temp1;

commit;
-- Temp table should not be there now.
desc ora$ptt_temp1;

create private temporary table ora$ptt_temp2(a int) on commit preserve definition;
insert into ora$ptt_temp2 values(1);
commit;
select * from ora$ptt_temp2;

disconnect;
connect eoda/foo@PDB1
select * from ora$ptt_temp2;

