-- Getting the Difference Between Two TIMESTAMPs

set echo on

select dt2-dt1
    from (select to_timestamp('29-feb-2000 01:02:03.122000',
                              'dd-mon-yyyy hh24:mi:ss.ff') dt1,
                 to_timestamp('15-mar-2001 11:22:33.000000',
                                           'dd-mon-yyyy hh24:mi:ss.ff') dt2
            from dual )
/

select numtoyminterval
         (trunc(months_between(dt2,dt1)),'month')
             years_months,
         dt2-add_months(dt1,trunc(months_between(dt2,dt1)))
                 days_hours
    from (select to_timestamp('29-feb-2000 01:02:03.122000',
                              'dd-mon-yyyy hh24:mi:ss.ff') dt1,
                 to_timestamp('15-mar-2001 11:22:33.000000',
                              'dd-mon-yyyy hh24:mi:ss.ff') dt2
            from dual )
/


select numtoyminterval
         (trunc(months_between(dt2,dt1)),'month')
             years_months,
         dt2-(dt1 + numtoyminterval( trunc(months_between(dt2,dt1)),'month' ))
                 days_hours
    from (select to_timestamp('29-feb-2000 01:02:03.122000',
                              'dd-mon-yyyy hh24:mi:ss.ff') dt1,
                 to_timestamp('15-mar-2001 11:22:33.000000',
                               'dd-mon-yyyy hh24:mi:ss.ff') dt2
            from dual )
/
