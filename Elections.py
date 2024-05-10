# + editable=true slideshow={"slide_type": ""}
import re 
import tweepy 
from tweepy import OAuthHandler 
from textblob import TextBlob 
import os
import pandas as pd
import matplotlib.pyplot as plt
import nltk
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.corpus import stopwords
import numpy as np
from nltk.tokenize import ToktokTokenizer
from nltk.classify import NaiveBayesClassifier
from nltk.sentiment.vader import SentimentIntensityAnalyzer
import time
import string


# -

class TwitterClient(object): 
    ''' Generic Twitter Class for sentiment analysis. '''
    
    def __init__(self): 
        ''' Class constructor or initialization method. '''
        # keys and tokens from the Twitter Dev Console 
        consumer_key= 'xxxxxx' # Enter the key provided by Twitter
        consumer_secret= 'xxxxxx' # Enter the key provided by Twitter
        access_token= 'xxxxxx' # Enter the key provided by Twitter
        access_token_secret= 'xxxxxx' # Enter the key provided by Twitter
        # attempt authentication 
        try: 
            # create OAuthHandler object 
            self.auth = OAuthHandler(consumer_key, consumer_secret) 
            # set access token and secret 
            self.auth.set_access_token(access_token, access_token_secret) 
            # create tweepy API object to fetch tweets 
            self.api = tweepy.API(self.auth) 
        except: 
            print("Error: Authentication Failed") 
            
            
    def clean_tweet(self, tweet): 
        ''' Utility function to clean tweet text by removing links, special characters using simple regex statements. '''
        return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split()) 
    
    
    def get_tweet_sentiment(self, tweet): 
        ''' Utility function to classify sentiment of passed tweet using textblob's sentiment method '''
        # create TextBlob object of passed tweet text 
        analysis = TextBlob(self.clean_tweet(tweet)) 
        # set sentiment 
        if analysis.sentiment.polarity > 0: 
            return 'positive'
        elif analysis.sentiment.polarity == 0: 
            return 'neutral'
        else: 
            return 'negative'
        
        
    def appendDFToCSV_void(self, df, sep=","):
        ''' Utility function to save tweets in csv file '''
        csvFilePath = "tweets.csv"
        if not os.path.isfile(csvFilePath):
            df.to_csv(csvFilePath, mode='a', index=False, sep=sep)
        elif len(df.columns) != len(pd.read_csv(csvFilePath, nrows=1, sep=sep).columns):
            raise Exception("Columns do not match!! Dataframe has " + str(len(df.columns)) + " columns. CSV file has " + str(len(pd.read_csv(csvFilePath, nrows=1, sep=sep).columns)) + " columns.")
        elif not (df.columns == pd.read_csv(csvFilePath, nrows=1, sep=sep).columns).all():
            raise Exception("Columns and column order of dataframe and csv file do not match!!")
        else:
            df.to_csv(csvFilePath, mode='a', index=False, sep=sep, header=False)
            
        
    def get_tweets(self, query, count): 
        ''' Main function to fetch tweets and parse them. '''
        # empty list to store parsed tweets 
        tweets = [] 

        try: 
            # call twitter api to fetch tweets 
            fetched_tweets = self.api.search(q = query, count = count) 

            # parsing tweets one by one 
            for tweet in fetched_tweets: 
                # empty dictionary to store required params of a tweet 
                parsed_tweet = {} 
                #saving tweet about
                parsed_tweet['tag'] = query
                # saving text of tweet 
                parsed_tweet['text'] = tweet.text 
                # saving sentiment of tweet 
                parsed_tweet['sentiment'] = self.get_tweet_sentiment(tweet.text)
                # saving candidate name 
                if(query == '#Trump2020 OR @realdonaldtrump'):              
                    parsed_tweet['name'] = 'Donald Trump'
                elif(query == '#Warren2020 OR @ewarren'):
                    parsed_tweet['name'] = 'Elizabeth Warren'
                elif(query == '#Sanders2020 OR @BernieSanders'):
                    parsed_tweet['name'] = 'Bernie Sanders'
                elif(query == '#Biden2020 OR @JoeBiden'):
                    parsed_tweet['name'] = 'Joe Biden'

                # appending parsed tweet to tweets list 
                if tweet.retweet_count > 0: 
                    # if tweet has retweets, ensure that it is appended only once 
                    if parsed_tweet not in tweets: 
                        tweets.append(parsed_tweet) 
                    else: 
                        tweets.append(parsed_tweet) 
                
            #save tweets in csv file
            dftweets = pd.DataFrame(data=tweets, columns=['tag','text','sentiment','name'])           
            self.appendDFToCSV_void(dftweets)
                
            # return parsed tweets 
            return tweets 

        except tweepy.TweepError as e: 
            # print error (if any) 
            print("Error : " + str(e)) 
            

def main(query): 
    # creating object of TwitterClient Class 
    api = TwitterClient() 
    # calling function to get tweets 
    tweets = api.get_tweets(query = query, count = 5000) 
    
    #Sentiment Analysis
    print("\nTweets about : ",query)
    # picking positive tweets from tweets 
    ptweets = [tweet for tweet in tweets if tweet['sentiment'] == 'positive'] 
    # percentage of positive tweets 
    print("Positive tweets percentage: {} %".format(100*len(ptweets)/len(tweets))) 
    # picking negative tweets from tweets 
    ntweets = [tweet for tweet in tweets if tweet['sentiment'] == 'negative'] 
    # percentage of negative tweets 
    print("Negative tweets percentage: {} %".format(100*len(ntweets)/len(tweets))) 
    # percentage of neutral tweets 
    print("Neutral tweets percentage: {} %".format(100*(len(tweets)-len(ntweets)-len(ptweets))/len(tweets))) 



if __name__ == "__main__": 
    
    # delete existing csv file
    csvFilePath = "tweets.csv"
    if os.path.isfile(csvFilePath):
        os.remove(csvFilePath)
            
    # calling main function
    # analyzing positive and negative tweets for each presidential candidate
    main('#Trump2020 OR @realdonaldtrump') 
    main('#Warren2020 OR @ewarren')
    main('#Sanders2020 OR @BernieSanders')
    main('#Biden2020 OR @JoeBiden')
    

# read tweets csv file 
dftweetsdata = pd.read_csv('tweets.csv')
dftweetsdata

# positive, negative and neutral sentiment by candidate
candidate_sentiment = dftweetsdata.groupby(['name', 'sentiment']).sentiment.count().unstack()
candidate_sentiment.plot(kind='bar')

# number of tweets for each candidate
dftweetsdata.name.value_counts().plot(kind='pie', autopct='%1.0f%%')

# distribution of sentiments across the tweets
dftweetsdata.sentiment.value_counts().plot(kind='pie', autopct='%1.0f%%', colors=["red", "yellow", "green"])

# +
df_neg = dftweetsdata[dftweetsdata.sentiment == "negative"]
df_pos = dftweetsdata[dftweetsdata.sentiment == "positive"]
neg_content = list(df_neg.text)
pos_content = list(df_pos.text)
neg_blob = " ".join(neg_content)
pos_blob = " ".join(pos_content)

neg_words = word_tokenize(neg_blob)
pos_words = word_tokenize(pos_blob)

stop_words = set(stopwords.words("english"))

filtered_neg_words = []
filtered_pos_words = []

for w in neg_words:
    if w not in stop_words:
        filtered_neg_words.append(w)

for w in pos_words:
    if w not in stop_words:
        filtered_pos_words.append(w)

# +
neg_tweets = dftweetsdata[dftweetsdata["sentiment"] == "negative"]["text"]
pos_tweets = dftweetsdata[dftweetsdata["sentiment"] == "positive"]["text"]

neg_words = []
pos_words = []

def extractNegativeWords(neg_tweets):
    global neg_words
    words = [word.lower() for word in word_tokenize(neg_tweets) if word.lower() not in stopwords.words("english") and word.lower().isalpha()]
    neg_words = neg_words + words
    
def extractPositiveWords(pos_tweets):
    global pos_words
    words = [word.lower() for word in word_tokenize(pos_tweets) if word.lower() not in stopwords.words("english") and word.lower().isalpha()]
    pos_words = pos_words + words
    
neg_tweets.apply(extractNegativeWords)
pos_tweets.apply(extractPositiveWords)
# -

neg_words = np.array(neg_words)
print("Top 10 Negative words are :\n")
pd.Series(neg_words).value_counts().head(n = 10)

pos_words = np.array(pos_words)
print("Top 10 Positive words are :\n")
pd.Series(pos_words).value_counts().head(n = 10)

# +
toktok = ToktokTokenizer()

remove_punct_and_digits = dict([(ord(punct), ' ') for punct in string.punctuation + string.digits])
stopWords = set(stopwords.words('english'))

def word_cleaner(data):
    cleaned_word = data.lower().translate(remove_punct_and_digits)
    words = word_tokenize(cleaned_word)
    words = [toktok.tokenize(sent) for sent in sent_tokenize(cleaned_word)]
    wordsFiltered = []
    if not words:
        pass
    else:
        for w in words[0]:
            if w not in stopWords:
                wordsFiltered.append(w)
                end=time.time()
    return wordsFiltered


# +
def word_feats(words):
    return dict([(word, True) for word in words])

neg_set=[(word_feats(word_feats(word_cleaner(neg_words[i]))), 0) for i in range(len(neg_words))]
pos_set=[(word_feats(word_feats(word_cleaner(pos_words[i]))), 1) for i in range(len(pos_words))]
print(neg_set)

negcutoff = int(len(neg_set)*3/4)
poscutoff = int(len(pos_set)*3/4)
 
trainfeats = neg_set[:negcutoff] + pos_set[:poscutoff]
testfeats = neg_set[negcutoff:] + pos_set[poscutoff:]
print(len(trainfeats), len(testfeats))
# -

classifier = NaiveBayesClassifier.train(trainfeats)
print('Accuracy is:', nltk.classify.util.accuracy(classifier, testfeats))

# + editable=true slideshow={"slide_type": ""}
sentences = dftweetsdata['text']

sid = SentimentIntensityAnalyzer()
for sentence in sentences:
     print(sentence)
     ss = sid.polarity_scores(sentence)
     for k in sorted(ss):
         print('{0}: {1}, '.format(k, ss[k]), end='')
         score = ss['compound']
         print('Sentiment:', score)
     print()
# -




