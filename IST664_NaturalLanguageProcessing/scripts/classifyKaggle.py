''' 
  This program shell reads phrase data for the kaggle phrase sentiment classification problem.
  The input to the program is the path to the kaggle directory "corpus" and a limit number.
  The program reads all of the kaggle phrases, and then picks a random selection of the limit number.
  It creates a "phrasedocs" variable with a list of phrases consisting of a pair
    with the list of tokenized words from the phrase and the label number from 1 to 4
  It prints a few example phrases.
  In comments, it is shown how to get word lists from the two sentiment lexicons:
      subjectivity and LIWC, if you want to use them in your features
  Your task is to generate features sets and train and test a classifier.

  Usage:  python classifyKaggle.py  <corpus directory path> <limit number>
'''
# open python and nltk packages needed for processing
import os
import sys
import random
import nltk
import re
from nltk.corpus import stopwords, wordnet
from nltk.collocations import *
import pandas as pd
from sklearn.naive_bayes import MultinomialNB
from sklearn.feature_extraction import DictVectorizer

import sentiment_read_subjectivity
# initialize the positive, neutral and negative word lists
(positivelist, neutrallist, negativelist) = sentiment_read_subjectivity.read_subjectivity_three_types(
  'SentimentLexicons/subjclueslen1-HLTEMNLP05.tff')

import sentiment_read_LIWC_pos_neg_words
# initialize positve and negative word prefix lists from LIWC
#   note there is another function isPresent to test if a word's prefix is in the list
(poslist, neglist) = sentiment_read_LIWC_pos_neg_words.read_words()


# define a feature definition function here

# define features (keywords) of a document for a BOW/unigram baseline
# each feature is 'contains(keyword)' and is true or false depending
# on whether that keyword is in the document
def document_features(document, word_features):
    document_words = set(document)
    features = {}
    for word in word_features:
        features['V_{}'.format(word)] = (word in document_words)
    return features


# define features that include words as before
# add the most frequent significant bigrams
# this function takes the list of words in a document as an argument and returns a feature dictionary
# it depends on the variables word_features and bigram_features
def bigram_document_features(document, word_features, bigram_features):
    document_words = set(document)
    document_bigrams = nltk.bigrams(document)
    features = {}
    for word in word_features:
        features['V_{}'.format(word)] = (word in document_words)
    for bigram in bigram_features:
        features['B_{}_{}'.format(bigram[0], bigram[1])] = (bigram in document_bigrams)
    return features


# this function takes a document list of words and returns a feature dictionary
# it runs the default pos tagger (the Stanford tagger) on the document
#   and counts 4 types of pos tags to use as features
def POS_features(document, word_features):
    document_words = set(document)
    tagged_words = nltk.pos_tag(document)
    features = {}
    for word in word_features:
        features['contains({})'.format(word)] = (word in document_words)
    numNoun = 0
    numVerb = 0
    numAdj = 0
    numAdverb = 0
    for (word, tag) in tagged_words:
        if tag.startswith('N'): numNoun += 1
        if tag.startswith('V'): numVerb += 1
        if tag.startswith('J'): numAdj += 1
        if tag.startswith('R'): numAdverb += 1
    features['nouns'] = numNoun
    features['verbs'] = numVerb
    features['adjectives'] = numAdj
    features['adverbs'] = numAdverb
    return features


# This function defines features based on subjectivity; positive, negative, and neutral
def subj_features(document, word_features):
  document_words = set(document)
  features = {}
  for word in word_features:
    features['contains({})'.format(word)] = (word in document_words)
  numPos = 0
  numNeg = 0
  numNeu = 0

  for word in document_words:
    if word in positivelist: numPos += 1
    if word in negativelist: numNeg += 1
    if word in neutrallist: numNeu += 1

  features['positive'] = numPos
  features['negative'] = numNeg
  features['neutral'] = numNeu

  return features


# This function defines features based on LIWC; positive, negative
def LIWC_features(document, word_features):
  document_words = set(document)
  features = {}
  for word in word_features:
    features['contains({})'.format(word)] = (word in document_words)
  numPos = 0
  numNeg = 0

  for word in document_words:
    if word in poslist: numPos += 1
    if word in neglist: numNeg += 1

  features['positive'] = numPos
  features['negative'] = numNeg

  return features


# This function defines features based on subjectivity and LIWC; positive, negative, and neutral
def sent_features(document, word_features):
    document_words = set(document)
    features = {}
    for word in word_features:
        features['contains({})'.format(word)] = (word in document_words)
    numPos = 0
    numNeg = 0
    numNeu = 0


    for word in document_words:
        if word in poslist or word in positivelist: numPos += 1
        if word in neglist or word in negativelist: numNeg += 1
        if word in neutrallist: numNeu += 1

    features['positive'] = numPos
    features['negative'] = numNeg
    features['neutral'] = numNeu

    return features


def all_features(document, word_features, bigram_features):
  document_words = set(document)
  features = {}
  tagged_words = nltk.pos_tag(document)
  document_bigrams = nltk.bigrams(document)
  for word in word_features:
    features['contains({})'.format(word)] = (word in document_words)
  numPos = 0
  numNeg = 0
  numNeu = 0
  numNoun = 0
  numVerb = 0
  numAdj = 0
  numAdverb = 0

  for word in document_words:
    if word in poslist or word in positivelist: numPos += 1
    if word in neglist or word in negativelist: numNeg += 1
    if word in neutrallist: numNeu += 1

  for (word, tag) in tagged_words:
      if tag.startswith('N'): numNoun += 1
      if tag.startswith('V'): numVerb += 1
      if tag.startswith('J'): numAdj += 1
      if tag.startswith('R'): numAdverb += 1

  for word in word_features:
      features['V_{}'.format(word)] = (word in document_words)
  for bigram in bigram_features:
      features['B_{}_{}'.format(bigram[0], bigram[1])] = (bigram in document_bigrams)
  features['nouns'] = numNoun
  features['verbs'] = numVerb
  features['adjectives'] = numAdj
  features['adverbs'] = numAdverb
  features['positive'] = numPos
  features['negative'] = numNeg
  features['neutral'] = numNeu

  return features



# Function to compute precision, recall and F1 for each label
#  and for any number of labels
# Input: list of gold labels, list of predicted labels (in same order)
# Output:  prints precision, recall and F1 for each label
def eval_measures(gold, predicted):
    # get a list of labels
    labels = list(set(gold))
    # these lists have values for each label
    recall_list = []
    precision_list = []
    F1_list = []
    for lab in labels:
        # for each label, compare gold and predicted lists and compute values
        TP = FP = FN = TN = 0
        for i, val in enumerate(gold):
            if val == lab and predicted[i] == lab:  TP += 1
            if val == lab and predicted[i] != lab:  FN += 1
            if val != lab and predicted[i] == lab:  FP += 1
            if val != lab and predicted[i] != lab:  TN += 1
        # use these to compute recall, precision, F1
        if (TP + FP) == 0:
            recall = 0
        else:
            recall = TP / (TP + FP)
        if (TP + FN) == 0:
            precision = 0
        else:
            precision = TP / (TP + FN)
        recall_list.append(recall)
        precision_list.append(precision)
        if (recall + precision) == 0:
            F1_list.append(0)
        else:
            F1_list.append( 2 * (recall * precision) / (recall + precision))
    # the evaluation measures in a table with one row per label
    print('\tPrecision\tRecall\t\tF1')
    # print measures for each label
    for i, lab in enumerate(labels):
        print(lab, '\t', "{:10.3f}".format(precision_list[i]), \
          "{:10.3f}".format(recall_list[i]), "{:10.3f}".format(F1_list[i]))


## cross-validation ##
# this function takes the number of folds, the feature sets
# it iterates over the folds, using different sections for training and testing in turn
#   it prints the accuracy for each fold and the average accuracy at the end
def cross_validation_accuracy(num_folds, featuresets):
    subset_size = int(len(featuresets)/num_folds)
    print('Each fold size:', subset_size)
    accuracy_list = []
    # iterate over the folds
    for i in range(num_folds):
        test_this_round = featuresets[(i*subset_size):][:subset_size]
        train_this_round = featuresets[:(i*subset_size)] + featuresets[((i+1)*subset_size):]
        # train using train_this_round
        classifier = nltk.NaiveBayesClassifier.train(train_this_round)
        # evaluate against test_this_round and save accuracy
        accuracy_this_round = nltk.classify.accuracy(classifier, test_this_round)
        print (i, accuracy_this_round)
        accuracy_list.append(accuracy_this_round)
        goldlist = []
        predictedlist = []
        for (features, label) in test_this_round:
            goldlist.append(label)
            predictedlist.append(classifier.classify(features))
        eval_measures(goldlist, predictedlist)
    # find mean accuracy over all rounds
    print ('mean accuracy', sum(accuracy_list) / num_folds)

def accuracy_full(featuresets_train, featuresets_test):
    classifier = nltk.NaiveBayesClassifier.train(featuresets_train)
    prediction = []
    for feature in featuresets_test:
        prediction.append(classifier.classify(feature))
    with open('./prediction.csv','w') as f:
        for item in prediction:
            f.write(str(item)+"\n")



# function to read kaggle training file, train and test a classifier
def processkaggle(dirPath,limitStr):
  # convert the limit argument from a string to an int
  limit = int(limitStr)

  os.chdir(dirPath)

  df = pd.DataFrame.from_csv('./train.tsv', sep='\t')
  phrasedata = []
  for sid in df.SentenceId.unique():
      df_temp = df.loc[df['SentenceId'] == sid]
      phrases = []
      sentiment = []
      for p in df_temp['Phrase']:
          phrases.append(p)
      for s in df_temp['Sentiment']:
          sentiment.append(s)
      max_len = 0
      index = 0
      i = 0
      for phrase in phrases:
          if len(phrase) > max_len:
              max_len = len(phrase)
              index = i
          i += 1
      phrasedata.append((phrases[index], sentiment[index]))
      for i in range(len(phrases)):
          if len(phrases[i].split(" ")) <= 3:
              phrasedata.append((phrases[i], sentiment[i]))

  f= open('./train.tsv', 'r')
  # loop over lines in the file and use the first limit of them
  phrasedata_full = []
  for line in f:
    # ignore the first line starting with Phrase and read all lines
    if (not line.startswith('Phrase')):
      # remove final end of line character
      line = line.strip()
      # each line has 4 items separated by tabs
      # ignore the phrase and sentence ids, and keep the phrase and sentiment
      phrasedata_full.append(line.split('\t')[2:4])

  # pick a random sample of length limit because of phrase overlapping sequences
  random.shuffle(phrasedata)
  random.shuffle(phrasedata_full)

  phraselist = phrasedata[:limit]
  phraselist_2 = phrasedata_full[:limit]

  print('Read', len(phrasedata), 'filtered phrases, using', len(phraselist), 'random, uniformly distributed phrases')
  print('Read', len(phrasedata_full), 'phrases, using', len(phraselist_2), 'random phrases')

  # create list of phrase documents as (list of words, label)
  phrasedocs = []
  phrasedocs_2 = []
  # add all the phrases
  for phrase in phraselist:
    tokens = nltk.word_tokenize(phrase[0])
    phrasedocs.append((tokens, int(phrase[1])))

  for phrase in phraselist_2:
    tokens = nltk.word_tokenize(phrase[0])
    phrasedocs_2.append((tokens, int(phrase[1])))

  # punctuation
  temp_docs = []
  for item in phrasedocs:
      temp = []
      for token in item[0]:
          matchObj = re.search('[^a-zA-Z\d]', token)
          if not matchObj:
              temp.append(token.lower())
      temp_docs.append((temp, item[1]))
  phrasedocs = temp_docs

  temp_docs = []
  for item in phrasedocs_2:
      temp = []
      for token in item[0]:
          matchObj = re.search('[^a-zA-Z\d]', token)
          if not matchObj:
              temp.append(token.lower())
      temp_docs.append((temp, item[1]))
  phrasedocs_2 = temp_docs

  # stopwords, typos
  sw = set(stopwords.words('english'))
  phrasedocs_pp = []
  all_words_list = []
  phrasedocs_2_pp = []
  all_words_list_2 = []
  for item in phrasedocs:
    temp = []
    for token in item[0]:
      all_words_list.append(token.lower())
      if token not in sw and wordnet.synsets(token):
        temp.append(token)
      phrasedocs_pp.append((temp,item[1]))
  for item in phrasedocs_2:
    temp = []
    for token in item[0]:
      all_words_list_2.append(token.lower())
      if token not in sw and wordnet.synsets(token):
        temp.append(token)
      phrasedocs_2_pp.append((temp,item[1]))

  documents = phrasedocs
  documents_3 = phrasedocs_pp
  documents_3f = phrasedocs_2

  # continue as usual to get all words and create word features
  all_words = nltk.FreqDist(all_words_list)
  all_words_2 = nltk.FreqDist(all_words_list_2)
  # get the 1500 most frequently appearing keywords in the corpus
  word_items = all_words.most_common(1500)
  word_features = [word for (word, count) in word_items]

  word_items_2 = all_words_2.most_common(1500)
  word_features_2 = [word for (word, count) in word_items_2]
  # adding bigram features
  bigram_measures = nltk.collocations.BigramAssocMeasures()
  # create the bigram finder on all the words in sequence
  finder = BigramCollocationFinder.from_words(all_words_list)
  finder_2 = BigramCollocationFinder.from_words(all_words_list_2)
  # define the top 500 bigrams using the chi squared measure
  bigram_features = finder.nbest(bigram_measures.chi_sq, 500)
  bigram_features_2 = finder_2.nbest(bigram_measures.chi_sq, 500)

  # feature sets from a feature definition function
  print('Generating Feature sets for:')
  print('\tUnigrams, no preprocessing, from full dataset')
  featuresets_2 = [(document_features(d, word_features), c) for (d, c) in documents_3f]
  print('\tUnigrams, no preprocessing, filtered')
  featuresets = [(document_features(d, word_features), c) for (d, c) in documents]
  print('\tUnigrams, with preprocessing, filtered')
  featuresets_3 = [(document_features(d, word_features), c) for (d, c) in documents_3]
  print('\tBigrams, no preprocessing, filtered')
  bigram_featuresets = [(bigram_document_features(d, word_features, bigram_features), c) for (d, c) in documents]
  #print('\tBigrams, with preprocessing, filtered')
  #bigram_featuresets_3 = [(bigram_document_features(d, word_features, bigram_features), c) for (d, c) in documents_3]
  print('\tPOS Tags, no preprocessing, filtered')
  POS_featuresets = [(POS_features(d, word_features), c) for (d, c) in documents]
  #print('\tPOS Tags, with preprocessing, filtered')
  #POS_featuresets_3 = [(POS_features(d, word_features), c) for (d, c) in documents_3]
  print('\tSubjectivity, no preprocessing, filtered')
  subj_featuresets = [(subj_features(d, word_features), c) for (d, c) in documents]
  #print('\tSubjectivity, with preprocessing, filtered')
  #subj_featuresets_3 = [(subj_features(d, word_features), c) for (d, c) in documents_3]
  print('\tLIWC, no preprocessing, filtered')
  LIWC_featuresets = [(LIWC_features(d, word_features), c) for (d, c) in documents]
  #print('\tLIWC, with preprocessing, filtered')
  #LIWC_featuresets_3 = [(subj_features(d, word_features), c) for (d, c) in documents_3]
  print('\tSentiment, no preprocessing, filtered')
  sent_featuresets = [(sent_features(d, word_features), c) for (d, c) in documents]
  #print('\tSentiment, with preprocessing, filtered')
  #sent_featuresets_3 = [(subj_features(d, word_features), c) for (d, c) in documents_3]
  print('\tAll Features, with preprocessing, filtered')
  all_featuresets = [(all_features(d, word_features, bigram_features), c) for (d, c) in documents]

  # train classifier and show performance in cross-validation
  # perform the cross-validation on the featuresets with word features and generate accuracy
  print('\nword frequencies, from full dataset')
  cross_validation_accuracy(2, featuresets_2)

  print('\nword frequencies, filtered')
  cross_validation_accuracy(2, featuresets)

  print('\nword frequencies, with preprocessing, filtered')
  cross_validation_accuracy(2, featuresets_3)

  #print('\nbigram, filtered')
  #cross_validation_accuracy(5, bigram_featuresets)
  #skl(bigram_featuresets)
  print('\nbigram, without preprocessing, filtered')
  cross_validation_accuracy(2, bigram_featuresets)

  #print('\npos, filtered')
  #cross_validation_accuracy(5, POS_featuresets)
  #skl(POS_featuresets)
  print('\npos, without preprocessing, filtered')
  cross_validation_accuracy(2, POS_featuresets)

  #print('\nsubjectivity, filtered')
  #cross_validation_accuracy(5, subj_featuresets)
  #skl(subj_featuresets)
  print('\nsubjectivity, without preprocessing, filtered')
  cross_validation_accuracy(2, subj_featuresets)

  #print('\nLIWC, filtered')
  #cross_validation_accuracy(5, LIWC_featuresets)
  #skl(LIWC_featuresets)
  print('\nLIWC, without preprocessing, filtered')
  cross_validation_accuracy(2, LIWC_featuresets)

  #print('\nsentiment, filtered')
  #cross_validation_accuracy(5, sent_featuresets)
  #skl(sent_featuresets)
  print('\nsentiment, without preprocessing, filtered')
  cross_validation_accuracy(2, sent_featuresets)

  print('\nall features, without preprocessing, filtered')
  cross_validation_accuracy(2, all_featuresets)


# function to read kaggle training file, train and test a classifier
def processkaggle_full(dirPath):
  os.chdir(dirPath)
  df_train = pd.DataFrame.from_csv('./train.tsv', sep='\t')
  df_test = pd.DataFrame.from_csv('./test.tsv', sep='\t')

  phrases_train = list(df_train['Phrase'])
  sentiment_train = list(df_train['Sentiment'])
  phrases_test = list(df_test['Phrase'])
  #sentiment_test = list(df_test['Sentiment'])

  phrasedata_train = []
  for i in range(len(phrases_train)):
      phrasedata_train.append((phrases_train[i],sentiment_train[i]))

  phrasedata_test = []
  for i in range(len(phrases_test)):
      phrasedata_test.append(phrases_test[i])


  phraselist_train = phrasedata_train
  phraselist_test = phrasedata_test

  # create list of phrase documents as (list of words, label)
  phrasedocs_train = []
  # add all the phrases
  for phrase in phraselist_train:
    tokens = nltk.word_tokenize(phrase[0])
    phrasedocs_train.append((tokens, int(phrase[1])))

  # create list of phrase documents as (list of words, label)
  phrasedocs_test = []
  # add all the phrases
  for phrase in phraselist_test:
    tokens = nltk.word_tokenize(phrase[0])
    phrasedocs_test.append((tokens))


  # punctuation
  temp_docs = []
  for item in phrasedocs_train:
      temp = []
      for token in item[0]:
          matchObj = re.search('[^a-zA-Z\d]', token)
          if not matchObj:
              temp.append(token.lower())
      temp_docs.append((temp, item[1]))
  phrasedocs_train = temp_docs

  temp_docs = []
  for item in phrasedocs_test:
      temp = []
      for token in item:
          matchObj = re.search('[^a-zA-Z\d]', token)
          if not matchObj:
              temp.append(token.lower())
      temp_docs.append(temp)
  phrasedocs_test = temp_docs

  # stopwords, typos
  sw = set(stopwords.words('english'))
  phrasedocs_train_2 = []
  all_words_list_train = []
  for item in phrasedocs_train:
    temp = []
    for token in item[0]:
      all_words_list_train.append(token.lower())
      if wordnet.synsets(token):
        temp.append(token)
      phrasedocs_train_2.append((temp,item[1]))

  phrasedocs_test_2 = []
  all_words_list_test = []
  for item in phrasedocs_test:
    temp = []
    for token in item:
        all_words_list_test.append(token.lower())
        if wordnet.synsets(token):
            temp.append(token)
        phrasedocs_test_2.append(temp)


  documents_train = phrasedocs_train_2
  documents_test = phrasedocs_test_2

  # continue as usual to get all words and create word features
  all_words_train = nltk.FreqDist(all_words_list_train)
  all_words_test = nltk.FreqDist(all_words_list_test)
  # get the 1500 most frequently appearing keywords in the corpus
  word_items_train = all_words_train.most_common(1500)
  word_features_train = [word for (word, count) in word_items_train]

  word_items_test = all_words_test.most_common(1500)
  word_features_test = [word for (word, count) in word_items_test]
  # adding bigram features
  bigram_measures = nltk.collocations.BigramAssocMeasures()
  # create the bigram finder on all the words in sequence
  finder_train = BigramCollocationFinder.from_words(all_words_list_train)
  finder_test = BigramCollocationFinder.from_words(all_words_list_test)
  # define the top 500 bigrams using the chi squared measure
  bigram_features_train = finder_train.nbest(bigram_measures.chi_sq, 500)
  bigram_features_test = finder_test.nbest(bigram_measures.chi_sq, 500)

  # feature sets from a feature definition function
  print('Generating Feature sets for:')
  print('\tSentiment, full sample training set')
  documents_train = documents_train[0:10000]
  all_featuresets_train = [(sent_features(d, word_features_train), c) for (d, c) in documents_train]
  all_featuresets_test = [(sent_features(d, word_features_test)) for (d) in documents_test]

  # train classifier and show performance

  print('\nsentiment, with preprocessing, Full dataset')
  accuracy_full(all_featuresets_train, all_featuresets_test)


"""
commandline interface takes a directory name with kaggle subdirectory for train.tsv
   and a limit to the number of kaggle phrases to use
It then processes the files and trains a kaggle movie review sentiment classifier.

"""
if __name__ == '__main__':
    if (len(sys.argv) != 3):
        print ('usage: classifyKaggle.py <corpus-dir> <limit>')
        sys.exit(0)
    processkaggle(sys.argv[1], sys.argv[2])
    processkaggle_full(sys.argv[1])