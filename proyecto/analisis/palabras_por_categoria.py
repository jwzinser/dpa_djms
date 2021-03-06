import sqlite3
import nltk
import pandas as pn
from nltk.tokenize import word_tokenize
from collections import Counter
import matplotlib.pyplot as plt
from wordcloud import WordCloud
from nltk.stem.snowball import SnowballStemmer
from resources.tools.auxiliar_functions import *



conn = sqlite3.connect('/Users/juanzinser/Documents/MCC/gran_escala/dpa_djms/proyecto/listverse.db')
stemmer = SnowballStemmer("english")
c = conn.cursor()
c.execute("""select distinct category from articles""")
categories = c.fetchall()
for category in categories:
    category = category[0]
    print category
    c.execute("""select * from articles where category='{category}'""".format(category=category))
    results = c.fetchall()

    texts = ' '.join([r[5] for r in results])
    tokenized_articles = nltk.regexp_tokenize(texts.lower(), r'\w+')

    # remove stopwords
    sw_file = open("resources/stopwords.txt", "r")
    sw = sw_file.readlines()
    sw_file.close()
    sw_all = ' '.join(sw).replace('\n',' ')
    """
    remove stopwords and stem words (so words with same root are grouped)
    """
    tokenized_articles = [stemmer.stem(word) for word in tokenized_articles if (word not in sw_all and not RepresentsInt(word))]

    word_counter = Counter(tokenized_articles)
    print word_counter.most_common(20)

    # wordcloud
    text = ' '.join(tokenized_articles)

    # Generate a word cloud image
    wordcloud = WordCloud().generate(text)
    plt.imshow(wordcloud)
    plt.axis("off")
    plt.savefig('plots/'+category+'_word_cloud.png',dpi=300)
    plt.close('all')

conn.close()
