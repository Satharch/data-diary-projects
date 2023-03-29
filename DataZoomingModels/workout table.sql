-- Daily Table:
CREATE TABLE michaels_daily_workout (
  workout_id INT auto_increment,
  workout_date DATEtime,
  workout_type VARCHAR(20),
  duration_minutes INT,
  calories_burned INT,
  PRIMARY KEY (workout_id, workout_date, workout_type)
);
-- Weekly Table:
CREATE TABLE michaels_weekly_workout (
weekly_id int auto_increment,
  week_date DATE,
  total_duration INT,
  total_calories INT,
  PRIMARY KEY (weekly_id,week_date)
);
-- Monthly Table:
CREATE TABLE michaels_monthly_workout (
monthly_id int auto_increment,
  month_date DATE,
  total_duration INT,
  total_calories INT,
  PRIMARY KEY (monthly_id, month_date)
);

CREATE TABLE michaels_yearly_workout (
  yearly_id INT AUTO_INCREMENT,
  year_date DATE,
  total_duration INT,
  total_calories INT,
  PRIMARY KEY (yearly_id, year_date)
);


-- Trigger to move data from daily to weekly table:
delimiter //
CREATE TRIGGER move_daily_to_weekly_trigger
AFTER INSERT ON michaels_daily_workout
FOR EACH ROW
BEGIN
  INSERT INTO michaels_weekly_workout (week_date, total_duration, total_calories)
    SELECT DATE_FORMAT(workout_date,'%Y-%m-%u'), SUM(duration_minutes), SUM(calories_burned)
    FROM michaels_daily_workout
    WHERE workout_date BETWEEN DATE_SUB(NEW.workout_date, INTERVAL 7 DAY) AND NEW.workout_date
    GROUP BY DATE_FORMAT(workout_date, '%Y-%m-%u');
END; //
delimiter ;

-- Trigger to move data from weekly to monthly table:
delimiter //
CREATE TRIGGER move_weekly_to_monthly_trigger
AFTER INSERT ON michaels_weekly_workout
FOR EACH ROW
BEGIN
  INSERT INTO michaels_monthly_workout (month_date, total_duration, total_calories)
    SELECT DATE_FORMAT(week_date, '%Y-%m-%u'), SUM(total_duration), SUM(total_calories)
    FROM michaels_weekly_workout
    WHERE week_date BETWEEN DATE_SUB(NEW.week_date, INTERVAL 31 DAY) AND NEW.week_date
    GROUP BY DATE_FORMAT(week_date, '%Y-%m-%u');
END;//
delimiter ;

-- Trigger to move data from monthly to yearly table:
delimiter //
CREATE TRIGGER move_monthly_to_yearly_trigger
AFTER INSERT ON michaels_monthly_workout
FOR EACH ROW
BEGIN
  INSERT INTO michaels_yearly_workout (year_date, total_duration, total_calories)
    SELECT DATE_FORMAT(month_date, '%Y-%m-%u'), SUM(total_duration), SUM(total_calories)
    FROM michaels_monthly_workout
    WHERE month_date BETWEEN DATE_SUB(NEW.month_date, INTERVAL 12 MONTH) AND NEW.month_date
    GROUP BY DATE_FORMAT(month_date, '%Y-%m-%u');
END;//
delimiter ;


insert into michaels_daily_workout( workout_date ,workout_type ,duration_minutes ,calories_burned )
values(sysdate(), "running", 50,140);
insert into michaels_daily_workout( workout_date ,workout_type ,duration_minutes ,calories_burned )
values(sysdate(), "cycling", 70,200);
insert into michaels_daily_workout( workout_date ,workout_type ,duration_minutes ,calories_burned )
values(sysdate(), "swimming", 80,250);
insert into michaels_daily_workout( workout_date ,workout_type ,duration_minutes ,calories_burned )
values(sysdate(), "treadmill", 80,250);




select * from michaels_daily_workout;
select * from michaels_weekly_workout;
