from nltk.stem import WordNetLemmatizer
import nltk
#nltk.download('wordnet')
wnl = WordNetLemmatizer()
print(wnl.lemmatize('cars','n'))