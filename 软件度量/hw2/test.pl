use Understand;

$db = Understand::open("bash-4.2.udb");
%fuction_num = ();
%content = ();
foreach $func ($db->ents("function ~unknown ~unresolved"))	{
		$content{ $func->parent()->relname() . "->" . $func->name() } = $func->contents();
		$fuction_num{ $func->parent()->relname() . "->" . $func->name() } = 0;
	}
$db->close();

for ($i=1; $i<=53;$i++ )
 {
      if($i<10 ){
       $patchname = "../bash-4.2-patches/bash42-00".$i;
      }else{
       $patchname = "../bash-4.2-patches/bash42-0".$i;
  
      }
  print "analysis patch:".$patchname."\n";
  #print($patchname);
  system ("patch -p0 < ".$patchname);
  system ("und analyze -changed bash-4.2.udb");
  $db = Understand::open("bash-4.2.udb");
  #更改后的数据库进行比较
  foreach $func ($db->ents("function ~unknown ~unresolved"))	{
		$change = $func->contents();
		$orign = $content{$func->parent()->relname() . "->" . $func->name() };
		if ( $change ne $orign )
	   {
			$fuction_num{ $func->parent()->relname() . "->" . $func->name() } += 1;
		    $content{ $func->parent()->relname() . "->" . $func->name() } = $func->contents();
		    print $func->name()."\n";
		}
	}
$db->close();            
}
foreach  $key ( keys %fuction_num )
	{
		$value = $fuction_num{$key};
		if($value > 0)
		{
			print $key, ", ";
			print $value, "\n";
		}
	}
   open( $filehandle,">bash-4.2-bug_fuction_num.csv");
	print $filehandle "FunctionName, NumberOfBugs\n";
	foreach $key ( keys %fuction_num )
	{
		$value = $fuction_num{$key};
		if($value > 0)
		{
			print $filehandle $key, ", ";
			print $filehandle $value, "\n";
		}
	}
	close $filehandle or die "Cannot close the file handle\n,,$!";
