# -------------------------------------------------------------------------
# # Purpose
#    Main programming file for MSTest Plugin
#
# MSTest Version
#    1.0.0.0
#
# Date
#    20/9/2011
#
# Engineer
#   Mario Carmona
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use warnings;
use strict; 
$|=1;
use ElectricCommander;
# -------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------
use constant {
	METADATA_VALUE => '.vsmdi',
	CONTAINER_VALUE => '.dll',
};


  #######################################################################
  # trim - deletes blank spaces before and after the entered value in 
  # the argument
  #
  # Arguments:
  #   -untrimmedString: string that will be trimmed
  #
  # Returns:
  #   trimmed string
  #
  ########################################################################  
  sub trim($) {
   
      my ($untrimmedString) = @_;
      
      my $string = $untrimmedString;
      
      #removes leading spaces
      $string =~ s/^\s+//;
      
      #removes trailing spaces
      $string =~ s/\s+$//;
      
      #returns trimmed string
      return $string;
  }


# -------------------------------------------------------------------------
# Variables
# -------------------------------------------------------------------------
  my $ec = new ElectricCommander();
  $ec->abortOnError(0);
  
  $::gMstestType = trim($ec->getProperty("/myCall/mstestType")-> findvalue("//value")->value());
  $::gMstestFileName = trim($ec->getProperty("/myCall/mstestFileName")-> findvalue("//value")->value());
  $::gMstestLocation = trim($ec->getProperty("/myCall/mstestLocation")-> findvalue("//value")->value());
  $::gTest = trim($ec->getProperty("/myCall/test")-> findvalue("//value")->value());
  $::gTestlist = trim($ec->getProperty("/myCall/testlist")-> findvalue("//value")->value());
  $::gRunconfig = trim($ec->getProperty("/myCall/runconfig")-> findvalue("//value")->value());
  $::gResultsFile = trim($ec->getProperty("/myCall/resultsFile")-> findvalue("//value")->value());
  $::gDetailtesttype = trim($ec->getProperty("/myCall/detailtesttype")-> findvalue("//value")->value());
  $::gDetailstdout = trim($ec->getProperty("/myCall/detailstdout")-> findvalue("//value")->value());
  
  
########################################################################
# main - contains the whole process to be done by the plugin, it builds 
#        the command line, sets the properties and the working directory
#
# Arguments:
#   -none
#
# Returns:
#   -nothing
#
########################################################################
sub main() {
     # create args array
    my @args = ();
    
    #properties' map
    my %props;
        
    
    #Path where the MSTest.exe file is located
    if($::gMstestLocation   && $::gMstestLocation ne "") {
        push(@args, '"' . $::gMstestLocation . '"');
    }
    
    
    if($::gMstestFileName  && $::gMstestFileName ne "" && ($::gMstestFileName =~ m/.dll/i || $::gMstestFileName =~ m/.vsmdi/i))
    {
    	if($::gMstestFileName =~ m/.dll/i)
    	{
    		push(@args, ' /testcontainer:' .'"'. $::gMstestFileName . '"');
    		
    		 #Sets the test list if there was one defined
			    if($::gTestlist   && $::gTestlist ne "") {
			     print "You can not set up a test list when loading a file diferent from .vsmdi";
			    }
    	}
    	else
    	{
    		if($::gMstestFileName =~ m/.vsmdi/i)
	    	{
	    		push(@args,' /testmetadata:' .'"'. $::gMstestFileName . '"');
	    		
	    		 #Sets the test list if there was one defined
			    if($::gTestlist   && $::gTestlist ne "") {
			    push(@args, ' /testlist:' . $::gTestlist);
			    }
	    	}
    	}    
    }
    else
    {
    	print "The given MSTest file name doesn't have a valid extension";
    }
        
        
        #Sets the configuration file if there was one defined
    if($::gRunconfig   && $::gRunconfig ne "") {
        push(@args, ' /runconfig:' .'"'. $::gRunconfig . '"');
    }
        
                 
    #Individual tests can be defined to be run
    if($::gTest  && $::gTest  ne "") {
        foreach my $singleTest (split(' ',$::gTest)) {
            push(@args, ' /test:' . $singleTest);
        }
    }
    
    #Test type can be displayed on each test that is run
    if($::gDetailtesttype   && $::gDetailtesttype ne "") {
        push(@args, ' /detail:testtype');
    }
    
     #standart output defined on the test can be printed on the MSTest log
    if($::gDetailstdout   && $::gDetailstdout ne "") {
        push(@args, ' /detail:stdout');
    }
    
    #User defined result file
    if($::gResultsFile   && $::gResultsFile ne "") {
        push(@args, ' /resultsfile:' .'"'. "$::gResultsFile". '"');
				
    }
         
    $props{'commandLine'} = createCommandLine(\@args);
    setProperties(\%props);
}

########################################################################
# createCommandLine - creates the command line for the invocation
# of the program to be executed.
#
# Arguments:
#   -arr: array containing the command name and the arguments entered by 
#         the user in the UI
#
# Returns:
#   -the command line to be executed by the plugin
#
########################################################################
sub createCommandLine($) {

    my ($arr) = @_;

    my $commandName = @$arr[0];

    my $command = $commandName;

    shift(@$arr);

    foreach my $elem (@$arr) {
        $command .= " $elem";
    }
    return $command;
}

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties 
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties($) {

    my ($propHash) = @_;

    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
}
sub cpf_error() {
    my ($message) = @_;
    chomp($message);
    $message =~ s/\.$//;
    $message = "ERROR: $message.\n";
    
    print(STDERR $message);
    
    exit 1;
}
main();
