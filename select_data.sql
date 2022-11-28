--количество исполнителей в каждом жанре;
select g.name, count(p.performer)
from performergenre p join genre g on p.genre = g.genre_id
group by g.name;

--количество треков, вошедших в альбомы 2019-2020 годов;
select a.name, count(t.name)
from album a join track t on a.album_id = t.album_id 
where a.year_of_issue between 2019 and 2020
group by a.name;

--средняя продолжительность треков по каждому альбому;
select a.name, avg(t.duration)
from album a join track t on a.album_id = t.album_id 
group by a.name

--все исполнители, которые не выпустили альбомы в 2020 году
select p.name
from performer p join performeralbum p2 on p.performer_id = p2.performer 
				join album a on p2.album = a.album_id 
where a.year_of_issue <> 2020;

--названия сборников, в которых присутствует конкретный исполнитель (выберите сами);
select c2.name n
from performer p join performeralbum p2 on p.performer_id = p2.performer 
				join album a on p2.album = a.album_id
				join track t on a.album_id = t.album_id 
				join collectiontrack c on t.track_id = c.track 
				join collection c2 on c.collection = c2.collection_id
where p.name = 'ДДТ'
group by n;

--название альбомов, в которых присутствуют исполнители более 1 жанра;
select a.name n
from genre g join performergenre p on g.genre_id = p.genre 
			join performer p2 on p.performer = p2.performer_id 
			join performeralbum p3 on p2.performer_id = p3.performer 
			join album a on p3.album = a.album_id 
group by n
having count(g.name) > 1; 

--наименование треков, которые не входят в сборники;
select name
from track
where track_id not in (select track from collectiontrack);

--исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);
select p.name n
from performer p join performeralbum p2 on p.performer_id = p2.performer 
				join album a on p2.album = a.album_id
				join track t on a.album_id = t.album_id 
where t.duration = (select min(duration) from track);

--название альбомов, содержащих наименьшее количество треков.
select a.name
from album a join track t on a.album_id = t.album_id 
group by a.name
having count(t.album_id) = (select min(kol_vo)
							from (select name, count(album_id) kol_vo
									from track
									group by name) as foo);
