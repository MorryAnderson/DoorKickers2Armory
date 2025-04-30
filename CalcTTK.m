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
        time_between_shots = 1000 / roundsPerSecond;
        time_between_seqs  = max(resetTime, time_between_shots);

        if (maxShots < 0)  % auto firing mode
            worst_shots_per_sequence = shots_to_kill;
            best_shots_per_sequence  = shots_to_kill;
        else
            worst_shots_per_sequence = ceil(minShots);
            best_shots_per_sequence  = floor(maxShots);
        end

        worst_num_sequences = ceil(shots_to_kill / worst_shots_per_sequence);
        worst_shots_in_final_sequence = shots_to_kill - (worst_num_sequences-1)*worst_shots_per_sequence;
        worst_duration_per_sequence  = time_between_shots * (worst_shots_per_sequence-1);
        worst_duration_of_final_seq  = time_between_shots * (worst_shots_in_final_sequence-1);
        worst_dutation_between_seqs  = time_between_seqs  * (worst_num_sequences-1);

        best_num_sequences = ceil(shots_to_kill / best_shots_per_sequence);
        best_shots_in_final_sequence = shots_to_kill - (best_num_sequences-1)*best_shots_per_sequence;
        best_duration_per_sequence  = time_between_shots * (best_shots_per_sequence-1);
        best_duration_of_final_seq  = time_between_shots * (best_shots_in_final_sequence-1);
        best_dutation_between_seqs  = time_between_seqs  * (best_num_sequences-1);

        if (crit_kill && critChance >= 100)
            statistics.curved.worst_ttk(i) = aimTime;
            statistics.curved.best_ttk(i)  = aimTime;
        else
            statistics.curved.worst_ttk(i) = aimTime + worst_duration_per_sequence * (worst_num_sequences-1) + worst_duration_of_final_seq + worst_dutation_between_seqs;
            statistics.curved.best_ttk(i)  = aimTime + best_duration_per_sequence * (best_num_sequences-1) + best_duration_of_final_seq + best_dutation_between_seqs;
        end
    end
end