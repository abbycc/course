def loadDic( infile ):
    input_file = open(infile, mode='r',encoding='gbk')

    infile_content = input_file.readlines()
    list_word = []
    for each in infile_content:
        list_temp = each.split(',')
        word = list_temp[0]
        list_word.append(word)

    input_file.close()
    return list_word

def split( text:str, dict ):
    i = len(text)
    while( len(text) ):
        a = text[0:i]
        if a in dict:
            print(a)
            text = text[i:len(text)]
            i = len(text)
            continue
        else:
            i -= 1
        if len(a) == 1:
            print(a)
            text = text[1:len(text)]
            i = len(text)




if __name__ == "__main__":

    dict = loadDic('C:\\Users\\zhc\\Documents\\nlp\\dic_ce\\ce.txt')
    #print(dict)
   # a ="我喜欢阿拉伯数字"
    sen = input("请输入句子：")
    split(sen,dict)