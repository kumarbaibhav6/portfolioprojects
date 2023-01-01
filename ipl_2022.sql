-- THIS IS A PROJECT TO ANALYZE IPL 2022 DATASET FROM KAGGLE
-- THE DATA HAS BEEN IMPORTED AS A CSV FILE INTO MYSQL AFTER CLEANING

use ipl_2022;
-- BASIC SELECT STAETEMENT TO VIEW THE DATASET
SELECT * 
FROM MATCHES;

-- TO FIND NO. OF INSTANCES OF FIELDING & BATTING AFTER WINNING TOSS
SELECT 
    toss_decision, COUNT(toss_decision) as count
FROM
    matches
GROUP BY toss_decision;

-- TO FIND NO. OF MATCHES WON WHILE DEFENDING & CHASING
select toss_decision, count(winning_team) as count_wins
from matches
where toss_winner=winning_team
group by toss_decision;

--  TO FIND NO. OF MATCHES LOST WHILE DEFENDING & CHASING
select won_by, count(winning_team) as loss_count
from matches
where toss_winner<>winning_team
group by won_by;

-- TO FIND HIGHEST MARGIN OF VICTORY WHILE DEFENDING
select team_1,team_2,winning_team, player_of_match, margin
from matches
where won_by = 'Runs' and margin = (select max(margin)
from matches
where  won_by = 'Runs');

-- TO FIND HIGHEST MARGIN OF VICTORY WHILE CHASING
select team_1,team_2,player_of_match, margin
from matches
where won_by = 'Wickets' and margin = (select max(margin)
from matches
where  won_by = 'Wickets');

---- TO FIND LOWEST MARGIN OF VICTORY WHILE DEFENDING
select team_1, team_2, winning_team, margin
from matches
where won_by = 'Runs' AND
margin = (select min(margin)
from matches
where won_by = 'Runs');

-- TO FIND LOWEST MARGIN OF VICTORY WHILE CHASING
select team_1, team_2, winning_team, margin
from matches
where won_by = 'Wickets' AND
margin = (select min(margin)
from matches
where won_by = 'Wickets');

-- NUMBER OF MATCHES WON BY EACH FRANCHISE
select winning_team, count(winning_team) as matches_won, dense_rank() OVER ( ORDER BY count(winning_team) DESC) as rank_team
from matches
group by winning_team
ORDER BY matches_won desc;

-- PLAYER WITH MOST MOTM AWARDS
select player_of_match, winning_team, count(player_of_match) as motm_awards
from matches
group by winning_team, player_of_match
order by motm_awards desc;

-- TEAMS WITH MOST WINS WHILE CHASING
select winning_team,count(winning_team) as matches_won_chasing
from matches
where won_by = 'Wickets'
group by winning_team
order by matches_won_chasing desc;

-- TEAMS WITH MOST WINS WHILE DEFENDING TOTALS
select winning_team,count(winning_team) as matches_won_defending
from matches
where won_by = 'Runs'
group by winning_team
order by matches_won_defending desc;

-- VENUES WITH MOST TOTALS CHASED
select venue, count(venue) as max_chased
from matches
where won_by = 'wickets'
group by venue
order by max_chased desc;

-- VENUES WITH MOST TOTALS DEFENDED
select venue, count(venue) as max_defended
from matches
where won_by = 'runs'
group by venue
order by max_defended desc;

-- TEAMS WITH MOST TOSSES WON
select toss_winner, count(toss_winner) as no_of_tosses_won
from matches
group by toss_winner
order by no_of_tosses_won desc;

-- DISTRIBUTION OF MATCHES VENUE WISE
select venue, count(venue) as no_of_matches_hosted
from matches
group by venue
order by no_of_matches_hosted desc;

-- ANALYZING IMPACT OF TOSS ON MATCHES
select count(*) as matches_won_after_losing_toss
from matches
where toss_winner <> winning_team;

select count(*) as matches_won_after_winning_toss
from matches
where toss_winner = winning_team;

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
group by battingteam
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
select battingteam, avg_powerplay_score,round((avg_powerplay_score/6),2) as run_rate, DENSE_RANK () OVER ( ORDER BY round((avg_powerplay_score/6),2) DESC) as rank_team
from powerplay
order by run_rate desc;

-- RUNRATE DURING DEATH OVERS
select battingteam,round((avg_powerplay_score/5),2) as run_rate, DENSE_RANK () OVER ( ORDER BY round((avg_powerplay_score/5),2) DESC) as rank_team
from death_overs
order by run_rate desc;

-- RUNRATE DURING MIDDLE OVERS
select battingteam,round((avg_powerplay_score/8),2) as run_rate, DENSE_RANK () OVER ( ORDER BY round((avg_powerplay_score/8),2) DESC) as rank_team
from middle_overs
order by run_rate desc;

-- TEAMS WITH MOST DOT BALLS
select battingteam, count(batsman_run) as no_of_dots
from ball_by_ball
where batsman_run = 0
group by battingteam
order by no_of_dots desc;

-- PLAYERS WITH MOST SIXES
select batter, count(batsman_run) as no_of_sixes
from ball_by_ball
where batsman_run = 6
group by batter 
order by no_of_sixes desc;

-- TO ANALYZE AVERAGE 1st INNINGS & 2nd INNINGS SCORE AT EVERY VENUE
-- WE WILL JOIN BOTH THE TABLES USING ID COLUMN & GET THE NECESSARY COLUMNS FOR ANALYSIS 
-- FURTHER, WE WILL USE AGGREGATE FUNCTIONS TO GET THE DESIRED RESULT
CREATE view stadium_1st_innings as (
select m.venue,
CASE 
WHEN venue = 'Wankhede Stadium, Mumbai'
THEN round(sum(b.total_run)/21)  -- HERE 21 DENOTES NO.OF MATCHES PLAYED AT THIS VENUE AND APPLIES TO OTHER VENUES TOO
WHEN venue = 'Dr DY Patil Sports Academy, Mumbai'
THEN round(sum(b.total_run)/20)
WHEN venue = 'Brabourne Stadium, Mumbai'
THEN round(sum(b.total_run)/16)
WHEN venue = 'Maharashtra Cricket Association Stadium, Pune'
THEN round(sum(b.total_run)/13)
WHEN venue in ('Eden Gardens, Kolkata', 'Narendra Modi Stadium, Ahmedabad')
THEN round(sum(b.total_run)/2)
END as avg_1st_innings_score
from matches m
join ball_by_ball b
on m.id=b.id
where b.innings = 1
group by m.venue
order by avg_1st_innings_score desc);

CREATE view stadium_2nd_innings as (
select m.venue,
CASE 
WHEN venue = 'Wankhede Stadium, Mumbai'
THEN round(sum(b.total_run)/21)  -- HERE 21 DENOTES NO.OF MATCHES PLAYED AT THIS VENUE AND APPLIES TO OTHER VENUES TOO
WHEN venue = 'Dr DY Patil Sports Academy, Mumbai'
THEN round(sum(b.total_run)/20)
WHEN venue = 'Brabourne Stadium, Mumbai'
THEN round(sum(b.total_run)/16)
WHEN venue = 'Maharashtra Cricket Association Stadium, Pune'
THEN round(sum(b.total_run)/13)
WHEN venue in ('Eden Gardens, Kolkata', 'Narendra Modi Stadium, Ahmedabad')
THEN round(sum(b.total_run)/2)
END as avg_2nd_innings_score
from matches m
join ball_by_ball b
on m.id=b.id
where b.innings = 2
group by m.venue
order by avg_2nd_innings_score desc);

-- SIDE BY SIDE ANALYSIS OF BOTH INNINGS BY VENUE USING VIEWS
SELECT s1.venue, s1.avg_1st_innings_score, s2.avg_2nd_innings_score
from stadium_1st_innings s1
join stadium_2nd_innings s2
on s1.venue = s2.venue;

CREATE TEMPORARY TABLE OVERS
SELECT bowler,count(ballnumber), round(count(ballnumber)/6) as num_overs
from ball_by_ball
where extra_type not in ('wides','noballs')   # WIDES AND NO BALLS ARE NOT COUNTED IN THE NO. OF LEGAL DELIEVERIES, HENCE, THEY ARE DISCARDED 
group by bowler
order by num_overs desc;

CREATE TEMPORARY TABLE RUNS_CONCEDED 
select bowler,sum(total_run) as runs_conceded
from ball_by_ball
where extra_type not in ('legbyes','byes')   # LEGBYES AND BYES ARE NOT ADDED TO THE BOWLER'S TOTAL 
GROUP by bowler
order by runs_conceded desc;

SELECT * FROM RUNS_CONCEDED;
select * from OVERS;

select o.bowler, r.runs_conceded, o.num_overs, round((r.runs_conceded/o.num_overs),2) as economy
from overs o 
join runs_conceded r
on o.bowler=r.bowler
where num_overs>=28   # WE TAKEN MIN OVERS BOWLED BY A BOWLER TO BE 28 OR MORE AS IT GIVES US A BETTER IDEA OF ECONOMY RATES IN THE LONG RUN
ORDER BY economy;

CREATE TEMPORARY TABLE BALLS_FACED
select batter, count(ballnumber) as balls_faced
from ball_by_ball
where extra_type != 'wides'                  # WIDES ARE NOT INCLUDED IN THE NO OF DELIVERIES FACED BY BATSMAN
group by batter
order by balls_faced desc;

create temporary table runs_scored
SELECT batter, sum(batsman_run) as most_runs
from ball_by_ball
group by batter
order by most_runs desc;

select * from BALLS_FACED;
select * from runs_scored;

select r.batter, r.most_runs, b.balls_faced, round((r.most_runs*100/b.balls_faced),2) as strike_rate 
from runs_scored r
join BALLS_FACED b
on r.batter = b.batter
where r.most_runs >=100  # WE HAVE TAKEN MIN RUNS SCORED AS 100 OR MORE TO GET A BETTER IDEA ABOUT STRIKE RATES 
order by strike_rate desc;

# lets check for top all rounders

CREATE TEMPORARY TABLE wickets 
select bowler, sum(isWicketDelivery) as wickets
from ball_by_ball
where kind <> 'run out'
group by bowler
order by wickets desc;

select r.batter, r.most_runs, w.wickets
from runs_scored r
join wickets w
on r.batter = w.bowler
where r.most_runs >=150 AND     # WE HAVE SET A LIMIT OF ATLEAST 150 RUNS AND MORE THAN 5 WICKETS
w.wickets >=5;