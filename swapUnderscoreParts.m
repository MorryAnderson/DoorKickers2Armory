function new_str = swapUnderscoreParts(str)
    % 检查输入是否为空
    if isempty(str)
        new_str = '';
        return;
    end

    % 找到第一个下划线的位置
    idx = strfind(str, '_');

    % 检查是否找到下划线
    if ~isempty(idx)
        % 获取第一个下划线前后的字符串部分
        before = str(1:idx(1)-1);    % 下划线前的部分
        after = str(idx(1)+1:end);   % 下划线后的部分
        
        % 交换两部分并构造新的字符串
        new_str = [after, '_', before];
    else
        % 如果没有下划线，返回原始字符串
        new_str = str;
    end
end
