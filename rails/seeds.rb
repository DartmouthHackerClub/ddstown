Term.create(:year => 2012,
            :term => 'Winter',
            :start => Date.new(2012,1,4),
            :end => Date.new(2012,3,14))

Term.create(:year => 2012,
            :term => 'Spring',
            :start => Date.new(2012,3,26),
            :end => Date.new(2012,5,10))

Plan.create(:name => 'SmartChoice20',
            :price => 1658.00,
            :swipes => 20,
            :dba => 75.00)

Plan.create(:name => 'SmartChoice14',
            :price => 1575.00,
            :swipes => 14,
            :dba => 125.00)

Plan.create(:name => 'SmartChoice5',
            :price => 1440.00,
            :swipes => 5,
            :dba => 875.00)

Plan.create(:name => 'SmartChoiceOC',
            :price => 875,
            :swipes => 0,
            :dba => 875.00)

