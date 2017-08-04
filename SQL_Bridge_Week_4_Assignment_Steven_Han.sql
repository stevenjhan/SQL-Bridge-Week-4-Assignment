/*
Steven Han - steven.han@nbcuni.com
Week 4 Assignment – Project: Building a Relational Database Management System

An organization grants key-card access to rooms based on groups that key-card holders belong to.
You may assume that users below to only one group. Your job is to design the database that supports the key-card system.

There are six users, and four groups.
- Modesto and Ayine are in group “I.T.”
- Christopher and Cheong woo are in group “Sales”.
- Saulat is in group “Administration.”
- Heidy is a new employee, who has not yet been assigned to any group.
- Group “Operations” currently doesn’t have any users assigned.

There are four rooms: “101”, “102”, “Auditorium A”, and “Auditorium B”.
- I.T. should be able to access Rooms 101 and 102.
- Sales should be able to access Rooms 102 and Auditorium A.
- Administration does not have access to any rooms.

After you determine the tables any relationships between the tables (One to many? Many to one? Many to many?), 
you should create the tables and populate them with the information indicated above.
*/

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS access;

# Create employees table with a reference to the groups table

CREATE TABLE employees
(
	employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    group_id VARCHAR(60) NULL REFERENCES groups(group_id)
);

INSERT INTO employees
(employee_name, group_id)
VALUES
('Modesto', 'STR-IT001'),
('Ayine', 'STR-IT001'),
('Christopher', 'PL-SL001'),
('Cheong Woo', 'PL-SL001'),
('Saulat', 'STR-AD001'),
('Heidy', NULL);

SELECT * FROM employees;

# Create groups table with no dependencies on other tables

CREATE TABLE groups
(
	group_id VARCHAR(30) NOT NULL PRIMARY KEY,
    group_name VARCHAR(60) NOT NULL
);

INSERT INTO groups
(group_id, group_name)
VALUES
('STR-AD001', 'Administration'),
('STR-IT001', 'IT'),
('STR-OPS001', 'Operations'),
('PL-SL001','Sales');

SELECT * FROM groups;

# Create room table with no dependencies on other tables

CREATE TABLE rooms
(
	room_id VARCHAR(30) PRIMARY KEY,
    room_name VARCHAR(60) NOT NULL
);

INSERT INTO rooms
(room_id, room_name)
VALUES
('rm101', '101'),
('rm102', '102'),
('audA', 'Auditorium A'),
('audB', 'Auditorium B');

SELECT * FROM rooms;

# Create access table which creates a many-to-many relation for the groups and rooms tables

CREATE TABLE access
(
	room_id VARCHAR(30) REFERENCES rooms(room_id),
    group_id VARCHAR(30) REFERENCES groups(group_id),
    CONSTRAINT access_key PRIMARY KEY (room_id, group_id)    
);

INSERT INTO access
(room_id, group_id)
VALUES
('rm101', 'STR-IT001'),
('rm102', 'STR-IT001'),
('rm101', 'PL-SL001'),
('audA', 'PL-SL001');

SELECT * FROM access;


# Next, write SELECT statements that provide the following information:
# All groups, and the users in each group. A group should appear even if there are no users assigned to the group.
 
SELECT
group_name AS `Group Name`,
IFNULL(employee_name, 'No employees') AS `Employee Name`

FROM groups
LEFT JOIN employees
ON groups.group_id = employees.group_id

ORDER BY `Group Name`, `Employee Name`;

# All rooms, and the groups assigned to each room. The rooms should appear even if no groups have been assigned to them.

SELECT
room_name AS `Room Name`,
IFNULL(group_name, 'No groups assigned') AS `Group Name`

FROM rooms
LEFT JOIN access
ON rooms.room_id = access.room_id
LEFT JOIN groups
ON access.group_id = groups.group_id

ORDER BY `Room Name`, `Group Name`;

# A list of users, the groups that they belong to, and the rooms to which they are assigned. This should be sorted alphabetically by user, then by group, then by room.

SELECT
employee_name AS `Employee Name`,
IFNULL(group_name, 'No groups assigned') AS `Group Name`,
IFNULL(room_name, 'No rooms assigned') AS `Room Name`

FROM employees
LEFT JOIN groups
ON employees.group_id = groups.group_id
LEFT JOIN access
ON groups.group_id = access.group_id
LEFT JOIN rooms
ON access.room_id = rooms.room_id

ORDER BY `Employee Name`, `Group Name`, `Room Name`;