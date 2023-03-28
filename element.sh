#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
fi

if [[ $1 ]]
then
#query database for atomic number if $1 is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number=$1;")
fi
#if not found set ATOMIC_NUMBER to null value
if [[ -z $GET_ATOMIC_NUMBER ]]
then
GET_ATOMIC_NUMBER=NULL
fi
#query database for name
GET_NAME=$($PSQL "SELECT name FROM elements FULL JOIN properties USING(atomic_number) WHERE name='$1';")
#query database for symbol
GET_SYMBOL=$($PSQL "SELECT symbol FROM elements FULL JOIN properties USING(atomic_number) WHERE symbol='$1';")
#update variables to get values for all
GET_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$GET_ATOMIC_NUMBER OR name='$GET_NAME' OR symbol='$GET_SYMBOL' ORDER BY atomic_number;")
GET_INFO_FORMATTED=$(echo $GET_INFO | sed 's/|/ | /g')
if [[ -z $GET_INFO ]]
then
echo "I could not find that element in the database."
else
echo $GET_INFO_FORMATTED | while read  ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
fi

#echo "I could not find that element in the database."
fi