function statistics = CalcTTK(statistics_in, enemy_hp, crit_kill)
    % 假设精准度为100%，射击次数取minShots
    statistics = statistics_in;

    for i=1:statistics.curved.num_points
        x = statistics.curved.sampling_distance(i);
        
        aimTime         = max(statistics.curved.aimTime(i), 0);
        resetTime       = statistics.curved.resetTime(i)      ;
        damage          = statistics.curved.damage(i)         ;
        minShots        = statistics.curved.minShots(i)       ;
        maxShots        = statistics.curved.maxShots(i)       ;
        roundsPerSecond = statistics.curved.roundsPerSecond(i);
        critChance      = statistics.curved.critChance(i)     ;

        shots_to_kill = ceil(enemy_hp / damage);

        if (maxShots < 0)  % auto firing mode
            shots_per_sequence = shots_to_kill;
        else
            shots_per_sequence = ceil(minShots);
        end

        num_sequences = ceil(shots_to_kill / shots_per_sequence);
        shots_in_final_sequence = shots_to_kill - (num_sequences-1)*shots_per_sequence;

        time_between_shots = 1000 / roundsPerSecond;
        time_between_seqs  = max(resetTime, time_between_shots);

        duration_per_sequence = time_between_shots * (shots_per_sequence-1);
        duration_of_final_seq = time_between_shots * (shots_in_final_sequence-1);
        dutation_between_seqs = time_between_seqs  * (num_sequences-1);

        if (crit_kill && critChance >= 100)
            statistics.curved.ttk(i) = aimTime;
        else
            statistics.curved.ttk(i) = aimTime + duration_per_sequence * (num_sequences-1) + duration_of_final_seq + dutation_between_seqs;
        end
    end
end