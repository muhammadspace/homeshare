import pandas as pd
import pymongo
import bson.objectid
import random

client = pymongo.MongoClient("mongodb+srv://swdproject:swdproject@cluster0.56yizii.mongodb.net/?retryWrites=true&w=majority")
db = client.gp

users_collection = db.users2

def FindUserById(id):
    if isinstance(id, bson.objectid.ObjectId):
        user = users_collection.find_one({"_id": id})
    else:
        user = users_collection.find_one({"_id": bson.objectid.ObjectId(id)})
    
    return user
    
def FindUserByUsername(username):
    return users_collection.find_one({"username": username})

# UPLOADING APTS TO MONGODB AND UPDATING OWNER.OWNED_APT
###################################################################################
# users2 = db.users2
# apts_coll = db.apts
# apts_coll.delete_many({ "seeker": {"$type": "string" }})

# owners = db.users2.find({"type": "owner"})
# seekers = db.users2.find({"type": "seeker"})
# apts = db.apts.find({"residents": {"$type": "string"}})
# owners_df = pd.DataFrame(list(owners))
# seekers_df = pd.DataFrame(list(seekers))
# apts_df = pd.DataFrame(list(apts))

# local_apts_df = pd.read_csv("datasets/rental_listings.csv")
# local_apts_df = local_apts_df[["Location", "Bedrooms", "Bathrooms", "price(USD)", "Property Type", "owner_id", "Start Date", "End Date", "max", "seeker_id"]]
# local_apts_df.rename(columns={"Location": "location", "Bedrooms": "bedrooms", "Bathrooms": "bathrooms", "owner_id": "owner", "seeker_id": "residents", "Start Date": "start_date", "End Date": "end_date", "Property Type": "property_type", "price(USD)": "price"}, inplace=True)

# local_apts_df.owner = owners_df._id
# apts.insert_many(df.to_dict("records"))

# for apt in apts_df.itertuples():
#     db.users2.update_many({"_id": apt.owner}, {"$set": {"owned_apt": apt._1}})
###################################################################################

# SETTING SEEKER.RESIDENT_APT AND APT.RESIDENTS
###################################################################################
# seeker_idx = 0
# apt_idx = 0
# while seeker_idx < seekers_df.shape[0] and apt_idx < apts_df.shape[0]:
#     n = random.randrange(0, int(apts_df.iloc[apt_idx]["max"]))
#     residents = []
#     for i in range(n):
#         if (seeker_idx < seekers_df.shape[0]):
#             residents.append(seekers_df.iloc[seeker_idx]._id)
#             seekers_df.at[seeker_idx, "resident_apt"] = apts_df.at[apt_idx, "_id"]
#             seeker_idx += 1
#     apts_df.at[apt_idx, "residents"] = residents
#     apt_idx += 1

# for seeker in seekers_df.itertuples():
#     db.users2.find_one_and_update({"_id": seeker._1}, {"$set": {"resident_apt": seeker.resident_apt}})

# for apt in apts_df.itertuples():
#     db.apts.find_one_and_update({"_id": apt._1}, {"$set": {"residents": apt.residents}})
###################################################################################


# INSERTING OWNERS AND SEEKERS
###################################################################################
# for apt in apts_df.itertuples():
#     db.users2.update_many({"_id": apt.owner}, {"$set": {"owned_apt": apt._1}})

# local_seekers_df = pd.read_csv("datasets/seekers_large.csv")
# local_seekers_df.email = "seeker" + local_seekers_df.email
# for seeker in local_seekers_df.itertuples(index=False):
#     users2.insert_one({
#         "username": seeker.user_name,
#         "email": seeker.email,
#         "gender": seeker.gender,
#         "dob": seeker.date_of_birth,
#         "hobbies_pastimes": seeker.hobbies_pastimes,
#         "sports_activities": seeker.sports_activities,
#         "cultural_artistic": seeker.cultural_artistic,
#         "intellectual_academic": seeker.intellectual_academic,
#         "type": "seeker"
#     })

# for owner in df.itertuples(index=False):
#     users2.insert_one({
#         "username": owner.user_name,
#         "email": owner.email,
#         "gender": owner.gender,
#         "dob": owner.date_of_birth,
#         "hobbies_pastimes": owner.hobbies_pastimes,
#         "sports_activities": owner.sports_activities,
#         "cultural_artistic": owner.cultural_artistic,
#         "intellectual_academic": owner.intellectual_academic,
#         "type": "owner"
#     })
###################################################################################