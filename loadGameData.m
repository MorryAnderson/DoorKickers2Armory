function [equip_data, doctrine_data, innate_data] = loadGameData(dir_path_of_steam, gun_len_csv_file)
    %% game path
    dir_path_of_game = "\steamapps\common\DoorKickers2";
    dir_path_of_data = "\data";
    
    game_data_dir = fullfile(dir_path_of_steam, dir_path_of_game, dir_path_of_data);
    
    if (~isfolder(game_data_dir))
        error("Error: directory %s does not exist", date_data_fir)
    end
    
    
    %% xml path
    xml_files.rifles.ranger        = fullfile(game_data_dir, "equipment", "firearms_rifles.xml"            );
    xml_files.rifles.cia           = fullfile(game_data_dir, "equipment", "firearms_cia.xml"               );
    xml_files.rifles.swat          = fullfile(game_data_dir, "equipment", "firearms_nwswat.xml"            );
    xml_files.rifles.patch         = fullfile(game_data_dir, "equipment", "patch1.xml"                     );
    
    xml_files.pistol.ranger        = fullfile(game_data_dir, "equipment", "firearms_pistols.xml"           );
    xml_files.pistol.cia           = fullfile(game_data_dir, "equipment", "firearms_pistols_cia.xml"       );
    xml_files.pistol.swat          = fullfile(game_data_dir, "equipment", "firearms_pistols_nws.xml"       );

    xml_files.various_release      = fullfile(game_data_dir, "equipment", "various_release.xml"            );
    
    xml_files.attacktype           = fullfile(game_data_dir, "equipment", "firearm_attacktypes.xml"        );
    xml_files.attacktype_release   = fullfile(game_data_dir, "equipment", "firearm_attacktypes_release.xml");
    xml_files.scope                = fullfile(game_data_dir, "equipment", "firearm_scopes.xml"             );
    xml_files.ammo                 = fullfile(game_data_dir, "equipment", "firearm_ammo.xml"               );

    xml_files.doctrine_data        = fullfile(game_data_dir, "units"    , "doctrine_nodes.xml"             );
    xml_files.doctrine_tree        = fullfile(game_data_dir, "units"    , "units.xml"                      );
    xml_files.innate               = fullfile(game_data_dir, "entities" , "human_innate_abilities.xml"     );
    
    
    %% all equipments' brief info (type, ammo, scope)
    equip_struct.eqb = [];
    
    equip_struct.eqb.rifle.ranger   = parseEqbXML(xml_files.rifles.ranger);
    equip_struct.eqb.rifle.cia      = parseEqbXML(xml_files.rifles.cia   );
    equip_struct.eqb.rifle.swat     = parseEqbXML(xml_files.rifles.swat  );
    equip_struct.eqb.rifle.patch    = parseEqbXML(xml_files.rifles.patch );
    
    equip_struct.eqb.pistol.ranger  = parseEqbXML(xml_files.pistol.ranger);
    equip_struct.eqb.pistol.cia     = parseEqbXML(xml_files.pistol.cia   );
    equip_struct.eqb.pistol.swat    = parseEqbXML(xml_files.pistol.swat  );

    
    equip_struct.eqb.rifle  = [equip_struct.eqb.rifle.ranger ; ... 
                               equip_struct.eqb.rifle.cia    ; ... 
                               equip_struct.eqb.rifle.swat   ; ... 
                               equip_struct.eqb.rifle.patch] ;

    equip_struct.eqb.pistol = [equip_struct.eqb.pistol.ranger; ...
                               equip_struct.eqb.pistol.cia   ; ...
                               equip_struct.eqb.pistol.swat] ;

    equip_struct.eqb.various_release = parseEqbXML(xml_files.various_release);

    equip_struct.eqb        = [equip_struct.eqb.rifle ; equip_struct.eqb.pistol; equip_struct.eqb.various_release];
    

    %% detailed statistics of guns
    equip_struct.gun = [];

    equip_struct.gun.rifle.ranger   = parseRiflesXML(xml_files.rifles.ranger);
    equip_struct.gun.rifle.cia      = parseRiflesXML(xml_files.rifles.cia   );
    equip_struct.gun.rifle.swat     = parseRiflesXML(xml_files.rifles.swat  );
    equip_struct.gun.rifle.patch    = parseRiflesXML(xml_files.rifles.patch );
    
    equip_struct.gun.pistol.ranger  = parseRiflesXML(xml_files.pistol.ranger);
    equip_struct.gun.pistol.cia     = parseRiflesXML(xml_files.pistol.cia   );
    equip_struct.gun.pistol.swat    = parseRiflesXML(xml_files.pistol.swat  );
        
    equip_struct.gun.rifle  = [equip_struct.gun.rifle.ranger ; ... 
                               equip_struct.gun.rifle.cia    ; ... 
                               equip_struct.gun.rifle.swat   ; ... 
                               equip_struct.gun.rifle.patch] ;

    equip_struct.gun.pistol = [equip_struct.gun.pistol.ranger; ...
                               equip_struct.gun.pistol.cia   ; ...
                               equip_struct.gun.pistol.swat] ;
    
    equip_struct.gun.various_release = parseRiflesXML(xml_files.various_release);

    equip_struct.gun        = [equip_struct.gun.rifle ; equip_struct.gun.pistol; equip_struct.gun.various_release];
    
    %%
    equip_struct.attack = [parseAttackXML(xml_files.attacktype), ...
                           parseAttackXML(xml_files.attacktype_release)];
    equip_struct.scope  =  parseScopeXML(xml_files.scope);
    equip_struct.ammo   =  parseAmmoXML(xml_files.ammo);
    
    %%
    equip_data.gun    = innerjoin(struct2table(equip_struct.eqb), struct2table(equip_struct.gun), 'Keys', 'name');
    equip_data.attack = struct2table(equip_struct.attack);
    equip_data.scope  = struct2table(equip_struct.scope);
    equip_data.ammo   = struct2table(equip_struct.ammo);

%     gun_length_table = loadGunLength(gun_len_csv_file);  % 暂时不要这个功能
%     equip_data.gun   = join(gun_length_table, equip_data.gun, 'Keys', 'name');  % 这里不该这么写

    %% enemy
    % xml_files.rifles.enemy         = fullfile(game_data_dir, "firearms_enemy.xml"             );
    % xml_files.rifles.enemy_release = fullfile(game_data_dir, "firearms_enemy_release.xml"     );
    % xml_files.rifles.enemy_special = fullfile(game_data_dir, "firearms_specialenemyweaps.xml" );
   
    % equip_struct.eqb.enemy.normal   = parseEqbXML(xml_files.rifles.enemy);
    % equip_struct.eqb.enemy.release  = parseEqbXML(xml_files.rifles.enemy_release);
    % equip_struct.eqb.enemy.special  = parseEqbXML(xml_files.rifles.enemy_special);

    % equip_struct.eqb.enemy  = [equip_struct.eqb.enemy.normal , equip_struct.eqb.enemy.release, equip_struct.eqb.enemy.special];

    % equip_struct.gun.enemy.normal   = parseRiflesXML(xml_files.rifles.enemy);
    % equip_struct.gun.enemy.release  = parseRiflesXML(xml_files.rifles.enemy_release);
    % equip_struct.gun.enemy.special  = parseRiflesXML(xml_files.rifles.enemy_special);
    
    % equip_struct.gun.enemy   = [equip_struct.gun.enemy.normal , equip_struct.gun.enemy.release, equip_struct.gun.enemy.special];

    %% doctrine
    doctrine_data.modifier = struct2table(parseDoctrineDataXML(xml_files.doctrine_data));
    doctrine_data.tree     = struct2table(parseDoctrineTreeXML(xml_files.doctrine_tree));

    %% innate
    innate_data = struct2table(parseInnateXML(xml_files.innate));

end

