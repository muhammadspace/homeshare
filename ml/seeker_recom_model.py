import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import json

# Load seeker and owner datasets separately
seekers_df = pd.read_csv('seekers.csv')  # Assuming you have a CSV file containing seeker data
owners_df = pd.read_csv('owners.csv')    # Assuming you have a CSV file containing owner data

# Load the apartments dataset
apartments_df = pd.read_csv('apartments.csv')  # Assuming you have a CSV file containing apartment data

# TF-IDF encoding for seeker interests
tfidf_vectorizer = TfidfVectorizer()
seekers_interests_tfidf = tfidf_vectorizer.fit_transform(seekers_df['interests'])

# TF-IDF encoding for owner interests
owners_interests_tfidf = tfidf_vectorizer.transform(owners_df['interests'])

# Compute cosine similarity between seeker and owner interest vectors
similarity_matrix = cosine_similarity(seekers_interests_tfidf, owners_interests_tfidf)

class Apt:
    def __init__(self, id, location):
        self.id = id
        self.location = location

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)

    def serialize(self):
        return self.toJSON()

def jsoner(o):
    print(o.type())
    print(o.isinstance())
    if o.__dir__().count("__dict__"):
        return o.__dict__
    else:
        return o.toJSON()

class Owner:
    def __init__(self, id, common_interests, apts = []):
        self.id = id
        self.common_interests = common_interests
        self.apts = apts

    def addApt(self, apt):
        # self.apts.append(apt)
        pass

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)
        # return json.dumps(self, default=jsoner, sort_keys=True, indent=4)

    def serialize(self):
        return self.toJSON()

def recommend_owners_and_apartments(seeker_id, top_n=10):
    # Find the index of the current seeker in the seekers DataFrame
    seeker_index = seekers_df.index[seekers_df['user_id'] == seeker_id]
    recommended_owners = []
    
    if not seeker_index.empty:
        seeker_index = seeker_index[0]  # Extract the index value
        
        # Get similarity scores between the seeker and potential owners
        similarity_scores = similarity_matrix[seeker_index]
        
        # Sort potential owners based on similarity scores
        sorted_indices = similarity_scores.argsort()[::-1]  # Sort in descending order
        
        # Check if there are any potential owners to recommend
        if len(sorted_indices) > 0:
            # Print recommendations
            print(f"Recommendations for Seeker {seeker_id}:")
            for idx in sorted_indices[:top_n]:
                owner_id = owners_df.at[idx, 'owner_id']
                common_interests = similarity_scores[idx]
                print(f"Owner ID: {owner_id}, Common Interests: {common_interests}")

                owner = Owner(int(owner_id), common_interests)
                
                # Find apartments owned by the recommended owner
                owner_apartments = apartments_df[apartments_df['owner_id'] == owner_id]

                for _, apartment_row in owner_apartments.iterrows():
                    apt = Apt(int(apartment_row['apartment_id']), apartment_row['location'])
                    owner.addApt(Apt)
                    print(f"Apartment ID: {apartment_row['apartment_id']}, Location: {apartment_row['location']}")
                
                print()  # Add a newline for readability

                recommended_owners.append(owner)
        else:
            print("No recommendations found for the seeker.")
            return 0
    else:
        print(f"Seeker with user ID {seeker_id} not found.")
        return -1

    print(recommended_owners)
    return recommended_owners

# Example usage:
# current_seeker_id = 30
# recommend_owners_and_apartments(current_seeker_id)
