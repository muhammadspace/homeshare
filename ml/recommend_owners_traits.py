#da 2a5er version
import pandas as pd
import db
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from owner_class import Owner, Apt

# Load seeker, owner, and rental listings datasets
owners_coll = db.users_collection.find({"type": "owner"})
seekers_coll = db.users_collection.find({"type": "seeker"})
apts_coll = db.db.apts.find()
owners_df = pd.DataFrame(list(owners_coll))
seekers_df = pd.DataFrame(list(seekers_coll))
apts_df = pd.DataFrame(list(apts_coll))

# print(owners_df)
# print(seekers_df)
# print(apts_df)

# Combine interests from all four columns into a single column
owners_df['All Traits'] = owners_df[['personality_trait','value_belief','interpersonal_skill','work_ethic']].apply(lambda x: ', '.join(x.dropna()), axis=1)
seekers_df['All Traits'] = seekers_df[['personality_trait','value_belief','interpersonal_skill','work_ethic']].apply(lambda x: ', '.join(x.dropna()), axis=1)

# TF-IDF encoding for seeker interests
tfidf_vectorizer = TfidfVectorizer()
seekers_interests_tfidf = tfidf_vectorizer.fit_transform(seekers_df['All Traits'])

# TF-IDF encoding for owner interests
owners_interests_tfidf = tfidf_vectorizer.transform(owners_df['All Traits'])

# Compute cosine similarity between seeker and owner interest vectors
similarity_matrix = cosine_similarity(seekers_interests_tfidf, owners_interests_tfidf)

def recommend_owners_traits(seeker_id):
    # Find the index of the current seeker in the seekers DataFrame
    seeker = seekers_df.loc[seekers_df._id.astype("string") == seeker_id]
    
    if not seeker.index.empty:
        seeker_index = seeker.index.item()
        
        # Get similarity scores between the seeker and potential owners
        similarity_scores = similarity_matrix[seeker_index]
        
        # Sort potential owners based on similarity scores
        sorted_indices = similarity_scores.argsort()[::-1]  # Sort in descending order
        
        # Flag to track if any recommendations are found
        recommendations_found = False
        
        # Print recommendations
        # print(f"Recommendations for Seeker {seeker_id}:")
        recommendations = []
        for idx in sorted_indices:
            owner_series = owners_df.iloc[idx]
            
            if pd.isna(owner_series.owned_apt):
                print(f"owner {owner_series._id} does not have an apartment")
                continue
                
            # owner_id = owners_df.at[idx, '_id']
            owner_id = owner_series._id
            
            # Count the number of common interests
            common_interests = sum(1 for interest in seekers_df.iloc[seeker_index]['All Traits'].split(', ') if interest in owner_series['All Traits'].split(', '))
            
            # If common interests are non-zero, print recommendation
            if common_interests > 0:
                recommendations_found = True

                owner_apartment = apts_df[apts_df._id == owner_series.owned_apt]
                # owner_apartment = apts_df[apts_df.owner == owner_id]
                if owner_apartment.admin_approval.item() == "pending":
                    print("skipped")
                    continue
                owner = Owner(owner_id, common_interests, Apt(owner_apartment))
                
                recommendations.append(owner)

                # Find apartments owned by the recommended owner
                # owner_apartments = apts_df[apts_df.owner == owner_id]
                # for _, apartment_row in owner_apartments.iterrows():
                #     print(f"Property ID: {apartment_row['_id']}")
                #     print(f"Location: {apartment_row['location']}")
                #     print(f"Bedrooms: {apartment_row['bedrooms']}, Bathrooms: {apartment_row['bathrooms']}")
                #     print(f"Price (USD): {apartment_row['price']}")
                #     print(f"Start Date: {apartment_row['start_date']}, End Date: {apartment_row['end_date']}")
                #     print(f"Max Occupancy: {apartment_row['max']}, Number of Occupiers: {len(apartment_row['residents'])}")
                #     print(f"Residents: {apartment_row['residents']}")
                
                # print()  # Add a newline for readability
        return recommendations
        
        if not recommendations_found:
            return {"success": False, "message": "No recommendations found for the seeker."}
    else:
        return {"success": False, "message": f"No seekers with ID {seeker_id} were found."}

# Example usage:
# current_seeker_id = "662711bf0942111626be5d6b"
# print(recommend_owners(current_seeker_id))