CREATE TABLE daily_sleep_data (
    sleep_id INT AUTO_INCREMENT,
    sleep_date DATEtime,
    REM_sleep int,
    Deep_sleep int,
     Hours_Slept int,
     Heart_rate int,
    sleep_score int,
    PRIMARY KEY (sleep_id, sleep_date)
    );
    drop table daily_sleep_data ;
insert into daily_sleep_data( sleep_date, REM_sleep, Deep_sleep, Hours_Slept, Heart_rate, sleep_score )
values(sysdate(), 21, 18, 7, 73, 89);
insert into daily_sleep_data( sleep_date ,REM_sleep, Deep_sleep, Hours_Slept, Heart_rate, sleep_score )
values(sysdate(), 15, 22, 9, 65, 90);
insert into daily_sleep_data( sleep_date, REM_sleep, Deep_sleep, Hours_Slept, Heart_rate, sleep_score )
values(sysdate(), 22, 25, 8, 75, 95);

select * from daily_sleep_data;
select * from weekly_sleep_data;



CREATE TABLE weekly_sleep_data (
    weekly_id INT AUTO_INCREMENT ,
	week_date DATE,
    avg_REM_sleep int,
    avg_Deep_sleep int,
	total_Hours_Slept int,
	avg_Heart_rate int,
    avg_sleep_score int,
PRIMARY KEY (weekly_id,week_date)	
);
 drop table weekly_sleep_data;


CREATE TABLE monthly_sleep_data (
   monthly_id INT AUTO_INCREMENT,
   month_date DATE,
   avg_REM_sleep int,
   avg_Deep_sleep int,
   total_Hours_Slept int,
	avg_Heart_rate int,
    avg_sleep_score int,
	PRIMARY KEY (monthly_id, month_date)
    
);
 drop table monthly_sleep_data;

CREATE TABLE yearly_sleep_data (
    yearly_id INT AUTO_INCREMENT ,
    year_date DATE,
    avg_REM_sleep int,
    avg_Deep_sleep int,
	total_Hours_Slept int,
	avg_Heart_rate int,
    avg_sleep_score int,
    PRIMARY KEY (yearly_id, year_date)
);
 drop table yearly_sleep_data ;

-- Trigger to move data from daily to weekly table:
delimiter //
CREATE TRIGGER daily_sleep_trigger
AFTER INSERT ON daily_sleep_data
FOR EACH ROW
BEGIN
  INSERT INTO weekly_sleep_data (week_date, avg_REM_sleep , avg_Deep_sleep , total_Hours_Slept , avg_Heart_rate ,avg_sleep_score)
    SELECT DATE_FORMAT(sleep_date,'%Y-%m-%u'),avg(rem_sleep),avg(deep_sleep), SUM(Hours_slept), avg(heart_rate),avg(sleep_score)
    FROM daily_sleep_data
    WHERE sleep_date BETWEEN DATE_SUB(NEW.sleep_date, INTERVAL 7 DAY) AND NEW.sleep_date
    GROUP BY DATE_FORMAT(sleep_date, '%Y-%m-%u');
END; //
delimiter ;
drop trigger daily_sleep_trigger;

-- Trigger to move data from weekly to monthly table:
delimiter //
CREATE TRIGGER weekly_sleep_trigger
 AFTER INSERT ON  weekly_sleep_data
FOR EACH ROW
BEGIN
  INSERT INTO monthly_sleep_data (month_date,avg_REM_sleep , avg_Deep_sleep , total_Hours_Slept , avg_Heart_rate ,avg_sleep_score )
    SELECT DATE_FORMAT(week_date, '%Y-%m-%u'), avg(rem_sleep),avg(deep_sleep), SUM(Hours_slept), avg(heart_rate),avg(sleep_score)
    FROM weekly_sleep_data
    WHERE week_date BETWEEN DATE_SUB(NEW.week_date, INTERVAL 31 DAY) AND NEW.week_date
    GROUP BY DATE_FORMAT(week_date, '%Y-%m-%u');
END;//
delimiter ;

-- Trigger to move data from monthly to yearly table:
delimiter //
CREATE TRIGGER monthly_sleep_trigger
 AFTER INSERT ON monthly_sleep_data
FOR EACH ROW
BEGIN
  INSERT INTO yearly_sleep_data  (year_date, avg_REM_sleep , avg_Deep_sleep , total_Hours_Slept , avg_Heart_rate ,avg_sleep_score )
    SELECT DATE_FORMAT(month_date, '%Y-%m-%u'), avg(rem_sleep),avg(deep_sleep), SUM(Hours_slept), avg(heart_rate),avg(sleep_score)
    FROM  monthly_sleep_data
    WHERE month_date BETWEEN DATE_SUB(NEW.month_date, INTERVAL 12 MONTH) AND NEW.month_date
    GROUP BY DATE_FORMAT(month_date, '%Y-%m-%u');
END;//
delimiter ;



