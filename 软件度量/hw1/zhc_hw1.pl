use Understand;

#获取文件句柄
open($filehandle,">gnuit-4.9.5.csv");


#输出标题

print $filehandle "FunctionName, RelativePath, CountLineCode, CountPath, Cyclomatic, MaxNesting, Knots, CountInput, CountOutput\n";


#打开udb数据库

$db = Understand::open("gnuit-4.9.5.udb");

foreach $function ($db->ents("function ~unknown ~unresolved"))

{

	print $filehandle $function->name(), ", ";#名称

	print $filehandle $function->parent()->relname(), ", ";#相对路径

	print $filehandle $function->metric("CountLineCode"), ", ";

	print $filehandle $function->metric("CountPath"), ", ";

	print $filehandle $function->metric("Cyclomatic"), ", ";

	print $filehandle $function->metric("MaxNesting"), ", ";

	print $filehandle $function->metric("Knots"), ", ";

	print $filehandle $function->metric("CountInput"), ", ";

	print $filehandle $function->metric("CountOutput"), "\n";

}


#关闭文件
close $filehandle  or die "Cannot close the file handle\n";

print "success\n";