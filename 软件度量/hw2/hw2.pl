use Understand;

$db = Understand::open("bash-4.2.udb");

%fuction_num = ();

#初始化一个hash表
#格式为 相对路径->函数名 数量
foreach my $func ($db->ents("function ~unknown ~unresolved"))
	{
		$fuction_num{ $func->parent()->relname() . "->" . $func->name() } = 0;
	}
#对每一个patch进行分析	
for($i = 1;$i<=53; $i++)
	{
	analysis($i);
	}
	
Result();

##################
sub analysis{
	$num = $_[0];
	$patchname = "bash-patches/bash42-00".$num;
	if( $num >=10 )
	{
		$patchname = "bash-patches/bash42-0".$num;
	}
	print "analysis patch:".$patchname."\n";
	
	open($filehandle,"<".$patchname)or die "can't open file\n, $!";;
	#一个bug file 对应多个bug 函数
	while( $lines = <$filehandle> )
			{
			if( $lines =~ /^\*\*\* / and $lines !~ /\*\*\*\*$/ )#所有的bug都由***开头，但结尾不包含****
				{
					#print $lines;
					@sub_lines= split(' ',$lines);#*** ../bash-4.2-patched/subst.c 2011-01-02 16:12:51.000000000 -0500
					$bug_name = substr($sub_lines[1], 3, length($sub_lines[1])-3);
					$bug_name =~ s/\//\\/g;  #将/改为\
					$bug_name =~ s/-patched//g;#去掉-patched
					}
				elsif ( $lines =~ /^\*\*\* / and $lines =~ /\*\*\*\*$/ )#所有的修改都由***开头，结尾包含****
				{
					$lines =~ s/\*//g; 
					$lines =~ s/ //g; 
					@sub_num= split(',',$lines);
					if(-e $bug_name)#判断文件是否存在
					{
					#print $bug_name."\n";
					SearchSource($bug_name, @sub_num);
					}			
				}
			}
	close $filehandle or die "can't close file\n,$!";
}
																																																								
sub SearchSource{
	my $sourcename = $_[0];
	my $start = int($_[1]);
	my $end = int($_[2]);
	my $i = 0;
	my $source = "";
	open(my $filehandle,"<".$sourcename);
	while ( my $lines = <$filehandle>)
	{
		$i ++;
		if( $i>=$start and $i <= $end )
		{
			$source .= $lines;
			}
	}
	#print $source;
	close $filehandle or die "Cannot close the file handle\n,$!" ;
	
	foreach my $func ($db->ents("function ~unknown ~unresolved"))
	{
		if( $func->parent()->relname eq $sourcename ) #该文件中的某函数
		{
			if( index($func->contents(), $source) != -1 )     #该bug文本属于该函数
			{
				$fuction_num{ $func->parent()->relname() . "->" . $func->name() } += 1;
			}
		}
	}	
}

sub Result{

#统计所有的函数和bug数量
	print "***output all fuction***"."\n";
	open(my$filehandle,">bash-4.2-all_fuction_num.csv");
	print $filehandle "FunctionName, RelativePath,NumberOfBugs\n";
	foreach my $func ($db->ents("function ~unknown ~unresolved"))
	{
		my $key = $func->parent()->relname() . "->" . $func->name();
		my $num = $fuction_num{$key};
		print $filehandle $func->name(), ", ";#名称
		print $filehandle $func->parent()->relname(), ", ";#相对路径
		print $filehandle $num,"\n";
		}
	close $filehandle or die "Cannot close the file handle\n,$!" ;

	print "***output buggy fuction***"."\n";
#统计含有 bug的函数和数量
	open(my$filehandle,">bash-4.2-bug_fuction_num.csv");
	print $filehandle "FunctionName, NumberOfBugs\n";
	foreach my $key ( keys %fuction_num )
	{
		my $value = $fuction_num{$key};
		if($value > 0)
		{
			print $filehandle $key, ", ";
			print $filehandle $value, "\n";
		}
	}
	close $filehandle or die "Cannot close the file handle\n,,$!";
}