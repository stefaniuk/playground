#!/usr/bin/perl -w

`chmod 655 /srv/scripts/perlmod.pl`;
$version = `/srv/scripts/perlmod.pl -vh`;

$cpan_url = "http://search.cpan.org";
$main_module = "";
$install_dir = "perlmod_installer";
chdir('/tmp');
`rm -rf $install_dir`;
@installed_modules = ();
@toinstall_modules = ('IO::Dir', 'ExtUtils::Packlist', 'ExtUtils::Installed', 'SOAP::Lite', 'HTML::Entities');

# taking perl modules from command line one by one
foreach $module(@toinstall_modules){	
	my $ret;

	if($module eq '') {next;}	
	$main_module = $module = &formatModuleName($module);

	$ret = &isModuleInstalled($module);
	if($ret ne 'installed'){
		&installModule($module);
	}else{
		print $module." already installed\n";
	}

}

print("\033[1m\nperlmod $version successfully installed in the system\n\n\033[0m");
exit;

# function to install perl module
sub installModule(){
	my($module) = @_;

	$check_module = &formatModuleName($module);
	$module =~ s/:/%3A/g;
	
	$url = "$cpan_url/search?query=$module&mode=all";
	print "$url\n";
	$html = &getContentUrl($url);

	#if($html =~ /<!--results-->.*?href="(.*?)"><b>$check_module<\/b>/i){
	if($html =~ /.*<a href="(.*?)"><b>$check_module<\/b><\/a>/i){

		print $url = "$cpan_url$1";
		$html = &getContentUrl($url);

		if($html =~ /Download:.*?href="(.*?)"/i){
			print "matched";
			@url_tmp = split('/', $1);
			$tar_file = $url_tmp[$#url_tmp];
			print $download_url = $cpan_url."/".$1;

			`mkdir $install_dir`;
			chdir($install_dir);
			`wget $download_url`;
			`tar -zxf $tar_file`;
			if($dir_name = &getDirectoryName()){
				print "\nDirectory Name: $dir_name\n";
				chdir($dir_name);
				system("perl Makefile.PL");
				`make`;
				`make install`;
				chdir('../../');
				`rm -rf $install_dir`;
				$ret = &isModuleInstalled($check_module);
				if($ret eq 'installed'){
					#print "\n====================================================================\nModule $check_module Installed Successfully..						   \n=====================================================================\n";
					push (@installed_modules, $check_module);  
					if($check_module ne $main_module){
						print "\nMain Module".$main_module."\n";
						$ret = &isModuleInstalled($main_module);
						if($ret ne 'installed'){
							$install_module = &getBaseClass($ret,$main_module);
							if($install_module eq "failed"){
								print "\n================================================================\nModule $main_module Installation Failed..!! \n=================================================================\n";
								return 0;
							}else{
								if($install_module ne ""){
									&installModule($install_module);
									return 0;
								}
							}
						}						
					}
					return 1;
				}else{
					$install_module = &getBaseClass($ret,$check_module);
					if($install_module eq "failed"){
						print "\n================================================================\nModule $check_module Installation Failed..!! \n=================================================================\n";
						return 0;
					}else{
						if($install_module ne ""){
							&installModule($install_module);
							return 0;
						}
					}				
				}				
			}
			
		}
	}

	print "\n================================================================\n Module $check_module Not Found in Cpan.org..!! \n=================================================================\n";
}

# func to find dependencies of current module
sub getBaseClass(){
	my($ret,$check_module) = @_;
	print "\n".$ret;
	$install_m = "";
	if($ret !~ /Can't locate (.*?) in /){		
		if($ret !~ /Base class package "(.*?)" is empty/){
			if($ret =~ /via package "(.*?)" at /){
				$install_m = $1;
			}
		}else{
			$install_m = $1;
		}
	}else{
		$install_m = $1;
	}

	print "\n$install_m\n";

	$install_module = &formatModuleName($install_m);
	if(($install_m eq "") || ($install_module eq $check_module)){
		return "failed";
	}

	if(grep /^$install_module$/, @installed_modules){
		return "failed";
	}
	return $install_module;
	
}

# function to format module name
sub formatModuleName(){
	my($module) = @_;
	$module =~ s/\/+/\//g;
	$module =~ s/\//::/g;
	$module =~ s/:+/::/g;
	$module =~ s/\.pm//ig;
	return $module;	
}

# func to check module installed in system
sub isModuleInstalled(){
	my($module) = @_;

	`perl -e "use $module" 2>out.txt`;
	open (OUT, "out.txt");
	$file = "";
	while(<OUT>){
		$file .= $_;
	}
	close (OUT);
	`rm out.txt`;

	if($file eq ""){
		return 'installed';
	}else{
		return $file;
	}
}

# func to get content of a url
sub getContentUrl(){
	my($url) = @_;
	$content = `wget --tries=45  --force-html -O - $url`;
	$content =~ s/\n//g;
	$content =~ s/\r//g;
	$content =~ s/\r\n//g;
	return $content; #decode_entities($content);
	
}

# func to get perl module directory from a folder
sub getDirectoryName(){
	@files = <*>;
	foreach $file (@files) {
		if (-d $file) {
			return $file;
		}
	}
	return 0;
}
