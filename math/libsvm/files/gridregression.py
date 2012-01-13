#!/usr/bin/env python



import os, sys, traceback
import getpass
from threading import Thread
from subprocess import *

if(sys.hexversion < 0x03000000):
	import Queue
else:
	import queue as Queue


# svmtrain and gnuplot executable

is_win32 = (sys.platform == 'win32')
svmtrain_exe = "../svm-train"
gnuplot_exe = "/usr/bin/gnuplot"
# example for windows
# svmtrain_exe = r"c:\tmp\libsvm-2.4\windows\svmtrain.exe"
# gnuplot_exe = r"c:\tmp\gp373w32\pgnuplot.exe"

# global parameters and their default values

fold = 5
c_begin, c_end, c_step = -1,  6, 1
g_begin, g_end, g_step =  0, -8, -1
p_begin, p_end, p_step =  -8, -1, 1
global dataset_pathname, dataset_title, pass_through_string
global out_filename, png_filename

# experimental

ssh_workers = []
# ssh_workers = ['linux1','linux1','linux2','linux2','linux3', 'linux4', 'linux6','linux7','linux8','linux8','linux9','linux10','linux11','linux12']
nr_local_worker = 1

# process command line options, set global parameters
def process_options(argv=sys.argv):

    global fold
    global c_begin, c_end, c_step
    global g_begin, g_end, g_step
    global p_begin, p_end, p_step
    global dataset_pathname, dataset_title, pass_through_string
    global svmtrain_exe, gnuplot_exe, gnuplot, out_filename, png_filename
    
    usage = """\
Usage: grid.py [-log2c begin,end,step] [-log2g begin,end,step] [-log2p begin,end,step] [-v fold] 
[-svmtrain pathname] [-gnuplot pathname] [-out pathname] [-png pathname]
[additional parameters for svm-train] dataset"""

    if len(argv) < 2:
        print(usage)
        sys.exit(1)

    dataset_pathname = argv[-1]
    dataset_title = os.path.split(dataset_pathname)[1]
    out_filename = '%s.out' % dataset_title
    png_filename = '%s.png' % dataset_title
    pass_through_options = []

    i = 1
    while i < len(argv) - 1:
        if argv[i] == "-log2c":
            i = i + 1
            (c_begin,c_end,c_step) = map(float,argv[i].split(","))
        elif argv[i] == "-log2g":
            i = i + 1
            (g_begin,g_end,g_step) = map(float,argv[i].split(","))
        elif argv[i] == "-log2p":
            i = i + 1
            (p_begin,p_end,p_step) = map(float,argv[i].split(","))
        elif argv[i] == "-v":
            i = i + 1
            fold = argv[i]
        elif argv[i] in ('-c','-g'):
            print("Option -c and -g are renamed.")
            print(usage)
            sys.exit(1)
        elif argv[i] == '-svmtrain':
            i = i + 1
            svmtrain_exe = argv[i]
        elif argv[i] == '-gnuplot':
            i = i + 1
            gnuplot_exe = argv[i]
        elif argv[i] == '-out':
            i = i + 1
            out_filename = argv[i]
        elif argv[i] == '-png':
            i = i + 1
            png_filename = argv[i]
        else:
            pass_through_options.append(argv[i])
        i = i + 1

    pass_through_string = " ".join(pass_through_options)
    assert os.path.exists(svmtrain_exe),"svm-train executable not found"
    assert os.path.exists(gnuplot_exe),"gnuplot executable not found"
    assert os.path.exists(dataset_pathname),"dataset not found"
#    gnuplot = Popen(gnuplot_exe,stdin = PIPE).stdin


def range_f(begin,end,step):
    # like range, but works on non-integer too
    seq = []
    while True:
        if step > 0 and begin > end: break
        if step < 0 and begin < end: break
        seq.append(begin)
        begin = begin + step
    return seq

def permute_sequence(seq):
    n = len(seq)
    if n <= 1: return seq

    mid = int(n/2)
    left = permute_sequence(seq[:mid])
    right = permute_sequence(seq[mid+1:])

    ret = [seq[mid]]
    while left or right:
        if left: ret.append(left.pop(0))
        if right: ret.append(right.pop(0))

    return ret

def redraw (db,tofile=0):
    if len(db) == 0: return
    begin_level = round(max(map(lambda x: (x[2],db)))) - 3
    step_size = 0.5
    if tofile:
        gnuplot.write(b"set term png transparent small color\n")
        gnuplot.write(b"set output \"%s\"\n" % png_filename.replace('\\','\\\\'))
        #gnuplot.write("set term postscript color solid\n".encode())
        #gnuplot.write(("set output \"%s.ps\"\n" % dataset_title).encode())
    else:
        if is_win32:
            gnuplot.write(b"set term windows\n")
        else:
            gnuplot.write(b"set term x11\n")
    gnuplot.write(b"set xlabel \"lg(C)\"\n")
    gnuplot.write(b"set ylabel \"lg(gamma)\"\n")
    gnuplot.write(b"set xrange [%s:%s]\n" % (c_begin,c_end))
    gnuplot.write(b"set yrange [%s:%s]\n" % (g_begin,g_end))
    gnuplot.write(b"set contour\n")
    gnuplot.write(b"set cntrparam levels incremental %s,%s,100\n" % (begin_level,step_size))
    gnuplot.write(b"set nosurface\n")
    gnuplot.write(b"set view 0,0\n")
    gnuplot.write(b"set label \"%s\" at screen 0.4,0.9\n" % dataset_title)
    gnuplot.write(b"splot \"-\" with lines\n")



    db.sort(key = lambda x:(x[0], -x[1]))

    prevc = db[0][0]
    for line in db:
        if prevc != line[0]:
            gnuplot.write(b"\n")
            prevc = line[0]
        gnuplot.write(b"%s %s %s\n" % line)
    gnuplot.write(b"e\n")
    gnuplot.write(b"\n") # force gnuplot back to prompt when term set failure
    gnuplot.flush()


def calculate_jobs():
    c_seq = permute_sequence(range_f(c_begin,c_end,c_step))
    g_seq = permute_sequence(range_f(g_begin,g_end,g_step))
    p_seq = permute_sequence(range_f(p_begin,p_end,p_step))
    nr_c = len(c_seq)
    nr_g = len(g_seq)
    nr_p = len(p_seq)
    jobs = []

    for i in range(0,nr_c):
        for j in range(0,nr_g):
            for s in range(0,nr_p):
                line = []
                line.append((c_seq[i],g_seq[j],p_seq[s]))
                jobs.append(line)
    return jobs

class WorkerStopToken:  # used to notify the worker to stop
        pass

class Worker(Thread):
    def __init__(self,name,job_queue,result_queue):
        Thread.__init__(self)
        self.name = name
        self.job_queue = job_queue
        self.result_queue = result_queue
    def run(self):
        while True:
            (cexp,gexp,pexp) = self.job_queue.get()
            if cexp is WorkerStopToken:
                self.job_queue.put((cexp,gexp,pexp))
                # print 'worker %s stop.' % self.name
                break
            try:
                rate = self.run_one(2.0**cexp,2.0**gexp,2.0**pexp)
                if rate is None: raise RuntimeError("get no rate")
            except:
                # we failed, let others do that and we just quit
            
                traceback.print_exception(sys.exc_info()[0], sys.exc_info()[1], sys.exc_info()[2])

                self.job_queue.put((cexp,gexp,pexp))
                print('worker %s quit.' % self.name)
                break
            else:
                self.result_queue.put((self.name,cexp,gexp,pexp,rate))

class LocalWorker(Worker):
    def run_one(self,c,g,p):
        cmdline = '%s -s 3 -c %s -g %s -p %s -v %s %s %s' % \
          (svmtrain_exe,c,g,p,fold,pass_through_string,dataset_pathname)
        result = Popen(cmdline,shell=True,stdout=PIPE).stdout
        for line in result.readlines():
            if str(line).find("Cross") != -1:
                return float(line.split()[-1])

class SSHWorker(Worker):
    def __init__(self,name,job_queue,result_queue,host):
        Worker.__init__(self,name,job_queue,result_queue)
        self.host = host
        self.cwd = os.getcwd()
    def run_one(self,c,g,p):
        cmdline = 'ssh %s "cd %s; %s -s 3 -c %s -g %s -p %s -v %s %s %s"' % \
          (self.host,self.cwd,
           svmtrain_exe,c,g,p,fold,pass_through_string,dataset_pathname)
#	print cmdline
        result = Popen(cmdline,shell=True,stdout=PIPE).stdout
        for line in result.readlines():
            if str(line).find("Cross") != -1:
                return float(line.split()[-1])

def main():

    # set parameters

    process_options()

    # put jobs in queue

    jobs = calculate_jobs()
    #print(len(jobs))
    job_queue = Queue.Queue(0)
    result_queue = Queue.Queue(0)

    for line in jobs:
        for (c,g,p) in line:
            job_queue.put((c,g,p))

    # hack the queue to become a stack --
    # this is important when some thread
    # failed and re-put a job. It we still
    # use FIFO, the job will be put
    # into the end of the queue, and the graph
    # will only be updated in the end
    
    job_queue._put = job_queue.queue.appendleft


    # fire ssh workers

    if ssh_workers:
        for host in ssh_workers:
            SSHWorker(host,job_queue,result_queue,host).start()

    # fire local workers

    for i in range(nr_local_worker):
        LocalWorker('local',job_queue,result_queue).start()

    # gather results

    done_jobs = {}


    result_file = open(out_filename,'w')


    db = []
    best_mse = float('+inf')

    for line in jobs:
        for (c,g,p) in line:
            while (c,g,p) not in done_jobs:
                (worker,c1,g1,p1,mse) = result_queue.get()
                done_jobs[(c1,g1,p1)] = mse
                result_file.write('%s %s %s %s\n' % (c1,g1,p1,mse))
                result_file.flush()
                if mse < best_mse:
                    best_mse = mse
                    best_c = 2.0**c1
                    best_g = 2.0**g1
                    best_p = 2.0**p1
                print("[%s] %s %s %s %s (best c=%s, g=%s, p=%s, mse=%s)" % \
(worker,c1,g1,p1,mse,best_c,best_g,best_p,best_mse))

#            db.append((c,g,r,done_jobs[(c,g,r)]))

    job_queue.put((WorkerStopToken,None,None))
    print("%s %s %s %s" % (best_c,best_g,best_p,best_mse))
    
main()
