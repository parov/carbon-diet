xml.chart do
  
  xml.chart_type "3d pie"

  xml.chart_value :position=>'cursor', :size=>'12', :color=>'000000', :background_color=>'ffffff', :alpha=>'75'

  xml.legend_rect :fill_alpha=>'0'

  xml.chart_transition :type=>'drop'
    
  xml.chart_data do
    xml.row do
      xml.null
      @totals.each do |item|
        xml.string item[:name]
      end
    end
    xml.row do
      xml.null
      @totals.each do |item|
        xml.number item[:data][:total]
      end
    end
  end
  
  xml.chart_value_text do
    xml.row do
      xml.null
      @totals.each do |item|
        xml.null
      end
    end
    xml.row do
      xml.null
      @totals.each do |item|
        xml.string(item[:name] + ": " + (item[:data][:percentage].nil? ? number_with_precision(item[:data][:total],:precision => 0) + " kg" : number_with_precision(item[:data][:percentage]*100,:precision => 0) + "%"))
      end
    end
  end

  if @colours
    xml.series_color do
      @colours.each do |colour|
        xml.color colour
      end
    end
  end

end
