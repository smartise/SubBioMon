

custom_css <- "
/* Table background and border */
table.dataTable {
  background-color: white !important;
  border-color: white !important;
  color: black !important;
}

/* Table cell text color */
table.dataTable td {
  color: black !important;    /* Text color for cells */
}

/* Table header background color and text color */
table.dataTable th {

  color: black !important;             /* Header text color */
  border-color: white !important;      /* Border color */
}

/* Pagination and other buttons */
div.dataTables_wrapper div.dataTables_paginate {
  color: black !important;       /* Pagination text color */
}

div.dataTables_wrapper div.dataTables_paginate a {
  color: black !important;       /* Pagination link color */
  background-color: white !important;  /* Pagination button background */
  border-color: white !important;     /* Pagination button border */
}

div.dataTables_wrapper div.dataTables_filter input {
  background-color: white !important;  /* Search bar background */
  color: black !important;             /* Search bar text color */
  border-color: white !important;      /* Search bar border */
}

div.dataTables_wrapper div.dataTables_length select {
  background-color: white !important;  /* Length selector background */
  color: black !important;             /* Length selector text color */
  border-color: white !important;      /* Length selector border */
}

div.dataTables_wrapper .dataTables_info {
  color: black !important;             /* Table info text color */
}

div.dataTables_wrapper .dataTables_processing {
  color: black !important;             /* Processing text color */
}

div.dataTables_wrapper div.dataTables_filter input {
  color: black !important;             /* Search box text */
}

/* Style the search button */
div.dataTables_wrapper div.dataTables_filter button {
  color: black !important;
  background-color: white !important;
  border: 1px solid white !important;
}
"
