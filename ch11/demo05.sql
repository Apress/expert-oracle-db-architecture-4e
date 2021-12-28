-- When should you use a B*tree Index

set echo on

set autotrace traceonly explain

select owner, status
from t
where owner = USER;

select count(*)
from t
where owner = user;
