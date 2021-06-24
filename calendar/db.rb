module DB
  def DB.array(fileName)
    if not File::exist?(fileName) 
      file = File.new(fileName, "a")
      file.close
      return 'noData'
    end
    file = File.open(fileName, "r")
    if File.size?(fileName) == nil
      return 'noData'
    end
    arrayFile = []
    while line = file.gets
      lineArray = []
      split = line.split("  ")
      for i in 0..split.length
        s = split[i]
        case s
        when "\n", " ", ","

        when "0\n"
          lineArray.push(0)
        else
          if not s == "0" and s.to_i == 0
              if not s == ""
                lineArray.push(s)
              end
          else
            lineArray.push(s.to_i)
          end
        end
      end
      lineArray.pop
      arrayFile.push(lineArray)
    end
    file.close
    return arrayFile
  end

  def DB.grid(array)
    grid = ""
    array.each do |a|
      b = -1
      a.each do |aEach|
        b += 1
        grid += "  "
        grid += aEach.to_s
        if not (a.length - 1)== b
          grid += "  ,"
        end
      end
      grid += "\n"
    end
    return grid
  end

  def DB.noData(lines, column, row, function)
    case function
    when "deleteRow", "getRow", "insertRow"
      functionRow = true
      functionColumn = false
    when "deleteColumn", "insertRow", "getColumn"
      functionRow = false
      functionColumn = true
    else
      functionRow = false
      functionColumn = false
    end
    nD = "noData"
    if lines == "noData"
      puts "There is no data in file"
      return nD
    end
    if functionRow !=  true and lines.length < (column - 1) 
      puts "There is no data in row"
      return nD
    end
    if functionColumn != true and lines[column].length < (row - 1)
      puts "There is no data in col"
      return nD
    end
  end

  def DB.getData(file, row, column)
    lines = DB.array(file)
    if DB.noData(lines, column, row, "getData") == "noData"
      return
    end
    #puts "The data is " + lines[row][column].to_s
    return lines[row][column]
  end

  def DB.getRow(file, row)
    lines = DB.array(file)
    if DB.noData(lines, column = 0, row, "getRow") == "noData"
      return
    end
    return lines[row]
  end

  def DB.getColumn(file, column)
    lines = DB.array(file)
    if DB.noData(lines, column, row = 0, "getColumn") == "noData"
      return
    end
    col = []
    lines.each do |l|
      col.push(l[column])
    end
    col
  end

  def DB.changeData(file, row, column, data)
    lines = DB.array(file)
    if DB.noData(lines, column, row, "changeData") == "noData"
      return
    end 
    lines[row][column] = data
    DB.grid(lines)
    File.write(file, DB.grid(lines))
  end

  def DB.delete(file, row, column)
    if DB.noData(lines, column, row, "delete") == "noData"
      return
    end
    lines = DB.array(file)
    lines[row][column] = "nil"
    File.write(file, DB.grid(lines))
  end

  def DB.deleteRow(file, row)
    if DB.noData(lines, column = 0, row, "deleteRow") == "noData"
      return
    end
    lines = DB.array(file)
    lines.delete_at(row)
    File.write(file, DB.grid(lines))
  end

  def DB.deleteColumn(file, column)
    lines = DB.array(file)
    if DB.noData(lines, column, row = 0, "deleteColumn") == "noData"
      return
    end
    lines.each do |l|
      l.delete_at(column)
    end
    File.write(file, DB.grid(lines))
  end

  def DB.insertRow(file, row, data)
    lines = DB.array(file)
    if DB.noData(lines, column = 0, row, "insertRow") == "noData"
      return
    end
    lines.insert(row, data)
    File.write(file, DB.grid(lines))
  end

  def DB.insertColumn(file, column, data)
    lines = DB.array(file)
    if DB.noData(lines, column, row = 0, "deleteColumn") == "noData"
      return
    end
    n = -1
    lines.each do |l|
      n += 1
      l.insert(column, data[n])
    end
    File.write(file, DB.grid(lines))
  end

  def DB.rows(file)
    lines = DB.array(file)
    lines.length
  end
end