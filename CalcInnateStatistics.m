function statistics = CalcInnateStatistics(  ...
    innate_data            , ...
    innate_marksmanship    , ...
    innate_assaultshooting , ...
    statistics_in            ...
)
    statistics = statistics_in;

    %% marksmanship
    marksmanship   = innate_data.modifiers(strcmp(innate_data.name, 'Marksmanship'));
    marksmanship   = marksmanship{1};
    index = strcmp({marksmanship.target}, 'accuracyAdd');
    accuracy_start = marksmanship(index).rangeStart;
    accuracy_end   = marksmanship(index).rangeEnd;
    accuracy_add   = linearInterpolationHold(0, 100, accuracy_start, accuracy_end, innate_marksmanship);

    index = strcmp({marksmanship.target}, 'critChanceAdd');
    crit_start = marksmanship(index).rangeStart;
    crit_end   = marksmanship(index).rangeEnd;
    crit_add   = linearInterpolationHold(0, 100, crit_start, crit_end, innate_marksmanship);

    %% assaultshooting
    % CAUTION: we assume 'maxAimTime' == 'minAimTime'
    assaultshooting = innate_data.modifiers(strcmp(innate_data.name, 'AssaultShooting'));
    assaultshooting = assaultshooting{1};
    index = strcmp({assaultshooting.target}, 'minAimTime');
    aim_time_start = assaultshooting(index).rangeStart;
    aim_time_end   = assaultshooting(index).rangeEnd;
    aim_time_add   = linearInterpolationHold(0, 100, aim_time_start, aim_time_end, innate_assaultshooting);

    %%
    statistics.curved.accuracy   = statistics.curved.accuracy   + accuracy_add;
    statistics.curved.critChance = statistics.curved.critChance + crit_add;
    statistics.curved.aimTime    = statistics.curved.aimTime    + aim_time_add;
end