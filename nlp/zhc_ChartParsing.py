#加载词和词性
def loadDic( infile ):
    input_file = open(infile, mode='r',encoding='utf-8')

    infile_content = input_file.readlines()
    list_word = []
    for each in infile_content:
        list_temp = each.split(' ')
        word = list_temp[0]
        if list_temp[1].strip() == 'none.' or list_temp[1].strip() == 'n.' :
            pattern = 'N'
        elif list_temp[1].strip() == 'v.' or list_temp[1].strip() == 'vt.' or list_temp[1].strip() == 'vi.' :
            pattern = 'V'
        else:
            pattern = list_temp[1][0:len(list_temp[1])-2].upper()
        list_word.append([word,pattern])
    #print(list_word)
    dict_temp = dict(list_word)
    #print(dict_temp)
    input_file.close()
    return dict_temp

#加入各种词的词法符号和位置
def getPattern( dic:dict, stack:list,  word: str, pos:int ):
    pattern = []
    if word in dic.keys():
        pattern.append(dic[word])
        pattern.append(pos)
        pattern.append(pos+1)
        #print(pattern)
    else:
        print(word + "不在词典中")
    stack.append(pattern)


def loadRegu( regufile ):
    input_file = open(regufile, mode='r', encoding='utf-8')

    infile_content = input_file.readlines()
    list_regu = []
    for each in infile_content:
        regu = []
        list_temp = each.split(' ')
        for i in range(len(list_temp)):
            if i == 1: continue
            else:
                regu.append(list_temp[i].strip())
        list_regu.append(regu)
    input_file.close()
    return list_regu


#增加活动边.包括了所蕴含的规则，起始结束位置和所在活动位置
def addActive( regu_list , pattern , active_list, stack, dic):
    p = pattern[0]
    pos1 = pattern[1]
    pos2 = pattern[2]
    for i in range( len(regu_list) ):
        regu = regu_list[i]
        active = []
        if regu[1] == p:
            if len(regu) == 2:#如果已经结束，就加入stack
                pattern = []
                pattern.append(regu[0])
                pattern.append(pos1)
                pattern.append(pos2)
                # print(pattern)
                stack.append(pattern)
            else:
                active.append(regu)
                active.append(1)
                active.append(pos1)
                active.append(pos2)
                active_list.append(active)
    return active_list

def searchActive( pattern , active_list, stack, dic):
    p = pattern[0]
    pos1 = pattern[1]
    pos2 = pattern[2]
    for i in range(len(active_list)):
        regu = active_list[i][0]
        index = active_list[i][1]
        start = active_list[i][2]
        end = active_list[i][3]
        if index < len(regu)-1 and regu[index+1] == p and end == pos1:
            index += 1
            active_list[i][1] = index
            active_list[i][3] = pos2
            if index == len(regu)-1:
                pattern = []
                pattern.append(regu[0])
                pattern.append(start)
                pattern.append(pos2)
                #print(pattern)
                stack.append(pattern)

    return active_list


def addInactive( pattern , inactive_list ):
    p = pattern[0]
    pos1 = pattern[1]
    pos2 = pattern[2]
    pattern = []
    pattern.append(p)
    pattern.append(pos1)
    pattern.append(pos2)
    # print(pattern)
    inactive_list.append(pattern)
    return inactive_list




if __name__ == "__main__":

    dict = loadDic('C:\\Users\\zhc\\Documents\\nlp\\parse\\word.txt')
    regu = loadRegu('C:\\Users\\zhc\\Documents\\nlp\\parse\\regular.txt')
    stack = []
    active_list = []
    inactive_list = []
    sen = "the cat caught a mouse"
    word = sen.split(' ')
    i = 0
    while( i<len(word) or stack != []):
        if stack == []:
            getPattern(dict, stack, word[i], i)
            i += 1
        pattern = stack.pop()
        addInactive(pattern, inactive_list)
        #print(inactive_list)
        addActive(regu, pattern, active_list, stack, dict)
        #print(active_list)
        searchActive(pattern, active_list, stack, dict)
        #print(active_list)

    print(inactive_list)
    #getPattern(dict, stack, "coventrate", 0)
    #active_list = searchActive(pattern, active_list, stack, dict)