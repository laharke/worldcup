#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  echo "year:$year"
  echo "round: $round"
  echo "winner: $winner"
  echo "opponent: $opponent"
  echo "winner_goals: $winner_goals"
  echo "winner_goals: $opponent_goals"
  echo ""
  # ---------------------------------------------------------------------------------------
  # insert teams
  # INSERT_GAMES_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
  # INSERT_GAMES_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
  # ---------------------------------------------------------------------------------------

  WINNER=$($PSQL "SELECT * FROM teams where name = '$winner'")
  if [[ $WINNER ]]
  then
    echo 'existe'
  else
    INSERT_GAMES_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
  fi
  
  OPPONENT=$($PSQL "SELECT * FROM teams where name = '$opponent'")
  if [[ $OPPONENT ]]
  then
    echo 'existe'
  else
    INSERT_GAMES_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
  fi

   # ---------------------------------------------------------------------------------------
  # insert games
  # WINNER_ID=$($PSQL "SELECT * FROM teams where name = '$winner'")
  # OPPONENT_ID=$($PSQL "SELECT * FROM teams where name = '$opponent'")
  # ---------------------------------------------------------------------------------------
  WINNER_ID=$($PSQL "SELECT team_id FROM teams where name = '$winner'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name = '$opponent'")

  INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$year', '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")



done < <(tail -n +2 games.csv)
