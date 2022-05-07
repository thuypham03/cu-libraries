import json
from db import db, User, Booking, Library, Room, Asset

from flask import Flask, request
import os

db_filename = "library.db"
app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

# generalized response formats


def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code

# routes 
@app.route("/")
def greeting():
    """
    Endpoint for greeting
    """
    return success_response("Welcome to BOOKED! Please try out other routes ヽ(o＾▽＾o)ノ")

@app.route("/users/")
def get_users():
    """
    Endpoint for getting all users
    """
    return success_response(
        {"users": [user.simple_serialize() for user in User.query.all()]}
    ) 

@app.route("/users/", methods=["POST"])
def create_user():
    """
    Endpoint for creating user
    """
    body = json.loads(request.data)
    net_id = body.get("net_id", -1)
    password = body.get("password", -1)

    if net_id == -1 or password == -1:
        return failure_response("Missing request information", 400)

    new_user = User(net_id=net_id, password=password)
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.simple_serialize(), 201)


@app.route("/users/<int:user_id>/")
def get_user_by_id(user_id):
    """
    Endpoint for getting user by id
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")
    return success_response(user.serialize())


@app.route("/libraries/")
def get_libraries():
    """
    Endpoint for getting all libraries
    """
    return success_response(
        {"libraries": [lib.serialize() for lib in Library.query.all()]}
    )


@app.route("/libraries/", methods=["POST"])
def create_library():
    """
    Endpoint for creating a new library
    """
    body = json.loads(request.data)
    name = body.get("name", -1)
    area_id = body.get("area_id", -1)
    time_start = body.get("time_start", -1)
    time_end = body.get("time_end", -1)

    if name == -1 or area_id == -1 or time_start == -1 or time_end == -1:
        return failure_response("Missing request information", 400)

    new_library = Library(name=name, area_id=area_id,
                          time_start=time_start, time_end=time_end)
    db.session.add(new_library)
    db.session.commit()
    return success_response(new_library.serialize(), 201)


@app.route("/libraries/areas/<int:area_id>/")
def get_libraries_by_area(area_id):
    """
    Endpoint for getting libraries by area_id
    """
    libraries = Library.query.filter_by(area_id=area_id)
    return success_response(
       {"libraries": [lib.serialize() for lib in libraries]}
    )


@app.route("/rooms/")
def get_rooms():
    """
    Endpoint for getting all rooms
    """
    return success_response(
        {"rooms": [room.simple_serialize() for room in Room.query.all()]}
    ) 


@app.route("/rooms/", methods=["POST"])
def create_room():
    """
    Endpoint for creating a new room
    """
    body = json.loads(request.data)
    library_id = body.get("library_id", -1)
    name = body.get("name", -1)
    capacity = body.get("capacity", -1)

    if library_id == -1 or name == -1 or capacity == -1:
        return failure_response("Missing request information", 400)

    library = Library.query.filter_by(id=library_id).first()
    if library is None:
        return failure_response("Library not found")

    new_room = Room(library_id=library_id, name=name, capacity=capacity)
    db.session.add(new_room)
    db.session.commit()
    return success_response(new_room.simple_serialize(), 201)


@app.route("/rooms/libraries/<int:library_id>/")
def get_rooms_by_library(library_id):
    """
    Endpoint for getting rooms by library_id
    """
    rooms = Room.query.filter_by(library_id=library_id)

    library = Library.query.filter_by(id=library_id).first()
    time_start = library.getTimeStart()
    time_end = library.getTimeEnd()

    res = []
    for room in rooms:
        avail = []
        for time in range(time_start, time_end):
            booking = Booking.query.filter_by(room_id=room.getID(), time_start=time).first()
            if booking == None:
                avail.append(time)

        serialize = room.simple_serialize()
        serialize["availability"] = avail
        res.append(serialize)

    return success_response({"rooms": res})


@app.route("/bookings/", methods=["POST"])
def create_booking():
    """
    Endpoint for creating the booking
    """
    body = json.loads(request.data)
    net_id = body.get("net_id", -1)
    room_id = body.get("room_id", -1)
    time_start = body.get("time_start", -1)

    if net_id == -1 or room_id == -1 or time_start == -1:
        return failure_response("Missing request information", 400)


    user = User.query.filter_by(net_id=net_id).first()
    if user is None:
        return failure_response("User not found")
    user_id = user.getID()

    room = Room.query.filter_by(id=room_id).first()
    if room is None:
        return failure_response("Room not found")

    booking = Booking.query.filter_by(user_id=user_id, room_id=room_id, time_start=time_start).first()
    if booking != None:
        return failure_response("Booking not available")

    new_booking = Booking(user_id=user_id, room_id=room_id, time_start=time_start)
    db.session.add(new_booking)

    db.session.commit()
    return success_response(new_booking.simple_serialize(), 201)

  
@app.route("/bookings/users/<string:net_id>/")
def get_bookings_by_user(net_id):
    """
    Endpoint for getting bookings by net_id
    """
    user = User.query.filter_by(net_id=net_id).first()
    if user is None:
        return failure_response("User not found")
    user_id = user.getID()

    bookings = Booking.query.filter_by(user_id=user_id)

    res = []
    for booking in bookings:
        temp = {
            "id": booking.getID(),
            "library_name": booking.getLibraryName(),
            "room_name": booking.getRoomName(),
            "time_start": booking.getTimeStart()
        }
        res.append(temp)

    return success_response({"bookings":res})


@app.route("/bookings/delete/<int:booking_id>/", methods=["DELETE"])
def delete_booking(booking_id):
    """
    Endpoint for deleting booking by booking_id
    """
    booking = Booking.query.filter_by(id=booking_id).first()
    if booking is None:
        return failure_response("Booking not found")

    db.session.delete(booking)
    db.session.commit()
    return success_response(booking.simple_serialize())

  
@app.route("/photos/")
def get_photo():
    """
    Endpoint for getting all photos
    """
    return success_response(
        {"photos": [photo.serialize() for photo in Asset.query.all()]}
    ) 

  
@app.route("/libraries/upload/<int:library_id>/", methods=["POST"])
def upload(library_id):
    """
    Endpoint for uploading an image of library to AWS given its base64 form,
    then storing/returning the URL of that image
    """
    body = json.loads(request.data)
    image_data = body.get("image_data", -1)
    if image_data == -1:
        return failure_response("No base64 image found")

    library = Library.query.filter_by(id=library_id).first()
    if library is None:
        return failure_response("Library not found")

    asset = Asset.query.filter_by(library_id=library_id).first()
    if asset is not None:
        db.session.delete(asset)

    new_asset = Asset(library_id=library_id, image_data=image_data)
    db.session.add(new_asset)
    db.session.commit()
    return success_response(new_asset.serialize(), 201)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
