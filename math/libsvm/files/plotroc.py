#!/usr/bin/env python
#This tool allow users to plot SVM-prob ROC curve from data
from svmutil import *
from sys import argv, platform
from os import path, popen
from random import randrange , seed
from operator import itemgetter
from time import sleep

#search path for gnuplot executable 
#be careful on using windows LONG filename, surround it with double quotes.
#and leading 'r' to make it raw string, otherwise, repeat \\.
gnuplot_exe_list = [r'"C:\Program Files\gnuplot\pgnuplot.exe"', "/usr/bin/gnuplot","/usr/local/bin/gnuplot"]


def get_pos_deci(train_y, train_x, test_y, test_x, param):
	model = svm_train(train_y, train_x, param)
	#predict and grab decision value, assure deci>0 for label+,
	#the positive descision value = val[0]*labels[0]
	labels = model.get_labels()
	py, evals, deci = svm_predict(test_y, test_x, model)
	deci = [labels[0]*val[0] for val in deci]
	return deci,model

#get_cv_deci(prob_y[], prob_x[], svm_parameter param, nr_fold)
#input raw attributes, labels, param, cv_fold in decision value building
#output list of decision value, remember to seed(0)
def get_cv_deci(prob_y, prob_x, param, nr_fold):
	if nr_fold == 1 or nr_fold==0:
		deci,model = get_pos_deci(prob_y, prob_x, prob_y, prob_x, param)
		return deci
	deci, model = [], []
	prob_l = len(prob_y)

	#random permutation by swapping i and j instance
	for i in range(prob_l):
		j = randrange(i,prob_l)
		prob_x[i], prob_x[j] = prob_x[j], prob_x[i]
		prob_y[i], prob_y[j] = prob_y[j], prob_y[i]

	#cross training : folding
	for i in range(nr_fold):
		begin = i * prob_l // nr_fold
		end = (i + 1) * prob_l // nr_fold
		train_x = prob_x[:begin] + prob_x[end:]
		train_y = prob_y[:begin] + prob_y[end:]
		test_x = prob_x[begin:end]
		test_y = prob_y[begin:end]
		subdeci, submdel = get_pos_deci(train_y, train_x, test_y, test_x, param)
		deci += subdeci
	return deci

#a simple gnuplot object
class gnuplot:
	def __init__(self, term='onscreen'):
		# -persists leave plot window on screen after gnuplot terminates
		if platform == 'win32':
			cmdline = gnuplot_exe
			self.__dict__['screen_term'] = 'windows'
		else:
			cmdline = gnuplot_exe + ' -persist'
			self.__dict__['screen_term'] = 'x11'
		self.__dict__['iface'] = popen(cmdline,'w')
		self.set_term(term)

	def set_term(self, term):
		if term=='onscreen':
			self.writeln("set term %s" % self.screen_term)
		else:
			#term must be either x.ps or x.png
			if term.find('.ps')>0:
				self.writeln("set term postscript eps color 22")
			elif term.find('.png')>0:
				self.writeln("set term png")
			else:
				print("You must set term to either *.ps or *.png")
				raise SystemExit
			self.output = term
		
	def writeln(self,cmdline):
		self.iface.write(cmdline + '\n')

	def __setattr__(self, attr, val):
		if type(val) == str:
			self.writeln('set %s \"%s\"' % (attr, val))
		else:
			print("Unsupport format:", attr, val)
			raise SystemExit

	#terminate gnuplot
	def __del__(self):
		self.writeln("quit")
		self.iface.flush()
		self.iface.close()

	def __repr__(self):
		return "<gnuplot instance: output=%s>" % term

	#data is a list of [x,y]
	def plotline(self, data):
		self.writeln("plot \"-\" notitle with lines linewidth 1")
		for i in range(len(data)):
			self.writeln("%f %f" % (data[i][0], data[i][1]))
			sleep(0) #delay
		self.writeln("e")
		if platform=='win32':
			sleep(3)

#processing argv and set some global variables
def proc_argv(argv = argv):
	#print("Usage: %s " % argv[0])
	#The command line : ./plotroc.py [-v cv_fold | -T testing_file] [libsvm-options] training_file
	train_file = argv[-1]
	test_file = None
	fold = 5
	options = []
	i = 1
	while i < len(argv)-1:
		if argv[i] == '-T': 
			test_file = argv[i+1]
			i += 1
		elif argv[i] == '-v':
			fold = int(argv[i+1])
			i += 1
		else :
			options += [argv[i]]
		i += 1

	return ' '.join(options), fold, train_file, test_file

def plot_roc(deci, label, output, title):
	#count of postive and negative labels
	db = []
	pos, neg = 0, 0 		
	for i in range(len(label)):
		if label[i]>0:
			pos+=1
		else:	
			neg+=1
		db.append([deci[i], label[i]])

	#sorting by decision value
	db = sorted(db, key=itemgetter(0), reverse=True)

	#calculate ROC 
	xy_arr = []
	tp, fp = 0., 0.			#assure float division
	for i in range(len(db)):
		if db[i][1]>0:		#positive
			tp+=1
		else:
			fp+=1
		xy_arr.append([fp/neg,tp/pos])

	#area under curve
	aoc = 0.			
	prev_x = 0
	for x,y in xy_arr:
		if x != prev_x:
			aoc += (x - prev_x) * y
			prev_x = x

	#begin gnuplot
	if title == None:
		title = output
	#also write to file
	g = gnuplot(output)
	g.xlabel = "False Positive Rate"
	g.ylabel = "True Positive Rate"
	g.title = "ROC curve of %s (AUC = %.4f)" % (title,aoc)
	g.plotline(xy_arr)
	#display on screen
	s = gnuplot('onscreen')
	s.xlabel = "False Positive Rate"
	s.ylabel = "True Positive Rate"
	s.title = "ROC curve of %s (AUC = %.4f)" % (title,aoc)
	s.plotline(xy_arr)

def check_gnuplot_exe():
	global gnuplot_exe
	gnuplot_exe = None
	for g in gnuplot_exe_list:
		if path.exists(g.replace('"','')):
			gnuplot_exe=g
			break
	if gnuplot_exe == None:
		print("You must add correct path of 'gnuplot' into gnuplot_exe_list")
		raise SystemExit

def main():
	check_gnuplot_exe()
	if len(argv) <= 1:
		print("Usage: %s [-v cv_fold | -T testing_file] [libsvm-options] training_file" % argv[0])
		raise SystemExit
	param,fold,train_file,test_file = proc_argv()
	output_file = path.split(train_file)[1] + '-roc.png'
	#read data
	train_y, train_x = svm_read_problem(train_file)
	if set(train_y) != set([1,-1]):
		print("ROC is only applicable to binary classes with labels 1, -1")
		raise SystemExit

	#get decision value, with positive = label+
	seed(0)	#reset random seed
	if test_file:		#go with test_file
		output_title = "%s on %s" % (path.split(test_file)[1], path.split(train_file)[1])
		test_y, test_x = svm_read_problem(test_file)
		if set(test_y) != set([1,-1]):
			print("ROC is only applicable to binary classes with labels 1, -1")
			raise SystemExit
		deci,model = get_pos_deci(train_y, train_x, test_y, test_x, param)
		plot_roc(deci, test_y, output_file, output_title)
	else:				#single file -> CV
		output_title = path.split(train_file)[1]
		deci = get_cv_deci(train_y, train_x, param, fold)
		plot_roc(deci, train_y, output_file, output_title)

if __name__ == '__main__':
	main()	
