import nltk
from nltk.stem import WordNetLemmatizer
import json
import pickle
import numpy as np
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation, Dropout
from tensorflow.keras.optimizers import SGD
import random

# Initialize WordNetLemmatizer
lemmatizer = WordNetLemmatizer()

# Read intents from JSON file (make sure to update the file name)
data_file = open('new.json').read()
intents = json.loads(data_file)

# Initialize lists
words = []
classes = []
documents = []
ignore_words = ['?', '!']

# Loop through each intent
for intent in intents['intents']:
    # Loop through each pattern
    for pattern in intent['patterns']:
        # Tokenize each word
        w = nltk.word_tokenize(pattern)
        words.extend(w)
        # Add documents in the corpus
        documents.append((w, intent['tag']))
        # Add to classes list
        if intent['tag'] not in classes:
            classes.append(intent['tag'])

# Lemmatize and lowercase each word and remove duplicates
words = [lemmatizer.lemmatize(w.lower()) for w in words if w not in ignore_words]
words = sorted(list(set(words)))
# Sort classes
classes = sorted(list(set(classes)))

# Create training data
training = []
output_empty = [0] * len(classes)

# Create bag of words for each sentence
for doc in documents:
    bag = []
    pattern_words = doc[0]
    pattern_words = [lemmatizer.lemmatize(word.lower()) for word in pattern_words]
    for w in words:
        bag.append(1) if w in pattern_words else bag.append(0)
    output_row = list(output_empty)
    output_row[classes.index(doc[1])] = 1
    training.append((bag, output_row))

# Shuffle the training data
random.shuffle(training)

# Separate bag and output_row into separate arrays
bag_array = np.array([t[0] for t in training])
output_array = np.array([t[1] for t in training])

# Create model
model = Sequential()
model.add(Dense(128, input_shape=(len(bag_array[0]),), activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(64, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(len(output_array[0]), activation='softmax'))

# Compile model
sgd = SGD(learning_rate=0.01, momentum=0.9, nesterov=True)
model.compile(loss='categorical_crossentropy', optimizer=sgd, metrics=['accuracy'])

# Fit model
hist = model.fit(bag_array, output_array, epochs=200, batch_size=5, verbose=1)

# Save model
model.save('chatbot2_model.h5')

# Save words and classes
pickle.dump(words, open('word2.pkl', 'wb'))
pickle.dump(classes, open('classes2.pkl', 'wb'))

print("Model created and saved")
