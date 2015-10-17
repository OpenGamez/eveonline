require 'au3'

class ImageProcessor
  ProgressColor1 = 0x004f66

  def self.hasTarget
    x = 1765
    y = 94
    AutoItX3.move_mouse(x/SCALE_FACTOR, (y + 5)/SCALE_FACTOR)
    sleep(1)

    validRedColors = [0xff1212]
    color = AutoItX3.get_pixel_color(x, y)

    sampledColors = [color]

    resultingArray = validRedColors & sampledColors

    if not (resultingArray).empty?
      puts 'Has Target'
      bFound = true
    else
      puts 'No Target'
      bFound = false
    end


    return bFound
  end

  def self.getOreHoldFillPercentage(x, y)
    xStartPositionProgressBar = x
    xEndPositionProgressBar = x + 393

    yPositionProgressBar = y

    x = xStartPositionProgressBar
    count = 0

    while x < xEndPositionProgressBar
      color = AutoItX3.get_pixel_color(x, yPositionProgressBar)
      r1 = (color >> 16) & 0xff
      g1 = (color >> 8) & 0xff
      b1 = (color) & 0xff
      r2 = (ProgressColor1 >> 16) & 0xff
      g2 = (ProgressColor1 >> 8) & 0xff
      b2 = (ProgressColor1) & 0xff

      manhattanDistance = (r1-r2).abs + (g1-g2).abs + (b1-b2).abs
      colorIsCloseEnough = manhattanDistance < 12

      if (colorIsCloseEnough)
        count += 5
        x += 5
      else
        break;
      end

    end

    percentage = count.to_f / (xEndPositionProgressBar.to_f - xStartPositionProgressBar.to_f)

    puts 'Ore Hold Percentage:%f' % percentage

    return percentage
  end

  def self.getSurveyScanResults
    sleep 3
    TkClipboard.set(" ")
    sleep 1
    AutoItX3.send_keys("{CTRLDOWN}")
    sleep 1
    AutoItX3.send_keys("a")
    sleep 1
    AutoItX3.send_keys("c")
    sleep 1
    AutoItX3.send_keys("{CTRLUP}")
    sleep 1

    return TkClipboard.get
  end
end