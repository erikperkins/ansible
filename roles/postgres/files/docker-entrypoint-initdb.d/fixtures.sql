create user phoenix_app with password 'phoenix_app' createdb login;

create user snap_app with password 'snap_app' createdb login;
create database snap_app;
alter database snap_app owner to snap_app;

\connect snap_app

create table todos (
  id integer,
  text text
);

insert into todos (id, text) values
  (1, 'Hello, Haskell and Docker!'),
  (2, '2nd Todo'),
  (3, 'Third Todo'),
  (4, 'Todo #4')
;

alter table todos owner to snap_app;
