import { Controller } from 'stimulus';
import { Chart } from 'chart.js';
import ChartAnnotation from 'chartjs-plugin-annotation';
import ChartDatalabels from 'chartjs-plugin-datalabels';

const PRIMARY_COLOR = '#1C4637';
const ACCENT_COLOR = '#48A12A';

const SOLID_BARS_STYLING = {
  backgroundColor: [
    '#BBD3BD',
    'transparent',
    '#BBD3BD'
  ],
  borderColor: [
    '#BBD3BD',
    '#BBD3BD',
    '#BBD3BD'
  ],
  borderWidth: 2
};
const SOLID_BARS_STYLING_NEW = {
  backgroundColor: [
    ACCENT_COLOR,
    'transparent',
    ACCENT_COLOR
  ],
  borderColor: [
    ACCENT_COLOR,
    ACCENT_COLOR,
    ACCENT_COLOR
  ],
  borderWidth: 2
};

const OFFSET_BAR_STYLING = {
  backgroundColor: [
    'transparent',
    'transparent',
    'transparent'
  ],
  borderColor: [
    'transparent',
    '#BBD3BD',
    'transparent'
  ],
  borderWidth: 1,
  datalabels: {
    display: false
  }
};
const OFFSET_BAR_STYLING_NEW = {
  backgroundColor: [
    'transparent',
    'transparent',
    'transparent'
  ],
  borderColor: [
    'transparent',
    ACCENT_COLOR,
    'transparent'
  ],
  borderWidth: 1,
  datalabels: {
    display: false
  }
};

function targetAnnotation(target, label) {
  return {
    annotation: { // should be under plugins key, but doesn't work
      annotations: [
        {
          drawTime: 'afterDatasetsDraw',
          type: 'line',
          mode: 'horizontal',
          scaleID: 'y-axis-0',
          value: target,
          borderColor: PRIMARY_COLOR,
          borderWidth: 1,
          borderDash: [5, 5],
          label: {
            backgroundColor: 'transparent',
            fontColor: PRIMARY_COLOR,
            fontStyle: 'normal',
            content: label,
            enabled: true,
            position: 'right',
            xAdjust: -0,
            yAdjust: 10
          }
        },
        {
          drawTime: 'afterDatasetsDraw',
          type: 'line',
          mode: 'horizontal',
          scaleID: 'y-axis-0',
          value: target,
          borderColor: 'transparent',
          borderWidth: 1,
          borderDash: [5, 5],
          label: {
            backgroundColor: 'transparent',
            fontColor: PRIMARY_COLOR,
            content: [target],
            enabled: true,
            position: 'right',
            xAdjust: -0,
            yAdjust: -10
          }
        }
      ]
    }
  };
}

function scales(max) {
  return {
    scales: {
      yAxes: [{
        display: false,
        gridLines: {
          display: false
        },
        ticks: {
          display: false,
          beginAtZero: true,
          max
        }
      }],
      xAxes: [{
        stacked: true,
        gridLines: {
          display: true,
          drawTicks: false,
          drawOnChartArea: false,
          color: PRIMARY_COLOR
        },
        ticks: {
          fontColor: PRIMARY_COLOR,
          beginAtZero: true,
          padding: 5
        }
      }]
    }
  };
}

export default class LifestyleFootprintChartController extends Controller {
  initialize() {
    this.chart = new Chart(this.element, this.chartConfig());
  }

  chartConfig() {
    return {
      type: 'bar',
      data: {
        labels: [
          this.data.get('userLabel'),
          this.data.get('offsetLabel'),
          this.data.get('countryLabel'),
          ''
        ],
        datasets: [
          {
            data: [
              this.data.get('userFootprint'),
              0,
              this.data.get('countryAverage'),
              null
            ],
            ...(this.data.get('newDesign') ? SOLID_BARS_STYLING_NEW : SOLID_BARS_STYLING)
          },
          {
            data: [null, this.data.get('userFootprint'), null],
            ...(this.data.get('newDesign') ? OFFSET_BAR_STYLING_NEW : OFFSET_BAR_STYLING)
          }
        ]
      },
      plugins: [ChartAnnotation, ChartDatalabels],
      options: {
        responsive: true,
        maintainAspectRatio: true,
        legend: {
          display: false
        },
        tooltips: {
          enabled: false
        },
        plugins: {
          datalabels: {
            anchor: 'end',
            align: 'end',
            offset: 1,
            font: {
              weight: 'bold'
            },
            color: PRIMARY_COLOR
          }
        },
        ...scales(
          Math.max(
            this.data.get('userFootprint'),
            this.data.get('countryAverage')
          ) + 3
        ),
        ...targetAnnotation('2.5', this.data.get('targetLabel'))
      }
    };
  }
}
