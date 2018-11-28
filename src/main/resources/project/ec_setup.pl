
# Data that drives the create step picker registration for this plugin.
my %runMSTest = (
    label       => "MSTest - Run MSTest",
    procedure   => "runMSTest",
    description => "Integrates MSTest test framework into Electric Commander",
    category    => "Test"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/MSTest");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/MSTest - Run MSTest");

@::createStepPickerSteps = (\%runMSTest);
