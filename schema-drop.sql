-- This script will delete everything created in 'schema.sql'. This script is
-- also idempotent, you can run it as many times as you like. Nothing 
-- will be dropped it the schemas and roles do not exist.

begin;

drop schema if exists erapto, erapto_private cascade;
drop role if exists erapto_postgraphql, erapto_anonymous, erapto_user;

commit;
