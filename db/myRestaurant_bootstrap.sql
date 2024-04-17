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
    startTime time,
    endTime time,
    payRate int                     not null,
    bohSupervisorId char(9),
    foreign key (bohSupervisorId) references BOH_emp (bohId)
);

create table FOH_emp (
    fohId char(9) primary key       not null,
    fName varchar(40)               not null,
    lName varchar(40)               not null,
    startTime time,
    endTime time,
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

insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8857', 'Calypso', 'Grigorey', '15:17:46', '2:14:58', 32.53, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('7704', 'Towny', 'Chart', '1:41:10', '22:13:23', 99.08, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5264', 'Wynn', 'Dawidowitz', '4:58:50', '6:05:15', 55.28, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('7335', 'Dionis', 'Dominec', '2:15:54', '8:54:42', 19.52, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3707', 'Donnell', 'Jallin', '22:31:38', '15:50:36', 76.93, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4490', 'Edmund', 'Josse', '22:51:01', '17:47:36', 26.71, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1979', 'Diandra', 'Dorrity', '6:51:30', '8:34:56', 13.62, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5249', 'Zachary', 'Huske', '9:26:17', '10:09:48', 50.43, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5042', 'Rinaldo', 'Samms', '5:12:14', '6:35:53', 25.54, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3090', 'Taddeusz', 'Fairhead', '4:12:46', '0:48:10', 78.95, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5066', 'Euell', 'Hastler', '1:10:45', '10:54:28', 61.62, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5045', 'Jakie', 'Ralton', '4:26:20', '12:49:05', 10.87, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3185', 'Roselle', 'Stanett', '17:16:16', '11:04:46', 52.32, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('9580', 'Jone', 'Portail', '23:16:16', '11:35:52', 45.24, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4678', 'Alvie', 'Janusik', '5:37:10', '17:04:57', 30.87, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3266', 'Karrie', 'Behninck', '21:01:49', '21:21:51', 53.81, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8737', 'Adolph', 'Oakenfall', '10:26:53', '4:38:22', 85.80, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1345', 'Stacee', 'Westmore', '8:08:08', '13:40:11', 74.37, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8050', 'Dusty', 'Botley', '2:08:38', '9:29:01', 15.58, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3949', 'Selena', 'Borthwick', '8:46:47', '13:56:27', 84.63, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1484', 'Ferrell', 'Farley', '20:32:38', '16:18:37', 39.87, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3913', 'Inglis', 'Gaspar', '0:09:58', '16:19:59', 11.42, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('7842', 'Appolonia', 'O''Codihie', '8:45:53', '20:14:04', 78.73, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3060', 'Johna', 'Ashfold', '13:55:32', '13:22:36', 22.80, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('7746', 'Griselda', 'Dain', '13:15:33', '19:53:17', 24.79, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3548', 'Karel', 'Corton', '3:33:43', '1:24:09', 20.46, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4549', 'Sonnie', 'Renals', '23:25:36', '1:52:00', 34.22, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5715', 'Kally', 'Wintour', '20:54:39', '15:00:41', 50.04, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4818', 'Bernadina', 'Drysdell', '0:00:45', '3:18:55', 22.25, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3497', 'Krista', 'Clubb', '0:11:11', '14:59:30', 33.07, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('7029', 'Elly', 'Ricks', '16:41:32', '4:54:38', 49.99, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('6645', 'Leela', 'Lilleman', '19:37:22', '2:17:53', 50.35, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1231', 'Axel', 'Rohlfs', '1:31:24', '17:35:34', 46.74, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1638', 'Chandra', 'Koppke', '20:01:50', '4:54:32', 10.15, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('2696', 'Earl', 'Nowakowski', '18:49:04', '10:57:23', 22.73, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3029', 'Crysta', 'Paiton', '12:59:01', '5:50:07', 60.56, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5351', 'Deeanne', 'Ledley', '2:46:01', '12:55:23', 58.46, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4997', 'Carree', 'Dawidowitz', '20:32:08', '16:20:06', 53.14, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3021', 'Tann', 'Bardey', '22:57:54', '6:46:10', 44.79, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3982', 'Enriqueta', 'Turbitt', '15:26:33', '6:02:45', 16.01, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('5847', 'Erasmus', 'Gehring', '10:19:44', '17:23:19', 43.45, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4800', 'Viviene', 'Justis', '9:47:39', '5:44:48', 72.90, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('4480', 'Anne', 'Heintsch', '16:56:53', '6:01:16', 53.08, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3178', 'Zachariah', 'Foyle', '17:39:32', '6:07:44', 13.08, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('2302', 'Carla', 'Caswill', '6:57:05', '7:43:36', 45.61, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('3132', 'Netta', 'Busby', '3:53:57', '0:09:32', 36.15, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('8660', 'Persis', 'Pautot', '2:19:02', '13:31:50', 86.58, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1163', 'Carny', 'Ambroisin', '14:49:26', '0:33:32', 54.14, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('7143', 'Florette', 'Clougher', '8:54:20', '10:26:50', 96.46, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('1876', 'Giffard', 'Bails', '12:54:12', '12:23:02', 86.19, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('6783', 'Palmer', 'Melonby', '9:29:28', '12:01:42', 54.39, '8857');
insert into BOH_emp (bohId, fName, lName, startTime, endTime, payRate, bohSupervisorId) values ('2792', 'Petronia', 'Dowell', '6:28:58', '9:54:22', 98.83, '8857');

insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('5876', 'Dolf', 'Sifflett', '7:36:57', '16:19:11', 64.21, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('6575', 'Brana', 'Fawley', '7:32:31', '19:12:19', 65.74, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('5824', 'Marcos', 'Perryman', '3:01:06', '18:51:20', 24.93, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1204', 'Carter', 'Soppit', '3:01:12', '0:11:44', 96.27, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('6575', 'Lois', 'Korfmann', '5:47:46', '19:31:56', 46.73, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('7360', 'Cristobal', 'Brogini', '18:19:35', '7:58:43', 70.85, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('4726', 'Theressa', 'Fellos', '17:14:42', '6:22:57', 40.86, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('7784', 'Carly', 'Karolyi', '23:10:40', '22:22:10', 11.80, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1009', 'Romonda', 'Godding', '6:05:40', '21:54:38', 55.31, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('8607', 'Gwendolyn', 'Arlow', '14:11:54', '1:57:26', 40.65, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('7101', 'Bibi', 'Hurtado', '8:58:42', '14:49:11', 27.09, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('8657', 'Phillip', 'D''Abbot-Doyle', '1:54:54', '23:43:02', 25.41, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1205', 'Eileen', 'Aubert', '7:25:48', '16:05:30', 78.84, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('7946', 'Jimmie', 'Lafuente', '7:46:12', '19:48:57', 99.73, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('6312', 'Truman', 'Bosher', '12:55:37', '7:43:08', 48.93, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('8399', 'Kurtis', 'Gotthard', '0:07:49', '11:30:01', 85.11, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('3357', 'Peder', 'Edelman', '2:03:11', '5:35:32', 78.41, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1093', 'Woody', 'Kirman', '2:34:29', '3:33:12', 29.09, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('2294', 'Gaye', 'Husby', '13:06:03', '11:14:41', 68.39, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('3188', 'Harli', 'Sterrie', '7:26:27', '2:56:10', 89.78, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9268', 'Jori', 'Bloxam', '0:17:43', '0:45:35', 88.44, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('2467', 'Kelsey', 'Chagg', '11:20:53', '13:48:39', 46.85, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('4278', 'Devonna', 'Nolda', '9:35:25', '17:29:35', 27.45, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('7001', 'Wendy', 'Pett', '19:35:35', '12:39:20', 74.59, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('7188', 'Sayers', 'Silvers', '6:37:14', '6:37:23', 26.36, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('2686', 'Pepito', 'Larking', '0:39:52', '23:34:15', 15.27, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('4772', 'Anthiathia', 'Merrikin', '1:29:32', '23:35:42', 64.80, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('8387', 'Shalom', 'Sheircliffe', '3:09:47', '8:17:01', 50.84, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('4572', 'Tobie', 'Reek', '13:20:04', '14:23:43', 11.45, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1910', 'Monroe', 'Boncore', '19:42:51', '9:14:46', 71.87, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9219', 'Joni', 'Tiffney', '13:44:22', '13:47:02', 78.54, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1865', 'Clayborne', 'Skitch', '17:00:48', '9:59:03', 56.84, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('2289', 'Yalonda', 'Carek', '8:04:56', '5:39:29', 65.56, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9405', 'Gardener', 'Banbridge', '11:57:39', '0:48:06', 64.83, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9741', 'Hunfredo', 'Meikle', '15:23:01', '1:16:07', 79.46, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9557', 'Rebecca', 'Polak', '17:07:33', '22:42:53', 89.99, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9315', 'Eulalie', 'Bomb', '14:56:45', '3:40:17', 77.30, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('4234', 'Filmore', 'Rizzone', '21:06:37', '9:11:33', 96.65, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9624', 'Demeter', 'Van Eeden', '9:18:34', '23:09:11', 25.42, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('7265', 'Lidia', 'Gavagan', '0:36:01', '18:55:51', 46.52, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('8176', 'Dasi', 'Barrabeale', '7:27:49', '0:27:15', 76.20, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('3754', 'Marielle', 'Tye', '20:42:54', '19:41:44', 92.49, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('2614', 'Phip', 'Basham', '18:41:00', '7:54:54', 85.55, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('4970', 'Theresa', 'Bantham', '23:51:43', '18:42:55', 70.95, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('2379', 'Bailie', 'Quantick', '23:25:15', '17:59:08', 14.64, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1674', 'Angel', 'Adds', '1:29:52', '23:58:47', 42.50, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('5423', 'Hetty', 'Landsman', '9:11:52', '22:22:18', 92.23, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('8144', 'Romy', 'Layus', '1:40:56', '21:02:11', 86.89, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9985', 'Elianore', 'Myhill', '16:55:26', '19:53:10', 59.81, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9752', 'Ambur', 'Pickford', '8:42:45', '17:22:33', 94.59, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('4837', 'Abramo', 'Harrismith', '7:37:51', '8:28:47', 66.31, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1908', 'Park', 'Strood', '10:40:33', '17:28:40', 46.69, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1349', 'Nye', 'Haibel', '2:18:43', '20:07:05', 99.90, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9179', 'Dot', 'Ciccotti', '1:14:52', '11:36:51', 86.34, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('4326', 'Mariette', 'Boriston', '5:31:24', '18:35:18', 18.90, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('4287', 'Korry', 'Kennelly', '13:18:58', '5:45:07', 72.17, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('5564', 'Bail', 'Ovett', '23:31:02', '1:39:55', 15.81, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('1389', 'Ariela', 'Perring', '17:13:52', '20:56:10', 15.10, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9817', 'Davina', 'Tremoille', '9:04:28', '7:56:21', 82.18, '5876');
insert into FOH_emp (fohId, fName, lName, startTime, endTime, payRate, fohSupervisorId) values ('9096', 'Crawford', 'Eagland', '22:02:58', '12:29:50', 37.61, '5876');

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
