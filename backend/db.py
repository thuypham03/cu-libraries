from flask_sqlalchemy import SQLAlchemy
import base64
import boto3
import datetime
import io
from io import BytesIO
from mimetypes import guess_extension, guess_type
import os
from PIL import Image
import random
import re
import string

db = SQLAlchemy()

EXTENSIONS = ["png", "gif", "jpg", "jpeg"]
BASE_DIR = os.getcwd()
S3_BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")
S3_BASE_URL = f"https://{S3_BUCKET_NAME}.s3.us-east-1.amazonaws.com"

class Asset(db.Model):
    """
    Asset model

    Has one-to-one relationship with Library model
    """
    __tablename__ = "assets"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    base_url = db.Column(db.String, nullable=True)
    name = db.Column(db.String, nullable=False)
    extension = db.Column(db.String, nullable=False)
    width = db.Column(db.Integer, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    library_id = db.Column(db.Integer, db.ForeignKey(
        "libraries.id"), nullable=False)

    def getURL(self):
        return f"{self.base_url}/{self.name}.{self.extension}"

    def _getLibraryName(self):
        library = Library.query.filter_by(id=self.library_id).first()
        name = library.getName()
        return ''.join(name.split())

    def __init__(self, **kwargs):
        """
        Initializes an Asset object
        """
        self.library_id = kwargs.get("library_id")
        self.name = self._getLibraryName()
        self.create(kwargs.get("image_data"))

    def serialize(self):
        """
        Serialize an Asset object
        """
        return {
            "url": f"{self.base_url}/{self.name}.{self.extension}",
            "created_at": str(self.created_at),
            "library_id": self.library_id
        }

    def create(self, image_data):
        """
        Given an image in base64 form, does the following:
        1. Rejects the image if it is not a supported filetype
        2. Decodes the image and attempts to upload it to AWS
        """
        try:
            ext = guess_extension(guess_type(image_data)[0])[1:]
            
            # only accept supported file extensions
            if ext not in EXTENSIONS:
                raise Exception(f"Unsupported file type: {ext}")

            # remove header of base64 string
            img_str = re.sub("^data:image/.+;base64,", "", image_data)
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            self.base_url = S3_BASE_URL
            self.extension = ext
            self.width = img.width
            self.height = img.height
            self.created_at = datetime.datetime.now()

            img_filename = f"{self.name}.{self.extension}"
            self.upload(img, img_filename)

        except Exception as e:
            print(f"Error when creating image: {e}")

    def upload(self, img, img_filename):
        """
        Attempts to upload the image to the specified S3 bucket
        """
        try:
            # save image temporarily on server
            img_temploc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temploc)

            # upload the image to S3
            s3_client = boto3.client("s3")
            s3_client.upload_file(img_temploc, S3_BUCKET_NAME, img_filename)

            # make S3 image url is public
            s3_resource = boto3.resource("s3")
            object_acl = s3_resource.ObjectAcl(S3_BUCKET_NAME, img_filename)
            object_acl.put(ACL="public-read")

            # remove image from server
            os.remove(img_temploc)
            
        except Exception as e:
            print(f"Error when uploading image: {e}")

        
class User(db.Model):
    """
    User model

    Has one-to-many relationship with Booking model
    """
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    net_id = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)

    def getID(self):
        return self.id

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
    Has one-to-one relationship with Asset model
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
        Serialize Library object
        """
        res = {
            "id": self.id,
            "name": self.name,
            "area_id": self.area_id,
            "time_start": self.time_start,
            "time_end": self.time_end
        }

        asset = Asset.query.filter_by(library_id=self.id).first()
        if asset is not None:
            res["photo"] = asset.getURL()
        return res


class Room(db.Model):
    """
    Room model

    Has one-to-many relationship with Booking model
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

class Booking(db.Model):
    """
    Booking model

    Has many-to-one relationship with User model
    Has many-to-one relationship with Room model
    """
    __tablename__ = "bookings"
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
        Initialize Booking object
        """
        self.user_id = kwargs.get("user_id")
        self.room_id = kwargs.get("room_id")
        self.time_start = kwargs.get("time_start")

    def simple_serialize(self):
        """
        Simple serialize Booking object
        """
        return {
            "id": self.id,
            "user_id": self.user_id,
            "room_id": self.room_id,
            "time_start": self.time_start,
        }

    def serialize(self):
        """
        Serialize Booking object
        """
        user = User.query.filter_by(id=(self.user_id)).first()
        room = Room.query.filter_by(id=(self.room_id)).first()
        return {
            "id": self.id,
            "user": user.simple_serialize(),
            "room": room.simple_serialize(),
            "time_start": self.time_start
        }
