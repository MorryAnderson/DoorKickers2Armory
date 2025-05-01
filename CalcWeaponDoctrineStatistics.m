function statistics = CalcWeaponDoctrineStatistics( ...
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
    battle_honor_2           ...
)

    gun_info   = equip_data.gun(strcmp(equip_data.gun.name, gun_name), :);
    scope_info = equip_data.scope(strcmp(equip_data.scope.name, scope_name), :);
    ammo_info  = equip_data.ammo(strcmp(equip_data.ammo.name, ammo_name), :);


    %% troop class
    activated_doctrines = getActivatedDoctrines(doctrine_record, gun_info.type, ...
                                                class_ranger_names, class_swat_names, class_cia_names, ...
                                                doctrine_enable_ranger, doctrine_enable_swat, doctrine_enable_cia);
    num_activated_doctrines = height(activated_doctrines);


    %% constant statistics
%     statistics_basic.constant.length                   = gun_info.length                  ;
    statistics_basic.constant.category                 = gun_info.category                ;
    statistics_basic.constant.moveSpeedModifierPercent = gun_info.moveSpeedModifierPercent;
    statistics_basic.constant.turnSpeedModifierPercent = gun_info.turnSpeedModifierPercent;
    statistics_basic.constant.closedBolt               = gun_info.closedBolt              ;
    statistics_basic.constant.cyclicReload             = gun_info.cyclicReload            ;
    statistics_basic.constant.reloadTime               = gun_info.reloadTime              ;
    statistics_basic.constant.reloadEmptyTime          = gun_info.reloadEmptyTime         ;
    statistics_basic.constant.changeInTime             = gun_info.changeInTime            ;
    statistics_basic.constant.changeOutTime            = gun_info.changeOutTime           ;
    statistics_basic.constant.readyTime                = gun_info.readyTime               ;
    statistics_basic.constant.guardTime                = gun_info.guardTime               ;
    statistics_basic.constant.suppressionScale         = gun_info.suppressionScale        ;
    statistics_basic.constant.roundsPerMagazine        = gun_info.roundsPerMagazine       ;
    statistics_basic.constant.numPellets               = gun_info.numPellets              ;
    statistics_basic.constant.audibleSoundRadius       = ammo_info.audibleSoundRadius     ;
    statistics_basic.constant.physicsImpactForce       = ammo_info.physicsImpactForce     ;
    statistics_basic.constant.silenced                 = ammo_info.silenced               ;
    % statistics_basic.constant.conditioning             = ammo_info.conditioning           ;

    if (~isnan(ammo_info.numPellets))
        statistics_basic.constant.numPellets = ammo_info.numPellets;
    end

    if (height(scope_info)) % scope_info is emtpy when scope is IronSight
        statistics_basic.constant.moveSpeedModifierPercent = statistics_basic.constant.moveSpeedModifierPercent + scope_info.moveSpeedModifierPercent; 
        statistics_basic.constant.turnSpeedModifierPercent = statistics_basic.constant.turnSpeedModifierPercent + scope_info.turnSpeedModifierPercent;
        statistics_basic.constant.changeOutTime = statistics_basic.constant.changeOutTime + scope_info.changeOutTime;
        statistics_basic.constant.reloadTime = statistics_basic.constant.reloadTime + scope_info.reloadTime;
        statistics_basic.constant.reloadEmptyTime = statistics_basic.constant.reloadEmptyTime + scope_info.reloadEmptyTime;
        statistics_basic.constant.readyTime = statistics_basic.constant.readyTime + scope_info.readyTime;
    end


    %% overridden attack types
    attack_types = gun_info.attackTypes{1};
    overridden_attack_types.name = string({attack_types.name})';
    overridden_attack_types.range_max = cell2mat({attack_types.rangeMeters})';
    overridden_attack_types.disabled = (string({attack_types.disabled}) == "true")';

    inCoverOverride_string = string({attack_types.inCoverOverride})';
    inCoverOverride_index = inCoverOverride_string ~= "";

    mountable = any(inCoverOverride_index);

    if (mountable && mounted)
        overridden_attack_types.name(inCoverOverride_index) = inCoverOverride_string(inCoverOverride_index);
    end


    %% enabled attack types
    disabled_type_index = string({attack_types.disabled}) == "true";
    has_disabled_type = any(disabled_type_index);

    enabled_attack_types = "";

    if (has_disabled_type)
        for i = 1:num_activated_doctrines
            current_doctrine_name = string(activated_doctrines(i,:).name);
            current_doctrine_data = doctrine_data.modifier(strcmp(doctrine_data.modifier.name, current_doctrine_name) ,:);
            current_doctrine_enable = current_doctrine_data.Enable{1};
            enabled_attack_types = [enabled_attack_types; current_doctrine_enable];
        end
    end

    %% final attack types
    num_max_attack_types = length(overridden_attack_types.name);
    num_final_attack_types = 0;

    final_attack_types.name = strings(num_max_attack_types,1);
    final_attack_types.range_min = zeros(num_max_attack_types, 1);
    final_attack_types.range_max = zeros(num_max_attack_types, 1);

    previous_range_min = 0;
    previous_range_max = 0;

    for i=1:num_max_attack_types
        current_range_max = overridden_attack_types.range_max(i);
        current_attack_type_name = overridden_attack_types.name(i);
        current_disabled = overridden_attack_types.disabled(i);

        if (~current_disabled || ismember(current_attack_type_name, enabled_attack_types))
            if (current_range_max ~= previous_range_max)
                num_final_attack_types = num_final_attack_types + 1;
                current_range_min = previous_range_max;
            else
                current_range_min = previous_range_min;
            end
            final_attack_types.name(num_final_attack_types) = current_attack_type_name;
            final_attack_types.range_min(num_final_attack_types) = current_range_min;
            final_attack_types.range_max(num_final_attack_types) = current_range_max;
            
            current_attack_type_info = equip_data.attack(strcmp(equip_data.attack.name, current_attack_type_name), :);

            final_attack_types.minAimTime(num_final_attack_types)              = current_attack_type_info.minAimTime;
            final_attack_types.maxAimTime(num_final_attack_types)              = current_attack_type_info.maxAimTime;
            final_attack_types.roundsPerSecondOverride(num_final_attack_types) = current_attack_type_info.roundsPerSecondOverride;
            final_attack_types.minShots(num_final_attack_types)                = current_attack_type_info.minShots;
            final_attack_types.maxShots(num_final_attack_types)                = current_attack_type_info.maxShots;
            final_attack_types.resetTime(num_final_attack_types)               = current_attack_type_info.resetTime;
            final_attack_types.accuracyAdd(num_final_attack_types)             = current_attack_type_info.accuracyAdd;
            final_attack_types.followupShotAccuracyAdd(num_final_attack_types) = current_attack_type_info.followupShotAccuracyAdd;
            final_attack_types.critChanceAdd(num_final_attack_types)           = current_attack_type_info.critChanceAdd;

            previous_range_min = current_range_min;
        end

        previous_range_max = current_range_max;
    end

    final_attack_types.name      = final_attack_types.name(1:num_final_attack_types);
    final_attack_types.range_min = final_attack_types.range_min(1:num_final_attack_types);
    final_attack_types.range_max = final_attack_types.range_max(1:num_final_attack_types);

    %% scope attack modifier
    if (height(scope_info) > 0)
        attack_modifiers = scope_info.attackTypeModifiers{1};
        num_scope_attack_modifiers     = length(attack_modifiers);
        scope_attack_modifiers.range_min     = [attack_modifiers.minRange];
        scope_attack_modifiers.range_max     = [attack_modifiers.maxRange];
        scope_attack_modifiers.minAimTimeAdd = [attack_modifiers.minAimTime2];
        scope_attack_modifiers.maxAimTimeAdd = [attack_modifiers.maxAimTime2];
        scope_attack_modifiers.resetTimeAdd  = [attack_modifiers.resetTime];
        scope_attack_modifiers.accuracyAdd   = [attack_modifiers.accuracyAdd];
        scope_attack_modifiers.critChanceAdd = [attack_modifiers.critChanceAdd];
    else
        num_scope_attack_modifiers = 1;
        scope_attack_modifiers.range_min     = 0;
        scope_attack_modifiers.range_max     = 9999;
        scope_attack_modifiers.minAimTimeAdd = 0;
        scope_attack_modifiers.maxAimTimeAdd = 0;
        scope_attack_modifiers.resetTimeAdd  = 0;
        scope_attack_modifiers.accuracyAdd   = 0;
        scope_attack_modifiers.critChanceAdd = 0;
    end


    %% curved statistics
    statistics_basic.curved.sampling_distance = 0: distance_step : max_distance;
    statistics_basic.curved.num_points = length(statistics_basic.curved.sampling_distance);
    statistics_basic.curved.attack_type_index           = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.scope_attack_modifier_index = zeros(statistics_basic.curved.num_points, 1);

    statistics_basic.curved.aimTime              = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.accuracy             = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.followupShotAccuracy = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.resetTime            = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.critChance           = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.roundsPerSecond      = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.minShots             = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.maxShots             = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.damage               = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.penetration          = zeros(statistics_basic.curved.num_points, 1);

    statistics_basic.curved.worst_ttk            = zeros(statistics_basic.curved.num_points, 1);
    statistics_basic.curved.best_ttk             = zeros(statistics_basic.curved.num_points, 1);

    for i=1:statistics_basic.curved.num_points
        D = statistics_basic.curved.sampling_distance(i);

        statistics_basic.curved.attack_type_index(i) = num_final_attack_types;
        statistics_basic.curved.scope_attack_modifier_index(i) = 0;

        for n=1:num_final_attack_types
            if (D <= final_attack_types.range_max(n))
                statistics_basic.curved.attack_type_index(i) = n;
                break;
            end
        end

        for n=1:num_scope_attack_modifiers
            if (D <= scope_attack_modifiers.range_max(n) && D > scope_attack_modifiers.range_min(n))
                statistics_basic.curved.scope_attack_modifier_index(i) = n;
                break;
            end
        end
    end


    for i=1:statistics_basic.curved.num_points
        attack_index       = statistics_basic.curved.attack_type_index(i);
        scope_attack_index = statistics_basic.curved.scope_attack_modifier_index(i);
        x = statistics_basic.curved.sampling_distance(i);

        % scope modifier
        if (scope_attack_index == 0)
            scope_aimTimeAdd = 0;
            scope_attack_modifiers_resetTimeAdd = 0;
            scope_attack_modifiers_accuracyAdd = 0;
            scope_attack_modifiers_critChanceAdd = 0;
        else 
            scope_start_x = scope_attack_modifiers.range_min(scope_attack_index);
            scope_end_x   = scope_attack_modifiers.range_max(scope_attack_index);
            scope_start_y = scope_attack_modifiers.minAimTimeAdd(scope_attack_index);
            scope_end_y   = scope_attack_modifiers.maxAimTimeAdd(scope_attack_index);

            scope_aimTimeAdd  = linearInterpolationZero(scope_start_x, scope_end_x, scope_start_y, scope_end_y, x);
            scope_attack_modifiers_resetTimeAdd  = scope_attack_modifiers.resetTimeAdd(scope_attack_index);
            scope_attack_modifiers_accuracyAdd   = scope_attack_modifiers.accuracyAdd(scope_attack_index);
            scope_attack_modifiers_critChanceAdd = scope_attack_modifiers.critChanceAdd(scope_attack_index);
        end

        % aimTime
        start_x = final_attack_types.range_min(attack_index);
        end_x   = final_attack_types.range_max(attack_index);
        start_y = final_attack_types.minAimTime(attack_index);
        end_y   = final_attack_types.maxAimTime(attack_index);

        attack_aimTime = linearInterpolationHold(start_x, end_x, start_y, end_y, x);

        statistics_basic.curved.aimTime(i) = attack_aimTime + scope_aimTimeAdd;

        % resetTime
        statistics_basic.curved.resetTime(i) = final_attack_types.resetTime(attack_index) + scope_attack_modifiers_resetTimeAdd;

        % accuracy
        start_x = gun_info.accuracyStartDist;
        end_x   = gun_info.accuracyEndDist;
        start_y = gun_info.accuracyStart;
        end_y   = gun_info.accuracyEnd;
        statistics_basic.curved.accuracy(i) = linearInterpolationHold(start_x, end_x, start_y, end_y, x) ...
                                              + final_attack_types.accuracyAdd(attack_index) ...
                                              + scope_attack_modifiers_accuracyAdd ...
                                              + ammo_info.accuracyAdd;
        statistics_basic.curved.accuracy(i) = statistics_basic.curved.accuracy(i) .* ammo_info.accuracyMultiplier ./ 100;                    
        statistics_basic.curved.followupShotAccuracy(i) = statistics_basic.curved.accuracy(i) ...
                                                          + final_attack_types.followupShotAccuracyAdd(attack_index);

        % minShots & maxShots
        statistics_basic.curved.minShots(i) = final_attack_types.minShots(attack_index);
        statistics_basic.curved.maxShots(i) = final_attack_types.maxShots(attack_index);
        
        % damage
        start_x = ammo_info.damageStartDist;
        end_x   = ammo_info.damageEndDist;
        start_y = ammo_info.damageStart;
        end_y   = ammo_info.damageEnd;
        statistics_basic.curved.damage(i) = ceil(linearInterpolationHold(start_x, end_x, start_y, end_y, x));
        statistics_basic.curved.damage(i) = statistics_basic.curved.damage(i) .* statistics_basic.constant.numPellets;

        %critChance
        start_x = ammo_info.criticalStartDist;
        end_x   = ammo_info.criticalEndDist;
        start_y = ammo_info.criticalStart;
        end_y   = ammo_info.criticalEnd;
        statistics_basic.curved.critChance(i) = linearInterpolationHold(start_x, end_x, start_y, end_y, x) ...
                                                + scope_attack_modifiers_critChanceAdd ...                                  
                                                + final_attack_types.critChanceAdd(attack_index);
        statistics_basic.curved.critChance(i) = statistics_basic.curved.critChance(i) .* statistics_basic.constant.numPellets;

        % penetration
        start_x = ammo_info.penetrationStartDist;
        end_x   = ammo_info.penetrationEndDist;
        start_y = ammo_info.penetrationStart;
        end_y   = ammo_info.penetrationEnd;
        statistics_basic.curved.penetration(i) = linearInterpolationHold(start_x, end_x, start_y, end_y, x);

        % roundsPerSecond
        statistics_basic.curved.roundsPerSecond(i) = ammo_info.roundsPerSecond;
        if (~isnan(final_attack_types.roundsPerSecondOverride(attack_index)))
            statistics_basic.curved.roundsPerSecond(i) = final_attack_types.roundsPerSecondOverride(attack_index);
        end

    end

    %% doctrine modifier
    statistics = CalcDoctrineStatistics( ...
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
        statistics_basic         ...
    );

end