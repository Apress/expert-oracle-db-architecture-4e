-- Bitmap Indexes 

set echo on

drop index job_idx;
create BITMAP index job_idx on emp(job);

select count(*) from emp where job = 'CLERK' or job = 'MANAGER';

select * from emp where job = 'CLERK' or job = 'MANAGER';
