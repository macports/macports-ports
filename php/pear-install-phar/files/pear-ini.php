<?php
# Automatically add the PEAR repository path to PHP's include_path.
set_include_path ( get_include_path (  ) . PATH_SEPARATOR . '@PREFIX@/lib/php/pear' );
