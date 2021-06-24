$LOAD_PATH << '.'
require 'db'
module Cal
  def Cal.file()
    file = "year.csv"
  end

  def Cal.time()
    time = Time.new
  end

  def Cal.findSpot(lines, appointment)
    yearFound = false
    if lines[1][1] < year
      lines.insert(1, appointment)
      yearFound = true
    elsif lines[-1][1] > year
      lines.insert(-1, appointment)
      yearFound = true
    end
    while yearFound == false
      years = []
      year = appointment[1]
      while years.empty? == true or hasYear == true
        for i in 1...lines.length()
          if lines[i][1] == year
            years.push(i)
          end
        end
        year -= 1
      end
      puts years.to_s
      
      months = []
      month = appointment[2]
      while months.empty? == true
        years.each do |i|
          if lines[i][2] == month
            months.push(i)
          end
        end
        month -= 1
      end
      puts months.to_s

      days = []
      day = appointment[3]
      while days.empty? == true
        months.each do |i|
          if lines[i][3] == day
            days.push(i)
          end
        end
        day -= 1
      end
      puts days.to_s

      hours = []
      hour = appointment[4]
      while hours.empty? == true
        days.each do |i|
          if lines[i][4] == hour
            hours.push(i)
          end
        end
        hour -= 1
      end
      puts hours.to_s

      minutes = []
      minute = appointment[5]
      while minutes.empty? == true
        hours.each do |i|
          if lines[i][5] == minute
            minutes.push(i)
          end
        end
        minute -= 1
      end
      puts minutes.to_s

      m = minutes[-1] 
      lines.insert(m + 1, appointment)
      puts lines.to_s
    end
  end

  def Cal.today()
    puts "Todays Activites"
    today = Time.new
    day = today.day
    lines = DB.array(Cal.file)
    for i in 1...lines.length
      if lines[i][3] == day
        puts lines[i].to_s
      end
    end
  end

  def Cal.day(day)
    dayI = day.to_i
    if not day == 0 and dayI == 0 
      puts "There was no day given"
      return
    elsif dayI == 1
      puts "The 1st's Activites" 
    elsif dayI == 2
      puts "The 2nd's Activites"
    elsif dayI == 3
      puts "The 3rd's Activities"
    else
      puts "The " + day.to_s + "th's Activities"  
    end
    lines = DB.array(Cal.file)
    for i in 1...lines.length
      if lines[i][3] == day
        puts lines[i].to_s
      end
    end
  end

  def Cal.title(name)
    if name == nil
      puts "There was no title given"
      return
    end
    title = false
    lines = DB.array(Cal.file)    
    for i in 1...lines.length
      if lines[i][0] == name
        if title == false
          puts "Activities with name " + name
          title = true
        end
        puts lines[i].to_s
      end
    end
  end

  def Cal.week()
    puts "This Weeks Activities"
    today = Time.new.day.to_i
    endDay = today.to_i + 7
    lines = DB.array(Cal.file)
    for i in 1...lines.length
      if (today <= lines[i][3].to_i) and (endDay >= lines[i][3].to_i)
        puts lines[i].to_s
      end
    end
  end

  def Cal.month()
    puts "Months Activities"
    lines = DB.array(Cal.file)
    lines.each do |i|
      puts i.to_s
    end
  end

  def Cal.test(num, dates, date, previous, lines)
    for i in 0...previous.length()
      p = previous[i]
      if lines[p][num] == date
        dates.push(previous[i])
      end
    end
    return dates
  end

  def Cal.empty(num, dates, date, previous, lines, appointment)
    first = previous[0]
    last = previous[previous.length() - 1]
    #print last
    if date > lines[last][num]
      lines.insert(last + 1, appointment)
      return lines
    elsif date < lines[first][num]
      lines.insert(first, appointment)
      return lines
    else 
      correctDate = nil
      beforeDate = date - 1
      while correctDate == nil
        for i in 0...previous.length()
          if lines[previous[i]][num] == beforeDate #lines[i][num] == beforeDate
            correctDate = previous[i] + 1
            #print correctDate
          end
        end
        beforeDate -= 1
        #puts beforeDate
      end
      lines.insert(correctDate, appointment)
      return lines
    end
  end
  
  def Cal.newAppointment(appointment)
    lines = DB.array(Cal.file())
    years = []
    year = appointment[1]
    for i in 1...lines.length()
      if lines[i][1] == year
        years.push(i)
      end
    end
    print years
    if years.empty? == true
      if year > lines[lines.length() - 1][1]
        lines.insert(lines.length(), appointment)
      elsif year < lines[1][1]
        lines.insert(1, appointment)
      else 
        correctyear = nil
        beforeyear = year -1
        while correctyear == nil
          for i in 1...lines.length()
            if lines[i][1] == beforeyear
              correctyear = i + 1
            end
          end
          beforeyear -= 1
        end
        lines.insert(correctyear, appointment)
      end
      print lines
      File.write(Cal.file(), DB.grid(lines))
      return
    end
  
    month = appointment[2]
    months = Cal.test(2, [], month, years, lines)
    print months
    if months.empty? == true
      lines = Cal.empty(2, months, month, years, lines, appointment)
      print lines
      File.write(Cal.file(), DB.grid(lines))
      return
    end
  
    day = appointment[3]
    days = Cal.test(3, [], day, months, lines)
    print days
    if days.empty? == true
      lines = Cal.empty(3, days, day, months, lines, appointment)
      print lines
      File.write(Cal.file(), DB.grid(lines))
      return
    end
  
    hour = appointment[4]
    hours = Cal.test(4, [], hour, days, lines)
    print hours
    if hours.empty? == true
      lines = Cal.empty(4, hours, hour, days, lines, appointment)
      print lines
      File.write(Cal.file(), DB.grid(lines))
      return
    end
  
    minute = appointment[5]
    minutes = Cal.test(5, [], minute, hours, lines)
    puts minutes
    if minutes.empty? == true
      lines = Cal.empty(5, minutes, minute, hours, lines, appointment)
      print lines
      File.write(Cal.file(), DB.grid(lines))
      return
    end
  
    lines.insert(minutes[-1], appointment)
    print lines
    File.write(Cal.file(), DB.grid(lines))
  end
end