function [gun_length_table] = loadGunLength(gun_length_csv_file)
    % 数据由手动测量得到
    % 字段：name, length

    gun_length_table = readtable(gun_length_csv_file);


end