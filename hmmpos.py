from collections import Counter, defaultdict
from numpy import argmax, zeros

def getEmitProbabilities(wordtags, tagCounts): #optimized
    emitCounts = Counter([(tag, word) for (word,tag) in wordtags])
    return {emission: emitCount/tagCounts[emission[0]] for (emission, emitCount) in emitCounts.items()}

def getTransProbabilities(wordtags, tagCounts): #optimized
    tags = [wordtag[1] for wordtag in wordtags]
    transCounts = Counter([trans for trans in zip(tags[:-1], tags[1:]) if trans[0] != '</s>'])
    return {transition: transCount/tagCounts[transition[0]] for (transition, transCount) in transCounts.items()}

def getWordtags(): #optimized
    lines = [line.strip() for line in open('wsj00-18.tag')]                       #get file data
    modlines = [[line] if line !='' else [' \t</s>', ' \t<s>'] for line in lines] #insert sentence tags
    fmodlines = [item for sublist in modlines for item in sublist]                #flatten
    fmodlines.insert(0, fmodlines.pop())                                          #move excess <s> at end to front
    return [(l.split("\t")[0],l.split("\t")[1]) for l in fmodlines]               #parse into bigrams

def viterbi(sentence, a, b):
    tags = list(set([wordtag[1] for wordtag in wordtags]))
    N, T = len(tags), len(sentence)
    trellis, backpointer = zeros((N, T)), zeros((N, T), dtype=int)
    for s in range(N):
        trellis[s,0] = a[('<s>',tags[s])] * b[(tags[s],sentence[0])]
    for t in range(1,T):
        for s in range(N):
            trellis[s,t] = max([trellis[sp,t-1] * a[(tags[sp],tags[s])] * b[(tags[s],sentence[t])] for sp in range(N)])
            backpointer[s,t] = argmax([trellis[sp,t-1] * a[(tags[sp],tags[s])] for sp in range(N)])
    trellis[tags.index('</s>'),T-1] = max([trellis[s,T-1] * a[(tags[s],'</s>')] for s in range(N)])
    backpointer[tags.index('</s>'), T-1] = argmax([trellis[s,T-1] * a[(tags[s],'</s>')] for s in range(N)])
    return backpointerToPos(backpointer, tags, T)

def backpointerToPos(backpointer, tags, T): #non-pythonic to reduce further
    pos = []
    b = backpointer[tags.index('</s>'), T-1]
    for i in range(1, T+1):
        pos.insert(0, tags[b])
        b = backpointer[b, T-i]
    return pos

wordtags = getWordtags()
tagCounts = Counter([tag for (word,tag) in wordtags])
emitProb = defaultdict(lambda: 0, getEmitProbabilities(wordtags, tagCounts))   #zero prob if emission not trained
transProb = defaultdict(lambda: 0, getTransProbabilities(wordtags, tagCounts)) #zero prob if trans not trained

print(viterbi(['This','is','a','sentence','.'], transProb, emitProb))
print(viterbi(['This','might','produce','a','result','if','the','system','works','well','.'], transProb, emitProb))
print(viterbi(['Can','a','can','can','a','can','?'], transProb, emitProb))
print(viterbi(['Can','a','can','move','a','can','?'], transProb, emitProb))
print(viterbi(['Can','you','walk','the','walk','and','talk','the','talk','?'], transProb, emitProb))
