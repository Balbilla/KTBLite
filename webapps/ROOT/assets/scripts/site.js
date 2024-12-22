$(function() {
  initialiseTableSorter();
  addFacetListEventHandler();
});


function addFacetListEventHandler() {
  var headings = document.getElementsByClassName("facet-header");
  for (i = 0; i < headings.length; i++) {
    headings[i].addEventListener("click", function() {
      this.classList.toggle("collapsed");
      var content = this.nextElementSibling;
      content.classList.toggle("collapsed");
    });
  }
}


function initialiseTableSorter() {
  var $table = $('.tablesorter');

  var pagerOptions = {
    container: $(".tablesorter-pager"),
    output: "{startRow} – {endRow} / {filteredRows} of {totalRows} total rows",
    cssGoto: ".gotoPage",
    removeRows: true,
    size: 50
  };

  $table.tablesorter({
    headerTemplate: "{content} {icon}",
    widgets: ["columnSelector", "filter", "zebra"],
    widgetOptions: {
      columnSelector_container: $("#column_selector"),
      columnSelector_layout: '<label><input type="checkbox">{name}</label>',
      columnSelector_layoutCustomizer: null,
      columnSelector_maxVisible: null,
      columnSelector_minVisible: 1,
      columnSelector_cssChecked: "checked",
      columnSelector_updated: "columnUpdate",
      filter_columnFilters: true,
      filter_functions: {
          9: function(e, n, f, i, $r, c, data) {
              let pattern = new RegExp(f, "i");
              return pattern.test(e);
          }
      }
    }
  }).tablesorterPager(pagerOptions);

  $table.removeClass("uk-hidden");
}
