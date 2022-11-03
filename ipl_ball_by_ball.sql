use ipl_2022;
-- TOP 10 HIGHEST RUN SCORERS
SELECT batter, sum(batsman_run) as most_runs
from ball_by_ball
group by batter
order by most_runs desc
LIMIT 10;

-- TOP 10 HIGHEST WICKET TAKERS
select bowler, sum(isWicketDelivery) as wickets
from ball_by_ball
where kind <> 'run out'
group by bowler
order by wickets desc
limit 10;

-- NO. OF SIXES HIT IN THE SEASON
select count(batsman_run) as no_of_sixes
from ball_by_ball
where total_run = 6;

-- RUNS SCORED OF EXTRAS
select extra_type, sum(extras_run) as total_runs
from ball_by_ball
where extra_type <> 'NA'
group by extra_type
order by total_runs desc;

-- DISTRIBUTION OF DISMISSALS
select kind, count(kind) as no_of_dismissals
from ball_by_ball
where kind <> 'NA'
group by kind
order by no_of_dismissals desc;

-- PLAYERS WITH MOST CATCHES
select fielders_involved, count(fielders_involved) as most_catches
from ball_by_ball
where kind in ('caught','caught and bowled') and fielders_involved <> 'NA'
group by fielders_involved
order by most_catches desc;

-- TOTAL AND AVG RUNS SCORED BY EACH FRANCHISE
select battingteam, sum(total_run) as runs, 
CASE 
WHEN battingteam in ('Rajasthan Royals')
THEN round(sum(total_run)/17)
WHEN battingteam in ('Royal Challengers Bangalore','Gujarat Titans')
THEN round(sum(total_run)/16)
WHEN battingteam in ('Lucknow Super Giants')
THEN round(sum(total_run)/15)
ELSE
round(sum(total_run)/14)
END as AVG_TEAM_TOTAL
from ball_by_ball
group by battingteam
order by AVG_TEAM_TOTAL DESC;

-- AVG TOTAL AT EACH VENUE
select m.venue, sum(b.total_run) as total_runs_by_venue, count( distinct m.match_number) as no_of_matches_played, round(((sum(b.total_run)/2)/ count( distinct m.match_number))) as avg_total
from matches m
join ball_by_ball b 
on m.id = b.id
group by m.venue
order by avg_total desc;

-- TEAMS WITH THEIR AVERAGE POWERPLAY SCORE
CREATE view powerplay as
(select battingteam,
CASE 
WHEN battingteam in ( 'Rajasthan Royals')
THEN round(sum(total_run)/17)
WHEN battingteam in ( 'Royals Challengers Bangalore', 'Gujarat Titans')
THEN round(sum(total_run)/16)
WHEN  battingteam in ( 'Lucknow Super Giants')
THEN round(sum(total_run)/15)
ELSE
round(sum(total_run)/14)
END AS avg_powerplay_score
from ball_by_ball
where overs between 1 and 6
group by bapowerplayttingteam
order by avg_powerplay_score desc);

-- TEAMS WITH RUNS BETWEEN OVERS 16 AND 20
create view death_overs as (select battingteam,
CASE 
WHEN battingteam in ( 'Rajasthan Royals')
THEN round(sum(total_run)/17)
WHEN battingteam in ( 'Royals Challengers Bangalore', 'Gujarat Titans')
THEN round(sum(total_run)/16)
WHEN  battingteam in ( 'Lucknow Super Giants')
THEN round(sum(total_run)/15)
ELSE
round(sum(total_run)/14)
END AS avg_powerplay_score
from ball_by_ball
where overs between 15 and 20
group by battingteam
order by avg_powerplay_score desc);

-- TEAMS WITH RUNS BETWEEN OVERS 7 AND 15
create view middle_overs as (select battingteam,
CASE 
WHEN battingteam in ( 'Rajasthan Royals')
THEN round(sum(total_run)/17)
WHEN battingteam in ( 'Royals Challengers Bangalore', 'Gujarat Titans')
THEN round(sum(total_run)/16)
WHEN  battingteam in ( 'Lucknow Super Giants')
THEN round(sum(total_run)/15)
ELSE
round(sum(total_run)/14)
END AS avg_powerplay_score
from ball_by_ball
where overs between 7 and 15
group by battingteam
order by avg_powerplay_score desc);

-- RUNRATE DURING POWERPLAY
select battingteam,round((avg_powerplay_score/6),2) as run_rate
from powerplay
order by run_rate desc;

-- RUNRATE DURING DEATH OVERS
select battingteam,round((avg_powerplay_score/5),2) as run_rate
from death_overs
order by run_rate desc;

-- RUNRATE DURING MIDDLE OVERS
select battingteam,round((avg_powerplay_score/8),2) as run_rate
from middle_overs
order by run_rate desc;





