#This makes the Naive Bayes Classifier
#Concepts used: Logistic regression, stochastic gradient descent,
#data cleaning, confusion matrices, k-fold cross validation

from csv import DictReader, DictWriter

import numpy as np
from numpy import array

import random

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import SGDClassifier

import re

import argparse
import string
from collections import defaultdict
import operator

from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score

kTAGSET = ["", "Married", "Divorced" ]
#0 = Married, 2 = Divorced

class Featurizer:
    def __init__(self):
        self.vectorizer = CountVectorizer(binary=True)

    def train_feature(self, examples):
        return self.vectorizer.fit_transform(examples)

    def test_feature(self, examples):
        return self.vectorizer.transform(examples)

    def show_top10(self, classifier, categories):
        feature_names = np.asarray(self.vectorizer.get_feature_names())
        for i, category in enumerate(categories):
            top10 = np.argsort(classifier.coef_[i])[-10:]
            print("%s: %s" % (category, " ".join(feature_names[top10])))
            
    def organize_top10(self, classifier, categories):
        feature_names = np.asarray(self.vectorizer.get_feature_names())
        i, category = 0, "Married"
        top10 = np.argsort(classifier.coef_[i])[-10:]
        print("%s: %s" % (category, " ".join(feature_names[top10])))
        i, category = 0, "Divorced"
        top10 = np.argsort(-1*classifier.coef_[i])[-10:]
        print("%s: %s" % (category, " ".join(feature_names[top10])))

def accuracy(classifier, x, y, examples):
    predictions = classifier.predict(x)
    cm = confusion_matrix(y, predictions)

    print("Accuracy: %f" % accuracy_score(y, predictions))

    print("\t".join(kTAGSET[1:]))
    for ii in cm:
        print("\t".join(str(x) for x in ii))  
        
def crossValidate(train_attributes, train, test_attributes, test, labels, K): 

    x_train = feat.train_feature(x for x in train_attributes)
    y_train = array(list(labels.index(x['iMarital']) for x in train))
    
    x_test = feat.test_feature(x for x in test_attributes)
    y_test = array(list(labels.index(x['iMarital']) for x in test))

    # Train classifier
   
    lr = SGDClassifier(loss='log', penalty='l2', shuffle=True)
    lr.fit(x_train, y_train)

    #feat.organize_top10(lr, labels) 
     
    print "" 
    print "TEST", K+1, "FOLD\n----------------------"
    accuracy(lr, x_test, y_test, (x['iMarital'] for x in test))
    
def kfold(attributes, train, labels, K = 10):
    bucket = len(train)/K
    
    values = []
    for k in xrange(0, K):
        random.shuffle(train)
        asTest = train[:bucket]
        asTrain = train[bucket:]
        train_att = attributes[bucket:]
        test_att = attributes[:bucket]
        crossValidate(train_att, asTrain, test_att, asTest, labels, k)
       

if __name__ == "__main__":

    # Cast to list to keep it all in memory
    train = list(DictReader(open("train.csv", 'r')))

    temp = []
    for line in train:
        if (line['iMarital'] == '0' or line['iMarital'] == '2'):
            temp.append(line)
    train = temp
    
    labels = [] 
    for line in train:
        if not line['iMarital'] in labels:
            labels.append(line['iMarital'])  
    
    feat = Featurizer()
    
    attributes = []
    ignore = ["iMarital", "iRspouse", "iRelat1", "iRelat2", "iSubfam1", "iSubfam2", "caseid"]
    for line in train:
        temp_line = []
        for key, value in line.iteritems():
            if key not in ignore:
                temp_token = key + "Q" + value + " "
            temp_line.append(temp_token)
        attributes.append(" ".join(temp_line))
       
    kfold(attributes, train, labels)   
