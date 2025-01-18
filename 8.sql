


create table role(
    id integer not null primary key,
    name_role text not null,
    id_role integer not null
);

insert into role(id, name_role, id_role) values (1 ,'Артём',2),(2,'Luz',6),(3,'admin',1);


create table artists(
artist_id integer not null primary key,
artist_name text not null,
pay integer not null
);
create unique index  artist_name on artists(artist_name);
create  table albums(
    album_id integer not null primary key,
    artist_id integer not null constraint albums_fsad references artists on update cascade  on delete cascade,
    title text not null,
    released date not null
);
create unique index  albums_title on albums(title);
create table artists_albums(
    artist_id integer not null constraint albums_fk references artists on update cascade  on delete cascade ,
    albums_id integer not null constraint albums_fs references albums on update cascade  on delete cascade,
    primary key (artist_id,albums_id)
);

create table genres(
    genre_id integer not null primary key,
    name_genres text not null
);

create table album_genres(
    album_id integer not null constraint album_genres_kf references albums on update cascade  on delete cascade,
    genre_id integer not null constraint album_genres_lf references genres on update cascade  on delete cascade,
    primary key (album_id,genre_id)
);

create table fans (
    fan_id integer not null primary key,
    login_fan text not null,
    name_fan text not null
);
create unique index  fans_login on fans(login_fan);
create table fans_follows(
    artist_id integer not null  constraint fans_fk references artists on update cascade on delete cascade,
    fan_id integer not null constraint fans_follows_fk references fans on update cascade  on delete cascade,
    primary key (artist_id,fan_id)
);

insert into artists(artist_id, artist_name,pay) values (1,'Okavari',5000), (2,'Steely',10000),
                                                   (3,'Elliott',20000),(4,'TWRP',5000),(5,'Donald',8000),(6,'Luz',9000),
                                                   (7,'Ella',7000);
insert into genres(genre_id, name_genres) VALUES (1,'Hip Hop'), (2,'Jazz'),
                                                   (3,'Electronic'),(4,'Rock'),(5,'Pop'),(6,'Funk'),
                                                   (7,'Indie');
insert into albums(album_id, artist_id, title, released) values (1,1,'Mirror','2009/06/24'), (2,2,'Pretzel Logic','1974-02-20'),
                                                   (3,3,'Under Construction','2002-11-12'),(4,4,'Return to Wherever','2019-07-11'),(5,5,'The Nightfly','1982-10-01'),(6,6,'It is Alive','2013-10-15'),
                                                   (7,7,'Pure Ella','1994-02-15');
insert into artists_albums(artist_id, albums_id) VALUES (1,1),(1,2),(2,2),(2,4),
                                                    (2,5),(3,1),(4,4),(4,6),
                                                    (5,2),(5,4),(5,5),(6,7),(7,2);
insert into album_genres(album_id, genre_id) VALUES (1,1),(1,2),(2,2),(2,4),
                                                    (2,5),(3,1),(4,4),(4,6),
                                                    (5,2),(5,4),(5,5),(6,7),(7,2);
insert into  fans(fan_id,login_fan, name_fan) values (1,'Влад','Влад'),(2,'Артём','Артём'),(3,'Ростислав','Ростислав'),(4,'GOD','Влад');
insert into  fans_follows(fan_id,artist_id) values (1,2),(1,3),(2,2),(2,1),(3,4),(4,5);


ALTER TABLE artists ENABLE ROW LEVEL SECURITY;
ALTER TABLE albums ENABLE  ROW LEVEL SECURITY;
ALTER TABLE fans ENABLE  ROW LEVEL SECURITY;
ALTER TABLE genres ENABLE  ROW LEVEL SECURITY;


CREATE USER administrator WITH LOGIN PASSWORD '1';
CREATE USER fan WITH LOGIN PASSWORD '2';
CREATE USER artist WITH LOGIN PASSWORD '3';

GRANT SELECT ON role, fans,albums,genres TO fan;
grant select(artist_name) on artists to fan;
GRANT update ON fans TO fan;

create role Артём login ;
grant fan to Артём;
CREATE  POLICY update_fans
  ON fans
  for update to fan using (fan_id in(select id_role from role where name_role = user));

CREATE  POLICY fans_fans
  ON fans
  for select using (true);
CREATE  POLICY fans_artist
  ON artists
  for select using (true);
CREATE  POLICY fans_albums
  ON albums
  for select using (true);
CREATE  POLICY fans_genres
  ON genres
  for select using (true);



select "current_user"();
set role Артём;
select "current_user"();

select *from fans,albums,genres;
select *from artists;
select (artist_name) from artists;
update artists set  artist_name = 'бог вселенной' where artist_name='TWRP';
select (artist_name) from artists;
update fans set name_fan = 'Игорь';
select *from fans;

set role postgres;



GRANT SELECT  ON artists,albums,genres TO artist;
GRANT update ON artists,albums TO artist;
GRANT SELECT(login_fan) on fans to artist ;
grant  delete on artists to artist;
grant select on role to  artist;


create role "Luz" login ;
grant artist to "Luz";

CREATE  POLICY del_art
  ON artists
  for delete to artist using (artist_id in(select  id_role from role where name_role = user));
CREATE  POLICY del_album
  ON albums
  for delete to artist using (artist_id in(select  id_role from role where name_role = user));

CREATE  POLICY update_artist
  ON artists
  for update to artist using (artist_id in(select  id_role from role where name_role = user));
CREATE  POLICY update_albums
  ON albums
  for update to artist using (artist_id in (select id_role from role where name_role = user));

CREATE  POLICY fans_artist
  ON fans
  for select using (true);
CREATE  POLICY artist_artist
  ON artists
  for select using (true);
CREATE  POLICY artist_albums
  ON albums
  for select using (true);
CREATE  POLICY artist_genres
  ON genres
  for select using (true);



select "current_user"();
set role "Luz";
select "current_user"();

select * from artists,albums,genres;
select * from fans;
select login_fan from fans;
select title from albums;
update artists set artist_name = 'bow';
select * from artists;

delete from artists ;
select * from artists;
select * from albums;



set role postgres;



grant all  on artists,fans,albums,genres,artists_albums,fans_follows,album_genres to administrator;

create role admin login ;
grant administrator to admin;

CREATE  POLICY admin
    ON artists
    to administrator
    using (true) with check (true);
CREATE  POLICY admin2
    ON fans
    to administrator
    using (true) with check (true);
CREATE  POLICY admin3
    ON albums
    to administrator
    using (true) with check (true);
CREATE  POLICY admin4
    ON genres
    to administrator
    using (true) with check (true);
CREATE  POLICY admin5
    ON artists_albums
    to administrator
    using (true) with check (true);
CREATE  POLICY admin6
    ON fans_follows
    to administrator
    using (true) with check (true);
CREATE  POLICY admin7
    ON album_genres
    to administrator
    using (true) with check (true);

select "current_user"();
set role admin;
select "current_user"();

drop database postgres ;



select * from fans;
DELETE FROM fans;
select *
from fans;
select * from artists;
delete from artists;
select * from artists;
select * from   albums;
insert  into  artists(artist_id, artist_name, pay) values (25,'линда ', 4500);
select * from  artists;













































set role postgres;
drop user Артём;
drop user "Luz";
drop user admin;


drop table artists_albums;
drop table album_genres;
drop table albums;
drop table fans_follows;
drop table fans;

drop table artists;
drop table genres;

drop user administrator;
drop table role;
drop user artist;
drop user fan;
