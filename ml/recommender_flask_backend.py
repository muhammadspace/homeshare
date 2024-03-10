from flask import Flask, jsonify, request
import json
from seeker import recommend_owners_and_apartments as getRecs
from owenr import generate_recommendations as getOwnerRecs

app = Flask(__name__)

@app.route("/recommend", methods=["POST"])
def recommend():
    data = request.json
    seeker_id = data["seeker_id"]
    recs = getRecs(seeker_id)

    # convert owners from Owner objects to dictionaries so that they're jsonify-able
    dictRecs = []
    for rec in recs:
        dictRecs.append(json.loads(rec.toJSON())) 

    return jsonify(dictRecs)

@app.route("/recommend/owner", methods=["POST"])
def recommend_owner():
    data = request.json
    target_user = data["target_user"]
    recs = getOwnerRecs(target_user)
    print(recs)

    # convert owners from Owner objects to dictionaries so that they're jsonify-able
    dictRecs = []
    for rec in recs:
        dictRecs.append(json.loads(rec.toJSON())) 

    return jsonify(dictRecs)    

if __name__ == "__main__":
    app.run(debug=True)
  



