function statistics = CalcBattleHonorStatistics( ...
    battle_honor_text      , ...
    battle_honor_1         , ...
    battle_honor_2         , ...
    statistics_in            ...
)

    statistics = statistics_in;

    % battle_honor_text{1} = none
    % battle_honor_text{2} = offensive : +10% critChange
    % battle_honor_text{3} = defensive : -25ms aimTime

    critChangeMultiplier = 1.1;
    aimTimeAdd = -25;


    if (strcmp(battle_honor_1, battle_honor_text{2}))
        statistics.curved.critChance = statistics.curved.critChance .* critChangeMultiplier;
    elseif (strcmp(battle_honor_1, battle_honor_text{3}))
        statistics.curved.aimTime = statistics.curved.aimTime + aimTimeAdd;
    end
    
    if (strcmp(battle_honor_2, battle_honor_text{2}))
        statistics.curved.critChance = statistics.curved.critChance .* critChangeMultiplier;
    elseif (strcmp(battle_honor_2, battle_honor_text{3}))
        statistics.curved.aimTime = statistics.curved.aimTime + aimTimeAdd;
    end            
end