import json
from db import db, User, Timeslot, Library, Room
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
@app.route("/users/")
def get_users():
    """
    Endpoint for getting all users
    """
    return success_response({
        "users": [user.simple_serialize() for user in User.query.all()]
    }) 

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
    return success_response({
        "libraries": [lib.serialize() for lib in Library.query.all()]
    })

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

    new_library = Library(name=name, area_id=area_id, time_start=time_start, time_end=time_end)
    db.session.add(new_library)
    db.session.commit()
    return success_response(new_library.serialize(), 201)

@app.route("/libraries/areas/<int:area_id>/")
def get_libraries_by_area(area_id):
    """
    Endpoint for getting libraries by area_id
    """
    libraries = Library.query.filter_by(area_id=area_id)
    return success_response({
        "libraries": [lib.serialize() for lib in libraries]
    })

@app.route("/rooms/")
def get_rooms():
    """
    Endpoint for getting all rooms
    """
    return success_response({
        "rooms": [room.simple_serialize() for room in Room.query.all()]
    }) 

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
            timeslot = Timeslot.query.filter_by(room_id=room.getID(), time_start=time).first()
            if timeslot == None:
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
    user_id = body.get("user_id", -1)
    room_id = body.get("room_id", -1)
    time_start = body.get("time_start", -1)

    if user_id == -1 or room_id == -1 or time_start == -1:
        return failure_response("Missing request information", 400)

    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")

    room = Room.query.filter_by(id=room_id).first()
    if room is None:
        return failure_response("Room not found")

    timeslot = Timeslot.query.filter_by(user_id=user_id, room_id=room_id, time_start=time_start).first()
    if timeslot != None:
        return failure_response("Timeslot not available")

    new_timeslot = Timeslot(user_id, room_id, time_start)
    db.session.add(new_timeslot)
    db.session.commit()
    return success_response(new_timeslot.simple_serialize(), 201)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)