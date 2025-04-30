function statistics = CalcDoctrineStatistics( ...
    max_distance           , ...
    distance_step          , ...
    equip_data             , ...
    doctrine_data          , ...
    innate_data            , ...
    class_ranger_names     , ...
    class_swat_names       , ...
    class_cia_names        , ...
    gun_name               , ...
    scope_name             , ...
    ammo_name              , ...
    mounted                , ...
    doctrine_record        , ...
    doctrine_enable_ranger , ...
    doctrine_enable_swat   , ...
    doctrine_enable_cia    , ...
    innate_marksmanship    , ...
    innate_assaultshooting , ...
    battle_honor_1         , ...
    battle_honor_2         , ...
    final_attack_types     , ...
    statistics_in            ...
)
    gun_info   = equip_data.gun(strcmp(equip_data.gun.name, gun_name), :);
    scope_info = equip_data.scope(strcmp(equip_data.scope.name, scope_name), :);
    % ammo_info  = equip_data.ammo(strcmp(equip_data.ammo.name, ammo_name), :);

    name_of_firearm     = gun_info.name{1};
    category_of_firearm = gun_info.category{1};

    if (height(scope_info) > 0)
        name_of_scope       = scope_info.name{1};
        category_of_scope   = scope_info.category{1};
    else
        name_of_scope     = 'IronSights';
        category_of_scope = 'magnified';
    end

    %%
    statistics_zero.constant.reloadTimeAdd          = 0;
    statistics_zero.constant.reloadEmptyTimeAdd     = 0;
    statistics_zero.constant.changeInTimeAdd        = 0;
    statistics_zero.constant.changeOutTimeAdd       = 0;
    statistics_zero.constant.readyTimeAdd           = 0;
    statistics_zero.constant.accuracyStartAdd       = 0;
    statistics_zero.constant.accuracyEndAdd         = 0;
    statistics_zero.constant.suppressionScaleAdd    = 0;
    statistics_zero.constant.suppressionRecoveryAdd = 0;
    statistics_zero.constant.conditioningAdd        = 0;

    statistics_zero.curved.sampling_distance = 0: distance_step : max_distance;
    statistics_zero.curved.num_points = length(statistics_zero.curved.sampling_distance);

    statistics_zero.curved.aimTimeAdd              = zeros(statistics_zero.curved.num_points, 1);
    statistics_zero.curved.accuracyAdd             = zeros(statistics_zero.curved.num_points, 1);
    statistics_zero.curved.followupShotAccuracyAdd = zeros(statistics_zero.curved.num_points, 1);
    statistics_zero.curved.critChanceAdd           = zeros(statistics_zero.curved.num_points, 1);
    statistics_zero.curved.resetTimeAdd            = zeros(statistics_zero.curved.num_points, 1);
    statistics_zero.curved.roundsPerSecondAdd      = zeros(statistics_zero.curved.num_points, 1);
    statistics_zero.curved.minShotsAdd             = zeros(statistics_zero.curved.num_points, 1);
    statistics_zero.curved.maxShotsAdd             = zeros(statistics_zero.curved.num_points, 1);

    statistics_add          = statistics_zero;
    statistics_doctrine_add = statistics_zero;

    %% doctrines
    activated_doctrines = getActivatedDoctrines(doctrine_record, gun_info.type, ...
                                                class_ranger_names, class_swat_names, class_cia_names, ...
                                                doctrine_enable_ranger, doctrine_enable_swat, doctrine_enable_cia);
    num_activated_doctrines = height(activated_doctrines);

    for i=1:num_activated_doctrines
        current_doctrine = activated_doctrines(i,:);
        current_doctrine_name  = current_doctrine.name;
        current_doctrine_level = current_doctrine.level;
        current_doctrine_data  = doctrine_data.modifier(strcmp(doctrine_data.modifier.name, current_doctrine_name), :);
        current_doctrine_attack_modifiers  = current_doctrine_data.attackTypeModifiers{1};
        current_doctrine_equip_modifiers  = current_doctrine_data.equipmentModifiers{1};

        statistics_doctrine_add = statistics_zero;

        %% - attack modifiers
        for n = 1:length(current_doctrine_attack_modifiers)
            current_attack_modifier_data = current_doctrine_attack_modifiers(n);
            target = current_attack_modifier_data.target;
    
            if (current_attack_modifier_data.onlyFromCover && ~mounted)
                continue;
            end

            if (current_attack_modifier_data.onlyOnSuppressed)
                continue;
            end

            % attack type modifier
            % - if 'target' is not specified, the modifier will get applied to all attack types for all weapons
            % - if 'target' is specified, it can be either of:
            %     - the name of a specific firearm
            %     - the category of the firearm: pistol / rifle / shotgun / rpg / etc.
            %     - the name of a specific scope
            %     - the category of the scope (defined in the Scope as category="name")
            %     - the name of a specific attack type (in which case the minRange/maxRange interval doesn't need to be specified)
            target_is_attack_type = contains(target, final_attack_types.name);

            if (isempty(target)                       || ...
                strcmp(target, category_of_firearm)   || ...
                strcmp(target, name_of_firearm)       || ...
                strcmp(target, category_of_scope)     || ...
                strcmp(target, name_of_scope)         || ...
                target_is_attack_type )

                if (target_is_attack_type)
                    attack_type_index = strcmp(final_attack_types.name, target);
                    start_x = final_attack_types.range_min(attack_type_index);
                    end_x   = final_attack_types.range_max(attack_type_index);
                else
                    start_x = current_attack_modifier_data.minRange;
                    end_x   = current_attack_modifier_data.maxRange;
                end

                end_x = min(end_x, max_distance);

                start_y = current_attack_modifier_data.minAimTimeAdd;
                end_y   = current_attack_modifier_data.maxAimTimeAdd;

                p_start = ceil((start_x+distance_step) / distance_step);
                p_end   = floor(end_x / distance_step);

                if (start_x == 0)
                    p_start = 0;
                end

                for p = 1 + (p_start : p_end)
                    x = statistics_doctrine_add.curved.sampling_distance(p);
                    statistics_doctrine_add.curved.aimTimeAdd(p)              = statistics_doctrine_add.curved.aimTimeAdd(p)              + linearInterpolationZero(start_x, end_x, start_y, end_y, x);
                    statistics_doctrine_add.curved.accuracyAdd(p)             = statistics_doctrine_add.curved.accuracyAdd(p)             + current_attack_modifier_data.accuracyAdd            ;
                    statistics_doctrine_add.curved.followupShotAccuracyAdd(p) = statistics_doctrine_add.curved.followupShotAccuracyAdd(p) + current_attack_modifier_data.followupShotAccuracyAdd + current_attack_modifier_data.accuracyAdd;
                    statistics_doctrine_add.curved.critChanceAdd(p)           = statistics_doctrine_add.curved.critChanceAdd(p)           + current_attack_modifier_data.critChanceAdd          ;
                    statistics_doctrine_add.curved.resetTimeAdd(p)            = statistics_doctrine_add.curved.resetTimeAdd(p)            + current_attack_modifier_data.resetTimeAdd           ;
                    statistics_doctrine_add.curved.roundsPerSecondAdd(p)      = statistics_doctrine_add.curved.roundsPerSecondAdd(p)      + current_attack_modifier_data.roundsPerSecondAdd     ;
                    statistics_doctrine_add.curved.minShotsAdd(p)             = statistics_doctrine_add.curved.minShotsAdd(p)             + current_attack_modifier_data.minShotsAdd            ;
                    statistics_doctrine_add.curved.maxShotsAdd(p)             = statistics_doctrine_add.curved.maxShotsAdd(p)             + current_attack_modifier_data.maxShotsAdd            ;
                end
                
                continue;
            end

        end

        %% - equip modifiers
        for n = 1:length(current_doctrine_equip_modifiers)
            current_equip_modifier_data = current_doctrine_equip_modifiers(n);
            target = current_equip_modifier_data.target;

            % equip type modifier
            % - if 'target' is not specified, 
            %     - it will apply modifiers once, on the human directly. Used for stuff like "suppressionRecoveryAdd", melee bonuses and the global modifiers below
            % - if 'target' is specified, it can point to various things:
            %     - every piece of equipment if set to 'all'
            %     - the equipment name to which we're gonna apply the modifiers
            %     - an entire category of firearms: pistol / rifle / shotgun / rpg (defined in the firearm as category="name")
            %     - an entire category of equipment, specified by the equipment type: Firearm / Armor / Shield / Grenade / SpyCamera / ExplosiveCharge / Lockpick / LockpickMachine / Crowbar / DynamicHammer / SuicideBomb / Ammo / Scope / TECTorch / Disguise / Helmet / HelmetNVG / FeetOfSteel
            if (isempty(target)                       || ...
                strcmp(target, 'all')                 || ...
                strcmp(target, name_of_firearm)       || ...
                strcmp(target, category_of_firearm)   || ...
                strcmp(target, 'Firearm')              ...
                )

                start_x = gun_info.accuracyStartDist;
                end_x   = gun_info.accuracyEndDist;
                start_y = current_equip_modifier_data.accuracyStartAdd;
                end_y   = current_equip_modifier_data.accuracyEndAdd  ;

                for p=1:statistics_doctrine_add.curved.num_points
                    x = statistics_doctrine_add.curved.sampling_distance(p);
                    accuracy_add = linearInterpolationHold(start_x, end_x, start_y, end_y, x);
                    statistics_doctrine_add.curved.accuracyAdd(p) = statistics_doctrine_add.curved.accuracyAdd(p) + accuracy_add;
                    statistics_doctrine_add.curved.followupShotAccuracyAdd(p) = statistics_doctrine_add.curved.followupShotAccuracyAdd(p) + accuracy_add;
                end

                statistics_doctrine_add.constant.reloadTimeAdd           = statistics_doctrine_add.constant.reloadTimeAdd           + current_equip_modifier_data.reloadTimeAdd         ;
                statistics_doctrine_add.constant.reloadEmptyTimeAdd      = statistics_doctrine_add.constant.reloadEmptyTimeAdd      + current_equip_modifier_data.reloadEmptyTimeAdd    ;
                statistics_doctrine_add.constant.changeInTimeAdd         = statistics_doctrine_add.constant.changeInTimeAdd         + current_equip_modifier_data.changeInTimeAdd       ;
                statistics_doctrine_add.constant.changeOutTimeAdd        = statistics_doctrine_add.constant.changeOutTimeAdd        + current_equip_modifier_data.changeOutTimeAdd      ;
                statistics_doctrine_add.constant.readyTimeAdd            = statistics_doctrine_add.constant.readyTimeAdd            + current_equip_modifier_data.readyTimeAdd          ;
                statistics_doctrine_add.constant.suppressionScaleAdd     = statistics_doctrine_add.constant.suppressionScaleAdd     + current_equip_modifier_data.suppressionScaleAdd   ;

                continue;
            end
        end

        statistics_add.curved.aimTimeAdd               = statistics_add.curved.aimTimeAdd               + current_doctrine_level .* statistics_doctrine_add.curved.aimTimeAdd             ;
        statistics_add.curved.accuracyAdd              = statistics_add.curved.accuracyAdd              + current_doctrine_level .* statistics_doctrine_add.curved.accuracyAdd            ;
        statistics_add.curved.followupShotAccuracyAdd  = statistics_add.curved.followupShotAccuracyAdd  + current_doctrine_level .* statistics_doctrine_add.curved.followupShotAccuracyAdd;
        statistics_add.curved.critChanceAdd            = statistics_add.curved.critChanceAdd            + current_doctrine_level .* statistics_doctrine_add.curved.critChanceAdd          ;
        statistics_add.curved.resetTimeAdd             = statistics_add.curved.resetTimeAdd             + current_doctrine_level .* statistics_doctrine_add.curved.resetTimeAdd           ;
        statistics_add.curved.roundsPerSecondAdd       = statistics_add.curved.roundsPerSecondAdd       + current_doctrine_level .* statistics_doctrine_add.curved.roundsPerSecondAdd     ;
        statistics_add.curved.minShotsAdd              = statistics_add.curved.minShotsAdd              + current_doctrine_level .* statistics_doctrine_add.curved.minShotsAdd            ;
        statistics_add.curved.maxShotsAdd              = statistics_add.curved.maxShotsAdd              + current_doctrine_level .* statistics_doctrine_add.curved.maxShotsAdd            ;
        
        statistics_add.constant.reloadTimeAdd          = statistics_add.constant.reloadTimeAdd          + current_doctrine_level .* statistics_doctrine_add.constant.reloadTimeAdd         ;
        statistics_add.constant.reloadEmptyTimeAdd     = statistics_add.constant.reloadEmptyTimeAdd     + current_doctrine_level .* statistics_doctrine_add.constant.reloadEmptyTimeAdd    ;
        statistics_add.constant.changeInTimeAdd        = statistics_add.constant.changeInTimeAdd        + current_doctrine_level .* statistics_doctrine_add.constant.changeInTimeAdd       ;
        statistics_add.constant.changeOutTimeAdd       = statistics_add.constant.changeOutTimeAdd       + current_doctrine_level .* statistics_doctrine_add.constant.changeOutTimeAdd      ;
        statistics_add.constant.readyTimeAdd           = statistics_add.constant.readyTimeAdd           + current_doctrine_level .* statistics_doctrine_add.constant.readyTimeAdd          ;
        statistics_add.constant.suppressionScaleAdd    = statistics_add.constant.suppressionScaleAdd    + current_doctrine_level .* statistics_doctrine_add.constant.suppressionScaleAdd   ;

    end   

    statistics = statistics_in;

    statistics.curved.aimTime               = statistics.curved.aimTime              + statistics_add.curved.aimTimeAdd              ;
    statistics.curved.accuracy              = statistics.curved.accuracy             + statistics_add.curved.accuracyAdd             ;
    statistics.curved.followupShotAccuracy  = statistics.curved.followupShotAccuracy + statistics_add.curved.followupShotAccuracyAdd ;
    statistics.curved.critChance            = statistics.curved.critChance           + statistics_add.curved.critChanceAdd           ;
    statistics.curved.resetTime             = statistics.curved.resetTime            + statistics_add.curved.resetTimeAdd            ;
    statistics.curved.roundsPerSecond       = statistics.curved.roundsPerSecond      + statistics_add.curved.roundsPerSecondAdd      ;
    statistics.curved.minShots              = statistics.curved.minShots             + statistics_add.curved.minShotsAdd             ;
    statistics.curved.maxShots              = statistics.curved.maxShots             + statistics_add.curved.maxShotsAdd             ;
    statistics.constant.reloadTime          = statistics.constant.reloadTime         + statistics_add.constant.reloadTimeAdd         ;
    statistics.constant.reloadEmptyTime     = statistics.constant.reloadEmptyTime    + statistics_add.constant.reloadEmptyTimeAdd    ;
    statistics.constant.changeInTime        = statistics.constant.changeInTime       + statistics_add.constant.changeInTimeAdd       ;
    statistics.constant.changeOutTime       = statistics.constant.changeOutTime      + statistics_add.constant.changeOutTimeAdd      ;
    statistics.constant.readyTime           = statistics.constant.readyTime          + statistics_add.constant.readyTimeAdd          ;
    statistics.constant.suppressionScale    = statistics.constant.suppressionScale   + statistics_add.constant.suppressionScaleAdd   ;

end