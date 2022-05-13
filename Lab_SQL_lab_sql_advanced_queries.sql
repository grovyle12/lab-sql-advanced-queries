
use sakila;
-- List each pair of actors that have worked together.

select c1.actor_id, actor.first_name, actor.last_name,c2.actor_id, actor.first_name, actor.last_name, c1.film_id
from film_actor as c1
join film_actor as c2
on c1.actor_id <> c2.actor_id
and c1.film_id = c1.film_id
join actor
on actor.actor_id = c1.actor_id;

-- For each film, list actor that has acted in more films.
with cte_gigs as
(
select film_id, actor_id, count(film_id) over (partition by actor_id) as actor_gigs
from film_actor
order by film_id, actor_gigs desc
)
select *, dense_rank() over (partition by film_id order by actor_gigs desc) as rank_
from cte_gigs
order by film_id, actor_gigs desc;
-----------------------------------------------------------------------------------------------------------------------------------

with cte_gigs as
(
select film_id, actor_id, count(film_id) over (partition by actor_id) as actor_gigs
from film_actor
order by film_id, actor_gigs desc
),
cte_rank_gigs as
(
select *, dense_rank() over (partition by film_id order by actor_gigs desc) as rank_
from cte_gigs
order by film_id, actor_gigs desc
)
select * from cte_rank_gigs
where rank_ = 1;

----------------------------
select film_id, actor_id, count(film_id) 
from film_actor
group by actor_id
order by film_id, count(film_id) desc;
-----------------------------------------------------------------------------------------------------------------------------------

with cte_gigs as
(
select film_id, actor_id, count(film_id) over (partition by actor_id) as actor_gigs
from film_actor
order by film_id, actor_gigs desc
),
cte_rank_gigs as
(
select *, dense_rank() over (partition by film_id order by actor_gigs desc) as rank_
from cte_gigs
order by film_id, actor_gigs desc
)
select cte_rank_gigs.film_id, cte_rank_gigs.actor_id, concat(actor.first_name,' ',actor.last_name) as sucessful_actor,cte_rank_gigs.rank_ 
from cte_rank_gigs
join actor
on actor.actor_id = cte_rank_gigs.actor_id
where rank_ = 1






