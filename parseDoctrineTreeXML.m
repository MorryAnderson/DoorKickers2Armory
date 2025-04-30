function treeStruct = parseDoctrineTreeXML(xmlFile)
    % 读取 XML 文件
    xmlDoc = xmlread(xmlFile);
    
    % 提取 DoctrineUnits 元素
    rootElement = xmlDoc.getElementsByTagName('Units').item(0);
    
    % 提取绑定的 Node 元素
    unitElements = rootElement.getElementsByTagName('Unit');
    numUnits = unitElements.getLength();

    % 初始化结构体数组
    treeStruct = [];
    
    % 遍历每个 Unit 元素
    for unitIdx = 0:numUnits-1
        unitElement = unitElements.item(unitIdx);
        
        % 初始化单个 Unit 结构体
        currentTree = struct();
        
        % 提取 Unit 的属性
        currentTree.unit = char(unitElement.getAttribute('name'));

        % 提取 enable 元素
        doctrineElements = unitElement.getElementsByTagName('Node');
        numDoctrines = doctrineElements.getLength();
        currentTree.nodes = [];

        for i=0:numDoctrines-1
            current_doctrine = doctrineElements.item(i);
            current_node.name = char(current_doctrine.getAttribute('name'));
            current_node.level = str2double(current_doctrine.getAttribute('numLevels'));

            if (isnan(current_node.level))
                current_node.level = 1;
            end

            currentTree.nodes = [currentTree.nodes; current_node];
        end

        %
        treeStruct = [treeStruct; currentTree];
    end


end
