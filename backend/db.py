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

    def simple_serialize_user(self):
        return {
            "id": self.id,
            "net_id": self.net_id,
            # "password": self.password // Removed for security
        }

    def serialize_user(self):
        return {
            "id": self.id,
            "net_id": self.net_id,
            "password": self.password
        }


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

    def simple_serialize_booking(self):
        return {
            "id": self.id,
            "time_start": self.time_start,
            "time_end": self.time_end
        }

    def serialize_booking(self):
        user = User.query.filter_by(id=(self.user_id)).first()
        room = Room.query.filter_by(id=(self.room_id)).first()
        return {
            "id": self.id,
            "user": user.simple_serialize_user(),
            "room": room.simple_serialize_user(),
            "time_start": self.time_start,
            "time_end": self.time_end
        }


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

    def simple_serialize_library(self):
        return {
            "id": self.id,
            "name": self.name,
            "location": self.location,
            "time_start": self.time_start,
            "time_end": self.time_end
        }

    # Not needed
    # def serialize_library(self):
    #     pass


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

    def simple_serialize_room(self):
        return {
            "id": self.id,
            "capacity": self.capacity,
            "description": self.description
        }

    def serialize_room(self):
        library = Library.query.filter_by(id=(self.library_id)).first()
        return {
            "id": self.id,
            "library": library.simple_serialize_library(),
            "capacity": self.capacity,
            "description": self.description
        }
