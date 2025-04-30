function [doctrine_record, doctrine_tree] = loadDoctrineFromCSV(doctrine_csv_file, rangers_name, swat_name, cia_name)
    % csv文件内容由loadGameData的返回值doctrine_data手动生成
    % 字段：name, maxlevel, text
    arguments
        doctrine_csv_file
        rangers_name string = "Rangers"
        swat_name    string = "SWAT" 
        cia_name     string = "CIA" 
    end

    doctrine_record = readtable(doctrine_csv_file);
    doctrine_record.enabled = false(height(doctrine_record), 1);
    % doctrine_record.level   = ones(height(doctrine_record), 1);
    doctrine_record.level   = doctrine_record.maxlevel;
    doctrine_record.class   = strings(height(doctrine_record), 1);

    rangers_index = contains(doctrine_record.text, rangers_name);
    swat_index = contains(doctrine_record.text, swat_name);
    cia_index = contains(doctrine_record.text, cia_name);

    doctrine_record.class(rangers_index) = rangers_name;
    doctrine_record.class(swat_index) = swat_name;
    doctrine_record.class(cia_index) = cia_name;

    doctrine_classified.Rangers.list = doctrine_record(rangers_index, :);
    doctrine_classified.SWAT.list = doctrine_record(swat_index, :);
    doctrine_classified.CIA.list = doctrine_record(cia_index, :);

    doctrine_classified.Rangers.enabled = false;
    doctrine_classified.SWAT.enabled    = false;
    doctrine_classified.CIA.enabled     = false;

    doctrine_tree.Rangers.Pistol  = doctrine_classified.Rangers.list(contains(doctrine_classified.Rangers.list.text, "手枪:"), :);
    doctrine_tree.Rangers.Rifle   = doctrine_classified.Rangers.list(contains(doctrine_classified.Rangers.list.text, "步枪:"), :);
    doctrine_tree.Rangers.Support = doctrine_classified.Rangers.list(contains(doctrine_classified.Rangers.list.text, "支援:"), :);
    doctrine_tree.Rangers.Elite   = doctrine_classified.Rangers.list(contains(doctrine_classified.Rangers.list.text, "精英:"), :);

    doctrine_tree.SWAT.Pistol     = doctrine_classified.SWAT.list(contains(doctrine_classified.SWAT.list.text, "手枪:"), :);
    doctrine_tree.SWAT.Rifle      = doctrine_classified.SWAT.list(contains(doctrine_classified.SWAT.list.text, "步枪:"), :);
    doctrine_tree.SWAT.Support    = doctrine_classified.SWAT.list(contains(doctrine_classified.SWAT.list.text, "盾牌:"), :);
    doctrine_tree.SWAT.Elite      = doctrine_classified.SWAT.list(contains(doctrine_classified.SWAT.list.text, "老兵:"), :);

    doctrine_tree.CIA.Pistol      = doctrine_classified.CIA.list(contains(doctrine_classified.CIA.list.text, "手枪:"), :);
    doctrine_tree.CIA.Rifle       = doctrine_classified.CIA.list(contains(doctrine_classified.CIA.list.text, "步枪:"), :);
    doctrine_tree.CIA.Support     = doctrine_classified.CIA.list(contains(doctrine_classified.CIA.list.text, "潜行:"), :);
end