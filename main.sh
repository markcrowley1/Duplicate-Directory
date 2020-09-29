#Mark Crowley

#This programme duplicates the directory structure of
#the input directory in the output directory. All png files are 
#duplicated and converted to jpg images.
#There are 2 arguments - source and destination.


#Functions are declared
#Function to handle .png files
function handlePng {
    pngFile=$FILE
    jpgFile=${pngFile/$pngSubStr/$jpgSubStr}

    #File moved to output directory while converting to jpg
    convert $currentPath$pngFile $outputPath$jpgFile
}

#Function to handle subdirectories
function handleSubdir {
    subDir=$FILE
    currentPath=$currentPath$subDir"/"
    outputPath=$outputPath$subDir"/"

    #Check if directory already exists
    if [ ! -e $outputPath ]
    then
        mkdir $outputPath
    fi

    #Functions to reset names after returning from a subdir
    local pathReset=$currentPath
    local outputReset=$outputPath

    #Get contents of current directory
    local subList=$(ls $currentPath)
    
    #Program will iterate through subdirectories
    for FILE in $subList; do
        if [[ "$FILE" != *"."* ]] && [ ! -e $FILE ]
        #Deals with directories
        then
            handleSubdir
            currentPath=$pathReset
            outputPath=$outputReset
        #Deals with png images
        else
            if [[ "$FILE" == *$pngSubStr ]]
            then
                handlePng
            fi
        fi
    done
}

#=============================================#
#! /bin/bash
#Variables hold command line argumentsprogram
#Contain directories of interest
inputDir=$1
outputDir=$2

#Check if user has input arguments
if [ -z $inputDir ] || [ -z $outputDir ]
then 
    echo "User input incomplete"
    exit 1
else
    echo "Inputs are:" $inputDir "&" $outputDir
fi

#Check if user has input valid directories
if [ ! -e $inputDir ] || [ ! -e $outputDir ]
then 
    echo "Directory does not exist"
    exit 1
fi


#Variables hold substrings used to identify files
#Used within handleSubdir and handlePng functions
pngSubStr=.png
jpgSubStr=.jpg

#Contents of inputDir held by LIST variable
LIST=$( ls $inputDir )

#Iterate through contents of list
for FILE in $LIST; do
    if [[ "$FILE" != *"."* ]] && [ ! -e $FILE ]
    #Deals with directories
    then
        currentPath=$inputDir
        outputPath=$outputDir
        handleSubdir
    #Deals with png images
    else
        if [[ "$FILE" == *$pngSubStr ]]
        then
            currentPath=$inputDir
            outputPath=$outputDir
            handlePng
        fi
    fi
done

exit 0

