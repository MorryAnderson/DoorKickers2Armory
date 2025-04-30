function num = str2double0(str)
    num = str2double(str);
    if (isnan(num))
        num = 0;
    end
end