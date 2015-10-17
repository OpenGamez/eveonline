require_relative 'InputSimulation'

class GameCommands
  def self.toggleTargetLock
    x = 1765
    y = 94
    InputSimulation.SimulateMouseClick(x, y, "left")
  end

  def self.startModule(slot)
    puts ['Start Module: ', slot]
    sleep(1)
    AutoItX3.send_keys(slot)
  end

  def self.toggleMiningTurret(turret)
    puts ['Toggle Mining Turret: ', turret]
    sleep(1)
    AutoItX3.send_keys(turret)
  end

  def self.targetFirstAsteroidInOverviewMiningTab
    puts 'TargetFirstAsteroidInOverviewMiningTab'
    sleep(1)
    SelectOverviewMiningTab()
    sleep(1)
    TargetOverviewFirstTarget()
  end

  def self.targetSecondAsteroidInOverviewMiningTab
    puts 'TargetSecondAsteroidInOverviewMiningTab'
    sleep(1)
    SelectOverviewMiningTab()
    sleep(1)
    TargetOverviewSecondTarget()
    GoToNextTargetInTargetGroup()
  end

  def self.GoToNextTargetInTargetGroup
    sleep(1)
    AutoItX3.send_keys("{ALTDOWN}")
    sleep(1)
    AutoItX3.send_keys("{RIGHT}")
    sleep(1)
    AutoItX3.send_keys("{ALTUP}")
    sleep(2)
  end

  def self.SelectOverviewMiningTab
    puts 'SelectOverviewMiningTab'
    sleep(1)
    InputSimulation.SimulateMouseClick(1723,150, "left")
  end

  def self.selectSurveyScanResultsWindow
    puts 'SelectSurveyScanResults'
    sleep 1
    InputSimulation.SimulateMouseClick(960,480, "left")
  end

  def self.TargetOverviewFirstTarget
    puts 'TargetOverviewFirstTarget'
    sleep(1.5)
    AutoItX3.send_keys("{CTRLDOWN}")
    sleep(1.5)
    InputSimulation.SimulateMouseClick(1723,190, "left")
    sleep(1.5)
    AutoItX3.send_keys("{CTRLUP}")
    sleep(2.5)
  end

  def self.TargetOverviewSecondTarget
    puts 'TargetOverviewSecondTarget'
    sleep(1)
    AutoItX3.send_keys("{CTRLDOWN}")
    sleep(1)
    InputSimulation.SimulateMouseClick(1723,207, "left")
    sleep(1)
    AutoItX3.send_keys("{CTRLUP}")
    sleep(2)
  end

  def self.dock
    puts 'Dock'
    sleep 1
    InputSimulation.SimulateMouseClick(110,640, "right")
    sleep 1
    InputSimulation.SimulateMouseClick(130,710, "right")
  end

  def self.launchDrones
    puts 'LaunchDrones'
    sleep(1)
    InputSimulation.SimulateMouseClick(1750,450, "right")
    sleep(1)
    InputSimulation.SimulateMouseClick(1775,460, "left")
    sleep(1)
  end

  def self.selectGameWindow
    sleep(1)
    InputSimulation.SimulateMouseClick(1800,30, "left")
  end

  def self.recallDrones
    GameCommands.selectGameWindow
    puts 'RecallDrones'
    sleep(1)
    AutoItX3.send_keys("{SHIFTDOWN}")
    sleep(1)
    AutoItX3.send_keys("r")
    sleep(1)
    AutoItX3.send_keys("{SHIFTUP}")
    sleep(2)
  end

  def self.ReconnectDrones
    puts 'ReconnectDrones'
    sleep(1)
    InputSimulation.SimulateMouseClick(2048, 1080, "right")
    sleep(1)
    InputSimulation.SimulateMouseClick(2114, 1331, "left")
  end

  def self.transferOreToItemHangar
    puts 'TransferOreToItemHangar'
    sleep(1)
    AutoItX3.send_keys("{ALTDOWN}")
    sleep(1)
    AutoItX3.send_keys("G")
    sleep(1)
    AutoItX3.send_keys("{ALTUP}")
    sleep(1)
    x1 = 1900/SCALE_FACTOR
    y1 = 1024/SCALE_FACTOR
    x2 = 1330/SCALE_FACTOR
    y2 = 669/SCALE_FACTOR
    AutoItX3.drag_mouse(x1,y1,x2,y2,"left")

    sleep(1)
    x1 = 1366/SCALE_FACTOR
    y1 = 713/SCALE_FACTOR
    x2 = 1235/SCALE_FACTOR
    y2 = 535/SCALE_FACTOR
    AutoItX3.drag_mouse(x1,y1,x2,y2,"left")

    sleep(1)
    AutoItX3.send_keys("{ALTDOWN}")
    sleep(1)
    AutoItX3.send_keys("G")
    sleep(1)
    AutoItX3.send_keys("{ALTUP}")
    sleep(1)
  end

  def self.stackItemsInItemHanger
    puts 'StackItemsInItemHanger'
    sleep(1)
    x = 1250
    y = 600
    InputSimulation.SimulateMouseClick(x,y,"right")
    sleep(1)
    x = 1300
    y = 670
    InputSimulation.SimulateMouseClick(x,y,"left")
  end

  def self.undockWithDelay
    puts 'UndockWithDelay'
    sleep(1)
    InputSimulation.SimulateMouseClick(1845,180,"left")
    sleep(20)
  end

  def self.goToCurrentMiningSpot
    puts 'GoToCurrentMiningSpot'
    sleep 1
    InputSimulation.SimulateMouseClick(110,660, "right")
    sleep 1
    InputSimulation.SimulateMouseClick(130,670, "right")
  end

  def self.exitGame
    puts 'ExitGame'
    sleep(1)
    AutoItX3.send_keys("{ESC}")

    sleep(1)
    x = 2400
    y = 1350
    InputSimulation.SimulateMouseClick(1300,810,"left")
  end

  def self.scanAsteroids
    GameCommands.startModule("{F5}")
    sleep 7
    GameCommands.selectSurveyScanResultsWindow
    sleep 1
    surveyScanResultsString = ImageProcessor.getSurveyScanResults.gsub(",", "").gsub(" km", "000").gsub("m", "")

    return GameInformationProcessor.processAsteroidScanResults(surveyScanResultsString)
  end
end