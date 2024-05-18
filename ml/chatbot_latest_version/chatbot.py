from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
import json
import numpy as np
import nltk
from nltk.stem import WordNetLemmatizer
import pickle
import random

nltk.download('punkt')
nltk.download('wordnet')

basePath = "./chatbot_latest_version/"

# Load the trained model and other necessary files
model = load_model(basePath + 'chatbot2_model.h5')
intents = json.load(open(basePath + 'new.json'))
words = pickle.load(open(basePath + 'word2.pkl', 'rb'))
classes = pickle.load(open(basePath + 'classes2.pkl', 'rb'))
lemmatizer = WordNetLemmatizer()

def clean_up_sentence(sentence):
    sentence_words = nltk.word_tokenize(sentence)
    sentence_words = [lemmatizer.lemmatize(word.lower()) for word in sentence_words]
    return sentence_words

def bag_of_words(sentence):
    sentence_words = clean_up_sentence(sentence)
    bag = [0] * len(words)
    for s in sentence_words:
        for i, w in enumerate(words):
            if w == s:
                bag[i] = 1
    return np.array(bag)

def predict_class(sentence):
    bow = bag_of_words(sentence)
    res = model.predict(np.array([bow]))[0]
    ERROR_THRESHOLD = 0.25
    results = [[i, r] for i, r in enumerate(res) if r > ERROR_THRESHOLD]
    results.sort(key=lambda x: x[1], reverse=True)
    return_list = []
    for r in results:
        return_list.append({"intent": classes[r[0]], "probability": str(r[1])})
    return return_list

def get_response(intents_list, intents_json):
    tag = intents_list[0]['intent']
    list_of_intents = intents_json['intents']
    for i in list_of_intents:
        if i['tag'] == tag:
            result = random.choice(i['responses'])
            break
    return result

def sendMessage(message):
    ints = predict_class(message)
    res = get_response(ints, intents)
    return jsonify({"response": res})