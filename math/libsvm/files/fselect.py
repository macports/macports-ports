#!/usr/bin/env python

import random
from random import randrange
import sys
from time import time
from datetime import datetime
#import string
#from string import *
import os
from os import system
from os import unlink
from subprocess import *

##### Path Setting #####

is_win32 = (sys.platform == 'win32')
if not is_win32:
	gridpy_exe = "./grid.py -log2c -2,9,2 -log2g 1,-11,-2"
	svmtrain_exe="../svm-train"
	svmpredict_exe="../svm-predict"
else:
	gridpy_exe = r".\grid.py -log2c -2,9,2 -log2g 1,-11,-2"
	svmtrain_exe=r"..\windows\svmtrain.exe"
	svmpredict_exe=r"..\windows\svmpredict.exe"

##### Global Variables #####

train_pathfile=""
train_file=""
test_pathfile=""
test_file=""
if_predict_all=0

whole_fsc_dict={}
whole_imp_v=[]


def arg_process():
	global train_pathfile, test_pathfile
	global train_file, test_file
	global svmtrain_exe, svmpredict_exe

	if len(sys.argv) not in [2,3]:
		print('Usage: %s training_file [testing_file]' % sys.argv[0])
		raise SystemExit

	train_pathfile=sys.argv[1]
	assert os.path.exists(train_pathfile),"training file not found"
	train_file = os.path.split(train_pathfile)[1]

	if len(sys.argv) == 3:
		test_pathfile=sys.argv[2]
		assert os.path.exists(test_pathfile),"testing file not found"
		test_file = os.path.split(test_pathfile)[1]


##### Decide sizes of selected feautures #####

def feat_num_try_half(max_index):
	v=[]
	while max_index > 1:
		v.append(max_index)
		max_index //= 2
	return v

def feat_num_try(f_tuple):
	for i in range(len(f_tuple)):
		if f_tuple[i][1] < 1e-20:
			i=i-1; break
	#only take first eight numbers (>1%)
	return feat_num_try_half(i+1)[:8]


def random_shuffle(label, sample):
	random.seed(1)  # so that result is the same every time
	size = len(label)
	for i in range(size):
		ri = randrange(0, size-i)
		tmp = label[ri]
		label[ri] = label[size-i-1]
		label[size-i-1] = tmp
		tmp = sample[ri]
		sample[ri] = sample[size-i-1]
		sample[size-i-1] = tmp



### compare function used in list.sort(): sort by element[1]
#def value_cmpf(x,y):
#	if x[1]>y[1]: return -1
#	if x[1]<y[1]: return 1
#	return 0
def value_cmpf(x):
	return (-x[1]);

### cal importance of features
### return fscore_dict and feat with desc order
def cal_feat_imp(label,sample):

	print("calculating fsc...")

	score_dict=cal_Fscore(label,sample)

	score_tuples = list(score_dict.items())
	score_tuples.sort(key = value_cmpf)

	feat_v = score_tuples
	for i in range(len(feat_v)): feat_v[i]=score_tuples[i][0]

	print("fsc done")
	return score_dict,feat_v


### select features and return new data
def select(sample, feat_v):
	new_samp = []

	feat_v.sort()

	#for each sample
	for s in sample:
		point={}
		#for each feature to select
		for f in feat_v:
			if f in s: point[f]=s[f]

		new_samp.append(point)

	return new_samp


### Do parameter searching (grid.py) 
def train_svm(tr_file):
	cmd = "%s %s" % (gridpy_exe,tr_file)
	print(cmd)
	print('Cross validation...')
	std_out = Popen(cmd, shell = True, stdout = PIPE).stdout

	line = ''
	while 1:
		last_line = line
		line = std_out.readline()
		if not line: break
	c,g,rate = map(float,last_line.split())

	print('Best c=%s, g=%s CV rate=%s' % (c,g,rate))

	return c,g,rate

### Given (C,g) and training/testing data,
### return predicted labels
def predict(tr_label, tr_sample, c, g, test_label, test_sample, del_model=1, model_name=None):
	global train_file
	tr_file = train_file+".tr"
	te_file = train_file+".te"
	if model_name:  model_file = model_name
	else:  model_file = "%s.model"%tr_file
	out_file = "%s.o"%te_file
        
	# train
	writedata(tr_sample,tr_label,tr_file)
	cmd = "%s -c %f -g %f %s %s" % (svmtrain_exe,c,g,tr_file,model_file)
	os.system(cmd) 

	# test
	writedata(test_sample,test_label,te_file)
	cmd = "%s %s %s %s" % (svmpredict_exe, te_file,model_file,out_file )
	print(cmd)
	os.system(cmd)
        
	# fill in pred_y
	pred_y=[]
	fp = open(out_file)
	line = fp.readline()
	while line:
		pred_y.append( float(line) )
		line = fp.readline()
        
	rem_file(tr_file)
	#rem_file("%s.out"%tr_file)
	#rem_file("%s.png"%tr_file)
	rem_file(te_file)
	if del_model: rem_file(model_file)
	fp.close()
	rem_file(out_file)
        
	return pred_y


def cal_acc(pred_y, real_y):
	right = 0.0

	for i in range(len(pred_y)):
		if(pred_y[i] == real_y[i]): right += 1

	print("ACC: %d/%d"%(right, len(pred_y)))
	return right/len(pred_y)

### balanced accuracy
def cal_bacc(pred_y, real_y):
	p_right = 0.0
	n_right = 0.0
	p_num = 0
	n_num = 0

	size=len(pred_y)
	for i in range(size):
		if real_y[i] == 1:
			p_num+=1
			if real_y[i]==pred_y[i]: p_right+=1
		else:
			n_num+=1
			if real_y[i]==pred_y[i]: n_right+=1

	print([p_right,p_num,n_right,n_num])
	writelog("       p_yes/p_num, n_yes/n_num: %d/%d , %d/%d\n"%(p_right,p_num,n_right,n_num))
	if p_num==0: p_num=1
	if n_num==0: n_num=1
	return 0.5*( p_right/p_num + n_right/n_num )


##### Log related #####
def initlog(name):
	global logname
	logname = name
	logfile_fd = open(logname, 'w')
	logfile_fd.close()


VERBOSE_MAX=100
VERBOSE_ITER = 3
VERBOSE_GRID_TIME = 2
VERBOSE_TIME = 1

def writelog(str, vlevel=VERBOSE_MAX):
	global logname
	if vlevel > VERBOSE_ITER:
		logfile_fd = open(logname, 'a')
		logfile_fd.write(str)
		logfile_fd.close()


def rem_file(filename):
	#system("rm -f %s"%filename)
	unlink(filename)

##### MAIN FUNCTION #####
def main():
	global train_pathfile, train_file
	global test_pathfile, test_file
	global whole_fsc_dict,whole_imp_v

	times=5 #number of hold-out times
	accuracy=[]

	### Read Data
	print("reading....")
	t=time()
	train_label, train_sample, max_index = readdata(train_pathfile)
	t=time()-t
	writelog("loading data '%s': %.1f sec.\n"%(train_pathfile,t), VERBOSE_TIME)
	print("read done")

	### Randomly shuffle data
	random_shuffle(train_label, train_sample)


	###calculate f-score of whole training data
	#whole_imp_v contains feat with order
	t=time()
	whole_fsc_dict,whole_imp_v = cal_feat_imp(train_label,train_sample)
	t=time()-t
	writelog("cal f-score time: %.1f\n"%t, VERBOSE_TIME)

	###write (sorted) f-score list in another file
	f_tuples = list(whole_fsc_dict.items())
	f_tuples.sort(key = value_cmpf)
	fd = open("%s.fscore"%train_file, 'w')
	for t in f_tuples:
		fd.write("%d: \t%.6f\n"%t)
	fd.close()


	### decide sizes of features to try
	fnum_v = feat_num_try(f_tuples) #ex: [50,25,12,6,3,1]
	for i in range(len(fnum_v)):
		accuracy.append([])
	writelog("try feature sizes: %s\n\n"%(fnum_v))


	writelog("%#Feat\test. acc.\n")

	est_acc=[]
	#for each possible feature subset
	for j in range(len(fnum_v)):

		fn = fnum_v[j]  # fn is the number of features selected
		fv = whole_imp_v[:fn] # fv is indices of selected features

		t=time()
		#pick features
		tr_sel_samp = select(train_sample, fv)
		tr_sel_name = train_file+".tr"
		t=time()-t
		writelog("\n   feature num: %d\n"%fn, VERBOSE_ITER)
		writelog("      pick time: %.1f\n"%t, VERBOSE_TIME)

		t=time()
		writedata(tr_sel_samp,train_label,tr_sel_name)
		t=time()-t
		writelog("      write data time: %.1f\n"%t, VERBOSE_TIME)


		t=time()
		# choose best c, gamma from splitted training sample
		c,g, cv_acc = train_svm(tr_sel_name)
		t=time()-t
		writelog("      choosing c,g time: %.1f\n"%t, VERBOSE_GRID_TIME)

		est_acc.append(cv_acc)
		writelog("%d:\t%.5f\n"%(fnum_v[j],cv_acc) )

	print(fnum_v)
	print(est_acc)

	fnum=fnum_v[est_acc.index(max(est_acc))]
#	print(est_acc.index(max(est_acc)))
	print('Number of selected features %s' % fnum)
	print('Please see %s.select for details' % train_file)

	#result for features selected
	sel_fv = whole_imp_v[:fnum]

	writelog("max validation accuarcy: %.6f\n"%max(est_acc))
	writelog("\nselect features: %s\n"%sel_fv)
	writelog("%s features\n"%fnum)
		

	# REMOVE INTERMEDIATE TEMPORARY FILE: training file after selection
	rem_file(tr_sel_name)
	rem_file("%s.out"%tr_sel_name)
	rem_file("%s.png"%tr_sel_name)


	### do testing 

	test_label=None
	test_sample=None
	if test_pathfile != "":
		print("reading testing data....")
		test_label, test_sample, max_index = readdata(test_pathfile)
		writelog("\nloading testing data '%s'\n"%test_pathfile)
		print("read done")
		
		#picking features
		train_sel_samp = select(train_sample, sel_fv)
		test_sel_samp = select(test_sample, sel_fv)

		#grid search
		train_sel_name = "%s.%d"%(train_file,fnum)
		writedata(train_sel_samp,train_label,train_sel_name)
		c,g, cv_acc = train_svm(train_sel_name)
		writelog("best (c,g)= %s, cv-acc = %.6f\n"%([c,g],cv_acc))

		# REMOVE INTERMEDIATE TEMPORARY FILE: training file after selection
		rem_file(train_sel_name)


		### predict
		pred_y = predict(train_label, train_sel_samp, c, g, test_label, test_sel_samp, 0, "%s.model"%train_sel_name)

		#calculate accuracy
		acc = cal_acc(pred_y, test_label)
		##acc = cal_bacc(pred_y, test_label)
		writelog("testing accuracy = %.6f\n"%acc)

		#writing predict labels
		out_name = "%s.%d.pred"%(test_file,fnum)
		fd = open(out_name, 'w')
		for y in pred_y: fd.write("%f\n"%y)
		fd.close()
		

### predict all possible sets ###
def predict_all():

	global train_pathfile, train_file
	global test_pathfile, test_file

	global whole_fsc_dict,whole_imp_v

	train_label, train_sample, max_index = readdata(train_pathfile)
	test_label, test_sample, m = readdata(test_pathfile)

	random_shuffle(train_label, train_sample)

	###whole_fsc_dict, ordered_feats = cal_feat_imp(train_label,train_sample)
	ordered_feats = whole_imp_v
	f_tuples = whole_fsc_dict.items()
	f_tuples.sort(key = value_cmpf)

	fnum_v = feat_num_try(f_tuples) #ex: [50,25,12,6,3,1]

	writelog("\nTest All %s\n"%fnum_v)
	for fnum in fnum_v:
		sel_fv = ordered_feats[:fnum]

		#picking features
		train_sel_samp = select(train_sample, sel_fv)
		test_sel_samp = select(test_sample, sel_fv)

		#grid search
		train_sel_name = "%s.%d"%(train_file,fnum)
		writedata(train_sel_samp,train_label,train_sel_name)
		c,g, cv_acc = train_svm(train_sel_name)
		writelog("best (c,g)= %s, cv-acc = %.6f\n"%([c,g],cv_acc))

		# REMOVE INTERMEDIATE TEMPORARY FILE: training file after selection
		rem_file(train_sel_name)

		#predict
		pred_y = predict(train_label, train_sel_samp, c, g, test_label, test_sel_samp)

		#calculate accuracy
		acc = cal_acc(pred_y, test_label)
		##acc = cal_bacc(pred_y, test_label)
		writelog("feat# %d, testing accuracy = %.6f\n"%(fnum,acc))

		#writing predict labels
		out_name = "%s.%d.pred"%(test_file,fnum)
		fd = open(out_name, 'w')
		for y in pred_y: fd.write("%f\n"%y)
		fd.close()

		del_out_png = 0
		if del_out_png:
			rem_file("%s.out"%train_sel_name)
			rem_file("%s.png"%train_sel_name)


###return a dict containing F_j
def cal_Fscore(labels,samples):

	data_num=float(len(samples))
	p_num = {} #key: label;  value: data num
	sum_f = [] #index: feat_idx;  value: sum
	sum_l_f = {} #dict of lists.  key1: label; index2: feat_idx; value: sum
	sumq_l_f = {} #dict of lists.  key1: label; index2: feat_idx; value: sum of square
	F={} #key: feat_idx;  valud: fscore
	max_idx = -1

	### pass 1: check number of each class and max index of features
	for p in range(len(samples)): # for every data point
		label=labels[p]
		point=samples[p]

		if label in p_num: p_num[label] += 1
		else: p_num[label] = 1

		for f in point.keys(): # for every feature
			if f>max_idx: max_idx=f
	### now p_num and max_idx are set

	### initialize variables
	sum_f = [0 for i in range(max_idx)]
	for la in p_num.keys():
		sum_l_f[la] = [0 for i in range(max_idx)]
		sumq_l_f[la] = [0 for i in range(max_idx)]

	### pass 2: calculate some stats of data
	for p in range(len(samples)): # for every data point
		point=samples[p]
		label=labels[p]
		for tuple in point.items(): # for every feature
			f = tuple[0]-1 # feat index
			v = tuple[1] # feat value
			sum_f[f] += v
			sum_l_f[label][f] += v
			sumq_l_f[label][f] += v**2
	### now sum_f, sum_l_f, sumq_l_f are done

	### for each feature, calculate f-score
	eps = 1e-12
	for f in range(max_idx):
		SB = 0
		for la in p_num.keys():
			SB += (p_num[la] * (sum_l_f[la][f]/p_num[la] - sum_f[f]/data_num)**2 )

		SW = eps
		for la in p_num.keys():
			SW += (sumq_l_f[la][f] - (sum_l_f[la][f]**2)/p_num[la]) 

		F[f+1] = SB / SW

	return F


###### svm data IO ######

def readdata(filename):
	labels=[]
	samples=[]
	max_index=0
	#load training data
	fp = open(filename)
	line = fp.readline()

	while line:
		# added by untitled, allowing data with comments
		line=line.strip()
		if line[0]=="#":
			line = fp.readline()
			continue

		elems = line.split()
		sample = {}
		for e in elems[1:]:
			points = e.split(":")
			p0 = int( points[0].strip() )
			p1 = float( points[1].strip() )
			sample[p0] = p1
			if p0 > max_index:
				max_index = p0
		labels.append(float(elems[0]))
		samples.append(sample)
		line = fp.readline()
	fp.close()

	return labels,samples,max_index

def writedata(samples,labels,filename):
	fp=sys.stdout
	if filename:
		fp=open(filename,"w")

	num=len(samples)
	for i in range(num):
		if labels: 
			fp.write("%s"%labels[i])
		else:
			fp.write("0")
		kk=list(samples[i].keys())
		kk.sort()
		for k in kk:
			fp.write(" %d:%f"%(k,samples[i][k]))
		fp.write("\n")

	fp.flush()
	fp.close()


###### PROGRAM ENTRY POINT ######

arg_process()

initlog("%s.select"%train_file)
writelog("start: %s\n\n"%datetime.now())
main()

# do testing on all possible feature sets
if if_predict_all :
	predict_all()

writelog("\nend: \n%s\n"%datetime.now())

