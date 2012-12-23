module Volume
  def volume
    `osascript -e 'output volume of (get volume settings)'`.chomp.to_i
  end

  def volume= value
    `osascript -e 'set volume output volume #{value}'`
  end
end