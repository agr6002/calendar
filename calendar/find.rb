$LOAD_PATH << '.'
require 'db'
def test(num, dates, date, previous, lines)
  for i in 0...previous.length()
    p = previous[i]
    if lines[p][num] == date
      dates.push(previous[i])
    end
  end
  return dates
end

def empty(num, dates, date, previous, lines, appointment)
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

def findSpot(lines, appointment)
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
    File.write(Cal.file(), DB.gird(lines))
    return
  end

  month = appointment[2]
  months = test(2, [], month, years, lines)
  print months
  if months.empty? == true
    lines = empty(2, months, month, years, lines, appointment)
    print lines
    File.write(Cal.file(), DB.gird(lines))
    return
  end

  day = appointment[3]
  days = test(3, [], day, months, lines)
  print days
  if days.empty? == true
    lines = empty(3, days, day, months, lines, appointment)
    print lines
    File.write(Cal.file(), DB.gird(lines))
    return
  end

  hour = appointment[4]
  hours = test(4, [], hour, days, lines)
  print hours
  if hours.empty? == true
    lines = empty(4, hours, hour, days, lines, appointment)
    print lines
    File.write(Cal.file(), DB.gird(lines))
    return
  end

  minute = appointment[5]
  minutes = test(5, [], minute, hours, lines)
  puts minutes
  if minutes.empty? == true
    lines = empty(5, minutes, minute, hours, lines, appointment)
    print lines
    File.write(Cal.file(), DB.gird(lines))
    return
  end

  lines.insert(minutes[-1], appointment)
  print lines
  File.write(Cal.file(), DB.grid(lines))
end
 
findSpot(DB.array("year.csv"), ["Sports", 2020, 4, 3, 12, 20])
