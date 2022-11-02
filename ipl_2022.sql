-- THIS IS A PROJECT TO ANALYZE IPL 2022 DATASET FROM KAGGLE
-- THE DATA HAS BEEN IMPORTED AS A CSV FILE INTO MYSQL AFTER CLEANING

-- TO FIND NO. OF MATCHES WON BY TOSS DECISION
SELECT 
    toss_decision, COUNT(winning_team)
FROM
    matches
GROUP BY toss_decision;

-- TO FIND NO. OF MATCHES WON WHILE DEFENDING & CHASING
select won_by, count(winning_team)
from matches
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
select winning_team, count(winning_team) as matches_won
from matches
group by winning_team
ORDER BY matches_won desc;

-- PLAYER WITH MOST MOTM AWARDS
select player_of_match, count(player_of_match) as most_motm_awards
from matches
group by player_of_match
order by most_motm_awards desc;

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

-- DISTRIBUTION OF MATCHES CITY WISE
select city, count(city) as no_of_matches_hosted
from matches
group by city
order by no_of_matches_hosted desc;

-- ANALYZING IMPACT OF TOSS ON MATCHES
select count(*) as matches_won_after_losing_toss
from matches
where toss_winner <> winning_team;

select count(*) as matches_won_after_winning_toss
from matches
where toss_winner = winning_team;

