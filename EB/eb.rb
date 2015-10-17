require 'reve'
require 'au3'
require 'tk/clipboard'
require 'win32/sound'
include Win32

require 'csv'
require 'rufus-scheduler'

require_relative 'ImageProcessor'
require_relative 'GameCommands'
require_relative 'GameInformationProcessor'

SCALE_FACTOR = 1.0 # This needs to be updated if you change windows font scale
PEOPLE_PLACES_WINDOW_PLACES_ENTRY_HEIGHT = 20
ORE_TABLE = GameInformationProcessor.createOreTable

scheduler = Rufus::Scheduler.new

ships =
    [
        {:name => "protector", :turretCount => 1, :miningYieldPerTurret => 2406, :turretCycleTimeSec => 165.6, :maxOreHold => 12000},
        {:isActive => true, :name => "retriever", :turretCount => 2, :miningYieldPerTurret => 1311, :turretCycleTimeSec => 165.6, :maxOreHold => 26400},
        {:name => "retriever w/ Scordite Mining Crystal", :turretCount => 2, :miningYieldPerTurret => 1420, :turretCycleTimeSec => 165.6, :maxOreHold => 26400, :oreTypeLimitation => "Scordite"},
        {:name => "covetor", :turretCount => 3, :miningYieldPerTurret => 962, :turretCycleTimeSec => 151.2, :maxOreHold => 7000}
    ]

currentShip = GameInformationProcessor.getActiveShip(ships)

startingFromStation = false
miningInLoop = true
useSurveyScanner = true
scanWithSurveyScanner = true
MAX_CARGO_PERCENTAGE_BEFORE_RETURN = 0.98

runs = 20

GameCommands.selectGameWindow

if startingFromStation
  GameCommands.undockWithDelay
  GameCommands.goToCurrentMiningSpot
  sleep(70) # replace with dock detection
  GameCommands.launchDrones
end

if (useSurveyScanner and scanWithSurveyScanner)
  surveyScanResultsArray = GameCommands.scanAsteroids
elsif useSurveyScanner
  surveyScanResultsString = TkClipboard.get.gsub(",", "").gsub(" km", "000").gsub(" m", "")
  surveyScanResultsArray = GameInformationProcessor.processAsteroidScanResults(surveyScanResultsString)
end

while miningInLoop
  percentage = ImageProcessor.getOreHoldFillPercentage(1325, 657)
  nextAsteroidFitInOreCargo = GameInformationProcessor.canNextAsteroidOreFitInOreCargo(currentShip, percentage, surveyScanResultsArray[0])

  if nextAsteroidFitInOreCargo

    isTargetingSomething = ImageProcessor.hasTarget

    if not isTargetingSomething
      numberOfTargetAttempt = 10

      isTargetingSomething = ImageProcessor.hasTarget

      while (!isTargetingSomething)
        GameCommands.targetFirstAsteroidInOverviewMiningTab
        isTargetingSomething = ImageProcessor.hasTarget

        numberOfTargetAttempt -= 1

        if (numberOfTargetAttempt <= 0)
          GameCommands.recallDrones
          GameCommands.dock
          sleep(80) # replace with dock detection
          GameCommands.exitGame
          exit
          break
        end
      end


      turrentCountToStart = currentShip[:turretCount]

      if turrentCountToStart > 0
        GameCommands.toggleMiningTurret("{F1}")
        turrentCountToStart -= 1
      end

      if turrentCountToStart > 0
        GameCommands.toggleMiningTurret("{F2}")
        turrentCountToStart -= 1
      end

      if turrentCountToStart > 0
        GameCommands.toggleMiningTurret("{F3}")
      end

      if (useSurveyScanner)
        timeToMine = GameInformationProcessor.calculateMiningTimeRequiredWithArrayEntry(currentShip[:turretCount] * currentShip[:miningYieldPerTurret], currentShip[:turretCycleTimeSec], surveyScanResultsArray[0])
        print "timeToMine(Secs) :", timeToMine

        nextAsteroidTimer = [timeToMine-5, 0].max

        scheduler.in nextAsteroidTimer do
          Sound.play("SystemExclamation", Sound::ALIAS)
          puts "======================== Next Asteroid in 5 seconds !!!!!!!"
        end

        sleep(timeToMine)
        GameCommands.selectGameWindow

        turrentCountToStart = currentShip[:turretCount]

        if turrentCountToStart > 0
          GameCommands.toggleMiningTurret("{F1}")
          turrentCountToStart -= 1
        end

        if turrentCountToStart > 0
          GameCommands.toggleMiningTurret("{F2}")
          turrentCountToStart -= 1
        end

        if turrentCountToStart > 0
          GameCommands.toggleMiningTurret("{F3}")
        end

        GameCommands.toggleTargetLock
        surveyScanResultsArray.delete_at(0)
      else
        sleep 10
      end
    end
  end

  percentage = ImageProcessor.getOreHoldFillPercentage(1325, 657)

  nextAsteroidFitInOreCargo = GameInformationProcessor.canNextAsteroidOreFitInOreCargo(currentShip, percentage, surveyScanResultsArray[0])

  # if (percentage > MAX_CARGO_PERCENTAGE_BEFORE_RETURN) or not nextAsteroidFitInOreCargo
  if not nextAsteroidFitInOreCargo
    puts 'Full and returning to base'
    GameCommands.recallDrones
    GameCommands.dock
    sleep(80) # replace with dock detection
    GameCommands.transferOreToItemHangar
    GameCommands.stackItemsInItemHanger

    runs -= 1
    puts 'RUNS to go:'
    puts runs

    if runs == 0
      puts 'We are done for tonight. Ciao!'
      GameCommands.exitGame
      exit
    else
      GameCommands.undockWithDelay
      GameCommands.goToCurrentMiningSpot
      sleep(70) # replace with dock detection
      GameCommands.launchDrones
      surveyScanResultsArray = GameCommands.scanAsteroids
    end
  end
end