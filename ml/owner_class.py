import json

class Owner:
    def __init__(self, id, common_interests, apt):
        self.owner_id = str(id)
        self.common_interests = common_interests
        self.apt = apt.id

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)
        # return json.dumps(self, default=jsoner, sort_keys=True, indent=4)

    def serialize(self):
        return self.toJSON()

class Apt:
    def __init__(self, id, location, bedrooms, bathrooms, price, start_date, end_date, max, residents):
        self.id = str(id)
        self.location = location
        self.bedrooms = bedrooms
        self.bathrooms = bathrooms
        self.price = price
        self.start_date = start_date
        self.end_date = end_date
        self.max = max
        self.residents = residents

    def __init__(self, df):
        self.id = str(df.iloc[0]._id)
        self.location = df.location
        self.bedrooms = df.bedrooms
        self.bathrooms = df.bathrooms
        self.price = df.price
        self.start_date = df.start_date
        self.end_date = df.end_date
        self.max = df.max
        self.residents = df.residents

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)
        # return json.dumps(self, default=jsoner, sort_keys=True, indent=4)

    def serialize(self):
        return self.toJSON()