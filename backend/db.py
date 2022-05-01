from flask_sqlalchemy import SQLAlchemy
# from dateutil import datetime

db = SQLAlchemy()

# --------------------------------------


class User(db.Model):
    """
    User model

    Has one-to-many relationship with Booking model
    """
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    net_id = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        """
        Initialize User object
        """
        self.net_id = kwargs.get("net_id")
        self.password = kwargs.get("password")


class Booking(db.Model):
    """
    Booking model

    Has many-to-one relationship with Booking model
    Has many-to-one relationship with Booking model
    """
    __tablename__ = "bookings"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    room_id = db.Column(db.Integer, db.ForeignKey("rooms.id"), nullable=False)
    time_start = db.Column(db.DateTime, nullable=False)
    time_end = db.Column(db.Datetime, nullable=False)

    def __init__(self, **kwargs):
        """
        Initialize Booking object
        """
        self.user_id = kwargs.get("user_id")
        self.room_id = kwargs.get("room_id")
        self.time_start = kwargs.get("time_start")
        self.time_end = kwargs.get("time_end")


class Library(db.Model):
    """
    Library model

    Has one-to-many relationship with Room model
    """
    __tablename__ = "libraries"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    location = db.Column(db.String, nullable=False)
    time_start = db.Column(db.DateTime, nullable=False)
    time_end = db.Column(db.Datetime, nullable=False)

    def __init__(self, **kwargs):
        """
        Initialize Library object
        """
        self.name = kwargs.get("name")
        self.location = kwargs.get("location")
        self.time_start = kwargs.get("time_start")
        self.time_end = kwargs.get("time_end")


class Room(db.model):
    """
    Room model

    Has many-to-one relationship with Booking model
    """
    __tablename__ = "rooms"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    library_id = db.Column(db.Integer, db.ForeignKey(
        "libraries.id"), nullable=False)
    capacity = db.Column(db.Integer, nullable=False)
    description = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        """
        Initialize Room object
        """
        self.library_id = kwargs.get("library_id")
        self.capacity = kwargs.get("capacity")
        self.description = kwargs.get("description")
