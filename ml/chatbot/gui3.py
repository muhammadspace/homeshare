import tkinter as tk
from tkinter import scrolledtext
from tensorflow.keras.models import load_model
import json
import numpy as np
import nltk
from nltk.stem import WordNetLemmatizer
import pickle
import random

# Load the trained model
model = load_model('chatbot2_model.h5')

# Load the intents file
with open('new.json') as file:
    intents = json.load(file)

# Load the preprocessed data
words = pickle.load(open('word2.pkl', 'rb'))
classes = pickle.load(open('classes2.pkl', 'rb'))

# Initialize the WordNetLemmatizer
lemmatizer = WordNetLemmatizer()

# Function to preprocess the user's input
def clean_up_sentence(sentence):
    # Tokenize the pattern
    sentence_words = nltk.word_tokenize(sentence)
    # Lemmatize each word
    sentence_words = [lemmatizer.lemmatize(word.lower()) for word in sentence_words]
    return sentence_words

# Function to create the bag of words
def bag_of_words(sentence):
    # Tokenize the pattern
    sentence_words = clean_up_sentence(sentence)
    # Create the bag of words
    bag = [0]*len(words)  
    for w in sentence_words:
        for i, word in enumerate(words):
            if word == w: 
                bag[i] = 1
    return np.array(bag)

# Function to predict the intent
def predict_class(sentence):
    # Predict the intent
    p = bag_of_words(sentence)
    res = model.predict(np.array([p]))[0]
    ERROR_THRESHOLD = 0.25
    results = [[i, r] for i, r in enumerate(res) if r > ERROR_THRESHOLD]
    # Sort by strength of probability
    results.sort(key=lambda x: x[1], reverse=True)
    return_list = []
    for r in results:
        return_list.append({'intent': classes[r[0]], 'probability': str(r[1])})
    return return_list

# Function to get the response
def get_response(intents_list, intents_json):
    tag = intents_list[0]['intent']
    list_of_intents = intents_json['intents']
    for i in list_of_intents:
        if i['tag'] == tag:
            result = random.choice(i['responses'])
            break
    return result

# Function to handle user input
def send():
    msg = entry.get()
    entry.delete(0, tk.END)
    if msg != '':
        response = get_response(predict_class(msg), intents)
        chat_box.config(state=tk.NORMAL)
        chat_box.insert(tk.END, "You: " + msg + '\n\n')
        chat_box.insert(tk.END, "Bot: " + response + '\n\n')
        chat_box.config(state=tk.DISABLED)
        chat_box.see(tk.END)

# Create the GUI
root = tk.Tk()
root.title("Chatbot")

frame = tk.Frame(root)
frame.pack()

chat_box = scrolledtext.ScrolledText(frame, width=50, height=20)
chat_box.pack(side=tk.TOP)

entry = tk.Entry(frame, width=40)
entry.pack(side=tk.LEFT)

send_button = tk.Button(frame, text="Send", command=send)
send_button.pack(side=tk.RIGHT)

root.mainloop()
