# The S-boxes [the heart of DES]
#
s = [
[ # S1
  14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
   0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
   4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
  15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13 ],
[ # S2
  15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
   3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
   0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
  13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9 ],
[ # S3
  10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
  13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
  13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
   1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12 ],
[ # S4
   7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
  13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
  10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4, 
   3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14 ],
[ # S5
   2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
  14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
   4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
  11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3 ],
[ # S6
  12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
  10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
   9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
   4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13 ],
[ # S7
   4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
  13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
   1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
   6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12 ],
[ # S8
  13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
   1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
   7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
   2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11 ]
]

pairs = [ ### These are actual problem pairs
    [
        [ [0x748502cd, 0x38451097], [0x2e48787d, 0xfb8509e6] ],
        [ [0x38747564, 0x38451097], [0xfc19cb45, 0xb6d9f494] ]
    ],
    [
        [ [0x48691102, 0x6acdff31], [0xac777016, 0x3ddc98e1] ],
        [ [0x375bd31f, 0x6acdff31], [0x7d708f6d, 0x4bc7ef16] ]
    ],
    [
        [ [0x357418da, 0x013fec86], [0x5a799643, 0x9823cf12] ],
        [ [0x12549847, 0x013fec86], [0xae46e276, 0x16c26b04] ]
    ]
]
'''
pairs = [ ### This is the example from the handout for debugging purposes
    [
        [ [0x748502cd, 0x38451097], [0x03c70306, 0xd8a09f10] ],
        [ [0x38747564, 0x38451097], [0x78560a09, 0x60e6d4cb] ]
    ],
    [
        [ [0x48691102, 0x6acdff31], [0x45fa285b, 0xe5adc730] ],
        [ [0x375bd31f, 0x6acdff31], [0x134f7915, 0xac253457] ]
    ],
    [
        [ [0x357418da, 0x013fec86], [0xd8a31b2f, 0x28bbc5cf] ],
        [ [0x12549847, 0x013fec86], [0x0f317ac2, 0xb23cb944] ]
    ]
]
'''
# the expansion function E()
exp = [ 32,  1,  2,  3,  4,  5,
         4,  5,  6,  7,  8,  9,
	      8,  9, 10, 11, 12, 13,
	     12, 13, 14, 15, 16, 17,
	     16, 17, 18, 19, 20, 21,
	     20, 21, 22, 23, 24, 25,
	     24, 25, 26, 27, 28, 29,
	     28, 29, 30, 31, 32,  1]

# the permutation P is applied after the S-boxes
P = [ 16,  7, 20, 21, 29, 12, 28, 17,  1, 15, 23, 26,  5, 18, 31, 10,
 2,  8, 24, 14, 32, 27,  3,  9, 19, 13, 30,  6, 22, 11,  4, 25 ];

def flip_L3R3():
   fp = []
   for (((pt_l, pt_r), (ct_l, ct_r)), ((pt_ls, pt_rs), (ct_ls, ct_rs))) in pairs:
      fp.append([[[pt_l, pt_r], [ct_r, ct_l]], [[pt_ls, pt_rs], [ct_rs, ct_ls]]])
   return fp

def calc_c():
   c_array = []
   for (((pt_l, pt_r), (ct_l, ct_r)), ((pt_ls, pt_rs), (ct_ls, ct_rs))) in pairs:
      Pc = (ct_r^ct_rs) ^ (pt_l^pt_ls) #Rprime3 xor Lprime0
      Pc = format(Pc, '#034b')[2:]
      c = range(32)
      for i in range(32): #inverse P
         c[i] = Pc[P.index(i + 1)]
      c_str = '0b' + ''.join(x for x in c)
      c_array.append(c_str)   #convert to 32-bit string
   return c_array

def calc_e():
   e_array = []
   for ((pt, (ct_l, ct_r)), ptct_star) in pairs:
      e = '0b'
      l3 = format(ct_l, '#034b') #32-bit binary with lead zero padding
      l3 = l3[2: ]               #remove '0b' from string
      for i in exp:
         e += l3[i-1]
      e_array.append(e)
   return e_array
   
def calc_estar():
   estar_array = []
   for (ptct, (pt, (ct_l, ct_r) ) ) in pairs:
      estar = '0b'
      l3 = format(ct_l, '#034b') #32-bit binary with lead zero padding
      l3 = l3[2: ]               #remove '0b' from string
      for i in exp:
         estar += l3[i-1]
      estar_array.append(estar)
   return estar_array
      
def INj(Bjprime, Cjprime, j):
   inj = []
   for Bj in range(pow(2,6)):
      Bj_str = format(Bj, '#08b')[2:] #work to index s-box correctly
      row_bj = int('0b' + Bj_str[0] + Bj_str[5], 0)
      col_bj = int('0b' + Bj_str[1:5], 0)
      Bjstar_str = format(Bj^Bjprime, '#08b')[2:]
      row_bjstar = int('0b' + Bjstar_str[0] + Bjstar_str[5], 0)
      col_bjstar = int('0b' + Bjstar_str[1:5], 0)
      if (s[j][16*row_bj + col_bj] ^ s[j][16*row_bjstar + col_bjstar] == Cjprime):
         inj.append(Bj)
   return inj
   
def testj(Ej, Ejstar, Cjprime, j):
   arr = []
   for Bj in INj(Ej^Ejstar, Cjprime, j):
      arr.append(Bj^Ej)
   return arr

if (False):
   pairs = flip_L3R3()
E = calc_e()
Estar = calc_estar()
C = calc_c()
Z = zip(E, Estar, C)
possible_keys = []
for i in range(8):
   possible_keys.append([])
for (e, eStar, c) in Z:
   print
   print "This is a new pair"
   #print "E is " + str(e)
   #print "C is " + str(c)
   for j in range(8):
      ej = int('0b' + e[6*j+2:6*(j+1)+2] , 0)
      ejStar = int('0b' + eStar[6*j+2:6*(j+1)+2], 0)
      cj = int('0b' + c[4*j+2:4*(j+1)+2], 0)
      print testj(ej, ejStar, cj, j)
      possible_keys[j].extend(testj(ej, ejStar, cj, j))
round_key = []
for j in range(8):
   for x in possible_keys[j]:
      if (possible_keys[j].count(x) == 3):
         round_key.append(x)
         break
print
print "This is the round 3 key:"
print round_key
