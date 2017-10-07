#!/bin/sh

run_test() {
	test_file=$1
	xmllint --noout --valid $test_file 2>/dev/null
	return $?
}

run_tests() {
	for i in $1/*.xml; do
		run_test $i
		if [ $? -ne $2 ]; then
			echo "Test $i failed"
		fi
	done
}

run_tests dtd-test/fail 4
run_tests dtd-test/pass 0
