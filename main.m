clear all;

dir_path_of_steam = "D:\Games\Steam";

class_ranger_names = ["Rangers"; "Assault"; "Support"; "Marksman"; "Grenadier"];
class_swat_names   = ["CIA"; "Undercover"; "BlackOps"];
class_cia_names    = ["SWAT"; "SwatLeader"; "SwatAssaulter"; "SwatSapper"; "SwatMilitia"];

[equip_data, doctrine_data, innate_data] = loadGameData(dir_path_of_steam, 'gun_length.csv');
[doctrine_record, doctrine_tree] = loadDoctrineFromCSV("doctrines.csv");


%%
gun_name = 'M16A4';
% gun_name = 'M9Sup Pistol';
scope_name = 'IronSights';
ammo_name = '556FMJM855_M16A4';
% ammo_name = '556FMJMk318_M16A4';

mounted                 = false;

doctrine_enable_ranger  = true;
doctrine_enable_swat    = true;
doctrine_enable_cia     = true;

innate_marksmanship     = 50;
innate_assaultshooting  = 50;
battle_honor_1          = "无";
battle_honor_2          = "无";


%%
% doctrine_record.enabled(strcmp(doctrine_record.name, "Rifles_ShortRangeDrills")) = true;
% doctrine_record.enabled(strcmp(doctrine_record.name, "Rifles_CloseRangeBurst")) = true;
% doctrine_record.enabled(strcmp(doctrine_record.name, "Rifles_MediumRangeDrills")) = true;
% doctrine_record.enabled(strcmp(doctrine_record.name, "Rifles_MediumRangeBurst")) = true;


%%
statistics = CalcWeaponDoctrineStatistics( ...
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
);


statistics = CalcTTK(statistics, 100);


