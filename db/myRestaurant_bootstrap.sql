-- bootstrap file for MyRestaurant db -------------------
-- CS3200 Project Phase 2
-- 4/2/24

-- create db
create database myRestaurant;

-- grant webapp user (created with Docker Compose) all
-- privileges

# grant all privileges on myRestaurant.* to 'webapp'@'%';
# flush privileges;

-- move into created db
use myRestaurant;

-- create DDL
create table Tables (
    tableNum int primary key        not null,
    numSeats int                    not null,
    isReserved boolean              not null,
    fohId char(9)                   not null
);

create table Meals (
    mealId char(6) primary key      not null,
    name varchar(80)                not null,
    price int                       not null
);

create table Suppliers (
    supplierID char(9) primary key  not null,
    name varchar(80)                not null
);

create table BOH_emp (
    bohID char(9) primary key       not null,
    fName varchar(40)               not null,
    lName varchar(40)               not null,
    startTime datetime,
    endTime datetime,
    payRate int                     not null,
    bohSupervisorId char(9),
    foreign key (bohSupervisorId) references BOH_emp (bohId)
);

create table FOH_emp (
    fohId char(9) primary key       not null,
    fName varchar(40)               not null,
    lName varchar(40)               not null,
    startTime datetime,
    endTime datetime,
    payRate int                     not null,
    fohSupervisorId char(9),
    foreign key (fohSupervisorId) references FOH_emp (fohId)
);

create table Reservations (
    resID char(6) primary key       not null,
    numPeople int                   not null,
    phone varchar(20)               not null,
    fName varchar(40)               not null,
    lName varchar(40)               not null,
    tableNum int,
    foreign key (tableNum) references Tables (tableNum)
);

create table Ingredients (
    ingredientId char(8) primary key    not null,
    supply int                          not null,
    name varchar(80)                    not null,
    supplierID char(9),
    mealId char(6)                      not null,
    foreign key (supplierID) references Suppliers (supplierID),
    foreign key (mealId) references Meals (mealId)
);

create table SupplyOrder (
    supplyOrderId char(8) primary key   not null,
    ingredientId char(8)                not null,
    ordererId char(9)                   not null,
    foreign key (ingredientId) references Ingredients (ingredientId),
    foreign key (ordererId) references BOH_emp (bohID)
);

-- Bridge table for SupplierOrder-Ingredients relationship
create table SupplierOrder_Ingredients (
    supplyOrderId char(8),
    ingredientId char(8),
    primary key (supplyOrderId, ingredientId),
    foreign key (supplyOrderId) references SupplyOrder (supplyOrderId),
    foreign key (ingredientId) references Ingredients (ingredientId)
);

-- Bridge table for Meals-Ingredients relationship
create table Meals_Ingredients (
    mealId char(6),
    ingredientId char(8),
    primary key (mealId, ingredientId),
    foreign key (mealId) references Meals (mealId),
    foreign key (ingredientId) references Ingredients (ingredientId)
);

create table Orders (
    orderId char(6) primary key     not null,
    isComplete boolean              not null,
    tableNum int,
    mealId char(6),
    preparerId char(9)                   not null,
    foreign key (tableNum) references Tables (tableNum),
    foreign key (mealId) references Meals (mealId),
    foreign key (preparerId) references BOH_emp (bohID)
);

-- Bridge table for Orders-Meals relationship
create table Orders_Meals (
    orderId char(6),
    mealId char(6),
    primary key (orderId, mealId),
    foreign key (orderId) references Orders (orderId),
    foreign key (mealId) references Meals (mealId)
);

alter table FOH_emp
add constraint FK_FOHOrderTable
foreign key (fohId) references Tables (fohId);

alter table Tables
add constraint FK_TableFOHOrder
foreign key (fohId) references FOH_emp (fohId);

show tables;

-- inserting in random data

insert into Tables (tableNum, numSeats, isReserved, fohId) values (1, 4, true, '9102');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (2, 2, true, '6698');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (3, 8, false, '4140');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (4, 5, true, '7519');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (5, 2, false, '1452');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (6, 10, true, '6812');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (7, 10, false, '9434');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (8, 9, false, '1984');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (9, 4, true, '9666');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (10, 5, true, '2484');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (11, 1, false, '9496');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (12, 5, true, '7524');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (13, 7, true, '4410');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (14, 5, true, '4755');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (15, 8, false, '7831');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (16, 2, true, '7338');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (17, 2, true, '1944');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (18, 7, false, '7945');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (19, 7, true, '4006');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (20, 2, false, '9571');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (21, 2, false, '3087');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (22, 9, false, '9848');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (23, 2, true, '7835');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (24, 10, true, '1576');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (25, 4, false, '1464');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (26, 7, false, '1265');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (27, 1, false, '2254');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (28, 2, false, '7251');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (29, 3, false, '9322');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (30, 4, true, '2513');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (31, 6, true, '1157');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (32, 10, true, '5707');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (33, 5, false, '9577');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (34, 4, false, '5640');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (35, 6, false, '2418');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (36, 9, false, '8585');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (37, 5, true, '3016');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (38, 8, true, '9979');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (39, 7, true, '2807');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (40, 9, false, '9023');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (41, 4, true, '6038');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (42, 4, true, '9966');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (43, 2, false, '7192');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (44, 6, false, '5231');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (45, 6, false, '3188');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (46, 3, true, '3067');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (47, 10, true, '5030');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (48, 3, false, '5019');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (49, 4, false, '9238');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (50, 3, true, '6887');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (51, 9, true, '6789');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (52, 5, true, '6013');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (53, 4, true, '8893');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (54, 3, true, '6350');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (55, 2, false, '6446');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (56, 7, true, '7433');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (57, 7, false, '9601');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (58, 2, false, '4305');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (59, 6, true, '5639');
insert into Tables (tableNum, numSeats, isReserved, fohId) values (60, 6, true, '3926');
