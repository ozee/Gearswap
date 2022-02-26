function user_job_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Match', 'Normal', 'Acc')
    state.HybridMode:options('Normal', 'Hybrid')
    state.PhysicalDefenseMode:options('PDT', 'PDTReraise')
    state.MagicalDefenseMode:options('MDT', 'MDTReraise')
    state.ResistDefenseMode:options('MEVA')
    state.IdleMode:options('Normal', 'PDT', 'Refresh', 'Reraise')
    state.ExtraMeleeMode = M {
        ['description'] = 'Extra Melee Mode',
        'None'
    }
    state.Passive = M {
        ['description'] = 'Passive Mode',
        'None',
        'Twilight'
    }
    state.Weapons:options('Chango', 'Shining One', 'Naegling', 'Loxotic Mace', 'Lvl1GA', 'Lvl1Sword', 'ProcDagger', 'ProcSword',
        'ProcGreatSword', 'ProcScythe', 'ProcPolearm', 'ProcGreatKatana', 'ProcClub', 'ProcStaff')

    gear.da_jse_back = {
        name = "Cichol's Mantle",
        augments = {'DEX+20', 'Accuracy+20 Attack+20', 'DEX+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%'}
    }
    gear.wsd_jse_back = {
        name = "Cichol's Mantle",
        augments = {'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%'}
    }

    autows = "Upheaval"

    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')
    send_command('bind @` gs c cycle SkillchainMode')

    select_default_macro_book()
end

function job_state_change(stateField, newValue, oldValue)
    update_melee_groups()

    if stateField == 'Weapons' and newValue ~= oldValue then
        if newValue:contains('Naegling') then
            if player.sub_job == 'SAM' and state.Stance.value ~= "None" then
                state.Stance:set("None")
            end

            send_command('gs c autows Savage Blade')
            send_command('gs c autows tp 1000')
        elseif newValue:contains('Shining One') then
            if player.sub_job == 'SAM' and not state.Buff.Hasso then
                state.Stance:set("Hasso")
            end

            send_command('gs c autows Impulse Drive')
            send_command('gs c autows tp 1250')
        elseif newValue:contains('Loxotic Mace') then
            if player.sub_job == 'SAM' and state.Stance.value ~= "None" then
                state.Stance:set("None")
            end

            send_command('gs c autows True Strike')
            send_command('gs c autows tp 1000')
        else
            if player.sub_job == 'SAM' and not state.Buff.Hasso then
                state.Stance:set("Hasso")
            end

            send_command('gs c autows Upheaval')
            send_command('gs c autows tp 1000')
        end
    end
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    -- Precast Sets

    sets.Enmity = {}
    sets.Knockback = {}
    sets.passive.Twilight = {
        head = "Twilight Helm",
        body = "Twilight Mail"
    }

    -- Precast sets to enhance JAs
    sets.precast.JA['Berserk'] = {
        back = gear.da_jse_back
    }
    sets.precast.JA['Warcry'] = {}
    sets.precast.JA['Defender'] = {}
    sets.precast.JA['Aggressor'] = {}
    sets.precast.JA['Mighty Strikes'] = {}
    sets.precast.JA["Warrior's Charge"] = {}
    sets.precast.JA['Tomahawk'] = {
        ammo = "Thr. Tomahawk"
    }
    sets.precast.JA['Retaliation'] = {}
    sets.precast.JA['Restraint'] = {}
    sets.precast.JA['Blood Rage'] = {}
    sets.precast.JA['Brazen Rush'] = {}
    sets.precast.JA['Provoke'] = set_combine(sets.Enmity, {})

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.Step = {}

    sets.precast.Flourish1 = {}

    -- Fast cast sets for spells

    sets.precast.FC = {
        ammo = "Impatiens",
        head = "Carmine Mask +1",
        neck = "Voltsurge Torque",
        ear1 = "Enchntr. Earring +1",
        ear2 = "Loquac. Earring",
        body = "Odyss. Chestplate",
        hands = "Leyline Gloves",
        ring1 = "Lebeche Ring",
        ring2 = "Prolix Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = gear.odyssean_fc_legs,
        feet = "Odyssean Greaves"
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})

    -- Midcast Sets
    sets.midcast.FastRecast = {
        ammo = "Staunch Tathlum +1",
        head = "Carmine Mask +1",
        neck = "Voltsurge Torque",
        ear1 = "Enchntr. Earring +1",
        ear2 = "Loquac. Earring",
        body = "Odyss. Chestplate",
        hands = "Leyline Gloves",
        ring1 = "Lebeche Ring",
        ring2 = "Prolix Ring",
        back = "Moonlight Cape",
        waist = "Tempus Fugit",
        legs = gear.odyssean_fc_legs,
        feet = "Odyssean Greaves"
    }

    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {
        back = "Mujin Mantle"
    })

    sets.midcast.Cure = {}

    sets.Self_Healing = {
        neck = "Phalaina Locket",
        hands = "Buremte Gloves",
        ring2 = "Kunaji Ring",
        waist = "Gishdubar Sash"
    }
    sets.Cure_Received = {
        neck = "Phalaina Locket",
        hands = "Buremte Gloves",
        ring2 = "Kunaji Ring",
        waist = "Gishdubar Sash"
    }

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Knobkierrie",
        head = "Agoge Mask +3",
        neck = "War. Beads +2",
        ear1 = "Thrud Earring",
        ear2 = "Moonshade Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Regal Ring",
        ring2 = "Epaminonda's Ring",
        back = gear.wsd_jse_back,
        waist = "Sailfi Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sulev. Leggings +2"
    }

    sets.precast.WS.SomeAcc = set_combine(sets.precast.WS, {
        back = "Letalis Mantle"
    })
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        neck = "Combatant's Torque"
    })
    sets.precast.WS.FullAcc = set_combine(sets.precast.WS, {
        neck = "Combatant's Torque"
    })
    sets.precast.WS.Fodder = set_combine(sets.precast.WS, {})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Savage Blade'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {})
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Savage Blade'].FullAcc = set_combine(sets.precast.WS.FullAcc, {})
    sets.precast.WS['Savage Blade'].Fodder = set_combine(sets.precast.WS.Fodder, {})

    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {
        ring2 = "Niqmaddu Ring"
    })
    sets.precast.WS['Upheaval'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {})
    sets.precast.WS['Upheaval'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Upheaval'].FullAcc = set_combine(sets.precast.WS.FullAcc, {})
    sets.precast.WS['Upheaval'].Fodder = set_combine(sets.precast.WS.Fodder, {})

    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Resolution'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {})
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Resolution'].FullAcc = set_combine(sets.precast.WS.FullAcc, {})
    sets.precast.WS['Resolution'].Fodder = set_combine(sets.precast.WS.Fodder, {})

    sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Ruinator'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {})
    sets.precast.WS['Ruinator'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Ruinator'].FullAcc = set_combine(sets.precast.WS.FullAcc, {})
    sets.precast.WS['Ruinator'].Fodder = set_combine(sets.precast.WS.Fodder, {})

    sets.precast.WS['Rampage'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Rampage'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {})
    sets.precast.WS['Rampage'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Rampage'].FullAcc = set_combine(sets.precast.WS.FullAcc, {})
    sets.precast.WS['Rampage'].Fodder = set_combine(sets.precast.WS.Fodder, {})

    sets.precast.WS['Raging Rush'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Raging Rush'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {})
    sets.precast.WS['Raging Rush'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Raging Rush'].FullAcc = set_combine(sets.precast.WS.FullAcc, {})
    sets.precast.WS['Raging Rush'].Fodder = set_combine(sets.precast.WS.Fodder, {})

    sets.precast.WS["Ukko's Fury"] = set_combine(sets.precast.WS, {})
    sets.precast.WS["Ukko's Fury"].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {})
    sets.precast.WS["Ukko's Fury"].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS["Ukko's Fury"].FullAcc = set_combine(sets.precast.WS.FullAcc, {})
    sets.precast.WS["Ukko's Fury"].Fodder = set_combine(sets.precast.WS.Fodder, {})

    sets.precast.WS["King's Justice"] = set_combine(sets.precast.WS, {})
    sets.precast.WS["King's Justice"].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {})
    sets.precast.WS["King's Justice"].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS["King's Justice"].FullAcc = set_combine(sets.precast.WS.FullAcc, {})
    sets.precast.WS["King's Justice"].Fodder = set_combine(sets.precast.WS.Fodder, {})

    -- Swap to these on Moonshade using WS if at 3000 TP
    sets.MaxTP = {
        ear1 = "Lugra Earring +1",
        ear2 = "Lugra Earring"
    }
    sets.AccMaxTP = {
        ear1 = "Mache Earring +1",
        ear2 = "Telos Earring"
    }
    sets.AccDayMaxTPWSEars = {
        ear1 = "Mache Earring +1",
        ear2 = "Telos Earring"
    }
    sets.DayMaxTPWSEars = {
        ear1 = "Ishvara Earring",
        ear2 = "Brutal Earring"
    }
    sets.AccDayWSEars = {
        ear1 = "Mache Earring +1",
        ear2 = "Telos Earring"
    }
    sets.DayWSEars = {
        ear1 = "Brutal Earring",
        ear2 = "Moonshade Earring"
    }

    -- Specialty WS set overwrites.
    sets.AccWSMightyCharge = {}
    sets.AccWSCharge = {}
    sets.AccWSMightyCharge = {}
    sets.WSMightyCharge = {}
    sets.WSCharge = {}
    sets.WSMighty = {}

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {}

    -- Idle sets
    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm",
        neck = "Dampener's Torque",
        ear1 = "Etiolation Earring",
        ear2 = "Infused Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Defending Ring",
        ring2 = "Karieyh Ring",
        back = gear.da_jse_back,
        waist = "Flume Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings",
    }

    sets.idle.Weak = set_combine(sets.idle, {
        head = "Twilight Helm",
        body = "Twilight Mail"
    })

    sets.idle.Reraise = set_combine(sets.idle, {
        head = "Twilight Helm",
        body = "Twilight Mail"
    })

    -- Defense sets
    sets.defense.PDT = {
        ammo = "Staunch Tathlum +1",
        head = "Genmei Kabuto",
        neck = "Loricate Torque +1",
        ear1 = "Genmei Earring",
        ear2 = "Ethereal Earring",
        body = "Tartarus Platemail",
        hands = "Sulev. Gauntlets +2",
        ring1 = "Moonbeam Ring",
        ring2 = "Moonlight Ring",
        back = "Shadow Mantle",
        waist = "Flume Belt +1",
        legs = "Sulev. Cuisses +2",
        feet = "Amm Greaves"
    }

    sets.defense.PDTReraise = set_combine(sets.defense.PDT, {
        head = "Twilight Helm",
        body = "Twilight Mail"
    })

    sets.defense.MDT = {
        ammo = "Staunch Tathlum +1",
        head = "Genmei Kabuto",
        neck = "Warder's Charm +1",
        ear1 = "Genmei Earring",
        ear2 = "Ethereal Earring",
        body = "Tartarus Platemail",
        hands = "Sulev. Gauntlets +2",
        ring1 = "Moonbeam Ring",
        ring2 = "Moonlight Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Sulev. Cuisses +2",
        feet = "Amm Greaves"
    }

    sets.defense.MDTReraise = set_combine(sets.defense.MDT, {
        head = "Twilight Helm",
        body = "Twilight Mail"
    })

    sets.defense.MEVA = {
        ammo = "Staunch Tathlum +1",
        head = "Genmei Kabuto",
        neck = "Warder's Charm +1",
        ear1 = "Genmei Earring",
        ear2 = "Ethereal Earring",
        body = "Tartarus Platemail",
        hands = "Sulev. Gauntlets +2",
        ring1 = "Moonbeam Ring",
        ring2 = "Moonlight Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Sulev. Cuisses +2",
        feet = "Amm Greaves"
    }

    sets.Kiting = {}
    sets.Reraise = {
        head = "Twilight Helm",
        body = "Twilight Mail"
    }
    sets.buff.Doom = set_combine(sets.buff.Doom, {})
    sets.buff.Sleep = {
        head = "Frenzy Sallet"
    }

    -- Engaged sets
    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Vim Torque +1",
        ear1 = "Schere Earring",
        ear2 = "Cessance Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Petrov Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.da_jse_back,
        waist = "Sailfi Belt +1",
        legs = "Pumm. Cuisses +2",
        feet = "Pumm. Calligae +3"
    }
    sets.engaged.Chango = set_combine(sets.engaged, {})
    sets.engaged.Chango.Hybrid = set_combine(sets.engaged, {
        head = "Sakpata's Helm",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    })
    sets.engaged.Naegling = set_combine(sets.engaged, {
        head = "Sakpata's Helm",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ear1 = "Schere Earring",
        ear2 = "Cessance Earring",
        ring1 = "Petrov Ring",
        waist = "Ioskeha Belt +1"
    })
    sets.engaged.Naegling.Hybrid = set_combine(sets.engaged.Naegling, {
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    })
    sets.engaged['Loxotic Mace'] = set_combine(sets.engaged.Naegling, {})
    sets.engaged['Loxotic Mace'].Hybrid = set_combine(sets.engaged.Naegling.Hybrid, {})
    sets.engaged.SomeAcc = {
        ammo = "Aurgelmir Orb +1",
        head = "Flam. Zucchetto +2",
        neck = "Combatant's Torque",
        ear1 = "Brutal Earring",
        ear2 = "Cessance Earring",
        body = gear.valorous_wsd_body,
        hands = gear.valorous_acc_hands,
        ring1 = "Flamma Ring",
        ring2 = "Niqmaddu Ring",
        back = "Cichol's Mantle",
        waist = "Ioskeha Belt",
        legs = "Sulev. Cuisses +2",
        feet = "Flam. Gambieras +2"
    }
    sets.engaged.Acc = {
        ammo = "Aurgelmir Orb +1",
        head = "Flam. Zucchetto +2",
        neck = "Combatant's Torque",
        ear1 = "Digni. Earring",
        ear2 = "Telos Earring",
        body = gear.valorous_wsd_body,
        hands = gear.valorous_acc_hands,
        ring1 = "Flamma Ring",
        ring2 = "Niqmaddu Ring",
        back = "Cichol's Mantle",
        waist = "Ioskeha Belt",
        legs = "Sulev. Cuisses +2",
        feet = "Flam. Gambieras +2"
    }
    sets.engaged.FullAcc = {
        ammo = "Aurgelmir Orb +1",
        head = "Flam. Zucchetto +2",
        neck = "Combatant's Torque",
        ear1 = "Mache Earring +1",
        ear2 = "Telos Earring",
        body = gear.valorous_wsd_body,
        hands = gear.valorous_acc_hands,
        ring1 = "Flamma Ring",
        ring2 = "Ramuh Ring +1",
        back = "Cichol's Mantle",
        waist = "Ioskeha Belt",
        legs = "Sulev. Cuisses +2",
        feet = "Flam. Gambieras +2"
    }
    sets.engaged.Fodder = {
        ammo = "Aurgelmir Orb +1",
        head = "Flam. Zucchetto +2",
        neck = "War. Beads +2",
        ear1 = "Brutal Earring",
        ear2 = "Dedition Earring",
        body = "Tatena. Harama. +1",
        hands = "Sulev. Gauntlets +2",
        ring1 = "Chirich ring +1",
        ring2 = "Niqmaddu Ring",
        back = gear.da_jse_back,
        waist = "Sailfi Belt +1",
        legs = "Tatena. Haidate +1",
        feet = "Tatena. Sune. +1"
    }

    -- Extra Special Sets

    sets.buff.Doom = set_combine(sets.buff.Doom, {})
    sets.buff.Retaliation = {}
    sets.buff.Restraint = {}
    sets.TreasureHunter = set_combine(sets.TreasureHunter, {})

    -- Weapons sets
    sets.weapons.Chango = {
        main = "Chango",
        sub = "Utu Grip",
    }
    sets.weapons.Lvl1GA = {
        main = "Helgoland",
        sub = "Utu Grip",
    }
    sets.weapons.Lvl1Sword = {
        main = "Helgoland",
        sub = "Blurred Shield +1",
    }
    sets.weapons.Naegling = {
        main = "Naegling",
        sub = "Blurred Shield +1",
    }
    sets.weapons['Shining One'] = {
        main = "Shining One",
        sub = "Utu Grip",
    }
    sets.weapons['Loxotic Mace'] = {
        main = "Loxotic Mace +1",
        sub = "Blurred Shield +1",
    }
    sets.weapons.Greatsword = {
        main = "Montante +1",
        sub = "Utu Grip",
    }
    sets.weapons.ProcDagger = {
        main = "Chicken Knife II",
        sub = empty
    }
    sets.weapons.ProcSword = {
        main = "Ark Sword",
        sub = empty
    }
    sets.weapons.ProcGreatSword = {
        main = "Lament",
        sub = empty
    }
    sets.weapons.ProcScythe = {
        main = "Ark Scythe",
        sub = empty
    }
    sets.weapons.ProcPolearm = {
        main = "Pitchfork +1",
        sub = empty
    }
    sets.weapons.ProcGreatKatana = {
        main = "Hardwood Katana",
        sub = empty
    }
    sets.weapons.ProcClub = {
        main = "Dream Bell +1",
        sub = empty
    }
    sets.weapons.ProcStaff = {
        main = "Terra's Staff",
        sub = empty
    }
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'SAM' then
        set_macro_page(3, 3)
    elseif player.sub_job == 'DNC' then
        set_macro_page(4, 3)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 3)
    else
        set_macro_page(5, 3)
    end
end
