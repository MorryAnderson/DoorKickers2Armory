function innateStruct = parseInnateXML(xmlFile)
    % 读取 XML 文件
    xmlDoc = xmlread(xmlFile);
    
    % 提取 Equipment 元素
    rootElement = xmlDoc.getElementsByTagName('InnateAbilities').item(0);
    
    % 获取所有 Innate 元素
    innateElements = rootElement.getElementsByTagName('InnateAbility');
    numInnate = innateElements.getLength();
    
    % 初始化结构体数组
    innateStruct = [];
    
    % 遍历每个 Innate 元素
    for i = 0:numInnate-1
        innateElement = innateElements.item(i);
        
        % 创建一个新的结构体来存储每个 Innate 的数据
        currentInnate = struct();
        
        % 提取 Innate 的属性
        currentInnate.name = char(innateElement.getAttribute('name'));

        % 提取 Modifier 元素
        modifiers = innateElement.getElementsByTagName('Modifier');
        numModifier = modifiers.getLength();
        currentInnate.modifiers = [];

        for i = 0:numModifier-1
            modifierElem = modifiers.item(i);

            currenttModifier.target     = char(modifierElem.getAttribute('target'));
            currenttModifier.rangeStart = str2double(modifierElem.getAttribute('rangeStart'));
            currenttModifier.rangeEnd   = str2double(modifierElem.getAttribute('rangeEnd'));

            currentInnate.modifiers = [currentInnate.modifiers; currenttModifier];
        end

        % 将当前 Innate 的数据存储到结构体数组中
        innateStruct = [innateStruct; currentInnate];
    end
end
