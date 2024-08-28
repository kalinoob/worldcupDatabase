#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
"$($PSQL "TRUNCATE games,teams")"
echo -e "\nDatabase tables were truncated.\n"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#Insert teams, since names are uniques can't be duplicated with INSERT INTO
CHECK_W="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")"
CHECK_O="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")"
  if [[ $WINNER != 'winner' || $OPPONENT != 'opponent' ]]
  then
    if [[ -z $CHECK_W ]]
      then
      INSERT_WIN="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      #else
      #echo "$WINNER already exist."
    fi
    if [[ -z $CHECK_O ]]
      then
        INSERT_OPP="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      #else
      #  echo "$OPPONENT already exist."
    fi
  fi
done
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#insert year, winner_id,opponent_id,winner_goals,opponent_goals,round
if [[ $YEAR != 'year' ]]
  then
  WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"
  OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")"
  QUERY="$($PSQL "INSERT INTO games(year,winner_id,opponent_id,winner_goals,opponent_goals,round) VALUES($YEAR,$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS,'$ROUND');")"
fi
done