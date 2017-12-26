BEGIN;

CREATE SCHEMA erapto;
CREATE SCHEMA erapto_private;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

CREATE TABLE erapto.semester (
    semester_id character varying(5) NOT NULL,
    tahun_ajaran_id character varying(4) NOT NULL,
    nama_semester character varying(20) NOT NULL,
    semester numeric(1,0) NOT NULL,
    periode_aktif character varying(1) NOT NULL,
    tanggal_mulai date NOT NULL,
    tanggal_selesai date NOT NULL,
    CONSTRAINT ckc_semester_semester CHECK ((semester = ANY (ARRAY[(1)::numeric, (2)::numeric])))
);

comment on table erapto.semester is 'The semester info.';
comment on column erapto.semester.semester_id is 'The primary unique identifier for this semester.';
comment on column erapto.semester.tahun_ajaran_id is 'Id of academic year';
comment on column erapto.semester.nama_semester is 'Semester name';
comment on column erapto.semester.semester is 'Index of semester in number';
comment on column erapto.semester.periode_aktif is 'Active period of semester';
comment on column erapto.semester.tanggal_mulai is 'Start period of semester';
comment on column erapto.semester.tanggal_mulai is 'End period of semester';


create role erapto_postgraphql login password 'xyz';

create role erapto_anonymous;
grant erapto_anonymous to erapto_postgraphql;

create role erapto_user;
grant erapto_user to erapto_postgraphql;

CREATE TABLE erapto_private.user_login (
  userid CHARACTER VARYING(50) NOT NULL,
  password CHARACTER VARYING(128) NOT NULL,
  nama CHARACTER VARYING(60) NOT NULL,
  level CHARACTER VARYING (50) NOT NULL,
  ptk_id uuid,
  salt CHARACTER VARYING(128)
);

comment on table erapto_private.user_login is 'Private info about a user’s account.';
comment on column erapto_private.user_login.userid is 'The id of the person associated with this account.';
comment on column erapto_private.user_login.password is 'An opaque hash of password';
comment on column erapto_private.user_login.nama is 'Login name of this account';
comment on column erapto_private.user_login.level is 'Level of user';
comment on column erapto_private.user_login.ptk_id is 'PTK id';

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

grant usage on SCHEMA erapto to erapto_anonymous, erapto_user;

grant select on table erapto.semester to erapto_anonymous, erapto_user;
grant update, delete on table erapto.semester to erapto_user;

alter table erapto.semester enable row level security;

create policy select_semester on erapto.semester for select
  using (true);

commit;
