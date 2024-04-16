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

create table Tables (
    tableNum int primary key        not null,
    numSeats int                    not null,
    isReserved boolean              not null,
    fohId char(9)                   not null,
    foreign key (fohId) references FOH_emp (fohId)
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
create table Meal_Ingredients (
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

show tables;

-- inserting in random data
insert into Meals (mealId, name, price) values ('8508', 'Caesar Salad', 32.16);
insert into Meals (mealId, name, price) values ('9312', 'House Salad', 29.05);
insert into Meals (mealId, name, price) values ('1895', 'Wedge Salad', 31.17);
insert into Meals (mealId, name, price) values ('3131', 'Crispy Chicken Salad', 62.63);
insert into Meals (mealId, name, price) values ('9967', 'Beet Salad', 36.50);
insert into Meals (mealId, name, price) values ('3779', 'Garden Salad', 37.39);
insert into Meals (mealId, name, price) values ('4335', 'Chicken Parmesan', 18.70);
insert into Meals (mealId, name, price) values ('1071', 'Eggplant Parmesan', 21.85);
insert into Meals (mealId, name, price) values ('6074', 'Chicken Wings', 40.09);
insert into Meals (mealId, name, price) values ('4591', 'Meatballs', 55.59);
insert into Meals (mealId, name, price) values ('3142', 'Spagetti and Meatballs', 52.50);
insert into Meals (mealId, name, price) values ('1329', 'Pesto Pasta', 44.79);
insert into Meals (mealId, name, price) values ('4792', 'Ragu Rigatoni', 49.28);
insert into Meals (mealId, name, price) values ('6755', 'Chicken Nuggets', 62.26);
insert into Meals (mealId, name, price) values ('7604', 'French Fries', 13.42);
insert into Meals (mealId, name, price) values ('1498', 'Steak Diane', 55.49);
insert into Meals (mealId, name, price) values ('7601', 'Hamburger', 62.61);
insert into Meals (mealId, name, price) values ('3588', 'Cheeseburger', 63.95);
insert into Meals (mealId, name, price) values ('6875', 'Artisan Burger', 48.45);
insert into Meals (mealId, name, price) values ('3845', 'Truffle Burger', 43.75);
insert into Meals (mealId, name, price) values ('9329', 'BLT', 30.99);
insert into Meals (mealId, name, price) values ('6585', 'Turkey Club', 55.68);
insert into Meals (mealId, name, price) values ('5887', 'Tuna Melt', 28.31);
insert into Meals (mealId, name, price) values ('7145', 'Meatball Sub', 21.57);
insert into Meals (mealId, name, price) values ('8570', 'Pasta Alfredo', 12.28);
insert into Meals (mealId, name, price) values ('1099', 'Mac And Cheese', 66.66);
insert into Meals (mealId, name, price) values ('2354', 'Ravioli with Meat Filling', 70.96);
insert into Meals (mealId, name, price) values ('3068', 'Ravioli with Spinch Filling', 15.02);
insert into Meals (mealId, name, price) values ('2574', 'Cheese Ravioli', 65.42);
insert into Meals (mealId, name, price) values ('3857', 'Pasta Carbonara', 38.15);
insert into Meals (mealId, name, price) values ('5732', '4 Cheese Pasta', 44.41);
insert into Meals (mealId, name, price) values ('6593', 'Caprese Salad', 74.92);
insert into Meals (mealId, name, price) values ('4680', 'Caprese Pasta', 39.42);
insert into Meals (mealId, name, price) values ('2749', 'Buffalo Chicken Wrap', 31.81);
insert into Meals (mealId, name, price) values ('1783', 'Buffalo Chicken Pasta', 33.10);
insert into Meals (mealId, name, price) values ('9724', 'Loaded French Fries', 39.07);
insert into Meals (mealId, name, price) values ('9870', 'Fried Zucchini', 24.85);
insert into Meals (mealId, name, price) values ('8725', 'Breadsticks', 71.19);
insert into Meals (mealId, name, price) values ('3699', 'Garlic Bread', 67.73);
insert into Meals (mealId, name, price) values ('9687', 'Cheese Plate', 55.56);
insert into Meals (mealId, name, price) values ('7861', 'Meat Plate', 34.52);
insert into Meals (mealId, name, price) values ('6702', 'Cheese and Meat Plate', 18.69);
insert into Meals (mealId, name, price) values ('3788', 'Chocolate Chip Cookie', 54.33);
insert into Meals (mealId, name, price) values ('4873', 'Sugar Cookie', 45.32);
insert into Meals (mealId, name, price) values ('2393', 'Double Chocolate Cookies', 26.27);
insert into Meals (mealId, name, price) values ('7223', 'Original Cheesecake', 73.57);
insert into Meals (mealId, name, price) values ('5426', 'Strawberry Cheesecake', 57.39);
insert into Meals (mealId, name, price) values ('2063', 'Oreo Cheesecake', 69.67);
insert into Meals (mealId, name, price) values ('6769', 'Chocolate Cheesecake', 50.97);
insert into Meals (mealId, name, price) values ('5729', 'Raspberry Cheesecake', 35.00);
insert into Meals (mealId, name, price) values ('2100', 'Caramel Cheesecake', 29.86);
insert into Meals (mealId, name, price) values ('2347', 'Lemon Cheesecake', 33.42);
insert into Meals (mealId, name, price) values ('8971', 'Blueberry Cheesecake', 46.33);
insert into Meals (mealId, name, price) values ('7808', 'Bistro Burger', 20.01);
insert into Meals (mealId, name, price) values ('5492', 'Cannoli', 42.82);
insert into Meals (mealId, name, price) values ('4286', 'Ice Cream Sundae', 44.74);
insert into Meals (mealId, name, price) values ('6102', 'Chocolate Cake', 16.67);
insert into Meals (mealId, name, price) values ('8041', 'Churro', 31.18);
insert into Meals (mealId, name, price) values ('1366', 'Brownies', 52.13);
insert into Meals (mealId, name, price) values ('1716', 'Cupcakes', 65.94);

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

insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8857', 'Fleurette', 'Rosentholer', '6:41 AM', '7:24 AM', 23.87, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8632', 'Putnem', 'Noorwood', '2:47 AM', '2:08 AM', 15.94, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8167', 'Rochell', 'Dominey', '3:51 PM', '9:37 PM', 17.45, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('2377', 'Phedra', 'Liveing', '9:32 PM', '11:17 AM', 17.61, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('7882', 'Rich', 'Stewartson', '8:27 PM', '6:22 PM', 26.71, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1628', 'Aveline', 'Shanklin', '2:26 AM', '10:31 PM', 28.04, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('9628', 'Asia', 'Seeger', '2:26 PM', '9:10 PM', 17.84, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5776', 'Cicely', 'Boecke', '11:56 AM', '3:57 AM', 11.26, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('6711', 'Issie', 'Cromblehome', '4:40 AM', '4:14 AM', 17.98, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3139', 'Shannan', 'Raddenbury', '6:34 PM', '3:28 PM', 26.93, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8215', 'Minnie', 'Ipwell', '8:28 AM', '4:04 PM', 12.64, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4451', 'Celestine', 'Looker', '8:14 AM', '12:06 PM', 19.14, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8374', 'Jasun', 'Shill', '9:10 AM', '6:58 PM', 20.87, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3158', 'Adriano', 'Castan', '1:56 PM', '7:39 PM', 12.75, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5914', 'Tab', 'Manshaw', '11:52 AM', '6:06 PM', 13.52, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3613', 'Denys', 'Ghirardi', '12:11 PM', '2:21 AM', 26.99, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('6842', 'Billy', 'Spurdens', '9:49 AM', '2:49 PM', 27.05, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('6142', 'Concordia', 'Wiskar', '2:23 AM', '4:37 AM', 16.09, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('7873', 'Montague', 'Slite', '11:02 PM', '10:48 AM', 15.35, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5215', 'Caterina', 'Wilcher', '4:44 AM', '7:46 AM', 16.32, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('9702', 'Odo', 'Pindell', '7:02 PM', '10:48 PM', 13.18, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5480', 'Harv', 'Edsell', '3:56 PM', '4:44 AM', 11.55, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4111', 'Camellia', 'Becker', '6:44 AM', '5:21 PM', 19.13, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5490', 'Sterling', 'Belford', '5:59 PM', '1:05 AM', 16.39, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('6560', 'Thedric', 'Grummitt', '5:56 AM', '11:02 AM', 25.35, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4440', 'Verla', 'Bickerstasse', '10:47 PM', '9:22 AM', 22.28, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8036', 'Belita', 'Roscamp', '2:08 PM', '2:03 AM', 27.09, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1657', 'Cliff', 'Milleton', '9:16 AM', '1:13 AM', 10.62, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('6174', 'Freemon', 'Gillon', '8:07 AM', '4:27 PM', 22.48, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3863', 'Margie', 'Sunderland', '9:47 AM', '12:42 AM', 28.04, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8528', 'Gabbie', 'Le Clercq', '2:17 PM', '3:09 AM', 18.93, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('9736', 'Tanhya', 'Ead', '11:11 AM', '6:52 PM', 17.15, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1174', 'Caresse', 'Feavearyear', '11:31 AM', '7:29 PM', 22.63, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5539', 'Isabeau', 'Dickie', '9:57 PM', '12:32 PM', 29.22, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4577', 'Gar', 'Van Halle', '6:03 PM', '12:00 AM', 10.98, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3212', 'Jerrie', 'Burke', '2:24 PM', '6:37 AM', 21.38, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1320', 'Ivar', 'Mcimmie', '11:48 PM', '4:31 AM', 28.14, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4855', 'Lila', 'Rex', '3:58 PM', '6:27 AM', 14.27, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('9767', 'Violante', 'Colbrun', '5:58 AM', '6:46 AM', 26.28, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5343', 'Myrwyn', 'Malthus', '4:14 PM', '9:51 AM', 15.62, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('2704', 'Madelyn', 'Milton', '11:11 PM', '3:20 PM', 29.48, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3445', 'Pierce', 'Pheazey', '6:18 PM', '2:19 PM', 29.78, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3994', 'Renelle', 'Ferne', '12:44 AM', '2:45 AM', 14.70, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5217', 'Wallace', 'Kittel', '10:29 PM', '9:46 PM', 24.86, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1547', 'Fran', 'Wincer', '3:16 PM', '6:26 PM', 27.22, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('6060', 'Onfre', 'Battams', '8:33 PM', '1:25 AM', 11.67, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8641', 'Maryjo', 'Maynell', '12:20 PM', '6:55 AM', 18.17, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3433', 'Tiffani', 'Hardwidge', '9:00 PM', '7:12 PM', 17.31, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8200', 'Sheffy', 'Candelin', '8:55 PM', '11:02 PM', 13.55, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4432', 'Rafe', 'Blacklawe', '6:33 AM', '2:00 PM', 13.90, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1863', 'Guendolen', 'Grason', '6:47 AM', '4:51 PM', 22.70, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5468', 'Midge', 'Purrington', '3:57 PM', '12:38 PM', 28.81, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1075', 'Gerik', 'Siely', '6:36 AM', '4:23 AM', 17.44, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3374', 'Stormi', 'Lammers', '11:41 AM', '6:52 PM', 13.62, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8795', 'Chris', 'Burrus', '9:47 AM', '8:35 PM', 18.79, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1028', 'Mikey', 'Chasmar', '11:43 AM', '1:46 AM', 28.90, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1666', 'Chaddy', 'Kensy', '8:31 PM', '7:33 AM', 17.13, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5285', 'Gussie', 'Brigden', '2:14 PM', '5:47 PM', 18.93, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5095', 'Karney', 'Cattermull', '11:43 AM', '4:30 PM', 11.27, '8857');
insert into BOH_emp (bohID, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5622', 'Ashleigh', 'Deinhard', '9:11 PM', '4:05 AM', 12.23, '8857');

insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (2036, 'Leslie', 'Hauxwell', '10:38 AM', '3:36 PM', 25.32);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (9910, 'Daniel', 'Newbold', '3:04 PM', '10:31 PM', 18.33);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (7420, 'Hussein', 'Mushart', '3:21 PM', '4:07 PM', 10.63);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (2127, 'Rollin', 'Draxford', '11:57 PM', '5:18 AM', 21.26, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (7409, 'Sigismondo', 'Montacute', '9:01 PM', '8:15 PM', 14.62, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (2116, 'Jeanie', 'Gerant', '5:37 PM', '6:48 PM', 24.36, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (7374, 'Storm', 'Larret', '1:35 AM', '9:31 PM', 14.18, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (1363, 'Dale', 'D''Angeli', '12:03 PM', '12:02 AM', 29.26, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (9984, 'Alfreda', 'Andraud', '4:38 AM', '4:11 AM', 24.14, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (3288, 'Sascha', 'Yakobowitz', '6:56 PM', '9:40 AM', 11.96, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (8616, 'Philip', 'Keays', '12:57 AM', '10:05 PM', 10.26, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (1581, 'Levey', 'Duggen', '12:23 AM', '12:17 PM', 22.90, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (3091, 'Jere', 'Sharpless', '5:42 AM', '2:39 AM', 24.69, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5577, 'Sutton', 'Chander', '2:57 AM', '9:18 AM', 18.26, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (3376, 'Lane', 'Tiernan', '2:59 PM', '6:24 AM', 25.01, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (6241, 'Malachi', 'Bissell', '12:59 AM', '11:46 AM', 11.22, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (9566, 'Ericka', 'Rafferty', '2:32 PM', '7:40 AM', 22.80, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (6514, 'Bartie', 'Walkowski', '10:44 PM', '10:55 PM', 11.27, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5390, 'Adore', 'Postlethwaite', '8:19 PM', '3:04 AM', 22.13, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (4483, 'Jonah', 'Ormston', '5:35 PM', '3:29 PM', 20.78, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (9340, 'Isaiah', 'Stebbins', '7:25 AM', '3:51 AM', 28.22, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (1416, 'Basilius', 'Castaneda', '11:34 AM', '1:09 PM', 24.90, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5709, 'Evin', 'Campana', '9:08 AM', '5:25 PM', 18.37, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (1678, 'Paddy', 'Bastone', '11:25 PM', '2:49 PM', 22.09, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (4829, 'Kaiser', 'Orbon', '4:21 AM', '12:13 PM', 13.21, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (9564, 'Oneida', 'Ghent', '8:06 AM', '4:55 PM', 22.10, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (3675, 'Nicolas', 'Shelf', '12:06 AM', '3:36 PM', 18.14, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (1190, 'Myrtice', 'Cutcliffe', '12:35 AM', '3:33 PM', 15.89, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (2617, 'Almeda', 'Spyby', '5:48 AM', '1:28 PM', 8.26, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (8437, 'Beitris', 'Hanley', '4:44 AM', '2:20 AM', 18.59, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (8403, 'Karylin', 'Borlease', '10:13 AM', '1:15 AM', 14.37, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5684, 'Miguela', 'Ellam', '9:25 PM', '3:30 AM', 16.58, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (9206, 'Cass', 'Westlake', '2:59 AM', '1:01 PM', 13.25, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (6012, 'Corabella', 'Currum', '8:32 AM', '2:51 PM', 29.66, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (7811, 'Ryon', 'Entissle', '1:00 AM', '1:14 AM', 26.33, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (2294, 'Florrie', 'Matyasik', '9:47 PM', '11:46 PM', 18.10, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (4621, 'Greg', 'Tooley', '10:22 AM', '11:14 PM', 17.61, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5130, 'Bertram', 'Skitt', '12:35 AM', '12:10 AM', 23.11, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5013, 'Sallyanne', 'Maplesden', '10:40 AM', '6:56 PM', 23.18, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (8856, 'Mitch', 'McGowing', '2:04 AM', '6:15 AM', 16.43, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (6956, 'Lorain', 'Atyea', '10:39 AM', '6:45 AM', 29.52, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (2698, 'Jervis', 'Blackall', '5:48 PM', '5:14 PM', 26.32, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (1992, 'Emily', 'Zorzutti', '4:40 AM', '12:53 PM', 22.32, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (2835, 'Tades', 'Grace', '8:30 PM', '1:57 PM', 20.08, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5311, 'Faye', 'Van', '10:16 PM', '3:13 PM', 29.59, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (2205, 'Sena', 'Sandison', '2:59 AM', '4:47 AM', 29.61, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (3532, 'Derrick', 'Orrell', '6:37 PM', '6:31 PM', 16.31, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5722, 'Ethyl', 'Briamo', '10:28 PM', '2:03 PM', 15.78, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (7016, 'Kit', 'Pouck', '1:14 AM', '3:52 PM', 24.06, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (4063, 'Elfie', 'Moyne', '11:18 AM', '4:40 AM', 18.64, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (1573, 'Veronica', 'Ewence', '11:50 PM', '7:22 PM', 18.82, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5720, 'Claudian', 'Probetts', '9:02 AM', '1:29 AM', 11.30, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (9756, 'Teirtza', 'Ingreda', '12:55 PM', '12:13 AM', 26.11, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (1446, 'Ernie', 'McGrowther', '4:45 AM', '12:26 PM', 14.16, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (4254, 'Rafaela', 'Naris', '10:32 AM', '12:24 PM', 20.29, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (2633, 'Hartwell', 'Coppeard', '1:59 PM', '4:07 PM', 22.50, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5396, 'Tedra', 'Skain', '8:07 AM', '7:45 AM', 20.97, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (5390, 'Duffie', 'Daoust', '1:41 AM', '5:03 AM', 10.16, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (9709, 'Marlena', 'Milesop', '11:46 AM', '7:16 AM', 24.36, 2036);
insert into FOH_emp (fohID, fName, lName, startTime, endTime, payRate, fohSupervisorId) values (6917, 'Dedie', 'O''Dogherty', '12:36 AM', '2:13 AM', 26.83, 2036);

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

insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('3346', 18, '988-623-4940', 'Rufe', 'Grunson', 15);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('2645', 17, '574-843-7060', 'Ailis', 'Lorant', 46);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('2950', 10, '277-228-4322', 'Marjorie', 'Vittori', 52);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('6229', 5, '107-385-9320', 'Charmain', 'Spradbrow', 44);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1225', 18, '310-171-8435', 'Remy', 'Brittian', 26);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('3755', 14, '888-766-1913', 'Monica', 'Toyer', 31);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('9674', 14, '704-255-2587', 'Gaylene', 'Randlesome', 48);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('9695', 13, '944-356-1024', 'Lothario', 'Caven', 60);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('4908', 7, '226-199-4158', 'Buddie', 'Lamplugh', 60);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('8715', 13, '116-784-0559', 'Alli', 'Doggett', 32);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('5279', 15, '541-920-6643', 'Janessa', 'Devo', 39);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1815', 18, '677-178-1620', 'Eve', 'Luney', 33);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('4637', 16, '926-169-7939', 'Marietta', 'McQuilty', 22);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('8253', 11, '893-392-4744', 'Ivory', 'Whaley', 59);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('7766', 19, '853-595-7095', 'Reeba', 'Lansly', 15);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('4612', 8, '806-301-3506', 'Jacquetta', 'Cholerton', 32);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1539', 6, '737-621-6785', 'Gay', 'Pehrsson', 10);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('3723', 17, '656-380-7494', 'Godiva', 'Traut', 13);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('3749', 15, '690-896-7389', 'Randall', 'Studman', 51);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('9238', 18, '905-795-0834', 'Elsbeth', 'Dryden', 24);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('7700', 11, '398-715-7444', 'Robinia', 'Krzysztof', 16);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('2863', 15, '337-565-4251', 'Gloriana', 'Clare', 11);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('9046', 10, '228-798-7720', 'Nathan', 'MacDonough', 38);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('3963', 15, '942-810-8917', 'Thorn', 'Sherrock', 48);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('5128', 2, '201-867-0499', 'Ferguson', 'Bande', 26);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('5607', 16, '483-326-2323', 'Andy', 'Doerr', 45);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('8498', 18, '507-775-9440', 'Claudie', 'Yockney', 1);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1557', 9, '268-803-0516', 'Chrystal', 'Frapwell', 44);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('6892', 5, '812-811-5830', 'Godiva', 'Spreadbury', 44);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('8337', 10, '283-521-1133', 'Phyllys', 'Gibard', 56);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('2030', 4, '973-558-4539', 'Hillel', 'McDell', 51);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1355', 20, '912-203-4223', 'Sidoney', 'Gurery', 37);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('3955', 20, '793-977-4406', 'Skippy', 'Leadbetter', 19);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('4544', 3, '772-887-2912', 'Cyndi', 'Westby', 33);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('9412', 4, '430-136-7702', 'Toni', 'Meadows', 15);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1068', 10, '641-301-7128', 'Thane', 'Hamlington', 27);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('6856', 18, '643-924-9461', 'Constancy', 'Fairey', 55);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1004', 10, '375-223-7634', 'Dody', 'Plitz', 40);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('5877', 14, '719-355-4352', 'Dodi', 'Pennoni', 60);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1955', 6, '515-237-0145', 'Carina', 'Dudmesh', 29);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('8359', 12, '408-575-2438', 'Theobald', 'Derrington', 54);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1499', 15, '513-177-9902', 'Micky', 'Scamadine', 46);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('2227', 14, '456-525-6256', 'Antonella', 'Pantling', 14);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('2633', 20, '233-384-9381', 'Norbert', 'Maxsted', 2);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('2119', 9, '294-316-0540', 'Winna', 'Woodhouse', 5);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1518', 13, '606-485-7524', 'Gregor', 'Mulvenna', 48);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('7843', 18, '368-958-0874', 'Kellia', 'Sharnock', 14);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('5998', 5, '454-501-5007', 'Kitti', 'Flement', 17);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('6384', 17, '605-256-3118', 'Jacqui', 'Hanney', 43);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('5432', 7, '226-907-9183', 'Jock', 'Mozzetti', 27);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('9178', 10, '661-447-8101', 'Annecorinne', 'Petrou', 58);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('8157', 11, '775-757-1194', 'Florry', 'Deppe', 51);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1231', 20, '446-591-6361', 'Vale', 'Rushworth', 38);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1072', 8, '171-431-7727', 'Nadean', 'Helsdon', 20);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('5699', 12, '200-727-7684', 'Cati', 'Ricciardelli', 33);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('1334', 9, '873-586-6624', 'Danice', 'Jerger', 47);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('5110', 12, '158-237-7007', 'Thebault', 'Choake', 48);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('2840', 10, '511-330-4179', 'Wendall', 'Jori', 21);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('9491', 2, '137-707-8005', 'Zorina', 'Domone', 50);
insert into Reservations (resID, numPeople, phone, fName, lName, tableNum) values ('2521', 17, '983-813-8264', 'Morty', 'Padrick', 17);

insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('2408', 158, 'Catfish - Fillets', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('5201', 131, 'Squash - Acorn', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('8865', 85, 'Wine - Two Oceans Cabernet', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('2013', 73, 'Pepper - Jalapeno', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1958', 82, 'Pie Shells 10', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('6838', 108, 'Almonds Ground Blanched', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('9240', 103, 'Wine - Remy Pannier Rose', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('2350', 10, 'Potatoes - Mini Red', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('4401', 134, 'Asparagus - Mexican', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('9163', 60, 'Corn - On The Cob', '7048', '8508');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1150', 170, 'Basil - Seedlings Cookstown', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('3585', 68, 'Pork - Sausage Casing', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('6870', 112, 'Pasta - Gnocchi, Potato', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1418', 69, 'Lobster - Canned Premium', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('2854', 37, 'Ocean Spray - Ruby Red', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1528', 69, 'Mushroom - Morels, Dry', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('8492', 191, 'Shrimp - Black Tiger 13/15', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('3811', 99, 'Milkettes - 2%', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('4283', 111, 'Bread - Sour Batard', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('9846', 123, 'Almonds Ground Blanched', '6351', '1329');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('5856', 82, 'Ecolab - Medallion', '6351', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('3183', 39, 'Ecolab - Hobart Upr Prewash Arm', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('4952', 141, 'Tomato - Peeled Italian Canned', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1663', 48, 'Mix Pina Colada', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('8207', 95, 'Oil - Shortening - All - Purpose', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('6478', 105, 'Dawn Professionl Pot And Pan', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('2552', 51, 'Chambord Royal', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('9548', 115, 'Magnotta Bel Paese Red', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('6800', 40, 'Cookie Dough - Chocolate Chip', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('5771', 32, 'Wine - Cahors Ac 2000, Clos', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('9577', 170, 'Veal - Brisket, Provimi, Bone - In', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('7190', 164, 'Chicken - Whole', '6453', '1071');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('8242', 69, 'Olive - Spread Tapenade', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('2019', 133, 'Juice - Orange, Concentrate', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('5861', 133, 'Beans - Butter Lrg Lima', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('4162', 112, 'Sour Puss Sour Apple', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('6298', 146, 'Peas - Frozen', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('4443', 51, 'Soup - Boston Clam Chowder', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('7039', 12, 'Lettuce - Boston Bib', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('8689', 47, 'Shrimp - Black Tiger 16/20', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1964', 169, 'Pork Ham Prager', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('9009', 40, 'Chocolate - Feathers', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1422', 134, 'Nantucket Pine Orangebanana', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('3851', 89, 'Bread - Focaccia Quarter', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('7048', 121, 'Grapes - Green', '6682', '3588');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('8558', 118, 'Curry Powder Madras', '6682', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1813', 27, 'Avocado', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('5782', 28, 'Sugar - Sweet N Low, Individual', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('7095', 191, 'Flavouring Vanilla Artificial', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('8157', 160, 'Bag Clear 10 Lb', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1672', 150, 'Appetizer - Escargot Puff', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('1565', 75, 'Wine - Red, Cooking', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('2462', 84, 'Chinese Foods - Pepper Beef', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('5316', 19, 'Carrots - Purple, Organic', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('7787', 2, 'Wine - Acient Coast Caberne', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('4774', 188, 'Foam Tray S2', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('7217', 168, 'Squash - Butternut', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('5918', 147, 'Mushroom - Porcini Frozen', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('2962', 55, 'Eggplant Oriental', '2854', '5732');
insert into Ingredients (ingredientId, supply, name, supplierID, mealId) values ('9683', 74, 'Wanton Wrap', '2854', '5732');

insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6186', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('2524', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6090', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('2711', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('8632', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('3548', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6089', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('3461', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('8005', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('3794', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('5410', '2408', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('2713', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('5701', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('8881', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('4309', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6062', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9976', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('8542', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9734', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6988', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9399', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('1981', '5201', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9790', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('1021', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9655', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('5489', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('3052', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('1423', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6042', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9836', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6581', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('3109', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('7673', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9415', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9605', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('1166', '8865', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('1883', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6478', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('5196', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('1582', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('1190', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('3012', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('3507', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('5865', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6704', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('2881', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9496', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('2911', '2013', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('7470', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('3199', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('3752', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('4220', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('5669', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('4395', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('1349', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('9064', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6594', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('6150', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('2590', '1958', '8857');
insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ('4948', '1958', '8857');

insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6186', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('2524', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6090', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('2711', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('8632', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('3548', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6089', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('3461', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('8005', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('3794', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('5410', '2408');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('2713', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('5701', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('8881', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('4309', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6062', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9976', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('8542', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9734', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6988', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9399', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('1981', '5201');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9790', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('1021', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9655', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('5489', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('3052', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('1423', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6042', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9836', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6581', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('3109', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('7673', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9415', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9605', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('1166', '8865');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('1883', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6478', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('5196', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('1582', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('1190', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('3012', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('3507', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('5865', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6704', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('2881', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9496', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('2911', '2013');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('7470', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('3199', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('3752', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('4220', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('5669', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('4395', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('1349', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('9064', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6594', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('6150', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('2590', '1958');
insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ('4948', '1958');

insert into Meal_Ingredients (ingredientId, mealId) values ('2408','8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('5201','8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('8865','8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('2013','8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('1958','8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('6838','8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('9240', '8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('2350','8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('4401','8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('9163', '8508');
insert into Meal_Ingredients (ingredientId, mealId) values ('1150','1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('3585','1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('6870', '1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('1418','1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('2854', '1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('1528', '1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('8492','1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('3811', '1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('4283', '1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('9846', '1329');
insert into Meal_Ingredients (ingredientId, mealId) values ('5856', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('3183', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('4952', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('1663', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('8207', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('6478', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('2552',  '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('9548','1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('6800', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('5771', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('9577', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('7190', '1071');
insert into Meal_Ingredients (ingredientId, mealId) values ('8242', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('2019', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('5861', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('4162', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('6298', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('4443',  '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('7039', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('8689', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('1964', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('9009', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('1422', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('3851', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('7048', '3588');
insert into Meal_Ingredients (ingredientId, mealId) values ('8558', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('1813','5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('5782', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('7095','5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('8157', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('1672', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('1565', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('2462', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('5316', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('7787','5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('4774', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('7217', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('5918',  '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('2962', '5732');
insert into Meal_Ingredients (ingredientId, mealId) values ('9683', '5732');

insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6923', true, 1, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('1006', false, 2, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6023', true, 3, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('2010', false, 4, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('1101', false, 5, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6827', true, 6, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6443', true, 7, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('4972', false, 8, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('3537', false, 9, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('2197', true, 10, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('7077', true, 11, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('1814', false, 12, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('3913', true, 13, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('8293', false, 14, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('3863', true, 15, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('8970', true, 16, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('8375', true, 17, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('2727', false, 18, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('2971', false, 19, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6128', false, 20, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('4821', false, 21, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6213', false, 22, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6145', true, 23, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('7076', false, 24, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('1716', true, 25, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('9070', false, 26, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6818', false, 27, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('5693', true, 28, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('9512', true, 29, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6318', false, 30, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('8777', false, 31, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('7692', true, 32, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6953', false, 33, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('5419', false, 34, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('2099', true, 35, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('7784', true, 36, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('3879', false, 37, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('5899', true, 38, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('1730', true, 39, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('5743', true, 40, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('3512', true, 41, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('8548', false, 42, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('3278', false, 43, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('8116', true, 44, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('2777', true, 45, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('5101', false, 46, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('4674', true, 47, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('1452', true, 48, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('5455', true, 49, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('5620', false, 50, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('2954', false, 51, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('6018', true, 52, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('7763', false, 53, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('3731', false, 54, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('3080', true, 55, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('9101', true, 56, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('5580', true, 57, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('1663', true, 58, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('7131', false, 59, '8508', '8857');
insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ('5128', true, 60, '8508', '8857');

insert into Orders_Meals (orderId, mealId) values ('6923','8508');
insert into Orders_Meals (orderId, mealId) values ('1006','8508');
insert into Orders_Meals (orderId, mealId) values ('6023', '8508');
insert into Orders_Meals (orderId, mealId) values ('2010', '8508');
insert into Orders_Meals (orderId, mealId) values ('1101','8508');
insert into Orders_Meals (orderId, mealId) values ('6827','8508');
insert into Orders_Meals (orderId, mealId) values ('6443','8508');
insert into Orders_Meals (orderId, mealId) values ('4972','8508');
insert into Orders_Meals (orderId, mealId) values ('3537','8508');
insert into Orders_Meals (orderId, mealId) values ('2197','8508');
insert into Orders_Meals (orderId, mealId) values ('7077','8508');
insert into Orders_Meals (orderId, mealId) values ('1814','8508');
insert into Orders_Meals (orderId, mealId) values ('3913', '8508');
insert into Orders_Meals (orderId, mealId) values ('8293','8508');
insert into Orders_Meals (orderId, mealId) values ('3863','8508');
insert into Orders_Meals (orderId, mealId) values ('8970','8508');
insert into Orders_Meals (orderId, mealId) values ('8375', '8508');
insert into Orders_Meals (orderId, mealId) values ('2727', '8508');
insert into Orders_Meals (orderId, mealId) values ('2971', '8508');
insert into Orders_Meals (orderId, mealId) values ('6128','8508');
insert into Orders_Meals (orderId, mealId) values ('4821','8508');
insert into Orders_Meals (orderId, mealId) values ('6213',  '8508');
insert into Orders_Meals (orderId, mealId) values ('6145', '8508');
insert into Orders_Meals (orderId, mealId) values ('7076', '8508');
insert into Orders_Meals (orderId, mealId) values ('1716', '8508');
insert into Orders_Meals (orderId, mealId) values ('9070', '8508');
insert into Orders_Meals (orderId, mealId) values ('6818', '8508');
insert into Orders_Meals (orderId, mealId) values ('5693', '8508');
insert into Orders_Meals (orderId, mealId) values ('9512', '8508');
insert into Orders_Meals (orderId, mealId) values ('6318', '8508');
insert into Orders_Meals (orderId, mealId) values ('8777','8508');
insert into Orders_Meals (orderId, mealId) values ('7692','8508');
insert into Orders_Meals (orderId, mealId) values ('6953', '8508');
insert into Orders_Meals (orderId, mealId) values ('5419', '8508');
insert into Orders_Meals (orderId, mealId) values ('2099','8508');
insert into Orders_Meals (orderId, mealId) values ('7784',  '8508');
insert into Orders_Meals (orderId, mealId) values ('3879', '8508');
insert into Orders_Meals (orderId, mealId) values ('5899', '8508');
insert into Orders_Meals (orderId, mealId) values ('1730', '8508');
insert into Orders_Meals (orderId, mealId) values ('5743',  '8508');
insert into Orders_Meals (orderId, mealId) values ('3512', '8508');
insert into Orders_Meals (orderId, mealId) values ('8548',  '8508');
insert into Orders_Meals (orderId, mealId) values ('3278', '8508');
insert into Orders_Meals (orderId, mealId) values ('8116',  '8508');
insert into Orders_Meals (orderId, mealId) values ('2777', '8508');
insert into Orders_Meals (orderId, mealId) values ('5101', '8508');
insert into Orders_Meals (orderId, mealId) values ('4674', '8508');
insert into Orders_Meals (orderId, mealId) values ('1452','8508');
insert into Orders_Meals (orderId, mealId) values ('5455','8508');
insert into Orders_Meals (orderId, mealId) values ('5620', '8508');
insert into Orders_Meals (orderId, mealId) values ('2954',  '8508');
insert into Orders_Meals (orderId, mealId) values ('6018', '8508');
insert into Orders_Meals (orderId, mealId) values ('7763', '8508');
insert into Orders_Meals (orderId, mealId) values ('3731',  '8508');
insert into Orders_Meals (orderId, mealId) values ('3080', '8508');
insert into Orders_Meals (orderId, mealId) values ('9101', '8508');
insert into Orders_Meals (orderId, mealId) values ('5580',  '8508');
insert into Orders_Meals (orderId, mealId) values ('1663','8508');
insert into Orders_Meals (orderId, mealId) values ('7131',  '8508');
insert into Orders_Meals (orderId, mealId) values ('5128', '8508');
