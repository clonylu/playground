DELIMITER ;
create table Students(
  id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name varchar(255) not null,
  enabled tinyint(1) default 1,
  last_updated DATETIME not null);
create table Students_hist(
  id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  student_id int NOT NULL,
  name varchar(255) not null,
  enabled tinyint(1),
  last_updated DATETIME not null,
  action ENUM('insert','update','delete'),
  timestamp DATETIME not null);

DELIMITER //
create trigger playground_students_update_trigger BEFORE UPDATE ON Students
  FOR EACH ROW
  BEGIN
    set @ts = NOW();
    insert into Students_hist (student_id, name, enabled, last_updated, action, timestamp) values (NEW.id, NEW.name, NEW.enabled, NEW.last_updated, 'update', @ts);
    set NEW.last_updated=@ts;
  END//
create trigger playground_students_insert_trigger AFTER INSERT ON Students
    FOR EACH ROW
    BEGIN
      insert into Students_hist (student_id, name, enabled, last_updated, action, timestamp) values (NEW.id, NEW.name, NEW.enabled, NEW.last_updated, 'insert', NEW.last_updated);
    END//
DELIMITER ;


'TODO: disable row deletion
