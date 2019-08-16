import "bootstrap";
// Uncomment if using chart.js
require("chartkick")
require("chart.js")
// Uncomment if using highcharts
// require("chartkick").use(require("highcharts"))
import { saveAs } from 'file-saver';
window.Sortable = require('sortablejs').default;

window.Chartkick = Chartkick
Chartkick.addAdapter(Chart)
Chartkick.options = {
  library: {animation: {easing: 'easeOutQuart'}},
}
