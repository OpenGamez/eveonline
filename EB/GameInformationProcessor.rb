require 'au3'
OreTableString =
"Veldspar,0.1,
Concentrated Veldspar,0.1,
Dense Veldspar,0.1,
Scordite,0.15,
Condensed Scordite,0.15,
Massive Scordite,0.15,
Pyroxeres,0.3,
Solid Pyroxeres,0.3,
Viscous Pyroxeres,0.3,
Plagioclase,0.35,
Azure Plagioclase,0.35,
Rich Plagioclase,0.35,
Omber,0.6,
Silvery Omber,0.6,
Golden Omber,0.6,
Kernite,1.2,
Luminous Kernite,1.2,
Fiery Kernite,1.2,
Jaspet,2.0,
Pure Jaspet,2.0,
Pristine Jaspet,2.0,
Hemorphite,3.0,
Vivid Hemorphite,3.0,
Radiant Hemorphite,3.0,
Hedbergite,3.0,
Vitric Hedbergite,3.0,
Glazed Hedbergite,3.0,
Gneiss,5.0,
Iridescent Gneiss,5.0,
Prismatic Gneiss,5.0,
Dark Ochre,8.0,
Onyx Ochre,8.0,
Obsidian Ochre,8.0,
Spodumain,16.0,
Bright Spodumain,16.0,
Gleaming Spodumain,16.0,
Crokite,16.0,
Sharp Crokite,16.0,
Crystalline Crokite,16.0,
Bistot,16.0,
Triclinic Bistot,16.0,
Monoclinic Bistot,16.0,
Arkonor,16.0,
Crimson Arkonor,16.0,
Prime Arkonor,16.0,
Mercoxit,40.0,
Magma Mercoxit,40.0,
Vitreous Mercoxit,40.0"

class GameInformationProcessor
    def self.createOreTable
      return Hash[*OreTableString.gsub("\n", '').split(",").each_slice(2).collect { |k, v| [k, v.to_f] }.flatten]
    end

    def self.processAsteroidScanResults(surveyScanResultsString)
      csv = CSV.new(surveyScanResultsString, {:col_sep => "\t"})
      surveyScanResultsArray = csv.to_a

      surveyScanResultsArray.delete_if do |element|
        if element[1] == nil or element[2] == nil
          true
        end
      end

      surveyScanResultsArray.each { |a| a[1] = a[1].to_s.to_i; a[2] = a[2].to_s.to_i }
      surveyScanResultsArray = surveyScanResultsArray.sort_by { |a| a[2] }
      print surveyScanResultsArray, "\n"

      return surveyScanResultsArray
    end

    def self.calculateMiningTimeRequiredWithShip(ship, oreType, oreAmountm3)
      turretsTotalMiningYield = ship[:turretCount] * ship[:miningYieldPerTurret]

      print ship[:name], " ", ship[:turretCount], " turrets,", "\n"
      calculateMiningTimeRequired(turretsTotalMiningYield, ship[:turretCycleTimeSec], ORE_TABLE[oreType], oreAmountm3)
    end

    def self.calculateMiningTimeRequiredWithArrayEntry(turretMiningYield, turretCycleDuration, arrayEntry)
      oreDensity = ORE_TABLE[arrayEntry[0]]
      print "turretMiningYield:   ", turretMiningYield, " m3/cycle (", turretCycleDuration," seconds)", "\n"
      print "turretCycleDuration: ", turretCycleDuration, " seconds" "\n"
      print "arrayEntry[0]:       ", arrayEntry[0], "\n"
      print "arrayEntry[1]:       ", arrayEntry[1], " units (", arrayEntry[1] * oreDensity, " m3)", "\n"
      print "arrayEntry[2]:       ", arrayEntry[2], " meters" "\n"
      value = arrayEntry[1].to_s.to_i
      print "value:               ", value, "\n"
      return calculateMiningTimeRequired(turretMiningYield, turretCycleDuration, oreDensity, value)
    end

    def self.calculateMiningTimeRequired(turretMiningYield, turretCycleDuration, oreDensity, oreAmountm3)
      m3perSeconds = turretMiningYield / turretCycleDuration / oreDensity
      timeRequiredSeconds = oreAmountm3 / m3perSeconds
      print "(m3 / sec) = ", m3perSeconds, "\n"
      print timeRequiredSeconds, " sec ", "(", timeRequiredSeconds / 60, " min)", "\n", "\n"

      return timeRequiredSeconds
    end

    def self.displayShipsInformation(ships,asteroidType,amountToMine)
      ships.each {|ship| GameInformationProcessor.calculateMiningTimeRequiredWithShip(ship, asteroidType, amountToMine)  }
    end

  def self.getActiveShip(ships)
    ships.find { |ship|
      if ship[:isActive]
        print "ActiveShip: ", ship, "\n"
        ship
      end }
  end

  def self.canNextAsteroidOreFitInOreCargo(currentShip, percentageOreCargo, surveyScanResultsArrayEntry)
    oreDensity = ORE_TABLE[surveyScanResultsArrayEntry[0]]

    oreCargoSpaceAvailable = currentShip[:maxOreHold] * (1.0 - percentageOreCargo)

    print "oreCargoSpaceAvailable:                ", oreCargoSpaceAvailable, "\n"

    oreSpaceRequired = oreDensity * surveyScanResultsArrayEntry[1]

    print "oreSpaceRequired:                      ", oreSpaceRequired, "\n"

    canFit = oreCargoSpaceAvailable > oreSpaceRequired

    if canFit
      print "ore can fit in remaining ore cargo space:                      ", "\n"
    else
      print "ore will not fit in remaining ore cargo space:                      ", "\n"
    end

    return canFit
  end
end
