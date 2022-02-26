-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Eva', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Match', 'Normal', 'Acc', 'Proc')
    state.IdleMode:options('Normal', 'Sphere')
    state.PhysicalDefenseMode:options('PDT')
    state.MagicalDefenseMode:options('MDT')
    state.ResistDefenseMode:options('MEVA')
    state.Weapons:options('Tauret', 'EVA', 'Savage', 'MagicWeapons')

    state.ExtraMeleeMode = M {
        ['description'] = 'Extra Melee Mode',
        'None',
        'Parry'
    }
    state.AmbushMode = M(false, 'Ambush Mode')

    gear.stp_jse_back = {
        name = "Toutatis's Cape",
        augments = {'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Store TP"+10', 'Phys. dmg. taken-10%'}
    }
    gear.eva_jse_back = {
        name = "Toutatis's Cape",
        augments = {'AGI+20', 'Eva.+20 /Mag. Eva.+20', 'Evasion+10', '"Store TP"+10', 'Parrying rate+5%'}
    }
    gear.wsd_jse_back = {
        name = "Toutatis's Cape",
        augments = {'DEX+20', 'Accuracy+20 Attack+20', 'DEX+10', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%'}
    }

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind !` input /ra <t>')
    send_command('bind @` gs c cycle SkillchainMode')
    send_command('bind @f10 gs c toggle AmbushMode')
    send_command('bind ^backspace input /item "Thief\'s Tools" <t>')
    send_command('bind ^q gs c weapons ProcWeapons;gs c set WeaponSkillMode proc;')
    send_command('bind !q gs c weapons SwordThrowing')
    send_command('bind !backspace input /ja "Hide" <me>')
    send_command('bind ^\\\\ input /ja "Despoil" <t>')
    send_command('bind !\\\\ input /ja "Mug" <t>')

    select_default_macro_book()
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Weapons' and newValue ~= oldValue then
        if newValue:contains('Savage') then
            send_command('gs c autows Savage Blade')
            send_command('gs c autows tp 1600')
        elseif newValue:contains('MagicWeapons') then
            send_command('gs c autows Aeolian Edge')
            send_command('gs c autows tp 1000')
        else
            send_command('gs c autows Evisceration')
            send_command('gs c autows tp 1000')
        end
    end
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {
        ammo = "Per. Lucky Egg",
        hands = "Plun. Armlets +3",
    }
    sets.Kiting = {
        feet = "Jute Boots +1"
    }

    sets.buff.Doom = set_combine(sets.buff.Doom, {})
    sets.buff.Sleep = {
        head = "Frenzy Sallet"
    }

    sets.buff['Sneak Attack'] = {}
    sets.buff['Trick Attack'] = {}

    -- Extra Melee sets.  Apply these on top of melee sets.
    sets.Knockback = {}
    sets.Parry = {
        ring1 = "Defending Ring"
    }
    sets.Ambush = {} -- body="Plunderer's Vest +1"

    -- Weapons sets
    sets.weapons.Tauret = {
        main = "Tauret",
        sub = "Gleti's Knife"
    }
    sets.weapons.Savage = {
        main = "Naegling",
        sub = "Ternion Dagger +1"
    }
    sets.weapons.EVA = {
        main = "Gandring",
        sub = "Ternion Dagger +1"
    }
    sets.weapons.ProcWeapons = {}
    sets.weapons.MagicWeapons = {
        main = "Tauret",
        sub = "Malevolence"
    }

    -- Actions we want to use to tag TH.
    sets.precast.Step = {
        ammo = "C. Palug Stone",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Mache Earring +1",
        ear2 = "Odr Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Ramuh Ring +1",
        ring2 = "Ramuh Ring +1",
        back = gear.stp_jse_back,
        waist = "Olseni Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.precast.JA['Violent Flourish'] = {
        ammo = "C. Palug Stone",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Digni. Earring",
        ear2 = "Odr Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Ramuh Ring +1",
        ring2 = "Ramuh Ring +1",
        back = gear.stp_jse_back,
        waist = "Olseni Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.precast.JA['Animated Flourish'] = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {"Skulker's Bonnet"}
    sets.precast.JA['Accomplice'] = {"Skulker's Bonnet"}
    sets.precast.JA['Flee'] = {} -- feet="Pillager's Poulaines +1"
    sets.precast.JA['Hide'] = {
        body = "Pillager's Vest +1"
    }
    sets.precast.JA['Conspirator'] = {
        body = "Skulker's Vest"
    }
    sets.precast.JA['Steal'] = {
        hands = "Pill. Armlets +1"
    }
    sets.precast.JA['Mug'] = {}
    sets.precast.JA['Despoil'] = {
        legs = "Skulker's Culottes",
        feet = "Skulk. Poulaines +1"
    }
    sets.precast.JA['Perfect Dodge'] = {
        hands = "Plunderer's Armlets"
    }
    sets.precast.JA['Feint'] = {} -- {legs="Assassin's Culottes +2"}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

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

    sets.Self_Waltz = {
        head = "Mummu Bonnet +2",
        body = "Passion Jacket",
        ring1 = "Asklepian Ring"
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo = "Impatiens",
        head = gear.herculean_fc_head,
        neck = "Voltsurge Torque",
        ear1 = "Enchntr. Earring +1",
        ear2 = "Loquac. Earring",
        body = "Dread Jupon",
        hands = "Leyline Gloves",
        ring1 = "Lebeche Ring",
        ring2 = "Prolix Ring",
        legs = "Rawhide Trousers"
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        neck = "Magoraga Beads",
        body = "Passion Jacket"
    })

    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Seeth. Bomblet +1",
        head = "Gleti's Mask",
        neck = "Fotia Gorget",
        ear1 = "Sherida Earring",
        ear2 = "Moonshade Earring",
        body = "Gleti's Cuirass",
        hands = "Meg. Gloves +2",
        ring1 = "Gere Ring",
        ring2 = "Regal Ring",
        back = gear.wsd_jse_back,
        waist = "Grunfeld Rope",
        legs = gear.lustratio_crit_legs,
        feet = gear.herculean_crit_feet
    }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {})
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS.Acc, {
        head = "Pill. Bonnet +2",
        body = gear.adhemar_att_body
    })
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"], {
        ammo = "Yetshila +1",
        ear1 = "Odr Earring"
    })

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        ammo = "Yetshila +1",
        head = gear.adhemar_att_head,
        ear1 = "Moonshade Earring",
        ear2 = "Odr Earring",
        neck = "Fotia Gorget",
        hands = gear.adhemar_att_hands,
        waist = "Fotia Belt",
        legs = "Pill. Culottes +2",
        feet = gear.adhemar_att_feet
    })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        head = "Nyame helm",
        neck = "Asn. Gorget +2",
        body = "Nyame mail",
        hands = "Nyame gauntlets",
        waist = "Sailfi belt +1",
        ring2 = "Epaminondas's Ring",
        legs = "Nyame flanchard",
        feet = "Nyame sollerets"
    })


    sets.precast.WS.Proc = {
        ammo = "Yamarang",
        head = "Malignance Chapeau",
        neck = "Voltsurge Torque",
        ear1 = "Digni. Earring",
        ear2 = "Heartseeker Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Varar Ring +1",
        ring2 = "Varar Ring +1",
        back = "Ground. Mantle +1",
        waist = "Olseni Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.precast.WS['Aeolian Edge'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Nyame Helm",
        neck = "Baetyl Pendant",
        ear1 = "Friomisi Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gloves",
        ring1 = "Dingir Ring",
        ring2 = "Epaminondas's Ring",
        back = gear.wsd_jse_back,
        waist = "Orpheus's Sash",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        head = gear.herculean_fc_head,
        neck = "Voltsurge Torque",
        ear1 = "Enchntr. Earring +1",
        ear2 = "Loquac. Earring",
        body = "Dread Jupon",
        hands = "Leyline Gloves",
        ring1 = "Defending Ring",
        ring2 = "Prolix Ring",
        back = "Moonlight Cape",
        waist = "Tempus Fugit",
        legs = "Rawhide Trousers",
        feet = "Malignance Boots"
    }

    -- Specific spells
    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {
        back = "Mujin Mantle"
    })

    sets.midcast.Dia = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
    sets.midcast.Diaga = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
    sets.midcast['Dia II'] = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
    sets.midcast.Bio = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
    sets.midcast['Bio II'] = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)

    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting sets
    sets.resting = {}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Eabani Earring",
        ear2 = "Odnowa Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gere Ring",
        ring2 = "Defending ring",
        back = gear.eva_jse_back,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Sphere = set_combine(sets.idle, {
        body = "Mekosu. Harness"
    })

    sets.idle.Weak = set_combine(sets.idle, {})

    -- Defense sets

    sets.defense.PDT = set_combine(sets.idle, {})
    sets.defense.MDT = set_combine(sets.defense.PDT, {})
    sets.defense.MEVA = set_combine(sets.defense.PDT, {})
    sets.defense.EVA = set_combine(sets.idle, {
        ammo = "Yamarang",
        head = "Malignance Chapeau",
        neck = "Asn. Gorget +2",
        ear1 = "Eabani Earring",
        ear2 = "Ethereal Earring",
        body = "Nyame Mail",
        hands = "Raetic Bangles +1",
        ring1 = "Moonlight Ring",
        ring2 = "Moonlight Ring",
        back = gear.eva_jse_back,
        waist = "Flume Belt +1",
        legs = "Malignance Tights",
        feet = "Nyame Sollerets"
    })


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = {
        ammo = "Aurgelmir Orb +1",
        head = gear.adhemar_acc_head,
        neck = "Asn. Gorget +2",
        ear1 = "Sherida Earring",
        ear2 = "Telos Earring",
        body = "Pillager's Vest +2",
        hands = gear.adhemar_acc_hands,
        ring1 = "Gere Ring",
        ring2 = "Hetairoi Ring",
        back = gear.stp_jse_back,
        waist = "Reiki Yotai",
        legs = "Pill. Culottes +2",
        feet = "Plun. Poulaines +3"
    }

    sets.engaged.Eva = set_combine(sets.engaged, {
        ammo = "Yamarang",
        head = "Malignance Chapeau",
        neck = "Asn. Gorget +2",
        ear1 = "Eabani Earring",
        ear2 = "Infused Earring",
        body = "Nyame Mail",
        hands = "Raetic Bangles +1",
        ring1 = "Moonlight Ring",
        ring2 = "Moonlight Ring",
        back = gear.eva_jse_back,
        waist = "Flume Belt +1",
        legs = "Malignance Tights",
        feet = "Nyame Sollerets"
    })

    sets.engaged.Acc = set_combine(sets.engaged, {
        ammo = "Yamarang",
        ear2 = "Telos Earring",
        hands = gear.adhemar_acc_hands,
        ring2 = "Regal Ring"
    })

    sets.engaged.DT = set_combine(sets.engaged, {
        ammo = "Staunch Tathlum +1",
        ear2 = "Eabani Earring",
        ring2 = "Defending Ring",
        legs = "Malignance Tights",
    })

    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Malignance Tights",
    })
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(8, 5)
    elseif player.sub_job == 'WAR' then
        set_macro_page(7, 5)
    elseif player.sub_job == 'NIN' then
        set_macro_page(10, 5)
    else
        set_macro_page(6, 5)
    end
end

-- Job Specific Trust Override
function check_trust()
    if not moving then
        if state.AutoTrustMode.value and not data.areas.cities:contains(world.area) and
            (buffactive['Elvorseal'] or buffactive['Reive Mark'] or not player.in_combat) then
            local party = windower.ffxi.get_party()
            if party.p5 == nil then
                local spell_recasts = windower.ffxi.get_spell_recasts()

                if spell_recasts[993] < spell_latency and not have_trust("ArkEV") then
                    windower.chat.input('/ma "AAEV" <me>')
                    tickdelay = os.clock() + 3
                    return true
                elseif spell_recasts[955] < spell_latency and not have_trust("Apururu") then
                    windower.chat.input('/ma "Apururu (UC)" <me>')
                    tickdelay = os.clock() + 3
                    return true
                elseif spell_recasts[952] < spell_latency and not have_trust("Koru-Moru") then
                    windower.chat.input('/ma "Koru-Moru" <me>')
                    tickdelay = os.clock() + 3
                    return true
                elseif spell_recasts[967] < spell_latency and not have_trust("Qultada") then
                    windower.chat.input('/ma "Qultada" <me>')
                    tickdelay = os.clock() + 3
                    return true
                elseif spell_recasts[914] < spell_latency and not have_trust("Ulmia") then
                    windower.chat.input('/ma "Ulmia" <me>')
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
