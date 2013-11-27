'use strict';

$(".issue .description").each(function () {
    var converter = new Showdown.converter();
    $(this).html(converter.makeHtml($(this).text()));
});

$(".issue .expand").on('click', function () {
    var description = $(this).nextAll(".description");
    var metadata = $(this).nextAll(".metadata");
    var expand = $(this).children();

    expand.toggleClass("glyphicon-collapse-up");
    expand.toggleClass("glyphicon-collapse-down");
    description.toggle();
    metadata.toggle();
});
$(".issue.status-close .expand").click();
