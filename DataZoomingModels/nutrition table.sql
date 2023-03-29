CREATE TABLE daily_nutrition (
  day_id INT AUTO_INCREMENT ,
  nutrition_date DATEtime ,
  calories_consumed INT ,
  protein INT ,
  carbs INT ,
  fats INT, 
  PRIMARY KEY (day_id, nutrition_date)
);
drop table daily_nutrition;
insert into daily_nutrition ( nutrition_date ,calories_consumed , protein , carbs, fats )
values(sysdate(), 500, 41,71,34);
insert into daily_nutrition ( nutrition_date ,calories_consumed , protein , carbs, fats )
values(sysdate(), 1200, 91,51,65);
insert into daily_nutrition ( nutrition_date ,calories_consumed , protein , carbs, fats )
values(sysdate(), 300, 61,45,23);


select * from daily_nutrition;
select * from weekly_nutrition;


CREATE TABLE weekly_nutrition (
  week_id INT AUTO_INCREMENT,
  week_date DATE ,
  total_calories_consumed INT ,
  total_protein INT ,
  total_carbs INT,
  total_fats INT,
  PRIMARY KEY (week_id,week_date)
);
drop table weekly_nutrition;

CREATE TABLE monthly_nutrition (
  month_id INT AUTO_INCREMENT ,
  month_date DATE ,
  total_calories_consumed INT ,
  total_protein INT ,
  total_carbs INT,
  total_fats INT,
  PRIMARY KEY (month_id, month_date)
);
drop table monthly_nutrition;

CREATE TABLE yearly_nutrition (
  year_id INT AUTO_INCREMENT,
  year_date DATE ,
  total_calories_consumed INT ,
  total_protein INT ,
  total_carbs INT,
  total_fats INT,
  PRIMARY KEY (year_id, year_date)
);
drop table yearly_nutrition;

-- Trigger to move data from daily to weekly table:
delimiter //
CREATE TRIGGER daily_nutrition_trigger 
AFTER INSERT ON daily_nutrition
FOR EACH ROW
BEGIN
  INSERT INTO weekly_nutrition (week_date, total_calories_consumed, total_protein, total_carbs, total_fats) 
    SELECT DATE_FORMAT(nutrition_date,'%Y-%m-%u'), SUM(calories_consumed),SUM(protein),SUM(carbs), SUM(fats)
    FROM daily_nutrition
    WHERE nutrition_date BETWEEN DATE_SUB(NEW.nutrition_date, INTERVAL 7 DAY) AND NEW.nutrition_date
    GROUP BY DATE_FORMAT(nutrition_date, '%Y-%m-%u');
END;//
delimiter ;
drop trigger daily_nutrition_trigger;

-- Trigger to move data from weekly to monthly table:
delimiter //
CREATE TRIGGER weekly_nutrition_trigger
 AFTER INSERT ON weekly_nutrition
FOR EACH ROW
BEGIN
  INSERT INTO  monthly_nutrition (month_date, total_calories_consumed, total_protein, total_carbs, total_fats)
    SELECT DATE_FORMAT(week_date, '%Y-%m-%u'), SUM(total_calories_consumed), SUM(total_protein),SUM(total_carbs),SUM(total_fats)
    FROM weekly_nutrition
    WHERE week_date BETWEEN DATE_SUB(NEW.week_date, INTERVAL 31 DAY) AND NEW.week_date
    GROUP BY DATE_FORMAT(week_date, '%Y-%m-%u');
END;//
delimiter ;
-- Trigger to move data from monthly to yearly table:
delimiter //
CREATE TRIGGER monthly_nutrition_trigger
 AFTER INSERT ON monthly_nutrition
FOR EACH ROW
BEGIN
  INSERT INTO yearly_nutrition (year_date, total_calories_consumed, total_protein, total_carbs, total_fats)
    SELECT DATE_FORMAT(month_date, '%Y-%m-%u'), SUM(total_calories_consumed),SUM(total_protein),SUM(total_carbs), SUM(total_fats)
    FROM  monthly_nutrition
    WHERE month_date BETWEEN DATE_SUB(NEW.month_date, INTERVAL 12 MONTH) AND NEW.month_date
    GROUP BY DATE_FORMAT(month_date, '%Y-%m-%u');
END;//
delimiter ;