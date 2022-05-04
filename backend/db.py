from flask_sqlalchemy import SQLAlchemy
from matplotlib.style import library

db = SQLAlchemy()

class User(db.Model):
    """
    User model

    Has one-to-many relationship with Timeslot model
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

    def simple_serialize(self):
        """
        Simple serialize User object
        """
        return {
            "id": self.id,
            "net_id": self.net_id,
        }

    def serialize(self):
        """
        Serialize User object
        """
        return {
            "id": self.id,
            "net_id": self.net_id,
            "password": self.password
        }

class Library(db.Model):
    """
    Library model

    Has one-to-many relationship with Room model
    """
    __tablename__ = "libraries"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    area_id = db.Column(db.Integer, nullable=False)
    time_start = db.Column(db.Integer, nullable=False)
    time_end = db.Column(db.Integer, nullable=False)

    def getTimeStart(self):
        return self.time_start
    
    def getTimeEnd(self):
        return self.time_end

    def getName(self):
        return self.name

    def __init__(self, **kwargs):
        """
        Initialize Library object
        """
        self.name = kwargs.get("name")
        self.area_id = kwargs.get("area_id")
        self.time_start = kwargs.get("time_start")
        self.time_end = kwargs.get("time_end")

    def serialize(self):
        """
        Simple serialize Library object
        """
        return {
            "id": self.id,
            "name": self.name,
            "area_id": self.area_id,
            "time_start": self.time_start,
            "time_end": self.time_end
        }


class Room(db.Model):
    """
    Room model

    Has many-to-one relationship with Timeslot model
    """
    __tablename__ = "rooms"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    library_id = db.Column(db.Integer, db.ForeignKey(
        "libraries.id"), nullable=False)
    name = db.Column(db.String, nullable=False)
    capacity = db.Column(db.Integer, nullable=False)

    def getID(self):
        return self.id

    def getName(self):
        return self.name
    
    def getLibrary(self):
        return Library.query.filter_by(id=self.library_id).first()
    
    def getLibraryName(self):
        library = self.getLibrary()
        return library.getName()

    def __init__(self, **kwargs):
        """
        Initialize Room object
        """
        self.library_id = kwargs.get("library_id")
        self.capacity = kwargs.get("capacity")
        self.name = kwargs.get("name")

    def simple_serialize(self):
        """
        Simple serialize Room object
        """
        return {
            "id": self.id,
            "library_id": self.library_id,
            "name": self.name,
            "capacity": self.capacity,
        }

    def serialize(self):
        """
        Serialize Room object
        """
        library = Library.query.filter_by(id=(self.library_id)).first()
        return {
            "id": self.id,
            "library": library.simple_serialize(),
            "name": self.name,
            "capacity": self.capacity,
        }

class Timeslot(db.Model):
    """
    Timeslot model

    Has many-to-one relationship with User model
    Has many-to-one relationship with Room model
    """
    __tablename__ = "timeslots"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    room_id = db.Column(db.Integer, db.ForeignKey("rooms.id"), nullable=False)
    time_start = db.Column(db.Integer, nullable=False)

    def getID(self):
        return self.id

    def getRoom(self):
        return Room.query.filter_by(id=self.room_id).first()

    def getRoomName(self):
        room = self.getRoom()
        return room.getName()

    def getLibraryName(self):
        room = self.getRoom()
        return room.getLibraryName()

    def getTimeStart(self):
        return self.time_start

    def __init__(self, **kwargs):
        """
        Initialize Timeslot object
        """
        self.user_id = kwargs.get("user_id")
        self.room_id = kwargs.get("room_id")
        self.time_start = kwargs.get("time_start")

    def simple_serialize(self):
        """
        Simple serialize Timeslot object
        """
        return {
            "id": self.id,
            "user_id": self.user_id,
            "room_id": self.room_id,
            "time_start": self.time_start,
        }

    def serialize(self):
        """
        Serialize Timeslot object
        """
        user = User.query.filter_by(id=(self.user_id)).first()
        room = Room.query.filter_by(id=(self.room_id)).first()
        return {
            "id": self.id,
            "user": user.simple_serialize(),
            "room": room.simple_serialize(),
            "time_start": self.time_start
        }
