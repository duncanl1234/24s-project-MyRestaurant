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
