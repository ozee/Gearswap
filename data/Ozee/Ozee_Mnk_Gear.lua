function user_job_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Match', 'Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.PhysicalDefenseMode:options('PDT')
    state.MagicalDefenseMode:options('MDT')
    state.ResistDefenseMode:options('MEVA')
    state.IdleMode:options('Normal')
    state.Weapons:options('Godhands', 'Verethragna', 'Xoanon', 'ProcStaff', 'ProcClub', 'ProcSword', 'ProcGreatSword',
        'ProcScythe', 'ProcPolearm', 'ProcGreatKatana')

    autows = 'Howling Fist'

    state.ExtraMeleeMode = M {
        ['description'] = 'Extra Melee Mode',
        'None'
    }

    gear.jse_da_back = {name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-6%',}}
    gear.jse_int_back = {name="Segomo's Mantle", augments = {'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', 'Weapon skill damage +10%'}}
    gear.jse_crit_back = {name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Crit. hit rate"+10',}}

    update_melee_groups()

    -- Additional local binds
    send_command('bind ^` input /ja "Boost" <me>')
    send_command('bind !` input /ja "Perfect Counter" <me>')
    send_command('bind ^backspace input /ja "Mantra" <me>')
    send_command('bind @` gs c cycle SkillchainMode')

    select_default_macro_book()
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Weapons' and newValue ~= oldValue then
        if newValue:contains('Verethragna') then
            send_command('gs c autows Victory Smite')
            send_command('gs c autows tp 1000')
        elseif newValue:contains('Xoanon') then
            send_command('gs c autows Cataclysm')
            send_command('gs c autows tp 1000')
        else
            send_command('gs c autows Howling Fist')
            send_command('gs c autows tp 1000')
        end
    end
end


function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast sets to enhance JAs on use
    sets.precast.JA['Hundred Fists'] = {
        legs = "Hes. Hose +3"
    }
    sets.precast.JA['Boost'] = {
        hands = "Anchorite's Gloves"
    }
    sets.precast.JA['Dodge'] = {
        feet = "Anch. Gaiters +3"
    }
    sets.precast.JA['Focus'] = {
        head = "Anchorite's Crown"
    }
    sets.precast.JA['Counterstance'] = {
        feet = "Hesychast's Gaiters +1"
    }
    sets.precast.JA['Footwork'] = {
        feet = "Shukuyu Sune-Ate"
    }
    sets.precast.JA['Mantra'] = {
        feet = "Hes. Gaiters"
    } -- feet="Hesychast's Gaiters +1"

    sets.precast.JA['Chakra'] = {
        head = "Nyame Helm",
        body = "Anchorite's Cyclas",
        hands = "Melee Gloves",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- Fast cast sets for spells

    sets.precast.FC = {
        ammo = "Sapience Orb",
        ear1 = "Enchntr. Earring +1",
        ear2 = "Loquac. Earring",
        hands = "Leyline Gloves",
        ring1 = "Rahab Ring",
        ring2 = "Kishar Ring",
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        neck = "Magoraga Beads"
    })

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Knobkierrie",
        head = gear.adhemar_att_head,
        body = "Ken. Samue +1",
        hands = gear.ryuo_da_hands,
        legs = "Ken. Hakama +1",
        feet = gear.herculean_crit_feet,
        neck="Mnk. Nodowa +2",
        waist="Moonbow Belt +1",
        left_ear="Odr Earring",
        right_ear="Sherida Earring",
        left_ring="Gere Ring",
        right_ring="Niqmaddu Ring",
        back=gear.jse_crit_back
    }

    -- Specific weaponskill sets.

    sets.precast.WS['Raging Fists'] = set_combine(sets.precast.WS, {
        head = "Mpaca's Cap",
        body = gear.adhemar_att_body,
        hands = gear.adhemar_att_hands,
        legs = "Tatena. Haidate +1",
        feet = "Mpaca's Boots",
        left_ear="Moonshade Earring",
    })
    sets.precast.WS['Howling Fist'] = set_combine(sets.precast.WS, {
        head = "Mpaca's Cap",
        body = "Tatena. Harama. +1",
        hands = "Mpaca's Gloves",
        legs = "Tatena. Haidate +1",
        feet = "Mpaca's Boots",
        left_ear="Moonshade Earring",
    })
    sets.precast.WS["Victory Smite"] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Hes. Hose +3",
        feet="Mpaca's Boots",
        left_ear="Mache Earring +1",
        back=gear.jse_da_back
    })
    sets.precast.WS['Tornado Kick'] = set_combine(sets.precast.WS, {
        head = "Mpaca's Cap",
        body = "Tatena. Harama. +1",
        hands = "Mpaca's Gloves",
        legs = "Tatena. Haidate +1",
        feet="Anch. Gaiters +3",
        left_ear="Moonshade Earring",
    })

    sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS, {
        head = "Pixie Hairpin +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = gear.herculean_mab_legs,
        feet = gear.herculean_mab_feet,
        waist = "Orpheus's Sash",
        ammo = "Pemphredo Tathlum",
        neck = "Baetyl Pendant",
        left_ear = "Friomisi Earring",
        right_ear = "Moonshade Earring",
        left_ring = "Epaminondas's Ring",
        right_ring = "Archon Ring",
        back=gear.jse_int_back
    })

    -- Specific spells
    sets.midcast.Utsusemi = {
        back = "Mujin Mantle"
    }

    -- Sets to return to when not performing an action.
    -- Idle sets
    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Loricate Torque +1",
        waist="Moonbow Belt +1",
        left_ear="Etiolation Earring",
        right_ear="Odnowa Earring +1",
        left_ring="Defending Ring",
        right_ring="Gelatinous Ring +1",
        back=gear.jse_da_back
    }

    -- Defense sets
    sets.defense.HP = set_combine(sets.idle, {})
    sets.defense.PDT = set_combine(sets.idle, {})
    sets.defense.MDT = set_combine(sets.idle, {})
    sets.defense.MEVA = set_combine(sets.idle, {})

    sets.Kiting = {
        feet = "Herald's Gaiters"
    }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee sets
    sets.engaged = {
        ammo="Aurgelmir Orb +1",
        head=gear.adhemar_acc_head,
        body="Bhikku Cyclas +1",
        hands=gear.adhemar_acc_hands,
        legs="Hes. Hose +3",
        feet="Anch. Gaiters +3",
        neck="Mnk. Nodowa +2",
        waist="Moonbow Belt +1",
        left_ear="Telos Earring",
        right_ear="Sherida Earring",
        left_ring="Gere Ring",
        right_ring="Niqmaddu Ring",
        back=gear.jse_da_back
    }

    sets.engaged.next = {
        ammo = "Aurgelmir Orb +1",
        head = "Ken. Jinpachi +1",
        body = "Mpaca's Doublet",
        hands = "Mpaca's Gloves",
        legs = "Mpaca's Hose",
        feet = "Anch. Gaiters +3",
        neck = "Mnk. Nodowa +2",
        waist = "Moonbow Belt +1",
        left_ear = "Brutal Earring",
        right_ear = "Sherida Earring",
        left_ring = "Gere Ring",
        right_ring = "Niqmaddu Ring",
        back = gear.jse_da_back
    }

    sets.engaged.Acc = set_combine(sets.engaged, {
        ammo = "Ginsen",
        legs = "Ken. Hakama +1",
        feet = "Ken. Sune-Ate +1"
    })

    -- Defensive melee hybrid sets
    sets.engaged.DT = set_combine(sets.engaged, {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        back = gear.da_jse_back
    })


    sets.engaged.Acc.PDT = {
        ammo = "Falcon Eye",
        head = "Dampening Tam",
        neck = "Moonbeam Nodowa",
        ear1 = "Cessance Earring",
        ear2 = "Sherida Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Defending Ring",
        ring2 = "Patricius Ring",
        back = "Segomo's Mantle",
        waist = "Olseni Belt",
        legs = gear.herculean_dt_legs,
        feet = "Hippo. Socks +1"
    }

    -- Hundred Fists/Impetus melee set mods

    sets.engaged.HF = set_combine(sets.engaged, {})
    sets.engaged.Acc.HF = set_combine(sets.engaged.Acc, {})

    sets.buff.Doom = set_combine(sets.buff.Doom, {})
    sets.buff.Impetus = {
        body = "Bhikku Cyclas +1"
    }
    sets.buff.Footwork = {
        feet = "Shukuyu Sune-Ate"
    }
    sets.buff.Boost = {
        waist = "Ask Sash"
    }

    sets.FootworkWS = {
        feet = "Shukuyu Sune-Ate"
    }
    sets.TreasureHunter = set_combine(sets.TreasureHunter, {})

    -- Weapons sets
    sets.weapons.Verethragna = {
        main = "Verethragna"
    }

    sets.weapons.Godhands = {
        main = "Godhands"
    }

    sets.weapons.Xoanon = {
        main = "Xoanon",
        sub = "Alber Strap"
    }

    sets.weapons.ProcStaff = {
        main = "Terra's Staff"
    }
    sets.weapons.ProcClub = {
        main = "Mafic Cudgel"
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
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(5, 20)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 20)
    elseif player.sub_job == 'THF' then
        set_macro_page(6, 20)
    elseif player.sub_job == 'RUN' then
        set_macro_page(7, 20)
    else
        set_macro_page(6, 20)
    end
end
