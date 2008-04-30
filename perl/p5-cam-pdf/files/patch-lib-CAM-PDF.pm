--- lib/CAM/PDF.pm.orig	2007-11-28 21:42:46.000000000 -0800
+++ lib/CAM/PDF.pm	2008-03-27 20:06:54.000000000 -0700
@@ -566,6 +566,9 @@
             $CAM::PDF::errstr = "Could not decipher xref row:\n" . $self->trimstr($row);
             return;
          }
+		if ((0 == $1) && (0 == $2)) {
+			next;
+		}
          if ($type eq 'n')
          {
             $index->{$objnum} = $indexnum;
@@ -3785,6 +3788,7 @@
    my $otherdoc = shift;
    my $otherkey = shift;
    my $follow = shift;
+   my %traversedNodes = ();
 
    # careful! 'undef' means something different from '0' here!
    if (!defined $follow)
@@ -3838,10 +3842,10 @@
          my $newkey = $self->appendObject($otherdoc, $oldrefkey, 0);
          $newrefkeys{$oldrefkey} = $newkey;
       }
-      $self->changeRefKeys($objnode, \%newrefkeys);
+      $self->changeRefKeys($objnode, \%newrefkeys, \%traversedNodes);
       for my $newkey (values %newrefkeys)
       {
-         $self->changeRefKeys($self->dereference($newkey), \%newrefkeys);
+         $self->changeRefKeys($self->dereference($newkey), \%newrefkeys, \%traversedNodes);
       }
    }
    return (%newrefkeys);
@@ -5040,7 +5044,7 @@
    if ($stream)
    {
       $stream = $self->{crypt}->encrypt($self, $stream, $objnode->{objnum}, $objnode->{gennum});
-      $str .= "\nstream\n" . $stream . 'endstream';
+      $str .= "\nstream\n" . $stream . '\nendstream';
    }
    return "obj\n$str\nendobj\n";
 }
@@ -5072,6 +5076,7 @@
    my $objnode = shift;
    my $func = shift;
    my $funcdata = shift;
+   my $funcResult = undef;
 
    my $traversed = {};
    my @stack = ($objnode);
@@ -5080,7 +5085,8 @@
    while ($i < @stack)
    {
       my $objnode = $stack[$i++];
-      $self->$func($objnode, $funcdata);
+      $funcResult = undef;
+      $funcResult = $self->$func($objnode, $funcdata);
 
       my $type = $objnode->{type};
       my $val = $objnode->{value};
@@ -5108,6 +5114,62 @@
    return;
 }
 
+sub recurseTraverse {
+	my ($self, $deref, $objnode, $traversedRef, $func, $funcdata, $objnum) = @_;
+	
+	my $type;
+	my $val;
+	my @nodes = ();
+	my $node = undef;
+	my $newObjNum = undef;
+	
+	if ((!defined($objnode)) || (! ref $objnode )) {
+		return;
+	}
+	
+	if (defined($objnum)) {
+		$newObjNum = $objnum;
+	}
+
+	$type = $objnode->{type};
+	$val = $objnode->{value};
+	
+	if (exists $objnode->{objnum}) {
+		$newObjNum = $objnode->{objnum};
+	}
+	
+	if ((defined($newObjNum)) && 
+	    (exists ($traversedRef->{$newObjNum}))) {
+		return;
+	} else {
+		$self->$func($objnode, $funcdata);
+	}
+	
+	if ($type eq 'dictionary') {
+		push (@nodes, values %{$val});
+	} elsif ($type eq 'array') {
+		push (@nodes, @{$val});
+	} elsif ($type eq 'object') {
+		push (@nodes, $val);
+	} elsif ($type eq 'reference') {
+		if ($deref) {
+			push (@nodes, $self->dereference($val));
+		} else {
+			return;
+		}
+	} 
+
+	for $node (@nodes) {
+		recurseTraverse($self, $deref, $node, $traversedRef, $func, $funcdata, $newObjNum);
+	}
+	
+	if (($type eq 'object')) {
+		$traversedRef->{$newObjNum} = 1;
+	} 
+
+	return;
+}
+
 # decodeObject and decodeAll differ from each other like this:
 #
 #  decodeObject JUST decodes a single stream directly below the object
@@ -5538,10 +5600,11 @@
    my $self = shift;
    my $objnode = shift;
    my $newrefkeys = shift;
+   my $traversedRef = shift;
 
    my $follow = shift || 0;   # almost always false
 
-   $self->traverse($follow, $objnode, \&_changeRefKeysCB, $newrefkeys);
+   $self->recurseTraverse($follow, $objnode, $traversedRef, \&_changeRefKeysCB, $newrefkeys, 0);
    return;
 }
 
@@ -5558,9 +5621,10 @@
       if (exists $newrefkeys->{$objnode->{value}})
       {
          $objnode->{value} = $newrefkeys->{$objnode->{value}};
+         return 1;
       }
    }
-   return;
+   return 0;
 }
 
 =item $doc->abbrevInlineImage($object)
