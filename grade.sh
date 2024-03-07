CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

set -e

# Clone student submission
git clone $1 student-submission
echo 'Finished cloning'

# Check if student has correct file submitted
if [ -f student-submission/ListExamples.java ];
then 
    echo 'Correct file is submitted'
else
    echo 'Incorrect file is submitted. Did you clone the correct file?'
fi
# Get student code and put it into grading-area
cp -r student-submission/* grading-area/

# Compile tests and student's code
set +e
javac grading-area/ListExamples.java
if [ $? -ne 0 ];
then
    echo 'Does not compile!'
fi
javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java
java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > student-submission/junit_output.txt

# Extract Test Summary
grep "Tests run" student-submission/junit_output.txt

# Calculate Grade Ratio
grep "Tests run" student-submission/junit_output.txt | awk -F, '{split($1,a,": "); split($2,b,": "); split($3,c,": "); split($4,d,": "); passed=a[2]-(b[2]+c[2]); print "Grade: "passed"/"a[2]}'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
