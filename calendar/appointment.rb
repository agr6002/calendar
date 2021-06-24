
module Calendar
  
  def newAppointment(title = "Untitled", hour = @@time.hour, minute = @@time.min, day = @@time.day, month = @@time.month)
    appointment = [title, day, hour, minute]
    case month
    when 1
      monthFile = "jan.csv"
    when 2
      monthFile = "feb.csv"
    when 3
      monthFile = "mar.csv"
    when 4
      monthFile = "apr.csv"
    when 5
      monthFile = "may.csv"
    when 6
      monthFile = "jun.csv"
    when 7
      monthFile = "jul.csv"
    when 8
      monthFile = "aug.csv"
    when 9
      monthFile = "sep.csv"
    when 10
      monthFile = "oct.csv"
    when 11
      monthFile = "nov.csv"
    when 12
      monthFile = "sep.csv"
    else
      monthFile = nil
    end
    for i in 1..DB.array("monthFile").length
      if DB.getData("monthFile", i, 1) == day
        if DB.getData("monthFile", i, 2) == hour
          for e in i..DB.array("monthFile").length

    DB.insertRow(monthFile, row, appointment)
  end

  def Cal.findSpot(lines, appointment)
    days = []
    for i in 1..(lines.length() - 1)
      if lines[i][3] == day
        days.push(i)
      end
    end
    before = false
    for d in 0..days.length
      pos = day[d]
      if lines[pos][4] == hour
        if lines[pos][5] == minute
          if lines[pos][6] == second 
            lines.insert(pos + 1, appointment)
          elsif lines[pos][6] > second
            lines.insert(pos, appointment)
          end
        elsif lines[pos][4] > minute
          return pos
        end
      elsif lines[pos][4].to_i > hour and before == false
        return pos
        before = true
      end
    end
  end
end