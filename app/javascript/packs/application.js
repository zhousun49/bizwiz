import "bootstrap";
// Uncomment if using chart.js
require("chartkick")
require("chart.js")
// Uncomment if using highcharts
// require("chartkick").use(require("highcharts"))
import { saveAs } from 'file-saver';

if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
  window.Sortable = require('sortablejs');
}else
{
  window.Sortable = require('sortablejs').default;
}
