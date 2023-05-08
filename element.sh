#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


# 修改表
# $PSQL "alter table properties rename weight to atomic_mass;"
# $PSQL "alter table properties rename melting_point to melting_point_celsius;"
# $PSQL "alter table properties rename boiling_point to boiling_point_celsius;"
# $PSQL "alter table properties alter column melting_point_celsius set not null;"
# $PSQL "alter table properties alter column boiling_point_celsius set not null;"
# $PSQL "alter table elements add unique(symbol);"
# $PSQL "alter table elements add unique(name);"
# $PSQL "alter table elements alter column symbol set not null;"
# $PSQL "alter table elements alter column name set not null;"
# $PSQL "alter table properties add foreign key(atomic_number) references elements(atomic_number);"
# $PSQL "create table types();"
# $PSQL "alter table types add column type_id int primary key;"
# $PSQL "alter table types add column type varchar(50) not null;"
# $PSQL "insert into types(type_id,type) values(1,'nonmetal'),(2,'metal'),(3,'metalloid');"
# $PSQL "alter table properties add column type_id int references types(type_id);"
# $PSQL "update properties set type_id = 1 where type = 'nonmetal';"
# $PSQL "update properties set type_id = 2 where type = 'metal';"
# $PSQL "update properties set type_id = 3 where type = 'metalloid';"
# $PSQL "alter table properties alter column type_id set not null;"
# $PSQL "update elements set symbol = 'He' where symbol = 'he';"
# $PSQL "update elements set symbol = 'Li' where symbol = 'li';"
# $PSQL "update elements set symbol = 'Mt' where symbol = 'mT';"
# $PSQL "delete from elements where atomic_number = 1000;"
# $PSQL "delete from properties where atomic_number = 1000;"
# $PSQL "alter table properties alter column atomic_mass type decimal;"
# $PSQL "insert into elements(atomic_number,symbol,name) values(9,'F','Fluorine');"
# $PSQL "insert into elements(atomic_number,symbol,name) values(10,'Ne','Neon');"
# $PSQL "insert into properties(atomic_number,type,atomic_mass,type_id,melting_point_celsius,boiling_point_celsius) values(9,'nonmetal','18.998',1,-220,-188.1);"
# $PSQL "insert into properties(atomic_number,type,atomic_mass,type_id,melting_point_celsius,boiling_point_celsius) values(10,'nonmetal','20.18',1,-248.6,-246.1);"
# $PSQL "alter table properties drop column type;"


# cat ../atomic_mass.txt | while read NUMBER BAR MASS
# do
#   if [[ $NUMBER != 'atomic_number' ]]
#   then
#       $PSQL "update properties set atomic_mass = $MASS where atomic_number = $NUMBER"
#   fi
# done



if [[ $1 ]]
then 
  ELEMENT=$($PSQL "select type_id,atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements left join properties using(atomic_number) left join types using(type_id) where symbol = '$1' or name = '$1' or cast(atomic_number as varchar) = '$1';")
  
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING BOILING;
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
  
else
  echo "Please provide an element as an argument."
fi