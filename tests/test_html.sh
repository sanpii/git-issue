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

	git issue new -q --title='Issue 1' --type='bug' '*First* issue'
	git issue new -q --title='Issue 2' --tags='test' '* One thing
* Other <thing>'

	git issue html -q
	git checkout -q gh-pages

	assert_file 'index.html' 'testHtmlIndex'
	assert_equal "$(cat index.html)" '<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
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
                <h2><a href="#1">#</a> [bug] Issue 1</h2>
                <a class="expand" href="#"><span class="glyphicon glyphicon-collapse-up"></span></a>
                <blockquote class="metadata">
                    <div class="tags"><span class="glyphicon glyphicon-tags"></span> -</div>
                    <div class="asign"><span class="glyphicon glyphicon-user"></span> -</div>
                    <div class="milestone"><span class="glyphicon glyphicon-bookmark"></span> -</div>
                </blockquote>
                <div class="well description">*First* issue</div>
            </div>
            <div id="2" class="issue status-new">
                <h2><a href="#2">#</a> Issue 2</h2>
                <a class="expand" href="#"><span class="glyphicon glyphicon-collapse-up"></span></a>
                <blockquote class="metadata">
                    <div class="tags"><span class="glyphicon glyphicon-tags"></span> test</div>
                    <div class="asign"><span class="glyphicon glyphicon-user"></span> -</div>
                    <div class="milestone"><span class="glyphicon glyphicon-bookmark"></span> -</div>
                </blockquote>
                <div class="well description">* One thing * Other &amp;lt;thing&amp;gt;</div>
            </div>
        </div>

        <script type="text/javascript" src="js/showdown.js"></script>
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/main.js"></script>
    </body>
</html>' 'testHtmlIndex'
}

testHtmlCharset () {
	git issue init -q
	git config issue.html.charset 'ISO8859-1'

	git issue html -q
	git checkout -q gh-pages

	assert_file 'index.html' 'testHtmlCharset'
	assert_equal "$(cat index.html)" '<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=ISO8859-1" />
        <title>Issues tracker</title>
        <link rel="stylesheet" href="css/bootstrap.min.css" />
        <link rel="stylesheet" href="css/main.css" />
    </head>
    <body>
        <div class="container">
            <div class="page-header">
                <h1>Issues tracker</h1>
            </div>

        </div>

        <script type="text/javascript" src="js/showdown.js"></script>
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/main.js"></script>
    </body>
</html>' 'testHtmlCharset'
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
