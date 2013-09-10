options_cycle_time = {
  chart: { 
    renderTo: 'cycle_chart', 
    defaultSeriesType: 'column'
  },
  title: { text: 'Cycle Time Average per Day' },
  xAxis: {
    type: 'datetime',
  },
  yAxis: { title: { text: 'Avg Cycle Time'}, min: 0 },
  tooltip: {
        formatter: ->
          Highcharts.dateFormat("%B %Y", @x) + ': ' + Highcharts.numberFormat(@y, 0)
  },
  series: [{
    type: 'area',
    name: 'Date Made',
    # 24hrs in milliseconds
    #pointInterval: 86400 * 1000,
    # milliseconds since the Epoch; in Ruby need Time.at(t/1000) to get this
    #pointStart: 1343174400000,
    data: <%= raw Story.cycle_dimension %>
  }]
}

# chart = new Highcharts.Chart(options_cards_time)

      #options_cards_time.series[0].data = plotdata.timeline.data
      #options_cards_time.series[0].pointStart = plotdata.timeline.interval_start
      #options_cards_time.series[0].pointInterval = plotdata.timeline.time_interval       
$("#cycle_chart").highcharts(options_cycle_time)