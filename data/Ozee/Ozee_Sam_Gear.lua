-- Setup vars that are user-dependent.
function user_job_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DTLite', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Match', 'Normal', 'Acc', 'Proc')
    state.RangedMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT', 'PDTReraise')
    state.MagicalDefenseMode:options('MDT', 'MDTReraise')
    state.ResistDefenseMode:options('MEVA')
    state.IdleMode:options('Normal', 'Reraise')
    state.Weapons:options('Masamune', 'ShiningOne', 'Soboro', 'ProcWeapon')

    gear.ws_jse_back = {
        name = "Smertrios's Mantle",
        augments = {'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%'}
    }
    gear.stp_jse_back = {
        name = "Smertrios's Mantle",
        augments = {'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Store TP"+10', 'Phys. dmg. taken-10%'}
    }

    autofood = 'Sublime Sushi +1'

    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')
    send_command('bind !backspace input /ja "Third Eye" <me>')
    send_command('bind @` gs c cycle SkillchainMode')
    send_command('bind !@^` gs c cycle Stance')

    select_default_macro_book()
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Weapons' and newValue ~= oldValue then
        if newValue:contains('ShiningOne') then
            send_command('gs c autows Impulse Drive')
            send_command('gs c autows tp 1750')
        elseif newValue:contains('Soboro') then
            send_command('gs c autows Tachi: Jinpu')
            send_command('gs c autows tp 1000')
        else
            send_command('gs c autows Tachi: Fudo')
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
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {
        head = "Wakido Kabuto +3",
        hands = "Sakonji Kote +1",
        back = gear.ws_jse_back
    }
    sets.precast.JA['Warding Circle'] = {
        head = "Wakido Kabuto +3"
    }
    sets.precast.JA['Blade Bash'] = {
        hands = "Sakonji Kote +1"
    }
    sets.precast.JA['Sekkanoki'] = {
        hands = "Kasuga Kote +1"
    }
    sets.precast.JA['Sengikori'] = {
        feet = "Kas. Sune-Ate +1"
    }

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head = "Flam. Zucchetto +2",
        body = "Tartarus Platemail",
        hands = "Flam. Manopolas +2",
        ring1 = "Asklepian Ring",
        ring2 = "Valseur's Ring",
        waist = "Chaac Belt",
        legs = "Wakido Haidate +3",
        feet = "Sak. Sune-Ate +1"
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    sets.precast.FC = {
        neck = "Voltsurge Torque",
        ear1 = "Enchntr. Earring +1",
        ear2 = "Loquac. Earring",
        hands = "Leyline Gloves",
        ring1 = "Lebeche Ring",
        ring2 = "Prolix Ring"
    }

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Knobkierrie",
        head = "Mpaca's Cap",
        body = "Sakonji Domaru +3",
        hands = {
            name = "Valorous Mitts",
            augments = {'Attack+11', 'Weapon skill damage +4%', 'STR+2'}
        },
        legs = "Wakido Haidate +3",
        feet = {
            name = "Valorous Greaves",
            augments = {'Accuracy+20 Attack+20', 'Weapon skill damage +3%', 'STR+7', 'Accuracy+2'}
        },
        neck = "Sam. Nodowa +2",
        waist = "Sailfi Belt +1",
        left_ear = "Thrud Earring",
        right_ear = "Moonshade Earring",
        left_ring = "Karieyh Ring",
        right_ring = "Epaminondas's Ring",
        back = gear.ws_jse_back
    }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        head = "Wakido Kabuto +3",
        body = "Sakonji Domaru +3",
        feet = "Wakido Sune. +3" --
    })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Tachi: Fudo'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {
        left_ring = "Niqmaddu Ring"
    })
    sets.precast.WS['Tachi: Shoha'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Tachi: Rana'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Tachi: Kasha'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Tachi: Gekko'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Tachi: Yukikaze'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Tachi: Ageha'] = {
        ammo = "Pemphredo Tathlum",
        head = "Flam. Zucchetto +2",
        neck = "Sanctity Necklace",
        ear1 = "Digni. Earring",
        ear2 = "Moonshade Earring",
        body = "Flamma Korazin +2",
        hands = "Flam. Manopolas +2",
        ring1 = "Ramuh Ring +1",
        ring2 = "Ramuh Ring +1",
        back = gear.ws_jse_back,
        waist = "Eschan Stone",
        legs = "Flamma Dirs +2",
        feet = "Flam. Gambieras +2"
    }

    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS, {
        ammo = "Knobkierrie",
        head = gear.valorous_magical_wsd_head,
        neck = "Fotia Gorget",
        ear1 = "Friomisi Earring",
        ear2 = "Moonshade Earring",
        body = "Sacro Breastplate",
        hands = "Founder's Gauntlets",
        ring1 = "Niqmaddu Ring",
        ring2 = "Regal Ring",
        back = gear.ws_jse_back,
        waist = "Eschan Stone",
        legs = "Wakido Haidate +3",
        feet = "Founder's Greaves"
    })

    sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {})

    -- Swap to these on Moonshade using WS if at 3000 TP
    sets.MaxTP = {
        ear1 = "Thrud Earring",
        ear2 = "Lugra Earring +1"
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
        ear1 = "Thrud Earring",
        ear2 = "Brutal Earring"
    }
    sets.AccDayWSEars = {
        ear1 = "Mache Earring +1",
        ear2 = "Telos Earring"
    }
    sets.DayWSEars = {
        ear1 = "Thrud Earring",
        ear2 = "Moonshade Earring"
    }

    -- Midcast Sets
    -- Specific spells
    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {
        back = "Mujin Mantle"
    })

    -- Sets to return to when not performing an action.
    -- Resting sets
    sets.resting = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        neck = "Loricate Torque +1",
        waist = "Ioskeha Belt +1",
        left_ear = "Odnowa Earring +1",
        right_ear = "Telos Earring",
        left_ring = "Gelatinous Ring +1",
        right_ring = "Defending Ring",
        back = gear.stp_jse_back
    }

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.Kiting = {
        feet = "Danzo Sune-ate"
    }

    sets.Reraise = {
        head = "Twilight Helm",
        body = "Twilight Mail"
    }

    sets.TreasureHunter = set_combine(sets.TreasureHunter, {})
    sets.Skillchain = {
        head = "Nyame Helm",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        neck = "Loricate Torque +1",
        waist = "Ioskeha Belt +1",
        left_ear = "Odnowa Earring +1",
        right_ear = "Etiolation Earring",
        left_ring = "Gelatinous Ring +1",
        right_ring = "Defending Ring",
        back = gear.stp_jse_back
    }

    sets.idle.Reraise = set_combine(sets.idle, sets.Reraise)

    sets.idle.Weak = set_combine(sets.idle, {})

    sets.idle.Weak.Reraise = set_combine(sets.idle.Weak, sets.Reraise)

    sets.DayIdle = {}
    sets.NightIdle = {}

    -- Defense sets
    sets.defense.PDT = set_combine(sets.idle, {})

    sets.defense.PDTReraise = set_combine(sets.defense.PDT, sets.Reraise)

    sets.defense.MDT = set_combine(sets.idle, {})

    sets.defense.MDTReraise = set_combine(sets.defense.MDT, sets.Reraise)

    sets.defense.MEVA = set_combine(sets.idle, {
        neck = "Warder's Charm +1"
    })

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = {
        ammo = "Aurgelmir Orb +1",
        head = "Flam. Zucchetto +2",
        body = "Tatena. Harama. +1",
        hands = "Wakido Kote +3",
        legs = "Tatena. Haidate +1",
        feet = "Ryuo Sune-Ate +1",
        neck = "Sam. Nodowa +2",
        waist = "Sailfi Belt +1",
        left_ear = "Dedition Earring",
        right_ear = "Telos Earring",
        left_ring = "Niqmaddu Ring",
        right_ring = "Chirich Ring +1",
        back = gear.stp_jse_back
    }
    sets.engaged.Acc = set_combine(sets.engaged, {
        waist="Ioskeha Belt +1",
        left_ear="Cessance Earring",
        feet = "Tatena. Sune. +1"
    })
    sets.engaged.DTLite = {
        ammo = "Aurgelmir Orb +1",
        head = "Mpaca's Cap",
        body = "Nyame Mail",
        hands = "Wakido Kote +3",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        neck = "Sam. Nodowa +2",
        waist = "Ioskeha Belt +1",
        left_ear = "Dedition Earring",
        right_ear = "Telos Earring",
        left_ring = "Niqmaddu Ring",
        right_ring = "Defending Ring",
        back = gear.stp_jse_back
    }
    sets.engaged.Acc.DTLite = {
        ammo = "Staunch Tathlum +1",
        head = "Ynglinga Sallet",
        neck = "Loricate Torque +1",
        ear1 = "Cessance Earring",
        ear2 = "Brutal Earring",
        body = "Tartarus Platemail",
        hands = "Wakido Kote +3",
        ring1 = "Defending Ring",
        ring2 = "Patricius Ring",
        back = gear.stp_jse_back,
        waist = "Ioskeha Belt",
        legs = "Wakido Haidate +3",
        feet = "Amm Greaves"
    }

    sets.engaged.Reraise = set_combine(sets.engaged, sets.Reraise)
    sets.engaged.Acc.Reraise = set_combine(sets.engaged.Acc, sets.Reraise)

    -- Weapons sets
    sets.weapons.Masamune = {
        main = "Masamune",
        sub = "Utu Grip"
    }
    sets.weapons.Soboro = {
        main = "Soboro Sukehiro",
        sub = "Utu Grip"
    }
    sets.weapons.ShiningOne = {
        main = "Shining One",
        sub = "Utu Grip"
    }
    sets.weapons.ProcWeapon = {
        main = "Norifusa +1",
        sub = "Bloodrain Strap"
    }

    -- Buff sets
    sets.Cure_Received = {
        hands = "Buremte Gloves",
        waist = "Gishdubar Sash",
        legs = "Flamma Dirs +2"
    }
    sets.buff.Doom = set_combine(sets.buff.Doom, {})
    sets.buff.Sleep = {
        neck = "Vim Torque +1"
    }
    sets.buff.Hasso = {
        hands = "Wakido Kote +3"
    }
    sets.buff['Third Eye'] = {} -- legs="Sakonji Haidate +3"
    sets.buff.Sekkanoki = {
        hands = "Kasuga Kote +1"
    }
    sets.buff.Sengikori = {
        feet = "Kas. Sune-Ate +1"
    }
    sets.buff['Meikyo Shisui'] = {
        feet = "Sak. Sune-Ate +1"
    }
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(3, 1)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(10, 1)
    elseif player.sub_job == 'THF' then
        set_macro_page(2, 1)
    else
        set_macro_page(1, 1)
    end
end

-- Job Specific Trust Overwrite
function check_trust()
    if not moving then
        if state.AutoTrustMode.value and not data.areas.cities:contains(world.area) and
            (buffactive['Elvorseal'] or buffactive['Reive Mark'] or not player.in_combat) then
            local party = windower.ffxi.get_party()
            if party.p5 == nil then
                local spell_recasts = windower.ffxi.get_spell_recasts()

                if spell_recasts[980] < spell_latency and not have_trust("Yoran-Oran") then
                    windower.send_command('input /ma "Yoran-Oran (UC)" <me>')
                    tickdelay = os.clock() + 3
                    return true
                elseif spell_recasts[952] < spell_latency and not have_trust("Koru-Moru") then
                    windower.send_command('input /ma "Koru-Moru" <me>')
                    tickdelay = os.clock() + 3
                    return true
                elseif spell_recasts[967] < spell_latency and not have_trust("Qultada") then
                    windower.send_command('input /ma "Qultada" <me>')
                    tickdelay = os.clock() + 3
                    return true
                elseif spell_recasts[914] < spell_latency and not have_trust("Ulmia") then
                    windower.send_command('input /ma "Ulmia" <me>')
                    tickdelay = os.clock() + 3
                    return true
                elseif spell_recasts[979] < spell_latency and not have_trust("Selh'teus") then
                    windower.send_command('input /ma "Selh\'teus" <me>')
                    tickdelay = os.clock() + 3
                    return true
                else
                    return false
                end
            end
        end
    end
    return false
end
