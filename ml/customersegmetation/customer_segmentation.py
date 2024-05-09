import pandas as pd
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
from sklearn.preprocessing import LabelEncoder

# Load the dataset
data = pd.read_csv("combined_results.csv")

# Drop non-numeric columns
numeric_data = data.drop(columns=['user_id'])

# Apply label encoding to convert categorical columns to numeric
label_encoder = LabelEncoder()
for column in numeric_data.columns:
    if numeric_data[column].dtype == 'object':
        numeric_data[column] = label_encoder.fit_transform(numeric_data[column])

# Find the optimal number of clusters using silhouette score
silhouette_scores = []
for num_clusters in range(2, 11):
    kmeans = KMeans(n_clusters=num_clusters, init='k-means++', max_iter=300, n_init=10, random_state=0)
    cluster_labels = kmeans.fit_predict(numeric_data)
    silhouette_avg = silhouette_score(numeric_data, cluster_labels)
    silhouette_scores.append((num_clusters, silhouette_avg))

# Find the number of clusters with the highest silhouette score
optimal_num_clusters = max(silhouette_scores, key=lambda x: x[1])[0]
print("Optimal number of clusters:", optimal_num_clusters)

# Build the K-means model with the optimal number of clusters
kmeans = KMeans(n_clusters=optimal_num_clusters, init='k-means++', max_iter=300, n_init=10, random_state=0)
cluster_labels = kmeans.fit_predict(numeric_data)

# Assign cluster labels to the original dataset
data['cluster'] = cluster_labels

# Analyze the clusters
cluster_counts = data['cluster'].value_counts()
print("Cluster counts:")
print(cluster_counts)

###el plots msh 3arfa hat7otaha w tezhar ezay?
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Assuming `numeric_data` contains your numerical features
pca = PCA(n_components=3)
principal_components = pca.fit_transform(numeric_data)

# Create a 3D scatter plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Scatter plot the principal components
scatter = ax.scatter(principal_components[:, 0], principal_components[:, 1], principal_components[:, 2], c=cluster_labels, cmap='viridis')

ax.set_xlabel('Principal Component 1')
ax.set_ylabel('Principal Component 2')
ax.set_zlabel('Principal Component 3')

# Add a color bar
legend = fig.colorbar(scatter, ax=ax, label='Cluster')

# Save the plot as an image file (e.g., PNG)
plt.savefig('3d_scatter_plot.png')

plt.show()


####el plot wl tany
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

fig = plt.figure(figsize=(8, 8))
ax = fig.add_subplot(111, projection='3d')

# Assuming `data` contains your dataset and `cluster_labels` contains the cluster labels
xs = numeric_data['hobbies_pastimes']
ys = numeric_data['sports_activities']
zs = numeric_data['cultural_artistic']

ax.scatter(xs, ys, zs, s=50, alpha=0.6, c=cluster_labels)

ax.set_xlabel('Hobbies/Pastimes')
ax.set_ylabel('Sports/Activities')
ax.set_zlabel('Cultural/Artistic')
# Save the plot as an image file (e.g., PNG)
plt.savefig('3d_scatter_plot2.png')
plt.show()

