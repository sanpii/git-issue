#!/bin/bash

setUp () {
	createTestRepository

	git config issue.html.showdow file:///dev/null
	git config issue.html.jquery file:///dev/null
	git config issue.html.bootstrap file:///dev/null
}

tearDown () {
	deleteTestRepository
}

testHtmlVendor () {
	local output

	git issue init -q

	output="$(git issue html 2>&1)"
	local status=$?

	assert_equal "$output" "Download js/showdown.js
Download js/jquery.js
Download css/bootstrap.min.css
Download fonts/glyphicons-halflings-regular.woff
Download fonts/glyphicons-halflings-regular.ttf
Download fonts/glyphicons-halflings-regular.svg
Download fonts/glyphicons-halflings-regular.eot
HTML generated in the 'gh-pages' branch." 'testHtmlVendor'
	assert_numeq $status 0 'testHtmlVendor'

	git checkout -q gh-pages

	assert_file 'js/showdown.js' 'testHtmlVendor'
	assert_file 'js/jquery.js' 'testHtmlVendor'
}

testHtmlIndex () {
	git issue init -q

	git issue new -q --title='Issue 1' '*First* issue'
	git issue new -q --title='Issue 2' '* One thing
* Other <thing>'

	git issue html -q
	git checkout -q gh-pages

	assert_file 'index.html' 'testHtmlIndex'
	assert_equal "$(cat index.html)" '<!DOCTYPE html>
<html>
    <head>
        <title>Issues tracker</title>
        <link rel="stylesheet" href="css/bootstrap.min.css" />
        <link rel="stylesheet" href="css/main.css" />
    </head>
    <body>
        <div class="container">
            <div class="page-header">
                <h1>Issues tracker</h1>
            </div>

            <div id="1" class="issue status-new">
                <h2><a href="#1">#</a> Issue 1</h2>
                <a class="expand" href="#"><span class="glyphicon glyphicon-collapse-up"></span></a>
                <blockquote class="description">*First* issue</blockquote>
            </div>
            <div id="2" class="issue status-new">
                <h2><a href="#2">#</a> Issue 2</h2>
                <a class="expand" href="#"><span class="glyphicon glyphicon-collapse-up"></span></a>
                <blockquote class="description">* One thing * Other &amp;lt;thing&amp;gt;</blockquote>
            </div>
        </div>

        <script type="text/javascript" src="js/showdown.js"></script>
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/main.js"></script>
    </body>
</html>' 'testHtmlIndex'
}

testHtmlBranch () {
	local output

	git issue init -q
	git config issue.html.branch issues-html

	output="$(git issue html 2>&1)"
	local status=$?

	assert_equal "$output" "Download js/showdown.js
Download js/jquery.js
Download css/bootstrap.min.css
Download fonts/glyphicons-halflings-regular.woff
Download fonts/glyphicons-halflings-regular.ttf
Download fonts/glyphicons-halflings-regular.svg
Download fonts/glyphicons-halflings-regular.eot
HTML generated in the 'issues-html' branch." 'testHtmlVendor'
	assert_numeq $status 0 'testHtmlBranch'

	outpu="$(git checkout -q gh-pages 2>&1)"
	local status=$?
	assert_numeq $status 1 'testHtmlBranch'

	outpu="$(git checkout -q issues-html 2>&1)"
	local status=$?
	assert_numeq $status 0 'testHtmlBranch'
}

. $CWD/tests/common.sh
