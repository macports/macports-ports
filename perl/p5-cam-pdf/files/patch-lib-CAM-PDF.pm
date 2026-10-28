--- lib/CAM/PDF.pm.orig
+++ lib/CAM/PDF.pm
@@ -1032,7 +1032,7 @@
 
    if (${$c} !~ m/ \G\s*(\d+)\s+(\d+)\s+obj\s* /cgxms) ##no critic(ProhibitUnusedCapture)
    {
-      die "Expected object open tag\n" . $self->trimstr(${$c});
+      die "Expected object open tag, got:  \"" . $self->trimstr(${$c} . "\"");
    }
    # need to implement like this with explicit capture vars for 5.6.1
    # compatibility
@@ -1714,8 +1714,9 @@
       #print "Filling cache for obj \#$key...\n";
 
       my $pos = $self->{xref}->{$key};
+      my $posAsInt = int($pos);
 
-      if (!$pos)
+      if (!$posAsInt)
       {
          warn "Bad request for object $key at position 0 in the file\n";
          return;
@@ -4884,9 +4885,20 @@
 
    # Turn off Linearization, if set
    my $first;
+   my $firstObjPos = undef;
    if (exists $self->{order})
    {
-      $first = $self->{order}->[0];
+      my $iterator = 0;
+      my $iteratorMAX = $#{$self->{order}};
+      ## find the first object at a non-zero position:
+      do {
+         $first = $self->{order}->[$iterator];
+         $firstObjPos = int($self->{xref}->{$first});
+         $iterator++;
+      } while (!$firstObjPos && $iterator < $iteratorMAX);
+      if (!$firstObjPos) {
+         die "ERROR: Failed to find first object with non-zero position";
+      }
    }
    else
    {
@@ -4894,6 +4906,7 @@
       ($first) = sort {$x->{$a} <=> $x->{$b}} grep {!ref $x->{$_}} keys %{$x};
    }
 
+
    my $objnode = $self->dereference($first);
    if ($objnode->{value}->{type} eq 'dictionary')
    {
@@ -5211,6 +5224,12 @@
 {
    my $self = shift;
    my $objnum = shift;
+   my $objref = $self->dereference($objnum);
+
+   if ((!defined($objref)) || (!ref $objref)) {
+      warn "WARN:  Failed to get object reference for object number $objnum, not writing it out...\n";
+      return "";
+   }
 
    return "$objnum 0 " . $self->writeAny($self->dereference($objnum));
 }
