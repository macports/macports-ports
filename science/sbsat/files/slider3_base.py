
import sys
from optparse import OptionParser 

def slider3(out_type, size, sat, offset):  
    if   sat == 0:
        slider3_unsat(out_type, size, offset)
    elif sat == 1:
        slider3_sat(out_type, size, offset)
    else:
        print >> sys.stderr, 'Error: Unknown out_type: %s' % out_type
        exit(0)

'''
 * sliders
 *
 * unsat
 * (first function -- notice 1,2,3,4,5,6)
   #define add_state1(1, 2, 3, 4, 5, 6)
   #equ(xor(1, and(-3, 5), nand(6, 4)), ite(2, or(5, -6), -5)))
 *
 * (second/third function)
   #define add_state2(1, 2, 3, 4, 5, 6, 7)
   #equ(6, xor(-1, xor(3, and(-4, 5), 4), equ(7, 2)))
   #define add_state3(1, 2, 3, 4, 5, 6, 7)
   #not(equ(6, xor(-1, xor(3, and(-4, 5), 4), equ(7, 2))))
 *
 * sat
 * (first function -- notice 1,2,3,5,4,6 -- 5,4 switched)
   #define add_state1(1, 2, 3, 5, 4, 6)\n");
   #equ(xor(1, and(-3, 5), nand(6, 4)), ite(2, or(5, -6), -5)))
 *
 * (second/third functions - notice -- they are the same)
   #define add_state2(1, 2, 3, 4, 5, 6)
   #xor(-1, xor(3, and(-4, 5), 4), equ(6, 2))
   #define add_state3(1, 2, 3, 4, 5, 6)
   #xor(-1, xor(3, and(-4, 5), 4), equ(6, 2))
 *
 * numbers are generated the same way for both sat and unsat
   int start1[6] = {1, 2*s+3, 2*s+1, size/2-1-3*s, size/2-1, size/2};
   int start2[7] = {1, 2*s-1, 2*s+2, size/2-1-4*s, size/2-1-2*s, size/2-1-s, size/2};
 *
 * Please note that UNSAT version seems to be harder than SAT.
 *
 * Disclaimer: no formal analysis was done to verify SAT and UNSAT
 * This means that for some n SAT might return UNSAT and UNSAT might return SAT problem.
 * Please use the solver to verify UN/SAT.
 *
 * I have tested n for mulple of 10 starting 20.
 * SAT instances seem to have at most 2 solutions.
 *'''

def slider3_sat(out_type, size, offset):
	s = size/20
	start1 = [1, 2*s+3, 2*s+1, size/2-1-3*s, size/2-1, size/2]
	start2 = [1, 2*s-1, 2*s+2, size/2-1-4*s, size/2-1-2*s, size/2-1-s, size/2]
	'''
	print >> sys.stderr, start1
	print >> sys.stderr, start2
	'''
	print "p bdd %d %d" % (size+offset,size+2*offset)
	print "; automatically generated SAT slider3 with size=%d " % size
	print "; Disclaimer: no formal analysis was done to verify SAT and UNSAT"

	#first function
	print "#define add_state1(1, 2, 3, 5, 4, 6)"
	print "#equ(xor(1, and(-3, 5), nand(6, 4)), ite(2, or(5, -6), -5)))"
	for i in range(0, size/2+offset):
		sys.stdout.write("add_state1")
		print tuple(start1)
		for item in range(len(start1)):
			start1[item] += 1

	#second and third function
	print("#define add_state2(1, 2, 3, 4, 5, 6)")
	print("#xor(-1, xor(3, and(-4, 5), 4), equ(6, 2))")
	print("#define add_state3(1, 2, 3, 4, 5, 6)")
	print("#not(xor(-1, xor(3, and(-4, 5), 4), equ(6, 2)))")
	for i in range(0, size-size/2+offset):
		test = (i%2)+2
		sys.stdout.write("add_state%d" % test)
		print tuple(start2[0:5]+start2[6:])
		for item in range(len(start2)):
			start2[item] += 1
    	
def slider3_unsat(out_type, size):
	# 80: 1675229 124.090s 
	# {1, 11,  9, 27, 39, 40 }
	# {1,  7, 10, 21, 33, 35, 40}
	# int start1[6] = {1, 17-6, 15-6, 24+3, 33+6, size/2};
	# int start2[7] = {1, 12-5, 16-6, 18+3, 27+6, 29+6, size/2};

	# {1, 11,  9, 27, 39, 40 }
	# {1,  7, 10, 23, 31, 35, 40}
	# int start1[6] = {1, 17-6, 15-6, 24+3, 33+6, size/2};
	# int start2[7] = {1, 12-5, 16-6, 18+5, 27+4, 29+6, size/2};
	#
	# good one for 80 and more unsat
	# int s=size/20;
	# int start1[6] = {1, 2*s+3, 2*s+1, size/2-1-3*s, size/2-1, size/2};
	# int start2[7] = {1, 2*s-1, 2*s+2, size/2-1-4*s, size/2-1-2*s, size/2-1-s, size/2};
	#
	# UNSAT

	# fprintf(stderr, "{%d, %d, %d, %d, %d, %d}\n", start1[0], start1[1], start1[2], start1[3], start1[4], start1[5]);
	# fprintf(stderr, "{%d, %d, %d, %d, %d, %d, %d}\n", start2[0], start2[1], start2[2], start2[3], start2[4], start2[5], start2[6]);
	print "p bdd {0:d), {0:d)".format(size)
	print("; automatically generated UNSAT slider3 with size={0:d}".format(size))
	print("; Disclaimer: no formal analysis was done to verify SAT and UNSAT")

	#first function
	print("#define add_state1(1, 2, 3, 4, 5, 6)")
	print("#equ(xor(1, and(-3, 5), nand(6, 4)), ite(2, or(5, -6), -5)))")
	
	for i in range(0, size/2):
		print "add_state1{0}".format(start1)
		for item in start1:
			start1[item] += 1
	
	#Second and Third Function
	print("#define add_state2(1, 2, 3, 4, 5, 6, 7)")
	print("#equ(6, xor(-1, xor(3, and(-4, 5), 4), equ(7, 2)))")
	print("#define add_state3(1, 2, 3, 4, 5, 6, 7)")
	print("#not(equ(6, xor(-1, xor(3, and(-4, 5), 4), equ(7, 2))))")
	for i in range(0, size-size/2):
		print "add_state{0}".format([i%2+2] + start2)
		for item in range(len(start2)):
			start2[item] += 1


#main method. Option parsing
def main():
	usage = "usage: %prog [options] size sat\n  size                  num variables\n  sat                   1/0 (un/sat)"
	parser = OptionParser(usage=usage)
	parser.add_option("-o", "--offset", type="int", nargs=1, default=0, help="sets the offset", dest="offset")
	
	(options, args) = parser.parse_args()
	if len(args) != 2:
		parser.error("Try again")
	[size, sat] = map(int, args)
	
	slider3('ite', size, sat, offset=options.offset)

if __name__ == "__main__":
    main()

