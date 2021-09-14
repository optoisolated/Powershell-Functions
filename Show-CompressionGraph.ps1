# Get-RecoveryGraph.ps1
# Function that returns a String in the form of an Ascii Graph which will illustrate 
# the saving when a source and target File Size is specified.
#
# eg. Get-RecoveryGraph -SourceSize 2000MB -TargetSize 500MB
#
# Returns:
# [524288000] [############-------------------------------------] 2097152000
# 
# Input Parameters:
# -SourceSize: The Original File Size, prior to compression
# -TargetSize: The Final File Size, after compression
# -BarLength: The size of the BarGraph (excluding the end stops) in Characters (Optional)

function Get-RecoveryGraph {
    [CmdletBinding()]
    param([long]$SourceSize, [long]$TargetSize, 
          [Parameter(Mandatory=$False)][int]$BarLength=50)
    Process {     
        $FinalLen = ($TargetSize / $SourceSize) * $BarLength
        $A = "[$($TargetSize) MB] ["
        For($i=1; $i -le $FinalLen; $i++) {$A += "#"}
        For($i=1; $i -le $BarLength-$FinalLen; $i++) {$A += "-"}
        $A += "] $($SourceSize) MB" 
        Return $A
    }
}
