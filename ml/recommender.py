import json
from recommend_seekers import recommend_seekers
from recommend_owners import recommend_owners
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/recommend/owners", methods=["POST"])
def recommend_owners_endpoint():
    data = request.json
    seeker_id = data["seeker_id"]
    recs = recommend_owners(seeker_id)

    # If there are no recommendations, the return value is a dictionary with the error message and success status
    if isinstance(recs, dict):
        return recs

    # convert owners from Owner objects to dictionaries so that they're jsonify-able
    recommendationsAsDicts = []
    for rec in recs:
        recommendationsAsDicts.append(json.loads(rec.toJSON())) 

    if len(recommendationsAsDicts) > 0:
        return jsonify(recommendationsAsDicts)    
    else:
        return {"success": False, "message": "Could not recommend any seekers"}

@app.route("/recommend/seekers", methods=["POST"])
def recommend_seekers_endpoint():
    data = request.json
    owner_id = data["owner_id"]
    recs = recommend_seekers(owner_id)

    # convert seekers from Seeker objects to dictionaries so that they're jsonify-able
    recommendatonsAsDicts = []
    for rec in recs:
        recommendatonsAsDicts.append(json.loads(rec.toJSON())) 

    if len(recommendatonsAsDicts) > 0:
        return jsonify(recommendatonsAsDicts)    
    else:
        return {"success": False, "message": "Could not recommend any seekers"}

if __name__ == "__main__":
    app.run(debug=True)