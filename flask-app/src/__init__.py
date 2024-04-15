# Some set up for the application 

from flask import Flask
from flaskext.mysql import MySQL

# create a MySQL object that we will use in other parts of the API
db = MySQL()

def create_app():
    app = Flask(__name__)
    
    # secret key that will be used for securely signing the session 
    # cookie and can be used for any other security related needs by 
    # extensions or your application
    app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'

    # these are for the DB object to be able to connect to MySQL. 
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = open('/secrets/db_root_password.txt').readline().strip()
    app.config['MYSQL_DATABASE_HOST'] = 'db'
    app.config['MYSQL_DATABASE_PORT'] = 3306
    app.config['MYSQL_DATABASE_DB'] = 'myRestaurant'

    # Initialize the database object with the settings above. 
    db.init_app(app)
    
    # Add the default route
    # Can be accessed from a web browser
    # http://ip_address:port/
    # Example: localhost:8001
    @app.route("/")
    def welcome():
        return "<h1>Welcome MyRestaurant, our CS3200 app.</h1>"

    # Import the various Beluprint Objects
    from src.BOH.BOH import BOH_emp
    from src.customers.customers import customers
    from src.FOH.FOH import FOH_emp
    from src.ingredients.ingredients import ingredients
    from src.meals.meals import meals
    from src.orders.orders import orders
    from src.products.products  import products
    from src.reservations.reservations import reservations
    from src.suppliers.suppliers import suppliers
    from src.tables.tables import tables


    # Register the routes from each Blueprint with the app object
    # and give a url prefix to each
    app.register_blueprint(customers,   url_prefix='/c')
    app.register_blueprint(BOH_emp,    url_prefix='/boh')
    app.register_blueprint(FOH_emp,    url_prefix='/foh')
    app.register_blueprint(ingredients,    url_prefix='/i')
    app.register_blueprint(meals,    url_prefix='/m')
    app.register_blueprint(orders,    url_prefix='/o')
    app.register_blueprint(products,    url_prefix='/p')
    app.register_blueprint(reservations,    url_prefix='/r')
    app.register_blueprint(suppliers,    url_prefix='/s')
    app.register_blueprint(tables,    url_prefix='/t')


    # Don't forget to return the app object
    return app