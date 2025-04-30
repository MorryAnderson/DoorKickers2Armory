function activated_doctrines = getActivatedDoctrines( ...
    doctrine_record, gun_info_type, ...
    class_ranger_names, class_swat_names, class_cia_names, ...
    doctrine_enable_ranger, doctrine_enable_swat, doctrine_enable_cia ...
)
    troop_type = gun_info_type{1};
    troop_is_rangers = any(ismember(troop_type, class_ranger_names));
    troop_is_swat    = any(ismember(troop_type, class_swat_names));
    troop_is_cia     = any(ismember(troop_type, class_cia_names));

    if (troop_is_rangers && doctrine_enable_ranger)
        activated_doctrines = doctrine_record(strcmp(doctrine_record.class, class_ranger_names(1)) ,:);
    elseif (troop_is_swat && doctrine_enable_swat)
        activated_doctrines = doctrine_record(strcmp(doctrine_record.class, class_swat_names(1)) ,:);
    elseif (troop_is_cia && doctrine_enable_cia)
        activated_doctrines = doctrine_record(strcmp(doctrine_record.class, class_cia_names(1)) ,:);
    else
        activated_doctrines = [];
    end

    if (height(activated_doctrines) ~= 0)
        activated_doctrines = activated_doctrines(activated_doctrines.enabled, :);
    end

end