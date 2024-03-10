#hena ba7awel 2a5aly yraga3 kol el users ely leeh ma3ahom 7agat in common msh bs el top 3 or top4
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import json

#hena me7ataga a passelo el dataset bta3et el owner bs
# Load dataset containing user interests
user_interests_df = pd.read_csv('datasets/trials.csv')  # Update with your dataset path 

# Create TF-IDF vectorizer
vectorizer = TfidfVectorizer()

# Fit-transform the interests to TF-IDF vectors
interests_tfidf = vectorizer.fit_transform(user_interests_df['Interests'])

# Calculate cosine similarity between users
user_similarity_matrix = cosine_similarity(interests_tfidf)

class Owner:
    def __init__(self, id, common_interests, similarity):
        self.id = id
        self.common_interests = common_interests
        self.similarity = similarity

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)

    def serialize(self):
        return self.toJSON()


# Function to generate recommendations for a target user
def generate_recommendations(target_user):
    target_index = user_interests_df[user_interests_df['User'] == target_user].index[0]
    similarities = user_similarity_matrix[target_index]
    
    # Sort indices by similarity (excluding the target user)
    similar_users_indices = similarities.argsort()[::-1][1:]

    # Get recommended users based on common interests
    recommended_users = []
    for index in similar_users_indices:
        common_interests = set(user_interests_df.iloc[target_index]['Interests'].split(', ')).intersection(set(user_interests_df.iloc[index]['Interests'].split(', ')))
        if len(common_interests) > 0:
            # recommended_users.append((user_interests_df.iloc[index]['User'], len(common_interests), similarities[index]))
            owner = Owner(int(user_interests_df.iloc[index]['User']), int(len(common_interests)), similarities[index])
            recommended_users.append(owner)

    # Sort recommended users by the similarity score
    print(recommended_users)
    recommended_users.sort(key=lambda x: x.similarity, reverse=True)

    return recommended_users

# Example 
# target_user = 1  #  target user
# recommendations = generate_recommendations(target_user)
# print(f"Recommended users for {target_user}:")
# for user, common_interests, similarity in recommendations:
#     print(f"User: {user}, Common Interests: {common_interests}, Similarity: {similarity}")