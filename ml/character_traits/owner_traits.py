#da lel traits
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Load seeker, owner, and rental listings datasets
owners_df = pd.read_csv('owner_personality_data.csv')        # Update with your owner dataset path
seekers_df = pd.read_csv('seeker_personality_data.csv')     # Update with your seeker dataset path

# Combine interests from all four columns into a single column
owners_df['All Traits'] = owners_df[['personality_trait','value_belief','interpersonal_skill','work_ethic']].apply(lambda x: ', '.join(x.dropna()), axis=1)
seekers_df['All Traits'] = seekers_df[['personality_trait','value_belief','interpersonal_skill','work_ethic']].apply(lambda x: ', '.join(x.dropna()), axis=1)

# TF-IDF encoding for owner interests
tfidf_vectorizer = TfidfVectorizer()
owners_Traits_tfidf = tfidf_vectorizer.fit_transform(owners_df['All Traits'])

# TF-IDF encoding for seeker interests
seekers_Traits_tfidf = tfidf_vectorizer.transform(seekers_df['All Traits'])

# Compute cosine similarity between owner and seeker interest vectors
similarity_matrix = cosine_similarity(owners_Traits_tfidf, seekers_Traits_tfidf)

def recommend_seekers(owner_id):
    # Find the index of the current owner in the owners DataFrame
    owner_index = owners_df.index[owners_df['owner_id'] == owner_id]
    
    if not owner_index.empty:
        owner_index = owner_index[0]  # Extract the index value
        
        # Get similarity scores between the owner and potential seekers
        similarity_scores = similarity_matrix[owner_index]
        
        # Sort potential seekers based on similarity scores
        sorted_indices = similarity_scores.argsort()[::-1]  # Sort in descending order
        
        recommendations = []
        
        # Check if there are any potential seekers to recommend
        if len(sorted_indices) > 0:
            # Store recommendations
            for idx in sorted_indices:
                seeker_id = seekers_df.at[idx, 'seeker_id']
                similarity = similarity_scores[idx]
                
                # Count the number of common interests
                common_Traits = sum(1 for Trait in owners_df.iloc[owner_index]['All Traits'].split(', ') if Trait in seekers_df.iloc[idx]['All Traits'].split(', '))
                
                # Only add recommendations where there are common interests
                if common_Traits > 0:
                    recommendations.append((seeker_id, common_Traits, similarity))
                
        else:
            print("No recommendations found for the owner.")
    
        return recommendations
    else:
        print(f"Owner with owner ID {owner_id} not found.")

# Example usage:
current_owner_id = 40
recommendations = recommend_seekers(current_owner_id)
print(f"Recommendations for Owner {current_owner_id}:")
for seeker_id, common_Traits, similarity in recommendations:
    print(f"Seeker ID: {seeker_id}, Common Interests: {common_Traits}, Similarity: {similarity}")