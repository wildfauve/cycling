options_cycle_time = {
  chart: {  
    type: 'column'
  },
  title: { text: "<%= @dim.title %>" },
  xAxis: {
    type: 'datetime',
  },
  yAxis: { title: { text: "<%= @dim.y %> "}, min: 0 },
  tooltip: {
        formatter: ->
          Highcharts.dateFormat("%d %B", @x) + ': ' + Highcharts.numberFormat(@y, 0)
  },
  plotOptions: {
    column: {
      pointPadding: 0.2,
      borderWidth: 0
    }
  },
  series: [{
    type: 'area',
    name: "<%= @dim.x %> ",
    # 24hrs in milliseconds
    #pointInterval: 86400 * 1000,
    # milliseconds since the Epoch; in Ruby need Time.at(t/1000) to get this
    #pointStart: 1343174400000,
    data: <%= raw @dim.data %>
  }]
}

# chart = new Highcharts.Chart(options_cards_time)

      #options_cards_time.series[0].data = plotdata.timeline.data
      #options_cards_time.series[0].pointStart = plotdata.timeline.interval_start
      #options_cards_time.series[0].pointInterval = plotdata.timeline.time_interval       
$("#cycle_chart").highcharts(options_cycle_time)