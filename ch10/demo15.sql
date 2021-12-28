-- Hash Clustered Tables, example 1

set echo on

drop cluster hash_cluster;

create cluster hash_cluster
  ( hash_key number )
    hashkeys 1000
    size 8192;

set serverout on
exec show_space( 'HASH_CLUSTER', user, 'CLUSTER' )
