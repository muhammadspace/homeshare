import json
from recommend_seekers_interests import recommend_seekers_interests
from recommend_owners_interests import recommend_owners_interests
from recommend_seekers_traits import recommend_seekers_traits
from recommend_owners_traits import recommend_owners_traits
from customer_segmentation import GetClusterCounts
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/recommend/owners_interests", methods=["POST"])
def recommend_owners_interests_endpoint():
    data = request.json
    seeker_id = data["seeker_id"]
    recs = recommend_owners_interests(seeker_id)

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

@app.route("/recommend/seekers_interests", methods=["POST"])
def recommend_seekers_interests_endpoint():
    data = request.json
    owner_id = data["owner_id"]
    recs = recommend_seekers_interests(owner_id)

    # convert seekers from Seeker objects to dictionaries so that they're jsonify-able
    recommendatonsAsDicts = []
    for rec in recs:
        recommendatonsAsDicts.append(json.loads(rec.toJSON())) 

    if len(recommendatonsAsDicts) > 0:
        return jsonify(recommendatonsAsDicts)    
    else:
        return {"success": False, "message": "Could not recommend any seekers"}

@app.route("/recommend/owners_traits", methods=["POST"])
def recommend_owners_traits_endpoint():
    data = request.json
    seeker_id = data["seeker_id"]
    recs = recommend_owners_traits(seeker_id)

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

@app.route("/recommend/seekers_traits", methods=["POST"])
def recommend_seekers_traits_endpoint():
    data = request.json
    owner_id = data["owner_id"]
    recs = recommend_seekers_traits(owner_id)

    # convert seekers from Seeker objects to dictionaries so that they're jsonify-able
    recommendatonsAsDicts = []
    for rec in recs:
        recommendatonsAsDicts.append(json.loads(rec.toJSON())) 

    if len(recommendatonsAsDicts) > 0:
        return jsonify(recommendatonsAsDicts)    
    else:
        return {"success": False, "message": "Could not recommend any seekers"}

@app.route("/admin/clusters", methods=["GET"])
def get_customer_clusters_counts():
    # Returns cluster counts (sorted by index)
    return jsonify(list(GetClusterCounts()))

if __name__ == "__main__":
    app.run(debug=True)