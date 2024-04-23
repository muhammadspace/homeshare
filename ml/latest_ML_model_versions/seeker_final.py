#da 2a5er version
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Load seeker, owner, and rental listings datasets
seekers_df = pd.read_csv('seekers_large.csv')     # Update with your seeker dataset path
owners_df = pd.read_csv('interests_large.csv')        # Update with your owner dataset path
modified_rental_listings_df = pd.read_csv('modified_rental_listings.csv')  # Update with your rental listings dataset path

# Combine interests from all four columns into a single column
seekers_df['All Interests'] = seekers_df[['hobbies_pastimes', 'sports_activities', 'cultural_artistic', 'intellectual_academic']].apply(lambda x: ', '.join(x.dropna()), axis=1)
owners_df['All Interests'] = owners_df[['hobbies_pastimes', 'sports_activities', 'cultural_artistic', 'intellectual_academic']].apply(lambda x: ', '.join(x.dropna()), axis=1)

# TF-IDF encoding for seeker interests
tfidf_vectorizer = TfidfVectorizer()
seekers_interests_tfidf = tfidf_vectorizer.fit_transform(seekers_df['All Interests'])

# TF-IDF encoding for owner interests
owners_interests_tfidf = tfidf_vectorizer.transform(owners_df['All Interests'])

# Compute cosine similarity between seeker and owner interest vectors
similarity_matrix = cosine_similarity(seekers_interests_tfidf, owners_interests_tfidf)

def recommend_owners_and_apartments(seeker_id):
    # Find the index of the current seeker in the seekers DataFrame
    seeker_index = seekers_df.index[seekers_df['seeker_id'] == seeker_id]
    
    if not seeker_index.empty:
        seeker_index = seeker_index[0]  # Extract the index value
        
        # Get similarity scores between the seeker and potential owners
        similarity_scores = similarity_matrix[seeker_index]
        
        # Sort potential owners based on similarity scores
        sorted_indices = similarity_scores.argsort()[::-1]  # Sort in descending order
        
        # Flag to track if any recommendations are found
        recommendations_found = False
        
        # Print recommendations
        print(f"Recommendations for Seeker {seeker_id}:")
        for idx in sorted_indices:
            owner_id = owners_df.at[idx, 'owner_id']
            
            # Count the number of common interests
            common_interests = sum(1 for interest in seekers_df.iloc[seeker_index]['All Interests'].split(', ') if interest in owners_df.iloc[idx]['All Interests'].split(', '))
            
            # If common interests are non-zero, print recommendation
            if common_interests > 0:
                recommendations_found = True
                print(f"Owner ID: {owner_id}, Common Interests: {common_interests}")
                
                # Find apartments owned by the recommended owner
                owner_apartments = modified_rental_listings_df[modified_rental_listings_df['owner_id'] == owner_id]
                for _, apartment_row in owner_apartments.iterrows():
                    print(f"Property ID: {apartment_row['property_id']}")
                    print(f"Location: {apartment_row['Location']}")
                    print(f"Bedrooms: {apartment_row['Bedrooms']}, Bathrooms: {apartment_row['Bathrooms']}")
                    print(f"Price (USD): {apartment_row['price(USD)']}")
                    print(f"Start Date: {apartment_row['Start Date']}, End Date: {apartment_row['End Date']}")
                    print(f"Max Occupancy: {apartment_row['max']}, Number of Occupiers: {apartment_row['no_of_occupiers']}")
                    print(f"Seeker ID: {apartment_row['seeker_id']}")
                
                print()  # Add a newline for readability
        
        if not recommendations_found:
            print("No recommendations found for the seeker.")
    else:
        print(f"Seeker with seeker ID {seeker_id} not found.")

# Example usage:
current_seeker_id = 40
recommend_owners_and_apartments(current_seeker_id)