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

insert into Meals (mealId, name, price) values (8508, 'Caesar Salad', '$32.16');
insert into Meals (mealId, name, price) values (9312, 'House Salad', '$29.05');
insert into Meals (mealId, name, price) values (1895, 'Wedge Salad', '$31.17');
insert into Meals (mealId, name, price) values (3131, 'Crispy Chicken Salad', '$62.63');
insert into Meals (mealId, name, price) values (9967, 'Beet Salad', '$36.50');
insert into Meals (mealId, name, price) values (3779, 'Garden Salad', '$37.39');
insert into Meals (mealId, name, price) values (4335, 'Chicken Parmesan', '$18.70');
insert into Meals (mealId, name, price) values (1071, 'Eggplant Parmesan', '$21.85');
insert into Meals (mealId, name, price) values (6074, 'Chicken Wings', '$40.09');
insert into Meals (mealId, name, price) values (4591, 'Meatballs', '$55.59');
insert into Meals (mealId, name, price) values (3142, 'Spagetti and Meatballs', '$52.50');
insert into Meals (mealId, name, price) values (1329, 'Pesto Pasta', '$44.79');
insert into Meals (mealId, name, price) values (4792, 'Ragu Rigatoni', '$49.28');
insert into Meals (mealId, name, price) values (6755, 'Chicken Nuggets', '$62.26');
insert into Meals (mealId, name, price) values (7604, 'French Fries', '$13.42');
insert into Meals (mealId, name, price) values (1498, 'Steak Diane', '$55.49');
insert into Meals (mealId, name, price) values (7604, 'Hamburger', '$62.61');
insert into Meals (mealId, name, price) values (3588, 'Cheeseburger', '$63.95');
insert into Meals (mealId, name, price) values (6875, 'Artisan Burger', '$48.45');
insert into Meals (mealId, name, price) values (3845, 'Truffle Burger', '$43.75');
insert into Meals (mealId, name, price) values (9329, 'BLT', '$30.99');
insert into Meals (mealId, name, price) values (6585, 'Turkey Club', '$55.68');
insert into Meals (mealId, name, price) values (5887, 'Tuna Melt', '$28.31');
insert into Meals (mealId, name, price) values (7145, 'Meatball Sub', '$21.57');
insert into Meals (mealId, name, price) values (8570, 'Pasta Alfredo', '$12.28');
insert into Meals (mealId, name, price) values (1099, 'Mac And Cheese', '$66.66');
insert into Meals (mealId, name, price) values (2354, 'Ravioli with Meat Filling', '$70.96');
insert into Meals (mealId, name, price) values (3068, 'Ravioli with Spinch Filling', '$15.02');
insert into Meals (mealId, name, price) values (2574, 'Cheese Ravioli', '$65.42');
insert into Meals (mealId, name, price) values (3857, 'Pasta Carbonara', '$38.15');
insert into Meals (mealId, name, price) values (5732, '4 Cheese Pasta', '$44.41');
insert into Meals (mealId, name, price) values (6593, 'Caprese Salad', '$74.92');
insert into Meals (mealId, name, price) values (4680, 'Caprese Pasta', '$39.42');
insert into Meals (mealId, name, price) values (2749, 'Buffalo Chicken Wrap', '$31.81');
insert into Meals (mealId, name, price) values (1783, 'Buffalo Chicken Pasta', '$33.10');
insert into Meals (mealId, name, price) values (9724, 'Loaded French Fries', '$39.07');
insert into Meals (mealId, name, price) values (9870, 'Fried Zucchini', '$24.85');
insert into Meals (mealId, name, price) values (8725, 'Breadsticks', '$71.19');
insert into Meals (mealId, name, price) values (3699, 'Garlic Bread', '$67.73');
insert into Meals (mealId, name, price) values (9687, 'Cheese Plate', '$55.56');
insert into Meals (mealId, name, price) values (7861, 'Meat Plate', '$34.52');
insert into Meals (mealId, name, price) values (6702, 'Cheese and Meat Plate', '$18.69');
insert into Meals (mealId, name, price) values (3788, 'Chocolate Chip Cookie', '$54.33');
insert into Meals (mealId, name, price) values (4873, 'Sugar Cookie', '$45.32');
insert into Meals (mealId, name, price) values (2393, 'Double Chocolate Cookies', '$26.27');
insert into Meals (mealId, name, price) values (7223, 'Original Cheesecake', '$73.57');
insert into Meals (mealId, name, price) values (5426, 'Strawberry Cheesecake', '$57.39');
insert into Meals (mealId, name, price) values (2063, 'Oreo Cheesecake', '$69.67');
insert into Meals (mealId, name, price) values (6769, 'Chocolate Cheesecake', '$50.97');
insert into Meals (mealId, name, price) values (5729, 'Raspberry Cheesecake', '$35.00');
insert into Meals (mealId, name, price) values (2100, 'Caramel Cheesecake', '$29.86');
insert into Meals (mealId, name, price) values (2347, 'Lemon Cheesecake', '$33.42');
insert into Meals (mealId, name, price) values (8971, 'Blueberry Cheesecake', '$46.33');
insert into Meals (mealId, name, price) values (7808, 'Bistro Burger', '$20.01');
insert into Meals (mealId, name, price) values (5492, 'Cannoli', '$42.82');
insert into Meals (mealId, name, price) values (4286, 'Ice Cream Sundae', '$44.74');
insert into Meals (mealId, name, price) values (6102, 'Chocolate Cake', '$16.67');
insert into Meals (mealId, name, price) values (8041, 'Churro', '$31.18');
insert into Meals (mealId, name, price) values (1366, 'Brownies', '$52.13');
insert into Meals (mealId, name, price) values (1716, 'Cupcakes', '$65.94');

insert into Suppliers (supplierId, name) values ('2900', 'Jabberbean');
insert into Suppliers (supplierId, name) values ('8800', 'Zava');
insert into Suppliers (supplierId, name) values ('7048', 'Dynazzy');
insert into Suppliers (supplierId, name) values ('8873', 'Dablist');
insert into Suppliers (supplierId, name) values ('5616', 'Shufflebeat');
insert into Suppliers (supplierId, name) values ('6469', 'Quaxo');
insert into Suppliers (supplierId, name) values ('8342', 'Edgepulse');
insert into Suppliers (supplierId, name) values ('7999', 'Thoughtbeat');
insert into Suppliers (supplierId, name) values ('8709', 'Vipe');
insert into Suppliers (supplierId, name) values ('7610', 'Photojam');
insert into Suppliers (supplierId, name) values ('2743', 'Linkbridge');
insert into Suppliers (supplierId, name) values ('8676', 'Youspan');
insert into Suppliers (supplierId, name) values ('3009', 'Lazzy');
insert into Suppliers (supplierId, name) values ('8237', 'Meetz');
insert into Suppliers (supplierId, name) values ('1356', 'Edgeblab');
insert into Suppliers (supplierId, name) values ('3548', 'Gabtype');
insert into Suppliers (supplierId, name) values ('1418', 'Kare');
insert into Suppliers (supplierId, name) values ('8749', 'Yodoo');
insert into Suppliers (supplierId, name) values ('2591', 'Jetpulse');
insert into Suppliers (supplierId, name) values ('9086', 'Eadel');
insert into Suppliers (supplierId, name) values ('5117', 'Fivebridge');
insert into Suppliers (supplierId, name) values ('2924', 'Ntag');
insert into Suppliers (supplierId, name) values ('7381', 'Dazzlesphere');
insert into Suppliers (supplierId, name) values ('2460', 'Plambee');
insert into Suppliers (supplierId, name) values ('7485', 'Realbridge');
insert into Suppliers (supplierId, name) values ('4462', 'Yata');
insert into Suppliers (supplierId, name) values ('5719', 'Pixoboo');
insert into Suppliers (supplierId, name) values ('4539', 'Flashdog');
insert into Suppliers (supplierId, name) values ('3099', 'Tagcat');
insert into Suppliers (supplierId, name) values ('6584', 'Tagpad');
insert into Suppliers (supplierId, name) values ('8331', 'Yozio');
insert into Suppliers (supplierId, name) values ('3474', 'Trilith');
insert into Suppliers (supplierId, name) values ('8019', 'Bubblebox');
insert into Suppliers (supplierId, name) values ('6553', 'Quire');
insert into Suppliers (supplierId, name) values ('6217', 'Twinder');
insert into Suppliers (supplierId, name) values ('6135', 'Eire');
insert into Suppliers (supplierId, name) values ('7798', 'Jaxspan');
insert into Suppliers (supplierId, name) values ('3246', 'Jaxspan');
insert into Suppliers (supplierId, name) values ('4351', 'Lazz');
insert into Suppliers (supplierId, name) values ('3676', 'Zooxo');
insert into Suppliers (supplierId, name) values ('6014', 'Photojam');
insert into Suppliers (supplierId, name) values ('8476', 'Yabox');
insert into Suppliers (supplierId, name) values ('1918', 'Youspan');
insert into Suppliers (supplierId, name) values ('7460', 'Skiba');
insert into Suppliers (supplierId, name) values ('2854', 'Fadeo');
insert into Suppliers (supplierId, name) values ('6682', 'Skiba');
insert into Suppliers (supplierId, name) values ('9229', 'Quimm');
insert into Suppliers (supplierId, name) values ('8178', 'Vinder');
insert into Suppliers (supplierId, name) values ('1420', 'Blogtag');
insert into Suppliers (supplierId, name) values ('7144', 'Zoonoodle');
insert into Suppliers (supplierId, name) values ('6453', 'Tekfly');
insert into Suppliers (supplierId, name) values ('6752', 'Thoughtstorm');
insert into Suppliers (supplierId, name) values ('6351', 'Brainbox');
insert into Suppliers (supplierId, name) values ('9591', 'Livetube');
insert into Suppliers (supplierId, name) values ('8254', 'Mita');
insert into Suppliers (supplierId, name) values ('7762', 'Divanoodle');
insert into Suppliers (supplierId, name) values ('4436', 'Quatz');
insert into Suppliers (supplierId, name) values ('8330', 'Fiveclub');
insert into Suppliers (supplierId, name) values ('3157', 'Thoughtblab');
insert into Suppliers (supplierId, name) values ('3553', 'Flashpoint');
