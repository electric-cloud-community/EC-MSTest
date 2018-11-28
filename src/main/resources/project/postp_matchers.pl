use ElectricCommander;



push (@::gMatchers,
  {
        id =>          "fileNotFound",
        pattern =>     q{^File(.+)not found},
        action =>           q{     	                
        	                   my $invalidPath;
        	                  
                              $invalidPath= "File $1 not found";

                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $invalidPath . "\n");
                               setProperty("/myJobStep/outcome", 'error');

                             },                   
  },
);

push (@::gMatchers,
  {
        id =>          "pathNotFound",
        pattern =>     q{^The system cannot find the path specified .+},
        action =>           q{     	                
        	                   my $invalidPath;
        	                  
                              $invalidPath= "The system cannot find the path specified";

                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $invalidPath . "\n");
                               setProperty("/myJobStep/outcome", 'error');

                             },                   
  },
);

push (@::gMatchers,
  {
        id =>          "notACommand",
        pattern =>     q{(.+)is not recognized as an internal or external command.+},
        action =>           q{     	                
        	                   my $invalidCommand;
        	                  
                              $invalidCommand= "$1 is not recognized as an internal or extenal command, operable program or batch file";

                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $invalidCommand . "\n");
                               setProperty("/myJobStep/outcome", 'error');

                             },                   
  },
);

push (@::gMatchers,
  {
        id =>          "invalidSwitch",
        pattern =>     q{^Invalid switch (.+)},
        action =>           q{     	                
        	                   my $invalidCommand;
        	                  
                              $invalidCommand= "Invalid Switch $1";

                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $invalidCommand . "\n");
                               setProperty("/myJobStep/outcome", 'error');

                             },                   
  },
);



push (@::gMatchers,
  {
        id =>          "invalid_testmetadata",
        pattern =>     q{^Data at the root level is invalid.+},
        action =>           q{     	                
        	                   my $invalidData;
        	                  
                              $invalidData= "Not a Valid file extension. The file extension for TestMetadata type must be .vsmdi" ;

                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $invalidData . "\n");
                               setProperty("/myJobStep/outcome", 'error');

                             },                   
  },
);

push (@::gMatchers,
  {
        id =>          "invalid_testcontainer",
        pattern =>     q{^File extension specified.+},
        action =>           q{     	                
        	                   my $invalidData;
        	                  
                              $invalidData= "Not a Valid file extension. The file extension for TestContainer type must be .dll" ;

                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $invalidData . "\n");
                               setProperty("/myJobStep/outcome", 'error');

                             },                   
  },
);


push (@::gMatchers,
  {
        id =>          "filAlreadyExists",
        pattern =>     q{^The results file (.+) already exists .+},
        action =>           q{     	                
        	                   my $fileExists;
        	                  
                              $fileExists= "The results file $1 already exists" ;

                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $fileExists . "\n");
                               setProperty("/myJobStep/outcome", 'error');

                             },                   
  },
);

push (@::gMatchers,
  {
        id =>          "invalidExtension",
        pattern =>     q{^The given MSTest file name doesn't have a valid extension.+},
        action =>           q{     	                
        	                   my $invalidExt;
        	                  
                              $invalidExt= "The given MSTest file name doesn't have a valid extension" ;

                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $invalidExt . "\n");
                               setProperty("/myJobStep/outcome", 'error');

                             },                   
  },
);


push (@::gMatchers,
  {
        id =>          "failed_tests",
        pattern =>     q{^Failed.+},
        action =>           q{
        	                  incValue("failedTests");
        	                
        	                  my $totalFailed=$::gProperties{"failedTests"};
        	                  my $totalPassed=$::gProperties{"passedTests"};
        	                   my $failedDesc;
        	                  
                              if($totalPassed){
                              $failedDesc= "Test Failed: " .$totalFailed . " Test Passed: " .$totalPassed ;
                              }else{
                              $failedDesc= "Test Failed: " .$totalFailed . " Test Passed: 0" ;
                              }
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $failedDesc . "\n");
                               setProperty("/myJobStep/outcome", 'error');
                                                              
                              diagnostic("", "error", 0);
                             },                   
  },
);
push (@::gMatchers,
{
        id =>          "passed_tests",
        pattern =>     q{^Passed.+},
        action =>           q{
        	                  incValue("passedTests");
        	                      	                  
        	                  my $totalFailed=$::gProperties{"failedTests"};
        	                  my $totalPassed=$::gProperties{"passedTests"};
                               my $passedDesc;
                              if ($totalFailed){
                                $passedDesc= "Test Failed: " .$totalFailed . " Test Passed: " .$totalPassed ;
                              }else{
                                $passedDesc= "Test Failed: 0 Test Passed: " .$totalPassed ;
                              }
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
                               setProperty("summary", $passedDesc . "\n");                               
                                                              
                              diagnostic("", "info", 0);
                             },                   
  },
);