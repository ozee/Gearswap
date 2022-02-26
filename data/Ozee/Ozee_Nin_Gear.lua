-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
    state.Auto_Kite = M(false, 'Auto_Kite')
    state.OffenseMode:options('Normal')
    state.HybridMode:options('Normal', 'DT', 'EVA')
    state.WeaponskillMode:options('Match', 'Normal', 'Proc')
    state.CastingMode:options('Normal', 'Proc', 'Resistant')
    state.IdleMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT')
    state.MagicalDefenseMode:options('MDT')
    state.ResistDefenseMode:options('MEVA')
    state.Weapons:options('Heishi', 'Savage', 'Edge', 'ProcDagger', 'ProcSword', 'ProcGreatSword', 'ProcScythe',
        'ProcPolearm', 'ProcGreatKatana', 'ProcKatana', 'ProcClub', 'ProcStaff')

    gear.wsd_jse_back = {
        name = "Andartia's Mantle",
        augments = {'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%', 'Damage taken-5%'}
    }
    gear.da_jse_back = {
        name = "Andartia's Mantle",
        augments = {'DEX+20', 'Accuracy+20 Attack+20', 'DEX+10', '"Dbl.Atk."+10', 'Damage taken-5%'}
    }
    gear.fc_jse_back = {
        name = "Andartia's Mantle",
        augments = {'AGI+20', 'Eva.+20 /Mag. Eva.+20', '"Fast Cast"+10', 'Damage taken-4%'}
    }
    gear.mab_jse_back = {
        name = "Andartia's Mantle",
        augments = {'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', 'Damage taken-5%'}
    }

    send_command('bind ^` input /ja "Innin" <me>')
    send_command('bind !` input /ja "Yonin" <me>')
    send_command('bind @` gs c cycle SkillchainMode')

    currentweapon = "Heishi"
    autows = "Blade: Shun"
    autofood = 'Sublime Sushi +1'

    utsusemi_cancel_delay = .3
    utsusemi_ni_cancel_delay = .06

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false

    update_combat_form()
    determine_haste_group()
    select_default_macro_book()
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

buff_spell_lists = {
    Auto = {{
        Name = 'Migawari: Ichi',
        Buff = 'Migawari',
        SpellID = 510,
        When = 'Combat'
    }, {
        Name = 'Myoshu: Ichi',
        Buff = 'Subtle Blow Plus',
        SpellID = 507,
        When = 'Combat'
    }, {
        Name = 'Kakka: Ichi',
        Buff = 'Store TP',
        SpellID = 509,
        When = 'Combat'
    }},

    Default = {{
        Name = 'Myoshu: Ichi',
        Buff = 'Subtle Blow Plus',
        SpellID = 507,
        Reapply = true
    }, {
        Name = 'Kakka: Ichi',
        Buff = 'Store TP',
        SpellID = 509,
        Reapply = true
    }}
}

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Weapons' and newValue ~= oldValue then
        if newValue:contains('Savage') then
            send_command('gs c autows Savage Blade')
            send_command('gs c autows tp 1600')
        elseif newValue:contains('Edge') then
            send_command('gs c autows Aeolian Edge')
            send_command('gs c autows tp 1000')
        else
            send_command('gs c autows Blade: Shun')
            send_command('gs c autows tp 1000')
        end
    end
end

function job_buff_change(buff, gain)
    update_melee_groups()

    if (not buffactive['Copy Image'] and not buffactive['Copy Image (2)'] and not buffactive['Copy Image (3)'] and not buffactive['Copy Image (4+)']) and (player.in_combat or being_attacked) then
        equip(sets.engaged.DT)
    end
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------

    sets.Enmity = {
        ammo = "Paeapua",
        head = "Dampening Tam",
        neck = "Unmoving Collar +1",
        ear1 = "Friomisi Earring",
        ear2 = "Trux Earring",
        body = "Emet Harness +1",
        hands = "Kurys Gloves",
        ring1 = "Petrov Ring",
        ring2 = "Vengeful Ring",
        back = "Moonlight Cape",
        waist = "Goading Belt",
        legs = gear.herculean_dt_legs,
        feet = "Amm Greaves"
    }

    -- Precast sets to enhance JAs
    sets.precast.JA['Futae'] = {
        hands = "Hattori Tekko +1"
    }
    sets.precast.JA['Sange'] = {
        legs = "Mochizuki Chainmail +3"
    }
    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast.JA['Warcry'] = sets.Enmity

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        ammo = "Yamarang",
        head = "Mummu Bonnet +2",
        neck = "Unmoving Collar +1",
        ear1 = "Enchntr. Earring +1",
        ear2 = "Handler's Earring +1",
        body = gear.herculean_waltz_body,
        hands = gear.herculean_waltz_hands,
        ring1 = "Defending Ring",
        ring2 = "Valseur's Ring",
        back = "Moonlight Cape",
        waist = "Chaac Belt",
        legs = "Dashing Subligar",
        feet = gear.herculean_waltz_feet
    }

    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo = "Sapience Orb",
        body = gear.adhemar_fc_body,
        hands = "Leyline Gloves",
        feet = "Hattori Kyahan +1",
        neck = "Baetyl Pendant",
        left_ear = "Loquac. Earring",
        right_ear = "Enchntr. Earring +1",
        left_ring = "Rahab Ring",
        right_ring = "Kishar Ring",
        back = gear.fc_jse_back
    }
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        neck = "Magoraga Beads",
        body = "Mochi. Chainmail +3"
    })
    sets.precast.FC.Shadows = set_combine(sets.precast.FC.Utsusemi, {
        ammo = "Staunch Tathlum +1"
    })

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Seeth. Bomblet +1",
        head = "Hachiya Hatsu. +3",
        body = gear.adhemar_att_body,
        hands = "Mochizuki Tekko +3",
        legs = "Mochi. Hakama +3",
        feet = "Mochi. Kyahan +3",
        neck = "Ninja Nodowa +2",
        waist = "Sailfi Belt +1",
        left_ear = "Moonshade Earring",
        right_ear = "Lugra Earring +1",
        left_ring = "Gere Ring",
        right_ring = "Regal Ring",
        back = gear.wsd_jse_back
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, {
        head = gear.adhemar_att_head,
        hands = gear.adhemar_att_hands,
        legs = gear.rao_att_legs,
        neck = "Fotia Gorget",
        waist = "Fotia Belt",
        -- left_ring="Ilabrat Ring",
        right_ring = "Regal Ring",
        back = gear.da_jse_back
    })

    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
        ammo = "Yetshila +1",
        head = "Hachiya Hatsu. +3",
        body = "Ken. Samue +1",
        hands = gear.ryuo_da_hands,
        feet = "Mummu Gamash. +2",
        left_ear = "Odr Earring",
        right_ring = "Regal Ring"
    })


    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Blade: To'] = set_combine(sets.precast.WS, {
        head = "Mochi. Hatsuburi +3",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        waist = "Orpheus's Sash",
        right_ring = "Epaminondas's Ring"
    })

    sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS, {
        head = "Mochi. Hatsuburi +3",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        waist = "Orpheus's Sash",
        right_ring = "Epaminondas's Ring"
    })

    sets.precast.WS['Blade: Teki'] = set_combine(sets.precast.WS, {
        head = "Mochi. Hatsuburi +3",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        waist = "Orpheus's Sash",
        right_ring = "Epaminondas's Ring"
    })

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        head = "Mochi. Hatsuburi +3",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        feet = "Nyame Sollerets",
        waist = "Orpheus's Sash",
        right_ear = "Friomisi Earring",
        right_ring = "Epaminondas's Ring"
    })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        head = "Nyame Helm",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        feet = "Nyame Sollerets",
        waist = "Sailfi Belt +1",
        right_ear = "Sherida Earring",
        right_ring = "Epaminondas's Ring"
    })


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.ElementalNinjutsu = {
        ammo = "Ghastly Tathlum +1",
        head = "Mochi. Hatsuburi +3",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Mochi. Kyahan +3",
        neck = "Baetyl Pendant",
        waist = "Orpheus's Sash",
        right_ear = "Friomisi Earring",
        left_ring = "Shiva Ring +1",
        right_ring = "Shiva Ring +1",
        back = gear.mab_jse_back
    }

    sets.MagicBurst = set_combine(sets.midcast.ElementalNinjutsu, {
        neck = "Warder's Charm +1",
        ring1 = "Mujin Band",
        ring2 = "Locus Ring"
    })

    sets.midcast.NinjutsuDebuff = {
        ammo = "Dosis Tathlum",
        head = "Dampening Tam",
        neck = "Incanter's Torque",
        ear1 = "Gwati Earring",
        ear2 = "Digni. Earring",
        body = "Mekosu. Harness",
        hands = "Mochizuki Tekko +1",
        ring1 = "Stikini Ring +1",
        ring2 = "Metamor. Ring +1",
        back = gear.fc_jse_back,
        waist = "Chaac Belt",
        legs = "Rawhide Trousers",
        feet = "Mochi. Kyahan +1"
    }

    sets.midcast.NinjutsuBuff = set_combine(sets.midcast.FastRecast, {
        back = "Mujin Mantle"
    })

    sets.midcast.Utsusemi = set_combine(sets.midcast.NinjutsuBuff, {
        back = gear.fc_jse_back,
        feet = "Hattori Kyahan +1"
    })

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = {}

    -- Idle sets
    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Malignance Tights",
        feet = "Danzo Sune-Ate",
        neck = "Loricate Torque +1",
        waist = "Kentarch Belt +1",
        left_ear = "Etiolation Earring",
        right_ear = "Odnowa Earring +1",
        left_ring = "Defending Ring",
        right_ring = "Gelatinous Ring +1",
        back = gear.da_jse_back
    }

    sets.defense.PDT = {
        ammo = "Togakushi Shuriken",
        head = "Dampening Tam",
        neck = "Loricate Torque +1",
        ear1 = "Genmei Earring",
        ear2 = "Sanare Earring",
        body = "Emet Harness +1",
        hands = "Malignance Gloves",
        ring1 = "Defending Ring",
        ring2 = "Dark Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = gear.herculean_dt_legs,
        feet = "Malignance Boots"
    }

    sets.defense.MDT = {
        ammo = "Togakushi Shuriken",
        head = "Dampening Tam",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Sanare Earring",
        body = "Emet Harness +1",
        hands = "Malignance Gloves",
        ring1 = "Defending Ring",
        ring2 = "Shadow Ring",
        back = "Engulfer Cape +1",
        waist = "Engraved Belt",
        legs = gear.herculean_dt_legs,
        feet = "Ahosi Leggings"
    }

    sets.defense.MEVA = {
        ammo = "Yamarang",
        head = "Dampening Tam",
        neck = "Warder's Charm +1",
        ear1 = "Etiolation Earring",
        ear2 = "Sanare Earring",
        body = "Mekosu. Harness",
        hands = "Leyline Gloves",
        ring1 = "Vengeful Ring",
        Ring2 = "Purity Ring",
        back = "Toro Cape",
        waist = "Engraved Belt",
        legs = "Samnuha Tights",
        feet = "Ahosi Leggings"
    }

    sets.Kiting = {
        feet = "Danzo Sune-Ate"
    }
    sets.DuskKiting = {
        feet = "Hachiya Kyahan +2"
    }
    sets.DuskIdle = {
        feet = "Nyame Sollerets"
    }
    sets.DayIdle = {
        feet = "Nyame Sollerets"
    }
    sets.NightIdle = {
        feet = "Nyame Sollerets"
    }

    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        ammo = "Seki Shuriken",
        head = gear.ryuo_stp_head,
        body = "Mochi. Chainmail +3",
        hands = gear.adhemar_att_hands,
        legs = "Tatena. Haidate +1",
        feet = "Hiza. Sune-Ate +2",
        neck = "Ninja Nodowa +2",
        waist = "Reiki Yotai",
        left_ear = "Cessance Earring",
        right_ear = "Suppanomimi",
        left_ring = "Gere Ring",
        right_ring = "Epona's Ring",
        back = gear.da_jse_back
    }

    sets.engaged.DW = set_combine(sets.engaged, {})
    sets.engaged.DW['DW: 39'] = set_combine(sets.engaged.DW, {})
    sets.engaged.DW['DW: 37-38'] = set_combine(sets.engaged.DW['DW: 39'], {})
    sets.engaged.DW['DW: 35-36'] = set_combine(sets.engaged.DW['DW: 37-38'], {})
    sets.engaged.DW['DW: 32-34'] = set_combine(sets.engaged.DW['DW: 35-36'], {
        right_ear = "Telos Earring"
    })
    sets.engaged.DW['DW: 29-31'] = set_combine(sets.engaged.DW['DW: 32-34'], {})
    sets.engaged.DW['DW: 26-28'] = set_combine(sets.engaged.DW['DW: 29-31'], {
        waist = "Kentarch Belt +1"
    })
    sets.engaged.DW['DW: 22-25'] = set_combine(sets.engaged.DW['DW: 26-28'], {})
    sets.engaged.DW['DW: 21'] = set_combine(sets.engaged.DW['DW: 22-25'], {})
    sets.engaged.DW['DW: 20'] = set_combine(sets.engaged.DW['DW: 21'], {})
    sets.engaged.DW['DW: 17-19'] = set_combine(sets.engaged.DW['DW: 20'], {
        feet = "Ken. Sune-Ate +1"
    })
    sets.engaged.DW['DW: 14-16'] = set_combine(sets.engaged.DW['DW: 17-19'], {})
    sets.engaged.DW['DW: 10-13'] = set_combine(sets.engaged.DW['DW: 14-16'], {})
    sets.engaged.DW['DW: 0-9'] = set_combine(sets.engaged.DW['DW: 10-13'], {
        head = "Mpaca's Cap",
        body = "Ken. Samue +1"
    })

    sets.engaged.DT = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        neck = "Ninja Nodowa +2",
        waist = "Kentarch Belt +1",
        left_ear = "Dedition Earring",
        right_ear = "Telos Earring",
        left_ring = "Gere Ring",
        right_ring = "Epona's Ring",
        back = gear.da_jse_back
    }

    sets.engaged.EVA = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Mpaca's Doublet",
        hands="Mpaca's Gloves",
        legs="Malignance Tights",
        feet="Mpaca's Boots",
        neck="Ninja Nodowa +2",
        waist="Kasiri Belt",
        left_ear="Eabani Earring",
        right_ear="Ethereal Earring",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back = gear.fc_jse_back
    }

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Migawari = {} -- body="Hattori Ningi +1"
    sets.buff.Doom = set_combine(sets.buff.Doom, {})
    sets.buff.Futae = {
        hands = "Hattori Tekko +1"
    }
    sets.buff.Yonin = {
        -- legs = "Hattori Hakama +1"
    }
    sets.buff.Innin = {
        -- head = "Hattori Zukin +1"
    }

    -- Extra Melee sets.  Apply these on top of melee sets.
    sets.Knockback = {}
    sets.TreasureHunter = set_combine(sets.TreasureHunter, {})

    -- Weapons sets
    sets.weapons.Heishi = {
        main = "Heishi Shorinken",
        sub = "Kunimitsu"
    }
    sets.weapons.Savage = {
        main = "Naegling",
        sub = "Kunimitsu"
    }
    sets.weapons.Edge = {
        main = "Tauret",
        sub = "Kunimitsu"
    }
    sets.weapons.Evisceration = {
        main = "Tauret",
        sub = "Kanaria"
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
    sets.weapons.ProcKatana = {
        main = "Kanaria",
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

function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
    check_moving()
end

function customize_idle_set(idleSet)
    if state.Auto_Kite.value == true then
        idleSet = set_combine(idleSet, sets.Kiting)
    end
    return idleSet
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function check_moving()
    if state.DefenseMode.value == 'None' and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    -- Choose gearset based on DW needed
    -- 0 haste 		= 39 DW
    -- 50 haste 		= 37 DW
    -- 100 haste 	= 35 DW
    -- 150 haste 	= 32 DW
    -- 200 haste 	= 29 DW
    -- 250 haste 	= 26 DW
    -- 300 haste 	= 22 DW
    -- 306 haste 	= 21 DW
    -- 317 haste 	= 20 DW
    -- 350 haste 	= 17 DW
    -- 372 haste 	= 14 DW
    -- 400 haste 	= 10 DW
    -- 450 haste 	= 1 DW
    if DW == true then
        if DW_needed < 10 then
            classes.CustomMeleeGroups:append('DW: 0-9')
        elseif DW_needed > 10 and DW_needed < 14 then
            classes.CustomMeleeGroups:append('DW: 10-13')
        elseif DW_needed > 13 and DW_needed < 17 then
            classes.CustomMeleeGroups:append('DW: 14-16')
        elseif DW_needed > 16 and DW_needed < 20 then
            classes.CustomMeleeGroups:append('DW: 17-19')
        elseif DW_needed == 20 then
            classes.CustomMeleeGroups:append('DW: 20')
        elseif DW_needed == 21 then
            classes.CustomMeleeGroups:append('DW: 21')
        elseif DW_needed > 21 and DW_needed < 26 then
            classes.CustomMeleeGroups:append('DW: 22-25')
        elseif DW_needed > 25 and DW_needed < 29 then
            classes.CustomMeleeGroups:append('DW: 26-28')
        elseif DW_needed > 28 and DW_needed < 32 then
            classes.CustomMeleeGroups:append('DW: 29-31')
        elseif DW_needed > 31 and DW_needed < 35 then
            classes.CustomMeleeGroups:append('DW: 32-34')
        elseif DW_needed > 34 and DW_needed < 37 then
            classes.CustomMeleeGroups:append('DW: 35-36')
        elseif DW_needed > 36 and DW_needed < 39 then
            classes.CustomMeleeGroups:append('DW: 37-38')
        elseif DW_needed > 38 then
            classes.CustomMeleeGroups:append('DW: 39')
        end
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 13)
    elseif player.sub_job == 'DNC' then
        set_macro_page(2, 13)
    elseif player.sub_job == 'RDM' then
        set_macro_page(3, 13)
    else
        set_macro_page(1, 13)
    end
end
