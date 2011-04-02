angles = set()

for x in range( 26 ):
	for y in range( 0, x+1 ):
		try:
			angles.add( float(y) / x )
		except ZeroDivisionError:
			angles.add( 0 )
		print "added {}, {}".format( x, y )

angles = sorted(angles)
print len(angles), "elements"
print angles

import math
rads = list()
for angle in angles:
	rads.append( math.atan( angle ) )
print rads
	
scaled = set()
for rad in rads:
	scaled.add( int(math.floor( 255 * (rad / max( rads )) )) )
print len(scaled), "elements"
print scaled

strings = list()
for s in scaled:
	strings.append( ('{:' + str(len(str(max(scaled)))) + 'd}').format(s) )
print '{'
for i in range( 0, len(strings), 5 ):
	print '\t'+(', '.join(strings[i:i+5]))+','
print '}'

strings = list()
for s in rads:
	strings.append( ('{:' + str(len(str(max(scaled)))) + 'f}').format(s) )
print '{'
for i in range( 0, len(strings), 5 ):
	print '\t'+(', '.join(strings[i:i+5]))+','
print '}'
