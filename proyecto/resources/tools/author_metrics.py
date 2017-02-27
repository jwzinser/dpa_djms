


#returns the number of sentences in text
def count_sents(text):
    sents = nltk.sent_tokenize(text);
    num_sents = len(sents);
    return num_sents;

#returns the number of tokens in text
def count_tokens(text):
    tokens = nltk.word_tokenize(text);
    num_tokens = len(tokens);
    return num_tokens;

#returns the number of tokens without punctuations in text
def count_tokens_wop(text):
    tokens_wop = nltk.word_tokenize(text.translate(None, string.punctuation));
    num_tokens_wop = len(tokens_wop);
    return num_tokens_wop;

#returns fraction of tokens that are punctuations
def frac_puncs(text):
    num_tokens = count_tokens(text);
    num_tokens_wop = count_tokens_wop(text);
    return (float(num_tokens - num_tokens_wop))/(float(num_tokens));

#returns average token length
def avg_token_len(text):
    tokens = nltk.word_tokenize(text);
    total_len=0;
    for token in tokens:
        total_len = total_len + len(token);
    return (float(total_len))/(float(len(tokens)));

#returns average sentence length (in terms of words)
def avg_sent_len1(text):
    sents = nltk.sent_tokenize(text);
    total_len=0;
    for sent in sents:
        total_len = total_len + count_tokens(sent);
    return (float(total_len))/(float(len(sents)));

#returns average sentence length (in terms of chars)
def avg_sent_len2(text):
    sents = nltk.sent_tokenize(text);
    total_len=0;
    for sent in sents:
        total_len = total_len + len(sent);
    return (float(total_len))/(float(len(sents)));


#returns standard deviation of lengths of tokens
def stdev_token_len(text):
    tokens = nltk.word_tokenize(text);
    len_array = [];
    for token in tokens:
        len_array.append(len(token));
    return np.std(np.array(len_array));
"""
#returns standard deviation of lengths of sentences (wrt words)
def stdev_sent_len1(text):
    tokens = nltk.word_tokenize(text);
    len_array = [];
    for token in tokens:
        len_array.append(len(token));
    return np.std(np.array(len_array));
"""

#returns standard deviation of lengths of tokens
def stdev_token_len(text):
    tokens = nltk.word_tokenize(text);
    len_array = [];
    for token in tokens:
        len_array.append(len(token));
    return np.std(np.array(len_array));

#returns number of digits in the text
def num_digits(text):
    ans=0;
    for c in text:
        if(c.isdigit()):
            ans = ans+1;
    return ans;

def similarity(text):
    # hash using winnowing algorithm
    currmax=-1;
    res = ''
    print >>sys.stderr , len(text)
    for i,x in enumerate(author_text):
        winnow1 = itx.algorithms.winnow(text[:2000])
        winnow2 = itx.algorithms.winnow(author_text[x][:2000])
        # look for matches of at least 'threshold' hashes
        a = itx.compare_fingerprints(winnow1, winnow2, threshold=3)
        if len(a)>currmax:
            currmax=len(a);
            res=x;
    return res

#returns the array with additional feature values
def extra_feats(text):
    feat_array=[];
    if(features_are_on):
        feat_array.append(count_tokens(text));            #number of tokens
        # feat_array.append(count_sents(text));            #number of sentences ??? Not a good feature
        feat_array.append(frac_puncs(text));            #fraction of punctuations
        # feat_array.append(avg_token_len(text));        #average token length ??? BAD feature
        feat_array.append(stdev_token_len(text));        #standard deviation of token lengths
        feat_array.append(avg_sent_len1(text));            #average sentence length (wrt words)
        feat_array.append(avg_sent_len2(text));            #average sentence length (wrt chars)
        # feat_array.append(num_digits(text));            #number of digits ???? BAD FEATURE
    return feat_array;
