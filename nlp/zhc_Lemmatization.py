import numpy as np
import re

#加载词典
def loadDic( infile ):
    input_file = open(infile, mode='r',encoding='utf-8')

    infile_content = input_file.readlines()
    list_word = []
    for each in infile_content:
        list_temp = each.split('\uf8f5')
        word = list_temp[0]
        meaning = ''
        for i in range(1,len(list_temp)-1):
            meaning += ' ' + list_temp[i]
        list_word.append([word,meaning])
    #print(list_word)
    dict_temp = dict(list_word)
    #print(dict_temp)
    input_file.close()
    return dict_temp

#词型还原
def trans( word:str ):
    re1 = re.compile(r'(\w+)s(\W)*',flags=re.I) #none transfrom
    re2 = re.compile(r'(\w+)es(\W)*',flags=re.I)
    re3 = re.compile(r'(\w+)ies(\W)*',flags=re.I)
    re4 = re.compile(r'(\w+)ves(\W)*',flags=re.I)

    re5 = re.compile(r'(\w+)ies',flags=re.I)#verb
    re6 = re.compile(r'(\w+)es',flags=re.I)
    re7 = re.compile(r'(\w+)s', flags=re.I)
    re8 = re.compile(r'(\w+)'+word[len(word)-4]+'{2}ing(\W)*',flags=re.I)#结尾双写加ing
    re9 = re.compile(r'(\w+)ying(\W)*',flags=re.I)
    re10 = re.compile(r'(\w+)ing(\W)*', flags=re.I)
    re11 = re.compile(r'(\w+)'+word[len(word)-4]+'{2}ed(\W)*',flags=re.I)
    re12 = re.compile(r'(\w+)ied(\W)*',flags=re.I)
    re13 = re.compile('(\w+)ed(\W)*',flags=re.I)
    res = []
    if re.search(re3,word):
        res.append(re.sub(r'ies',r'y',word))
    elif re.search(re4,word):
        res.append(re.sub(r'ves',r'f',word))
        res.append(re.sub(r'ves',r'fe', word))
    elif re.search(re2,word):
        res.append(re.sub(r'es',r'',word))
        res.append(re.sub(r'es',r'e',word))
    elif re.search(re1,word):
        res.append(re.sub(r's',r'',word))
        '''
    if re.search(re5,word):
        res.append(re.sub(r'ies',r'y',word))
    elif re.search(re6,word):
        res.append(re.sub(r'es',r'',word))
    elif re.search(re7,word):
        res.append(re.sub(r's',r'',word))
        '''
    elif re.search(re8,word):
        res.append(re.sub(r''+word[len(word) - 4] + '{2}ing', r''+word[len(word) - 4],word))
    elif re.search(re9,word):
        res.append(re.sub(r'ying',r'ie',word))
    elif re.search(re10,word):
        res.append(re.sub(r'ing',r'',word))
        res.append(re.sub(r'ing',r'e',word))
    elif re.search(re11, word):
        res.append(re.sub(r''+word[len(word) - 4] + '{2}ed', r''+word[len(word) - 4],word))
    elif re.search(re12, word):
        res.append(re.sub(r'ied',r'y',word))
    elif re.search(re13, word):
        res.append(re.sub(r'ed',r'',word))
        res.append(re.sub(r'ed',r'e',word))
    return res

#没有匹配的词语
def NoMatch( outfile, word ):
    file_handle = open(outfile, 'a', encoding='utf-8')
    file_handle.write(word + '\n')

#不规则的词语
def irregular( ir_file , word:str ):
    input_file = open( ir_file, mode='r', encoding='utf-8')
    infile_content = input_file.readlines()
    for each in infile_content:
        list_word = each.split('\t')
        for i in range( len(list_word) ):
            if list_word[i].strip() == word:
                return list_word[0]
    return 'no match'


if __name__ == "__main__":
    '''
    b = "book"
    a = "lifes"
    c =  "shopping"
    d = "cooked"
    print( trans(a) )
    print( trans(b) )
    print(trans(c))
    print(trans(d))
    '''
   # print (irregular('C:\\Users\\zhc\\Documents\\nlp\\dic_ec\\irregular.txt','dug'))
    dict = loadDic('C:\\Users\\zhc\\Documents\\nlp\\dic_ec\\dic_ec.txt')
    while( True ):
        word = input('请输入要查询的单词：')
        if word == 'q':
            print('查询结束，欢迎使用')
            break
        ifMatch = False
        if word in dict.keys():
            ifMatch = True
            print(word,dict[word])
        word_list = trans(word)
        if word_list!= []:
            for i in range(len(word_list)):
                word_temp = word_list[i]
                if word_temp in dict.keys():
                    ifMatch = True
                    print(word_temp, dict[word_temp])
        word_ir = irregular('C:\\Users\\zhc\\Documents\\nlp\\dic_ec\\irregular.txt',word)
        if word_ir != 'no match' and word_ir in dict.keys():
            print(word_ir,dict[word_ir])
            ifMatch = True
        if ifMatch == False:
            print('输入的单词不存在，已加入NoMatchList.txt!')
            NoMatch('C:\\Users\\zhc\\Documents\\nlp\\dic_ec\\NoMatchList.txt',word)
