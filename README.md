# MyRestaurant
### By Liam Duncan, Justin Guthrie, Logan Lary, Maya Makonnen, and Maria-Theresa Silverio

Digital solution to address restaurant needs from the persepctive of front-of-house workers, back-of-house workers, managers, and suppliers.

## Application Overview
MyRestaurant currently supports the following features:

**Managers** can:
- Easily access and edit employee info
- View and edit menu details

**Front-of-House Employees** can:
- Quickly view and add reservations
- Create new orders

**Back-of-House Employees** can:
- View currently queued orders
- View ingredient information


## Docker Instructions
1. Clone this repository
2. In the `secrets/` folder, create `db_password.txt` and `db_root_passwort.txt` files and create <br>
passwords for non-root and root users respectively.
3. Run `docker compose build` in a terminal to build the images
4. Run `docker compose up -d`

## Demo Video
https://drive.google.com/file/d/1IY8TFfVc8PI_kFxbQNM4HrpFZv_pVgbj/view?usp=sharing
