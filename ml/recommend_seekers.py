#da begad 2a5er wa7ed
import pandas as pd
import db
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from seeker_class import Seeker

# Load seeker, owner, and rental listings datasets
owners_coll = db.users_collection.find({"type": "owner"})
seekers_coll = db.users_collection.find({"type": "seeker"})
owners_df = pd.DataFrame(list(owners_coll))
seekers_df = pd.DataFrame(list(seekers_coll))

# Combine interests from all four columns into a single column
owners_df['All Interests'] = owners_df[['hobbies_pastimes', 'sports_activities', 'cultural_artistic', 'intellectual_academic']].apply(lambda x: ', '.join(x.dropna()), axis=1)
seekers_df['All Interests'] = seekers_df[['hobbies_pastimes', 'sports_activities', 'cultural_artistic', 'intellectual_academic']].apply(lambda x: ', '.join(x.dropna()), axis=1)

# TF-IDF encoding for owner interests
tfidf_vectorizer = TfidfVectorizer()
owners_interests_tfidf = tfidf_vectorizer.fit_transform(owners_df['All Interests'])

# TF-IDF encoding for seeker interests
seekers_interests_tfidf = tfidf_vectorizer.transform(seekers_df['All Interests'])

# Compute cosine similarity between owner and seeker interest vectors
similarity_matrix = cosine_similarity(owners_interests_tfidf, seekers_interests_tfidf)

def recommend_seekers(owner_id):
    # Find the index of the current owner in the owners DataFrame
    owner = owners_df.loc[owners_df._id.astype("string") == owner_id]
    
    if not owner.index.empty:
        owner_index = owner.index.item()  # Extract the index value
        
        # Get similarity scores between the owner and potential seekers
        similarity_scores = similarity_matrix[owner_index]
        
        # Sort potential seekers based on similarity scores
        sorted_indices = similarity_scores.argsort()[::-1]  # Sort in descending order
        
        recommendations = []
        
        # Check if there are any potential seekers to recommend
        if len(sorted_indices) > 0:
            # Store recommendations
            for idx in sorted_indices:
                seeker_id = seekers_df.at[idx, '_id']
                similarity = similarity_scores[idx]
                
                # Count the number of common interests
                common_interests = sum(1 for interest in owners_df.iloc[owner_index]['All Interests'].split(', ') if interest in seekers_df.iloc[idx]['All Interests'].split(', '))
                
                # Only add recommendations where there are common interests
                if common_interests > 0:
                    recommendations.append(Seeker(str(seeker_id), common_interests, similarity))
                
        else:
            print("No recommendations found for the owner.")
    
        return recommendations
    else:
        print(f"Owner with owner ID {owner_id} not found.")

# Example usage:
# current_owner_id = "6627110027289ebf310aac7c"
# recommendations = recommend_seekers(current_owner_id)
# print(f"Recommendations for Owner {current_owner_id}:")
# for seeker in recommendations:
#     print(seeker.toJSON())