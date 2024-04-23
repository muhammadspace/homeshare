import json
class Seeker:
    def __init__(self, id, common_interests, similarity):
        self.seeker_id = id
        self.common_interests = common_interests
        self.similarity = similarity

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)

    def serialize(self):
        return self.toJSON()